SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR0101','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MR0101', 'Tra cứu trạng thái tiểu khoản Margin (UBCK)', 'View margin account status (SSC)', 'select v.*, t.grpname
from vw_mr0101 v, (select * from tlgroups where GRPTYPE = ''2'') t
where v.careby = t.grpid(+)
and exists (SELECT 1 FROM TLGRPUSERS TLGRP WHERE TLGRP.GRPID = v.CAREBY and TLID = ''<$TELLERID>'')', 'MRTYPE', '', '', '', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;