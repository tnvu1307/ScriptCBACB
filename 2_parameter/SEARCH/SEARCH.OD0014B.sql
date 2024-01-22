SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OD0014B','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OD0014B', 'Cắt CK bán', 'Cut CK sale', 'SELECT MST.AUTOID, MST.ORDERID, MST.AFACCTNO, MST.AFACCTNO || MST.CODEID SEACCTNO, MST.CODEID, MST.QTTY, MST.AMT, MST.FEEAMT, MST.CLEARDATE SETTLEMENT, FA.SHORTNAME BROKER, MST.VAT TAXAMT, --STS.NETTING QTTY, STS.CASHRECEVING AMT, STS.FEEAMT, STS.VAT TAXAMT, STS.CLEARDATE SETTLEMENT,
    DD.REFCASAACCT, DD.ACCTNO DDACCTNO, CF.CUSTODYCD, SB.SYMBOL,
    CF.FULLNAME, CF.CIFID, ''SE'' TYPE, A1.<@CDCONTENT> TYPEORDER, A1.CDVAL, A2.<@CDCONTENT> ASSETTYPE
FROM ODMAST OD, FAMEMBERS FA, CFMAST CF, DDMAST DD,
(SELECT * FROM SBSECURITIES WHERE BONDTYPE <> ''001'') SB,
--(SELECT * FROM STSCHD_NETOFF WHERE STATUS = ''P'' AND DELTD = ''N'') STS,
(SELECT * FROM STSCHD WHERE STATUS = ''P'' AND DELTD <> ''Y'' AND DUETYPE IN (''SS'')) MST,
(SELECT * FROM SYSVAR WHERE GRNAME = ''SYSTEM'' AND VARNAME = ''CURRDATE'') CRD,
(SELECT * FROM ALLCODE WHERE CDNAME = ''EXECTYPE'' AND CDTYPE = ''OD'') A1,
(SELECT * FROM ALLCODE WHERE CDNAME = ''ASSETTYPE'' AND CDTYPE = ''OD'') A2
WHERE CF.CUSTID = OD.CUSTID
AND MST.ORDERID = OD.ORDERID
AND MST.CODEID = SB.CODEID
AND MST.DDACCTNO = DD.ACCTNO
AND OD.MEMBER = FA.AUTOID
AND OD.EXECTYPE = A1.CDVAL(+)
AND OD.EXECTYPE IN (''NS'')
AND TO_DATE(MST.CLEARDATE, ''DD/MM/RRRR'') = TO_DATE(CRD.VARVALUE,''DD/MM/RRRR'')
AND (CASE WHEN SB.TRADEPLACE = ''099'' THEN ''TPRL'' ELSE ''CKNY'' END) = A2.CDVAL(+)
AND NOT EXISTS (
    SELECT F.CVALUE
    FROM TLLOG TL, TLLOGFLD F
    WHERE TL.TXNUM = F.TXNUM
    AND TL.TXDATE = F.TXDATE
    AND TL.TLTXCD = ''8848''
    AND TL.TXSTATUS IN (''1'', ''4'')
    AND F.FLDCD = ''01''
    AND F.NVALUE = MST.AUTOID
)', 'OD.ODMAST', 'frmODMAST', '', '8848', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;