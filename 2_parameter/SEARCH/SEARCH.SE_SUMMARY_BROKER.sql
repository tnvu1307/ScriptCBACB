SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE_SUMMARY_BROKER','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE_SUMMARY_BROKER', 'Tra cứu thông tin tài khoản thấu chi', 'Overdraft account information', 'select B.SYMBOL,FA.SHORTNAME BROKER,B.TOTALHOLD,B.TOTALUNHOLD from buf_se_member b,famembers fa where (b.totalhold >0 or b.totalunhold >0) and b.members = fa.autoid', 'CIMAST', '', '', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;