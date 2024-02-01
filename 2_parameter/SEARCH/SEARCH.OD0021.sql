SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OD0021','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OD0021', 'Thanh toán tiền mua G-bond', 'Payment of G-bond purchase', 'SELECT OD.ORDERID, OD.TXNUM, DD.ACCTNO DDACCTNO, DD.REFCASAACCT, CF.FULLNAME, OD.EXECAMT AMOUNT, OD.FEEAMT,
    OD.TAXAMT, OD.IDENTITY, CRB.BANKNAME,CRB.bankname BANKACCNAME, OD.CITAD,''DD'' TYPE,OD.SEACCTNO,OD.EXECQTTY QTTY,A1.<@CDCONTENT> ISHOLD,A1.CDVAL ISHOLD_TEXT,
    ''SETTLE-BUY - ''||OD.ORDERID || '' - '' || OD.SYMBOL || '' - '' || OD.EXECQTTY DESCRIPTION, CF.CUSTODYCD, SB.SYMBOl,CRB.BANKACCOUNT RDDACCTNO_GB
FROM ODMAST OD, DDMAST DD ,CFMAST CF, CRBBANKLIST CRB, SBSECURITIES SB, ALLCODE A1
WHERE OD.DDACCTNO = DD.ACCTNO
AND DD.STATUS <> ''C'' AND DD.ISDEFAULT = ''Y''
AND OD.CUSTID = CF.CUSTID
AND OD.CITAD = CRB.CITAD
AND OD.CODEID = SB.CODEID
AND SB.BONDTYPE = ''001''
AND OD.EXECTYPE = ''NB''
AND OD.CLEARDATE <= GETCURRDATE
AND OD.ISPAYMENT = ''N''
AND A1.CDTYPE = ''OD'' AND A1.CDNAME = ''ISHOLDOD'' AND A1.CDVAL  = OD.ISHOLD
AND NOT EXISTS (
    SELECT F1.CVALUE
    FROM TLLOG TL, TLLOGFLD F1
    WHERE TL.TXNUM = F1.TXNUM
    AND TL.TXDATE = F1.TXDATE
    AND TL.TLTXCD = ''8869''
    AND F1.FLDCD = ''25''
    AND TL.TXSTATUS IN(''1'', ''4'')
    AND F1.CVALUE = OD.ORDERID
    AND OD.ISPAYMENT =''N''
)', 'OD0021', 'frmODMAST', 'TXNUM', '8869', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;