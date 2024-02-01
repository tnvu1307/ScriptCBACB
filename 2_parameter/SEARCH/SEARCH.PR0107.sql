SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('PR0107','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('PR0107', 'Điều chỉnh Room đã sử dụng', 'Adjust the room was used', 'select * from (
SELECT  cf.custodycd, AFACCTNO, SB.SYMBOL CODEID, C1.cdcontent ALLOCTYP,
--SUM(case when AFPR.restype = ''M'' then PRINUSED else 0 end) PRINUSED,
SUM(case when AFPR.restype = ''S'' then PRINUSED else 0 end) SYPRINUSED
--,SUM(case when AFPR.restype = ''O'' then PRINUSED else 0 end) DBPRINUSED
FROM vw_afpralloc_all AFPR, ALLCODE C1, sbsecurities SB, afmast af, cfmast cf
where AFPR.alloctyp = C1.cdval and C1.cdtype = ''PR'' and C1.cdname = ''ALLOCTYP''
and SB.codeid = afpr.codeid and AFPR.afacctno = af.acctno and af.custid = cf.custid
and AFPR.restype=''S''
GROUP BY  AFACCTNO, SB.SYMBOL,cf.custodycd, C1.cdcontent
ORDER BY  AFACCTNO,cf.custodycd, CODEID) where  0 = 0', 'AFPRALLOC', NULL, NULL, '0107', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;