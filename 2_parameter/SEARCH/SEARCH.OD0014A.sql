SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OD0014A','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OD0014A', 'Nhận CK mua', 'Receive the buying securities for the buyer', 'SELECT MST.AUTOID, MST.ORDERID, MST.AFACCTNO, MST.AFACCTNO || MST.CODEID SEACCTNO, MST.CODEID, MST.QTTY, MST.AMT, MST.FEEAMT, MST.CLEARDATE SETTLEMENT, FA.SHORTNAME BROKER, MST.VAT TAXAMT, --STS.RECEVING QTTY, STS.CASHNETTING AMT, STS.FEEAMT, STS.VAT TAXAMT, STS.CLEARDATE SETTLEMENT,
    DD.REFCASAACCT, DD.ACCTNO DDACCTNO, CF.CUSTODYCD, SB.SYMBOL,
    CF.FULLNAME, CF.CIFID, A1.<@CDCONTENT> TYPEORDER, A1.CDVAL, A2.<@CDCONTENT> ASSETTYPE
FROM ODMAST OD, FAMEMBERS FA, CFMAST CF, DDMAST DD,
(SELECT * FROM SBSECURITIES WHERE BONDTYPE <> ''001'') SB,
--(SELECT * FROM STSCHD_NETOFF WHERE STATUS = ''P'' AND DELTD = ''N'') STS,
(SELECT * FROM STSCHD WHERE STATUS = ''P'' AND DELTD <> ''Y'' AND DUETYPE IN (''RS'')) MST,
(SELECT * FROM SYSVAR WHERE GRNAME = ''SYSTEM'' AND VARNAME = ''CURRDATE'') CRD,
(SELECT * FROM ALLCODE WHERE CDNAME = ''EXECTYPE'' AND CDTYPE = ''OD'') A1,
(SELECT * FROM ALLCODE WHERE CDNAME = ''ASSETTYPE'' AND CDTYPE = ''OD'') A2
WHERE CF.CUSTID = OD.CUSTID
AND MST.ORDERID = OD.ORDERID
AND MST.CODEID = SB.CODEID
AND MST.DDACCTNO = DD.ACCTNO
AND OD.MEMBER = FA.AUTOID
AND OD.EXECTYPE = A1.CDVAL(+)
AND OD.EXECTYPE IN (''NB'')
AND TO_DATE(MST.CLEARDATE, ''DD/MM/RRRR'') = TO_DATE(CRD.VARVALUE,''DD/MM/RRRR'')
AND (CASE WHEN SB.TRADEPLACE = ''099'' THEN ''TPRL'' ELSE ''CKNY'' END) = A2.CDVAL(+)
AND NOT EXISTS (
    SELECT F.CVALUE
    FROM TLLOG TL, TLLOGFLD F
    WHERE TL.TXNUM = F.TXNUM
    AND TL.TXDATE = F.TXDATE
    AND TL.TLTXCD = ''8819''
    AND TL.TXSTATUS IN (''1'', ''4'')
    AND F.FLDCD = ''01''
    AND F.NVALUE = MST.AUTOID
)', 'OD.ODMAST', 'frmODMAST', '', '8819', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;