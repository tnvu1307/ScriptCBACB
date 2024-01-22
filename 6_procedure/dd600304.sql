SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE dd600304(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_AMCCODE              IN       VARCHAR2, /*Ma AMC */
   PV_CUSTODYCD           IN       VARCHAR2, /*So TK Luu ky */
   P_CLIENTGR             IN       VARCHAR2  /*Loai KH 1,2,3,ALL */
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
    v_Nextdate          date;
    v_Prevdate          date;


    v_IA1               number;
    v_IA2               number;
    v_IA3               number;
    v_IB1               number;
    v_IB2               number;
    v_IB3               number;
    v_IC1               number;
    v_IC2               number;
    v_IC3               number;
    v_ID1               number;
    v_ID2               number;
    v_ID3               number;

    v_IIA1               number;
    v_IIA2               number;
    v_IIB1               number;
    v_IIB2               number;
    v_IIIA1               number;
    v_IIIA2               number;
    v_IIIB1               number;
    v_IIIB2               number;
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
    v_Prevdate  := fn_get_prevdate(v_FromDate,1);
    v_Nextdate  := fn_get_nextdate(v_FromDate,1);



OPEN PV_REFCURSOR FOR
with  tmpNameOfAccount as (
    Select 'Correcting errors after transaction'  NameOfAccount,'C' cfType, 0 NoTran, 0 amt , '' Note from dual
    union all
    Select 'Handling transactions with deferred settlement' NameOfAccount,'H' cfType, 0 NoTran, 0 amt , '' Note from dual
   )
Select  *
from tmpNameOfAccount nfa;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('DD600304: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
