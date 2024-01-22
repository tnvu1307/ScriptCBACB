SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE8879','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE8879', 'Tra cứu giao dịch bán chứng khoán lô lẻ chưa thanh toán chứng khoán', 'View odd lot trading payment', 'SELECT FN_GET_LOCATION(AF.BRID) LOCATION, CF.CUSTODYCD, B.DESACCTNO AFDDI , C.CODEID, C.SYMBOL, C.PARVALUE, A.AFACCTNO,
    to_char(B.TXDATE,''dd/mm/yyyy'') txdate,b.TXNUM,b.ACCTNO,b.PRICE,b.QTTY,b.STATUS,b.DESACCTNO,b.FEEAMT,b.TAXAMT,b.SDATE,b.VDATE,
    CF.IDCODE ,A4.CDCONTENT TRADEPLACE,
    ROUND(decode(CF.VAT,''Y'',1,0)* B.QTTY*b.price/100*(SELECT to_number(varvalue) FROM SYSVAR WHERE VARNAME =''ADVSELLDUTY'')) TAX,
    b.pitqtty,
    0 pitamt,cf.fullname, to_char(B.TXDATE,''dd/mm/yyyy'') || b.TXNUM ACCREF,
    DDS.acctno sellacctno, DDB.acctno buyacctno
FROM SEMAST A, SERETAIL B, SBSECURITIES C ,AFMAST AF , CFMAST CF,
     ALLCODE A4,DDMAST DDS, DDMAST DDB, SEMAST SEB
WHERE A.ACCTNO = B.ACCTNO AND A.CODEID = C.CODEID AND B.QTTY > 0 AND B.STATUS=''S''
AND AF.ACCTNO =A.AFACCTNO AND AF.CUSTID =CF.CUSTID
AND A4.CDTYPE = ''SE'' AND A4.CDNAME = ''TRADEPLACE''  AND A4.CDVAL = C.TRADEPLACE
AND af.acctno= DDS.afacctno and DDS.isdefault =''Y''
AND SEB.ACCTNO = B.DESACCTNO AND SEB.afacctno = DDB.afacctno AND DDB.isdefault =''Y''
AND to_char(B.TXDATE,''ddmmyyyy'')||B.TXNUM not in
(
    select NVL( MAX(CASE WHEN  FLDCD =''04'' THEN CVALUE END) || MAX( CASE WHEN  FLDCD =''05'' THEN CVALUE END),''-'') REF
    from tllog tl, tllogfld fld
    where tl.tltxcd =''8879''
    and tl.txnum = fld.txnum and tl.txdate = fld.txdate
    and tl.deltd <> ''Y'' and tl.txstatus =''4''
    and not  EXISTS (select 1 from tllog t where t.txnum = tl.txnum and t.deltd<>''Y'' and txstatus =''1'')
    GROUP BY  TL.TXDATE, TL.TXNUM
)', 'SEMAST', '', '', '8879', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;