SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE dd6020(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_AMCCODE              IN       VARCHAR2, /* Ma AMC */
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
    -- Lay danh sach cac ty gia theo ngay bao cao
    BEGIN
        SELECT LISTAGG(TEXT,'   ') WITHIN GROUP(ORDER BY CURRENCY) INTO v_listFXRate
        FROM (
            SELECT EA.CURRENCY, EA.VND , 'FX rate ('||EA.CURRENCY||'/VND): '||UTILS.SO_THANH_CHU2(NVL(EA.VND,0)) TEXT
            FROM EXCHANGERATE_ORTHER EA,
            (
                SELECT CURRENCY, MAX(TRADEDATE) TRADEDATE
                FROM EXCHANGERATE_ORTHER
                WHERE TRADEDATE <= v_FromDate
                AND CURRENCY IN ('USD','EUR','JPY')
                GROUP BY CURRENCY
            )EB
            WHERE EA.CURRENCY = EB.CURRENCY
            AND EA.TRADEDATE = EB.TRADEDATE
         );
    EXCEPTION
    WHEN OTHERS THEN
        v_listFXRate := 'No data';
    END;
    --------------------------------------------------------------------------------

    OPEN PV_REFCURSOR FOR
    Select v_FromDate ValueDate,
           (CASE WHEN v_TXNUM IS NULL THEN 'No: BC...../' ELSE 'No: BC'||v_TXNUM||'/' END)||TO_CHAR(v_FromDate,'yyyy')||'/ SSD-SHBVN' ReportingNo,
           'Ho Chi Minh City, '||TO_CHAR(v_FromDate,'Mon ddth, YYYY') ReportingDate,
           v_listFXRate ListExchangeRate
    from dual;
EXCEPTION
WHEN OTHERS THEN
  plog.error ('DD6020: ' || SQLERRM || dbms_utility.format_error_backtrace);
  Return;
End;
/
