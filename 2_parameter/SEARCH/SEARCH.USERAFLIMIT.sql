SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('USERAFLIMIT','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('USERAFLIMIT', 'Hạn mức bảo lãnh', 'Limit T0', 'select CF.SHORTNAME, AF.ACTYPE,AFT.TYPENAME ACNAME, SUBSTR(AF.CUSTID,1,4) || ''.'' || SUBSTR(AF.CUSTID,5,6) CUSTID,
CF.FULLNAME FULLNAME,CF.FULLNAME || ''(''||CF.CUSTODYCD ||'')'' CUSTNAME,CF.CUSTODYCD CUSTODYCD,
SUBSTR(AF.ACCTNO,1,4) || ''.'' || SUBSTR(AF.ACCTNO,5,6) ACCTNO, AF.AFTYPE
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
nvl(urlt.t0,0) - nvl(uflt.t0acclimit,0) urt0limitremain,urlt.dplimitmax,
nvl(urlt.acctlimit,0) mracclimit, nvl(urlt.dplimit,0) tcacclimit , nvl(urlt.t0max,0) t0acclimit,
nvl(T0af.AFT0USED,0) AFT0USED, nvl(MRaf.AFMRUSED,0) AFMRUSED, nvl(TCaf.AFTCUSED,0) AFTCUSED
from cfmast cf, afmast af, aftype aft, TLGROUPS GRP, tlprofiles tlp,
(select sum(acclimit) CUSTT0USED, af.CUSTID from useraflimit us, afmast af where af.acctno = us.acctno and us.typereceive = ''T0'' group by custid) T0,
(select sum(acclimit) AFT0USED, acctno from useraflimit us where us.typereceive = ''T0'' group by acctno) T0af,
(select sum(mrcrlimitmax) CUSTMRUSED, CUSTID from afmast group by custid) MR,
(select sum(mrcrlimitmax) AFMRUSED, acctno from afmast group by acctno) MRaf,
(select sum(dpcrlimitmax) CUSTCRUSED, CUSTID from afmast group by custid) TC,
(select sum(dpcrlimitmax) AFTCUSED, acctno from afmast group by acctno) TCaf,
(select tliduser,allocatelimmit,usedlimmit,acctlimit,t0,t0max,dplimit,dplimitmax from userlimit where TLIDUSER = ''<$TELLERID>''
) urlt,
(select tliduser,sum(decode(typereceive,''T0'',acclimit, 0)) t0acclimit,sum(decode(typereceive,''MR'',acclimit, 0)) mracclimit,sum(decode(typereceive,''DP'',acclimit, 0)) tcacclimit  from useraflimit where typeallocate = ''Flex'' and TLIDUSER = ''<$TELLERID>'' group by tliduser
) uflt
where cf.custid = af.custid and af.actype = aft.actype and cf.custid = t0.custid (+) 
and cf.custid = mr.custid(+) and  cf.custid = TC.custid(+)
and af.acctno = T0af.acctno(+) and af.acctno = MRaf.acctno(+) and af.acctno = TCaf.acctno(+)
and tlp.tlid = uflt.tliduser(+) and tlp.tlid = urlt.tliduser(+) and tlp.tlid = ''<$TELLERID>''
AND AF.CAREBY = GRP.GRPID AND GRP.GRPTYPE = ''2''
AND (SUBSTR(CF.CUSTID,1,4) = DECODE(''<$BRID>'', ''<$HO_BRID>'', SUBSTR(CF.CUSTID,1,4), ''<$BRID>'')
  OR AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>''))', 'USERAFLIMIT', '', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;