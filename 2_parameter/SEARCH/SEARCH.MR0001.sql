SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR0001','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MR0001', 'Tra cứu trạng thái tiểu khoản Margin', 'View margin account status', 'select v.*, t.grpname,'''' GRPAFACCTNO
from vw_mr0001_all v, (select * from tlgroups where GRPTYPE = ''2'') t
where v.careby = t.grpid(+)
and exists (SELECT 1 FROM TLGRPUSERS TLGRP WHERE TLGRP.GRPID = v.CAREBY and TLID = ''<$TELLERID>'')', 'MRTYPE', 'frmMarginInfo', '', '', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;