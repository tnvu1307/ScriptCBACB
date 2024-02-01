SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RM1005','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RM1005', 'DS các lần hold/unhold phát sinh bên ngân hàng', 'Hold/UnHold action need to check', '
select cf.custodycd, cf.fullname, cf.idcode, af.bankname, af.bankacctno, blog.amount, blog.reftype, blog.txdate, blog.bankcode, blog.refno, BLOG.STATUS
from bidvtranlog blog, afmast af, cfmast cf
where blog.bankacctno = af.bankacctno
and af.custid = cf.custid
', 'RMMAST', NULL, NULL, NULL, NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;