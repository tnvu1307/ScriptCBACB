SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3309','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA3309', 'Tra cứu điện thông báo thông tin sự kiện quyền', 'Tra cứu điện thông báo thông tin sự kiện quyền', 'SELECT RE.REQID, RE.AUTOID,RE.VSDCAID, RE.ISINCODE, REQTYPE, A1.CDCONTENT CATYPENAME, CATYPE, SB.SYMBOL,
       SB1.SYMBOL TOSYMBOL, NULL REQTTY, NULL REAMT, A3.CDCONTENT CIROUNDTYPE, ACTIONRATE,
       NULL PRICE, BEGINDATE, NULL LASTDATE, REPORTDATE SEDATE, NULL TRFDATE, NULL ENDTRFDATE,
       ACTIONDATE, EXPRICE, MSGSTATUS, A2.CDCONTENT STATUS, TXDATE, REPORTDATE
FROM MSGCARECEIVED RE,
(SELECT * FROM SBSECURITIES WHERE REFCODEID IS NULL) SB,
(SELECT * FROM SBSECURITIES WHERE REFCODEID IS NULL) SB1,
(SELECT * FROM ALLCODE WHERE CDTYPE = ''CA'' AND CDNAME = ''CATYPE'') A1,
(SELECT * FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''VSDTXREQSTS'') A2,
(SELECT * FROM ALLCODE WHERE CDTYPE = ''CA'' AND CDNAME = ''ROUNDMETHOD'') A3
WHERE RE.CATYPE = A1.CDVAL(+)
AND RE.MSGSTATUS = A2.CDVAL(+)
AND RE.CIROUNDTYPE = A3.CDVAL(+)
AND RE.ISINCODE = SB.ISINCODE(+)
AND RE.TOISINCODE = SB1.ISINCODE(+)
AND RE.MSGSTATUS <> ''F''
AND RE.REQTYPE <> ''CANC''', 'CAMAST', NULL, 'REQID DESC', '3309', 0, 5000, 'N', 30, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;