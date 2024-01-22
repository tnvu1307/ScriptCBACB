SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf6017 (
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
    --
    v_FromDate  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    --
    select VARVALUE into v_SHVBICCODE
      from SYSVAR
     where GRNAME='SYSTEM' and VARNAME='SHVBICCODE';
    --
OPEN PV_REFCURSOR FOR
select rownum STT,A.* from(
select * from (
   select distinct A1.CDCONTENT IO,swiftid,to_char(trim(substr(msgbody,668,12))) OUTBIC,to_char(trim(substr(msgbody,698,12))) THEIRBIC,
         --to_char((trim(substr(msgbody,662,1024))|| trim(substr(msgbody,2710,9999)) || substr(msgbody,1686,2) )) RLCONTENT,
         '' RLCONTENT, --nam.ly 21/02/2020 SHBVNEX-591
         IORO, substr(msgcode,0,3) mttype ,crb.reftxnum REF, refid.ocval RLREF, to_char(req.txdate,'DD/MM/RRRR') CREATEDATE, '' REMARK
from crblog crb , ALLCODE A1, VSDTXREQ REQ,(SELECT * FROM VSDTXREQDTL WHERE FLDNAME in ('REFID')) refid
where crb.msgtype ='ST'
and A1.cdname = 'MTTYPE' and A1.cdtype = 'CF' and A1.CDVAL  = crb.ioro
AND req.reqid = refid.reqid(+)
and crb.cbreqkey = req.reqid and trunc(req.txdate) >= v_FromDate and trunc(req.txdate) <= v_ToDate
and REQ.MSGSTATUS <> 'S'
--order by crb.createdate desc
union all
   select distinct A1.CDCONTENT IO,swiftid,to_char(trim(substr(msgbody,668,12))) OUTBIC,to_char(trim(substr(msgbody,698,12))) THEIRBIC,
         --to_char((trim(substr(msgbody,662,1024))|| trim(substr(msgbody,2710,9999)) || substr(msgbody,1686,2) )) RLCONTENT,
         '' RLCONTENT, --nam.ly 21/02/2020 SHBVNEX-591
         IORO, substr(msgcode,0,3) mttype ,crb.swiftid REF, crb.swiftid  RLREF, to_char(req.txdate,'DD/MM/RRRR') CREATEDATE, '' REMARK
from crblog crb , ALLCODE A1, swiftmsgmaplog REQ
where crb.msgtype ='ST'
and A1.cdname = 'MTTYPE' and A1.cdtype = 'CF' and A1.CDVAL  = crb.ioro
and crb.swiftid = req.msgid and trunc(req.txdate) >= v_FromDate and trunc(req.txdate) <= v_ToDate
--order by crb.createdate desc
) order by IORO,createdate desc)A
;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF6018: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
