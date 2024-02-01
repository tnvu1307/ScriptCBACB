SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ODMAST_8838','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('ODMAST_8838', 'Quản lý sổ lệnh', 'Order management', 'select * from (select od.*,cf.custodycd,sec.symbol,
 CASE WHEN NVL(TBL2.ORDERID,''0'') <> ''0'' THEN ''Y'' ELSE ''N'' END  ISPTRP2
 from odmast od,
(SELECT ORDERID2  ORDERID FROM  TBL_ODREPO WHERE deltd=''N'' AND status =''A'' AND ORDERID2 IS NOT NULL
 union
 SELECT REF_ORDERID2 ORDERID FROM TBL_ODREPO WHERE DELTD=''N'' AND REF_ORDERID2 IS NOT NULL ) TBL2,
 afmast af, cfmast cf, sbsecurities sec
 where  od.deltd <> ''Y''
 and od.afacctno=af.acctno
 and af.custid=cf.custid
  AND OD.ORDERID = TBL2.ORDERID(+)
  and od.codeid=sec.codeid
  and od.remainqtty=0
  and NVL(TBL2.ORDERID,''0'') <> ''0'')
  where 0=0', 'OD.ODMAST', 'frmODMAST', 'ORDERID DESC', NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;