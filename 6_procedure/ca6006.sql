SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca6006(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_AMCCODE              IN       VARCHAR2, /* Ma AMC */
   PV_TXNUM               IN       VARCHAR2 /*SO CHUNG TU*/
   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- du.phan    23-10-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    v_FromDate          date;
    v_ToDate            date;
    v_CurrDate          date;
    v_issuedate         date;
    v_expdate           date;
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
    v_TXNUM             VARCHAR2(10);
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
    v_ToDate    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_TXNUM         :=     PV_TXNUM;

    BEGIN
        SELECT EA.VND INTO V_EXCHANGERATE
        FROM EXCHANGERATE_ORTHER EA,
        (
            SELECT CURRENCY, MAX(TRADEDATE) TRADEDATE
            FROM EXCHANGERATE_ORTHER
            WHERE TRADEDATE <= v_FromDate
            AND CURRENCY = 'USD'
            GROUP BY CURRENCY
        )EB
        WHERE EA.CURRENCY = EB.CURRENCY AND EA.TRADEDATE = EB.TRADEDATE;
    EXCEPTION
        WHEN OTHERS  THEN
            V_EXCHANGERATE := 0;
            plog.error ('CA6006: '||'TY GIA USD/VND NGAY '||v_FromDate||' KHONG TON TAI!!!');
    END;

OPEN PV_REFCURSOR FOR
    Select TO_CHAR(v_FromDate,'dd/MM/yy') ReportingDate,
            v_FromDate ValueDate,
            (CASE WHEN v_TXNUM IS NULL THEN 'No: BC...../' ELSE 'No: BC'||v_TXNUM||'/' END)||TO_CHAR(v_FromDate,'yyyy')||'/ SSD-SHBVN' ReportingDate1,
            'Ho Chi Minh City, '||TO_CHAR(v_FromDate,'Mon ddth, YYYY') ReportingDate2,
           'Unit:1,000USD / FX rate: 1USD=VND'|| TO_CHAR(V_EXCHANGERATE,'999,999.9999') ExchangeRate,
            '' DeptBranch
    from dual;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CA6006: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
