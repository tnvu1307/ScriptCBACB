SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE dd6021(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_AMCCODE              IN       VARCHAR2, /* Ma AMC */
   P_CIFID                IN       VARCHAR2, /*Ma KH tai ngan hang */
   P_CLIENTGR             IN       VARCHAR2, /*Loai KH 1,2,3,ALL */
   PV_TXNUM               IN       VARCHAR2 /*SO CHUNG TU*/
   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- NAM.LY      13-12-2019            CREATED
    -- ---------   ------               -------------------------------------------
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    v_FromDate          date;
    v_ToDate            date;
    v_CurrDate          date;
    v_issuedate         date;
    v_expdate           date;
    v_IDate             DATE;
    v_CustodyCD         varchar2(20);
    v_Symbol            varchar2(50);
    v_IDCODE           varchar2(200);
    v_OFFICE           varchar2(200);
    v_REFNAME          varchar2(200);
    v_shvstc           varchar2(200);
    v_shvcustodycd     varchar2(200);
    v_shvcifid         varchar2(200);
    v_tltitle          varchar2(200);
    v_tlfullname       varchar2(200);
    v_ExchangeRate     number;
    v_listFXRate       varchar2(500);
    v_AMCfullname      varchar2(200);
    v_TXNUM             VARCHAR2(10);
    V_CIFID            varchar2(200);
    v_first_date_in_month date;
    v_end_work_date date;
BEGIN
    V_STROPTION := OPT;
    v_CurrDate   := getcurrdate;
    if v_stroption = 'A' then
        v_strbrid := '%';
    elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
    else
        v_strbrid:=brid;
    end if;
    v_TXNUM         :=     PV_TXNUM;
    v_FromDate  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_IDate       :=  getcurrdate;

    --v_first_date_in_month := TO_DATE('01' || to_char(v_FromDate,'MM/RRRR'),'DD/MM/RRRR');
    --v_end_work_date := getprevdate(v_first_date_in_month, 1);

    -- Lay danh sach cac ty gia theo ngay bao cao
    BEGIN
        SELECT LISTAGG(TEXT,'   ') WITHIN GROUP(ORDER BY CURRENCY) INTO v_listFXRate
        FROM (
            SELECT EB2.CURRENCY, EB2.VND , 'FX RATE ('||EB2.CURRENCY||'/VND): '||UTILS.SO_THANH_CHU2(NVL(EB2.VND,0)) TEXT
            FROM
            (
                SELECT CURRENCY, ITYPE, RTYPE, MAX(LASTCHANGE) LASTCHANGE
                FROM (
                    SELECT * FROM EXCHANGERATE
                    UNION ALL
                    SELECT * FROM EXCHANGERATE_HIST
                )
                WHERE TO_DATE(TO_CHAR(LASTCHANGE,'DD/MM/RRRR'),'DD/MM/RRRR') <= v_FromDate--TRADEDATE <= v_FromDate
                AND CURRENCY = 'USD'
                AND ITYPE = 'SHV'
                AND RTYPE = 'TTM'
                GROUP BY CURRENCY, ITYPE, RTYPE
            )EB1,
            (
                SELECT * FROM EXCHANGERATE
                UNION ALL
                SELECT * FROM EXCHANGERATE_HIST
            )EB2
            WHERE EB1.CURRENCY = EB2.CURRENCY
            AND EB1.ITYPE = EB2.ITYPE
            AND EB1.RTYPE = EB2.RTYPE
            AND EB1.LASTCHANGE = EB2.LASTCHANGE
        );
    EXCEPTION
    WHEN OTHERS  THEN
        v_listFXRate := 'No data';
    END;
------------------------------------RIT-----------------------------------------
    if P_CIFID ='ALL' then
        V_CIFID:='%';
    else
        V_CIFID:=P_CIFID;
    end if;
--------------------------------------------------------------------------------
    IF  P_AMCCODE='ALL' AND P_CIFID='ALL' THEN
        V_AMCFULLNAME:='ALL' ;
    ELSIF P_AMCCODE <> 'ALL' AND P_CIFID = 'ALL' THEN
        BEGIN
            SELECT FA.FULLNAME
            INTO V_AMCFULLNAME
            FROM FAMEMBERS FA
            WHERE FA.SHORTNAME LIKE P_AMCCODE
            AND FA.ROLES ='AMC';
        EXCEPTION
        WHEN OTHERS THEN
            V_AMCFULLNAME:='';
        END;
    ELSIF P_CIFID <> 'ALL' THEN
        BEGIN
            SELECT CF.FULLNAME
            INTO V_AMCFULLNAME
            FROM CFMAST CF
            WHERE CF.CIFID LIKE P_CIFID;
        EXCEPTION
        WHEN OTHERS THEN
            V_AMCFULLNAME:='';
        END;
    END IF;
    OPEN PV_REFCURSOR FOR
    Select v_FromDate ValueDate,
           (CASE WHEN v_TXNUM IS NULL THEN 'No: BC...../' ELSE 'No: BC'||v_TXNUM||'/' END)||TO_CHAR(v_FromDate,'yyyy')||'/ SSD-SHBVN' ReportingNo,
           'Ho Chi Minh City, '||TO_CHAR(v_FromDate,'Mon ddth, YYYY') ReportingDate,
           v_listFXRate ListExchangeRate,
           v_AMCfullname ClientName
    from dual;
EXCEPTION
WHEN OTHERS THEN
  plog.error ('DD6021: ' || SQLERRM || dbms_utility.format_error_backtrace);
  Return;
End;
/
