SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE8815','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE8815', 'Tra cứu danh sách hồ sơ giao dịch lô lẻ chờ chuyển lên VSD', 'View odd lot trading sent to VSD', '
SELECT FN_GET_LOCATION(AF.BRID) LOCATION, CF.CUSTODYCD, B.DESACCTNO AFDDI , C.CODEID, C.SYMBOL, C.PARVALUE, A.AFACCTNO,seinf.BASICPRICE CURRPRICE,seinf.FLOORPRICE , B.* , CF.IDCODE ,A4.CDCONTENT TRADEPLACE,ROUND(decode(cf.VAT,''Y'',1,0)* B.QTTY*seinf.FLOORPRICE*(SELECT to_number(varvalue) FROM SYSVAR WHERE VARNAME =''TAXRETAIL'')/100) TAX,
CF.FULLNAME
FROM SEMAST A, SERETAIL B, SBSECURITIES C ,AFMAST AF , CFMAST CF ,ALLCODE A4,securities_info seiNF,aftype afty
WHERE A.ACCTNO = B.ACCTNO AND A.CODEID = C.CODEID and  c.codeid = seinf.codeid AND B.QTTY > 0 AND B.STATUS=''N'' AND AF.ACCTNO =A.AFACCTNO AND AF.CUSTID =CF.CUSTID and af.actype=afty.actype
AND A4.CDTYPE = ''SE'' AND A4.CDNAME = ''TRADEPLACE''  AND A4.CDVAL = C.TRADEPLACE
AND NOT EXISTS (SELECT * FROM vw_tllog_pending WHERE TLTXCD =''8815'' AND FLDCD =''05'' AND cvalue = B.txnum)
AND EXISTS (SELECT * FROM TLGRPUSERS G WHERE G.GRPID = AF.CAREBY AND G.TLID = ''<$TELLERID>'' )
', 'SEMAST', NULL, NULL, '8815', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;