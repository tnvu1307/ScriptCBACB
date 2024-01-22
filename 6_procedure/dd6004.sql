SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE dd6004(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_GCBCODE              IN       VARCHAR2, /*Ma GCB */
   P_AMCCODE              IN       VARCHAR2, /*Ma AMC */
   P_CUSTODYCD            IN       VARCHAR2
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
    v_faFullname        VARCHAR2 (200);
    v_duedate           VARCHAR2 (10);
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
-- lay ten AMC
  BEGIN
    if UPPER(P_AMCCODE) ='ALL' then
        v_faFullname:='ALL';
    else
        select fa.fullname
    into v_faFullname
    from FAMEMBERS fa
    where roles='AMC' and UPPER(fa.shortname) =  UPPER(P_AMCCODE);
    end if;
  EXCEPTION
    WHEN OTHERS THEN
    v_faFullname:='';
  END;
 -- plog.error ('DD6004: ' || SQLERRM || dbms_utility.format_error_backtrace);
-- lay ngay moi nhat cua due date
BEGIN
    WITH tmpfeetran as (
        Select ADD_MONTHS(txdate,1) txdate
        From FeeTRAN ft
        where type='F' and status='N' and txdate <=v_ToDate and txdate >=v_FromDate and txdate<=v_ToDate
        order by txdate desc
    )
    select to_char(txdate,'MM/yyyy')
    into v_duedate
    from tmpfeetran
    where rownum=1
    order by 1;
EXCEPTION
    WHEN OTHERS THEN
    v_duedate:='';
  END;
OPEN PV_REFCURSOR FOR
   Select v_faFullname amcFullname, v_duedate duedate
   from dual;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('DD6004: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
