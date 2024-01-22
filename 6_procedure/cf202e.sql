SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CF202E (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2 /*den ngay */
   )
IS
    -- Swift summary
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- trung.luu    29-10-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    v_FromDate     date;
    v_ToDate       date;
    v_CurrDate     date;
    v_CustodyCD    varchar2(20);
    v_SHVBICCODE   varchar2(100);
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
    v_FromDate  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    select VARVALUE into v_SHVBICCODE
      from SYSVAR
     where GRNAME='SYSTEM' and VARNAME='SHVBICCODE';
OPEN PV_REFCURSOR FOR
    select rownum STT, A1.CDCONTENT IO, 'SHBKVNVXCUS' OUTBIC, cf.swiftcode THEIRBIC,
       crb.msgcode MTTYPE, crb.reftxnum REF, crb.cbreqkey RLREF, crb.createdate CREATEDATE,
       '' RLCONTENT, '' REMARK
    from crblog crb,cfmast cf, ALLCODE A1
        where   crb.msgtype = 'ST'
            and cf.cifid = crb.cifid (+)
            and A1.cdname = 'MTTYPE' and A1.cdtype = 'CF' and A1.CDVAL  = crb.ioro
    order by STT
    ;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF202E: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
