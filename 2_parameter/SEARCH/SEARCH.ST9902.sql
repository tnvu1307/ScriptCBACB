SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ST9902','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('ST9902', 'Thông báo xác nhận lệnh', 'Order confirmation message', 'SELECT OD.VSDMSGID, OD.VSDMSGDATE, TRF.DESCRIPTION, OD.CUSTODYCD, OD.ISINCODE, SB.SYMBOL, SB.CODEID,
    OD.QTTY, OD.PRICE, OD.AMT, OD.CCYCD, OD.SETTDATE, DE.DEPOSITID || ''-'' || DE.SHORTNAME REBICCODE, 
    OD.CANCELID, OD.STATUS,
    A1.CDCONTENT TRADEPLACE, A2.CDCONTENT SESS
FROM MSGODRECEIVED OD, DEPOSIT_MEMBER DE,
(SELECT * FROM SBSECURITIES WHERE REFCODEID IS NULL) SB,
(SELECT * FROM VSDTRFCODE WHERE VSDMT = ''586'' AND TYPE = ''INF'') TRF,
(SELECT * FROM ALLCODE WHERE CDNAME LIKE ''KRXTRADEPLACE'' AND CDTYPE = ''OD'') A1,
(SELECT * FROM ALLCODE WHERE CDNAME LIKE ''KRXSESSION'' AND CDTYPE = ''OD'') A2
WHERE OD.TRFCODE = TRF.TRFCODE
AND OD.ISINCODE = SB.ISINCODE(+)
AND OD.REBICCODE = DE.BICCODE(+)
AND OD.TRADEPLACE = A1.CDVAL(+)
AND OD.SESS = A2.CDVAL(+)
AND OD.DELTD IN (''N'')
AND OD.STATUS IN (''P'',''E'',''R'')', 'ST9902', '', '', '1501', NULL, 5000, 'N', 30, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;