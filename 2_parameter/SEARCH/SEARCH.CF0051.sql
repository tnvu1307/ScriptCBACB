SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CF0051','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CF0051', 'Danh sách tiểu khoản theo loại hình hợp đồng', 'List of sub accounts order by Aftype', 'Select cf.custodycd,af.acctno,cf.fullname,cf.dateofbirth,cf.idcode,cf.iddate,cf.idplace,cf.address,cf.phone,cf.mobile,cf.email,cf.tradetelephone,
    tradeonline,af.mrcrlimit,cf.vat,
    cf.careby carebyid , tl.grpname carebyname , aft.actype ,aft.typename,
    cf.custatcom, af.corebank, af.bankname, af.bankacctno, af.status,cf.idtype, BR.brname BRANCH,af.autoadv
from cfmast cf ,afmast af , aftype aft,  tlgroups tl,  brgrp BR
where cf.careby = tl.grpid 
and af.custid = cf.custid and af.actype =aft.actype
AND (SUBSTR(fn_get_broker(AF.acctno,''AFACCTNO''),12,4)) = BR.BRID(+)', 'AFMAST', '', '', '', NULL, 1000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;