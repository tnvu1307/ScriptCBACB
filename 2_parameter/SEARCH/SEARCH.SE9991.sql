SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE9991','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE9991', 'Thông tin chứng khoán quyền đã phân bổ', 'CA stock allocated ', '
select cf.custodycd, af.acctno afacctno, cf.fullname, sb.symbol,
al.qtty, al.price, al.aright, al.pitrate, al.orgorderid, sepitlog_id,txnum,txdate
from sepitallocate al,  afmast af, cfmast cf, sbsecurities sb
where al.afacctno = af.acctno
and af.custid = cf.custid
and al.codeid= sb.codeid
', 'SEMAST', 'frmSEMAST', NULL, NULL, NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;