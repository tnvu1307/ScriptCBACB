SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR0112','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MR0112', 'Theo dõi hold tiền các tài khoản bị call, bị xử lý', 'View hold money of call accounts or dealt', '
select * from vw_mr0112 where 0=0
', 'MRTYPE', '', '', '6690', 0, 5000, 'N', 1, 'NYNNYYYYYN', 'Y', 'T', '', 'Y', 'BANKACCTNO');COMMIT;