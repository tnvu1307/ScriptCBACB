SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE dd6022(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_AMCCODE              IN       VARCHAR2 /* Ma AMC */
   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- Thoai.Tran      08/07/2020            CREATED
    -- ---------   ------               -------------------------------------------
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    v_FromDate          date;
    v_PreWeek          date;
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
    v_listFXRate       number;
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
    v_FromDate  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_FromDate  := v_FromDate - 1;
    v_ToDate    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_IDate       :=  getcurrdate;
    v_PreWeek :=v_FromDate-7;
    -- Lay danh sach cac ty gia theo ngay bao cao
    BEGIN
          SELECT Round(NVL(EA.VND,0),3) INTO v_listFXRate
            FROM EXCHANGERATE_ORTHER EA,
            (
                SELECT CURRENCY, MAX(TRADEDATE) TRADEDATE
                FROM EXCHANGERATE_ORTHER
                WHERE TRADEDATE <= v_FromDate
                AND CURRENCY IN ('USD')
                GROUP BY CURRENCY
            )EB
            WHERE EA.CURRENCY = EB.CURRENCY
            AND EA.TRADEDATE = EB.TRADEDATE;
    EXCEPTION
    WHEN OTHERS THEN
        v_listFXRate := 1;
    END;
    --------------------------------------------------------------------------------

    OPEN PV_REFCURSOR FOR
    Select v_FromDate ValueDate,
            'from '||TO_CHAR(v_PreWeek,'dd/MM/rrrr')||' to '||TO_CHAR(v_FromDate,'dd/MM/rrrr') ReportingDate,
           v_listFXRate ListExchangeRate
    from dual;
EXCEPTION
WHEN OTHERS THEN
  plog.error ('DD6022: ' || SQLERRM || dbms_utility.format_error_backtrace);
  Return;
End;
/
