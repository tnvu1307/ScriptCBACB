SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR0025','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MR0025', 'Tự động cập hạn mức bảo lãnh (1816)', 'Auto limit', 'select CF.SHORTNAME,AF.ACCTNO,NVL(PRATIO,0)PRATIO,NVL(MRATIO,0)MRATIO, AF.ACTYPE,AFT.TYPENAME ACNAME, SUBSTR(AF.CUSTID,1,4) || ''.'' || SUBSTR(AF.CUSTID,5,6) CUSTID,
CF.FULLNAME FULLNAME,CF.FULLNAME || ''(''||CF.CUSTODYCD ||'')'' CUSTNAME,CF.CUSTODYCD CUSTODYCD,
SUBSTR(AF.ACCTNO,1,4) || ''.'' || SUBSTR(AF.ACCTNO,5,6) ACCTNO1, AF.AFTYPE
,cf.PIN,cf.mobilesms TRADEPHONE,CF.IDCODE,CF.IDDATE, CF.IDPLACE,
AF.BANKACCTNO,AF.SWIFTCODE,CF.EMAIL,CF.ADDRESS,cf.FAX,
SUBSTR(AF.ACCTNO,1,4) || ''.'' || SUBSTR(AF.ACCTNO,5,6) CIACCTNO,AF.LASTDATE,
AF.ADVANCELINE,AF.DEPOSITLINE,AF.BRATIO,AF.DESCRIPTION,
GRP.GRPNAME CAREBY,
GRP.GRPID CAREBYID, CF.REFNAME, AF.COREBANK,AF.BANKNAME,
AF.MRIRATE,AF.MRMRATE,AF.MRLRATE,AF.MRCRLIMIT,AF.MRCRLIMITMAX, AF.DPCRLIMITMAX,
cf.mrloanlimit, cf.t0loanlimit, nvl(t0.CUSTT0USED,0) CUSTT0USED, nvl(mr.CUSTMRUSED,0) CUSTMRUSED,nvl(TC.CUSTCRUSED,0) CUSTTCUSED,
(cf.mrloanlimit -( nvl(mr.CUSTMRUSED,0) +  nvl(TC.CUSTCRUSED,0))) CUSTMRREMAIN, cf.t0loanlimit - nvl(t0.CUSTT0USED,0)  CUSTT0REMAIN,
nvl(urlt.allocatelimmit,0) - nvl(uflt.mracclimit,0) urmrlimitremain,nvl(urlt.dplimit,0) - nvl(uflt.tcacclimit,0) urtclimitremain,
nvl(urlt.t0,0) - nvl(uflt.t0acclimit,0) urt0limitremain,
nvl(urlt.acctlimit,0) mracclimit, nvl(urlt.dplimit,0) tcacclimit , nvl(urlt.t0max,0) t0acclimit,
nvl(T0af.AFT0USED,0) AFT0USED, nvl(MRaf.AFMRUSED,0) AFMRUSED, nvl(TCaf.AFTCUSED,0) AFTCUSED, fn_cal_afblamount(AF.ACCTNO) TOAMT
 --,CF1.FULLNAME REFULLNAME,cf1.custid recustid,CF2.CUSTID REGRCUSTID,
,reg.fullname REGRFULLNAME,FN_GETCAREBYBROKER(af.custid,getcurrdate) recustid,cf1.fullname mgfullname,rec.brid,
buf.marginrate_mc
from cfmast cf, afmast af, aftype aft, TLGROUPS GRP, tlprofiles tlp,AFUWRATIO O,buf_ci_account buf,
 (select custid,refrecflnkid from regrplnk where getcurrdate BETWEEN frdate and todate and status=''A'' group by custid,refrecflnkid) regl,
 (select * from regrp where status=''A'') reg, cfmast cf1,
 (select * from recflnk where getcurrdate BETWEEN effdate and expdate and status=''A'') rec,
 --cfmast cf2, cfmast cf1,
(select sum(acclimit) CUSTT0USED, af.CUSTID from useraflimit us, afmast af where af.acctno = us.acctno and us.typereceive = ''T0'' group by custid) T0,
(select sum(acclimit) AFT0USED, acctno from useraflimit us where us.typereceive = ''T0'' group by acctno) T0af,
(select sum(mrcrlimitmax) CUSTMRUSED, CUSTID from afmast group by custid) MR,
(select sum(mrcrlimitmax) AFMRUSED, acctno from afmast group by acctno) MRaf,
(select sum(dpcrlimitmax) CUSTCRUSED, CUSTID from afmast group by custid) TC,
(select sum(dpcrlimitmax) AFTCUSED, acctno from afmast group by acctno) TCaf,
(select tliduser,sum(allocatelimmit) allocatelimmit,sum(usedlimmit) usedlimmit,sum(acctlimit) acctlimit,
sum(t0) t0,sum(t0max) t0max,sum(dplimit) dplimit,sum(dplimitmax) dplimitmax from userlimit
group by tliduser
) urlt,
(select tliduser,sum(decode(typereceive,''T0'',acclimit, 0)) t0acclimit,sum(decode(typereceive,''MR'',acclimit, 0)) mracclimit,sum(decode(typereceive,''DP'',acclimit, 0)) tcacclimit  from useraflimit where typeallocate = ''Flex''
group by tliduser
) uflt
where cf.custid = af.custid and af.actype = aft.actype and cf.custid = t0.custid (+)
and cf.custid = mr.custid(+) and  cf.custid = TC.custid(+)
and af.acctno = T0af.acctno(+) and af.acctno = MRaf.acctno(+) and af.acctno = TCaf.acctno(+)
and cf.tlid = tlp.tlid
and tlp.tlid = uflt.tliduser(+)
and tlp.tlid = urlt.tliduser(+)-- and tlp.tlid = ''<0001>''
AND AF.CAREBY = GRP.GRPID AND GRP.GRPTYPE = ''2''
AND O.ACCTNO = AF.ACCTNO and O.DELTD =''N''
and FN_GETCAREBYBROKER(af.custid,getcurrdate) = regl.custid(+)
and FN_GETCAREBYBROKER(af.custid,getcurrdate) = cf1.custid(+)
and FN_GETCAREBYBROKER(af.custid,getcurrdate) = rec.custid(+)
and regl.refrecflnkid=reg.autoid(+)
and af.acctno=buf.afacctno(+)', 'MR0025', 'frmAFUWRATIO', NULL, '1810', NULL, 1000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;