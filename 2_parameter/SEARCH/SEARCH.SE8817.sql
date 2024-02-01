SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE8817','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE8817', 'Tra cứu giao dịch quản lý lô lẻ ', 'Cancel odd lot trading', '
SELECT FN_GET_LOCATION(AF.BRID) LOCATION, CF.CUSTODYCD, B.DESACCTNO AFDDI , C.CODEID, C.SYMBOL, C.PARVALUE, A.AFACCTNO,SUBSTR(B.DESACCTNO,1,10)  AFACCTNO2,
    to_char(B.TXDATE,''dd/mm/yyyy'') txdate,b.TXNUM,b.ACCTNO,b.PRICE,b.QTTY,b.STATUS,b.DESACCTNO,b.FEEAMT,b.TAXAMT,b.SDATE,b.VDATE,
    CF.IDCODE ,A4.CDCONTENT TRADEPLACE,CASE WHEN CI.COREBANK=''Y'' THEN 0 ELSE 1 END ISCOREBANK,
    ROUND(decode(cf.VAT,''Y'',1,0)* B.QTTY*b.price/100*(SELECT to_number(varvalue) FROM SYSVAR WHERE VARNAME =''ADVSELLDUTY'')) TAX,
    CI.DEPOLASTDT,fn_get_retailSell_caqtty(b.qtty, b.acctno) pitqtty,
    round(fn_get_retailSell_cavat(b.qtty, b.acctno) * (case when b.price>c.parvalue then c.parvalue else b.price end)/100) pitamt,cf.fullname,
    to_char(B.TXDATE,''dd/mm/yyyy'') || b.TXNUM ACCREF
FROM SEMAST A, SERETAIL B, SBSECURITIES C ,AFMAST AF , CFMAST CF ,ALLCODE A4,AFTYPE afTY,CIMAST CI
WHERE A.ACCTNO = B.ACCTNO AND A.CODEID = C.CODEID AND B.QTTY > 0 AND B.STATUS=''N'' AND AF.ACCTNO =A.AFACCTNO AND AF.CUSTID =CF.CUSTID
AND A4.CDTYPE = ''SE'' AND A4.CDNAME = ''TRADEPLACE''  AND A4.CDVAL = C.TRADEPLACE
AND AF.ACTYPE=afty.actype and af.acctno=ci.acctno', 'SEMAST', NULL, NULL, '8817', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;