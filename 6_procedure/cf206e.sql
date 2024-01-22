SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CF206E (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   R_DATE                 IN       VARCHAR2 /*ngay bao cao */
   )
IS
    -- Swift summary
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- nam.ly      03-12-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    v_ReportDate     DATE;
BEGIN
   V_STROPTION := OPT;
    if v_stroption = 'A' then
        v_strbrid := '%';
    elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
    else
        v_strbrid:=brid;
    end if;
    v_ReportDate  :=     TO_DATE(R_DATE, SYSTEMNUMS.C_DATE_FORMAT);
OPEN PV_REFCURSOR FOR
       SELECT FULLNAME, (CASE WHEN COUNTRY ='234' THEN SUBSTR(CUSTODYCD,5,6) ELSE TRADINGCODE END) STC, CIFID
                FROM CFMAST
                WHERE OPNDATE <= v_ReportDate AND STATUS <> 'C';
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF206E: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
