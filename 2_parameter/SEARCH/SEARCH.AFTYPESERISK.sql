SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('AFTYPESERISK','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('AFTYPESERISK', 'Tham số chứng khoán ký quỹ cho loại hình tiểu khoản giao dịch', 'Securities margin apply for contract type', 'select a.actype aftype, c.typename, b.codeid, b.SYMBOL,a.MRRATIORATE,a.MRRATIOLOAN,a.MRPRICERATE,a.MRPRICELOAN,a.DPRATIORATE,a.DPRATIOLOAN
from AFSERISK  a, sbsecurities b, aftype c
where a.codeid=b.codeid and a.actype =c.actype AND c.actype = ''<$KEYVAL>''', 'SECURITIES_INFO', '', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;