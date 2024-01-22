SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OD0014_1','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OD0014_1', 'Thanh toán tiền mua (TPRL)', 'Cut money from the buyer (PPBs)', 'SELECT CRD.VARVALUE, MST.AUTOID, MST.ORDERID, MST.AFACCTNO, MST.AFACCTNO || MST.CODEID SEACCTNO, MST.CODEID, MST.QTTY, MST.AMT, MST.FEEAMT, MST.CLEARDATE SETTLEMENT, FA.SHORTNAME BROKER,
	DD.REFCASAACCT, MST.VAT TAXAMT, CF.FULLNAME, CF.CIFID, CF.CUSTODYCD, MST.SYMBOL, MST.DDACCTNO,
	A1.<@CDCONTENT> TYPEORDER, A1.CDVAL, A2.<@CDCONTENT> ISHOLD, A2.CDVAL ISHOLD_TEXT,
	(''SETTLE-BUY - '' || MST.ORDERID ||'' - '' || MST.SYMBOL || '' - '' || MST.QTTY) DESCT
FROM ODMAST OD, FAMEMBERS FA, CFMAST CF, DDMAST DD,
(SELECT * FROM SBSECURITIES WHERE BONDTYPE <> ''001'' AND TRADEPLACE = ''099'') SB,
(SELECT * FROM STSCHD WHERE STATUS = ''P'' AND DELTD <> ''Y'' AND DUETYPE IN (''SM'')) MST,
(SELECT * FROM SYSVAR WHERE GRNAME = ''SYSTEM'' AND VARNAME = ''CURRDATE'') CRD,
(SELECT * FROM SYSVAR WHERE VARNAME = ''DEALINGCUSTODYCD'')SYS,
(SELECT * FROM ALLCODE WHERE CDNAME = ''EXECTYPE'' AND CDTYPE = ''OD'') A1,
(SELECT * FROM ALLCODE WHERE CDNAME = ''ISHOLDOD'' AND CDTYPE = ''OD'') A2
WHERE CF.CUSTID = OD.CUSTID
AND MST.ORDERID = OD.ORDERID
AND MST.CODEID = SB.CODEID
AND MST.DDACCTNO = DD.ACCTNO
AND OD.MEMBER = FA.AUTOID
AND OD.EXECTYPE = A1.CDVAL(+)
AND OD.ISHOLD = A2.CDVAL(+)
AND OD.EXECTYPE IN (''NB'')
AND OD.ISPAYMENT = ''N''
AND SUBSTR(OD.CUSTODYCD,0,4) NOT LIKE SYS.VARVALUE
AND TO_DATE(MST.CLEARDATE,''DD/MM/RRRR'') <= TO_DATE(CRD.VARVALUE,''DD/MM/RRRR'')
AND NOT EXISTS (
    SELECT F.CVALUE
    FROM TLLOG TL, TLLOGFLD F
    WHERE TL.TXNUM = F.TXNUM
    AND TL.TXDATE = F.TXDATE
    AND TL.TLTXCD = ''8818''
    AND TL.TXSTATUS IN (''1'', ''4'')
    AND F.FLDCD = ''01''
    AND F.NVALUE = MST.AUTOID
)', 'OD0014_1', 'frmODMAST', '', '8818', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;