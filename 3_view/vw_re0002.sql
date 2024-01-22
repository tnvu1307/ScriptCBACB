SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_RE0002
(COMMDATE, RETYPE, DESC_RETYPE, REFRECFLNKID, CAREBY, 
 CUSTID, FULLNAME, REROLE, DESC_REROLE, TYPENAME, 
 MINDREVAMT, MINIREVAMT, MININCOME, MINRATESAL, SALTYPE, 
 REACTYPE, ISDREV, ODRNUM, ACCTNO, DIRECTACR, 
 DIRECTFEEACR, LMN, DISPOSAL, INDIRECTACR, INDIRECTFEEACR, 
 INLMN, INDISPOSAL, ODFEETYPE, ODFEERATE, DISDIRECTACR, 
 DISREVACR, DISRFMATCHAMT, DISRFFEEACR, RFFEECOMM, REVENUE, 
 COMMISION, TXNUM, TXDATE, AUTOID, RATEMINCOMPLETED, 
 TLNAME, DRCALLCENTER, DRBONDTYPETP, IRCALLCENTER, IRBONDTYPETP, 
 DRGT, GRPMINIREVAMT)
AS 
(
    SELECT a.commdate, a.retype,a1.cdcontent DESC_RETYPE, a.refrecflnkid,CF.CAREBY, a.custid, cf.fullname, rty.rerole,
       DECODE(RTY.RETYPE,'I','...',A2.cdcontent) DESC_REROLE, RTY.typename ,A.mindrevamt,
       a.minirevamt, a.minincome,(fn_re_icrate(rf.custid||rty.actype,
       a.revenue,a.revenue)) minratesal,
        a.saltype, a.reactype,
       a.isdrev, a.odrnum, a.acctno, a.directacr, a.directfeeacr,a.lmn, a.feedisposal,
       a.indirectacr, a.indirectfeeacr,a.inlmn,a.ifeedisposal,
       a.odfeetype, a.odfeerate,
       a.disdirectacr, a.disrevacr,
       case when a.retype = 'I' then a.inrfmatchamt else a.rfmatchamt end disrfmatchamt,
       case when a.retype = 'I' then a.inrffeeacr else a.rffeeacr end disrffeeacr,
case when a.retype = 'I' then a.INRFFEECOMM else a.rffeecomm end rffeecomm,
a.revenue, a.commision, a.txnum,
       a.txdate, a.autoid,a.RATEMINCOMPLETED, nvl(tl.tlname,'') tlname,
       a.dRFEECALLCENTER Drcallcenter, a.drfeebondtypetp Drbondtypetp, a.IRFEECALLCENTER Ircallcenter, a.irfeebondtypetp Irbondtypetp,
       a.drfeecallcenter+a.drfeebondtypetp+a.feedisposal DRGT,case when a.retype = 'I' then nvl(grpminirevamt,0) else 0 end grpminirevamt
  FROM recommision a, cfmast cf , allcode a1, retype rty, allcode a2, recflnk rf,tlprofiles tl,
       (select custid||actype acctno ,grpminirevamt  from regrp where status ='A') grp
  --,(select actype, icrate from ICCFTYPEDEF where eventcode = 'CALFEECOMM') ic
  where a.custid=cf.custid
  and a1.cdtype='RE' and a1.cdname='RETYPE'
  and a2.cdtype='RE' and a2.cdname='REROLE'
  and a.acctno =  grp.acctno(+)
  and a.retype=a1.cdval
  and rty.rerole=a2.cdval
  and a.reactype=rty.actype
  and a.custid = rf.custid
  and rf.status = 'A' --AND (<$BRID> ='0001' or RF.BRID = <$BRID>)
  and rf.tlid=tl.tlid(+)
)
/
