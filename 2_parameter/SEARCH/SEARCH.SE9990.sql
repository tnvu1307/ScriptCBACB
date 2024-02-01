SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE9990','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE9990', 'Thông tin chứng khoán quyền chờ bán', 'CA stock pending sell', '
select se.autoid,cf.custodycd, sb.symbol , af.acctno afacctno, se.qtty, se.mapqtty,
       se.qtty - se.mapqtty remainqtty, cf.fullname, se.camastid, se.pitrate, se.txdate
from sepitlog se, afmast af, cfmast cf , sbsecurities sb
where se.afacctno = af.acctno and af.custid = cf.custid
and se.codeid= sb.codeid
and se.deltd<>''Y''  and se.QTTY-se.MAPQTTY>0
', 'SEMAST', 'frmSEMAST', NULL, NULL, NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;