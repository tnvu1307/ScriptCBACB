SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR9004','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MR9004', 'Theo dõi tài sản vay khách hàng', 'Margin asset management', 'SELECT v.* FROM vw_getsecmargindetail v, afmast af
WHERE v.afacctno = af.acctno
      AND af.careby IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>'')', 'MRTYPE', NULL, NULL, NULL, NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'N', 'T', NULL, 'N', NULL);COMMIT;