SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CAMAST3394','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CAMAST3394', 'Quản lý thực hiện quyền', 'Coporate action management', 'SELECT DISTINCT CA.VALUE, CA.AUTOID, CA.SYMBOL, CA.CAMASTID, CA.CODEID, CA.EXCODEID, CA.TYPEID, CA.KHQDATE,
CA.REPORTDATE, CA.DUEDATE, CA.ACTIONDATE, CA.BEGINDATE, CA.EXPRICE, CA.EXRATE, CA.RIGHTOFFRATE,
CA.OPTCODEID, CA.DEVIDENTSHARES, CA.SPLITRATE, CA.INTERESTRATE, CA.DESCRIPTION, CA.CONTENTS, CA.INTERESTPERIOD,
CA.FRDATERETAIL, CA.TODATERETAIL, CA.TRFLIMIT, CA.ROPRICE, CA.TVPRICE,
CA.PITRATE, CA.PITRATEMETHOD_CD, CA.CATYPEVAL, CA.FRDATETRANSFER,
CA.TODATETRANSFER, CA.PITRATESE, CA.INACTIONDATE, CA.AMT, CA.QTTY, CA.TAXAMT, CA.AMTAFTER,
CA.STATUSVAL, CA.ISCHANGESTT, CA.MAKERID, CA.APPRVID, CA.ISRIGHTOFF, CA.TRADE, CA.TRADE3375,
CA.TOSYMBOL, CA.TOCODEID, CA.CAQTTY, CA.CANCELDATE, CA.RECEIVEDATE, CA.ISINCODE, CA.ADVDESC,
CA.TYPERATE, CA.DEVIDENTRATE, CA.DEVIDENTVALUE, CA.REMAINDEVIDENTRATE, CA.REMAINDEVIDENTVALUE,
CA.RATE1, CA.STATUS1, CA.DEBITDATE, CA.RIGHTTRANSDL, CA.VSDID,
A1.<@CDCONTENT> CATYPE, A3.<@CDCONTENT> PITRATEMETHOD, A4.<@CDCONTENT> FORMOFPAYMENT,
(CASE WHEN CA.TRADEDATE IS NULL THEN '''' ELSE TO_CHAR(CA.TRADEDATE,''DD/MM/RRRR'') END) TRADEDATE,
(CASE WHEN CA.CATYPE IN (''014'',''023'') THEN TO_CHAR(CA.INSDEADLINE,''DD/MM/RRRR'') ELSE CA.INSTRUCTION END) INSTRUCTION,
(CASE WHEN CA.CATYPE =''011'' AND CA.DEVIDENTRATE <> 0 THEN CA.DEVIDENTRATE||''%'' WHEN CA.CATYPE =''011'' AND CA.DEVIDENTRATE = 0 THEN CA.DEVIDENTSHARES ELSE CA.RATE END) RATE,
(CASE WHEN CA.DELTD=''Y'' then ''Cancelled'' else A2.<@CDCONTENT> end) STATUS
FROM V_CAMAST_CANCELLED CA,
(SELECT * FROM ALLCODE WHERE CDNAME = ''CATYPE'' AND CDTYPE = ''CA'') A1,
(SELECT * FROM ALLCODE WHERE CDNAME = ''CASTATUS'' AND CDTYPE = ''CA'') A2,
(SELECT * FROM ALLCODE WHERE CDNAME = ''PITRATEMETHOD'' AND CDTYPE = ''CA'') A3,
(SELECT * FROM ALLCODE WHERE CDNAME = ''FORMOFPAYMENT'' AND CDTYPE = ''CA'') A4,
(SELECT * FROM TLLOGALL WHERE TLTXCD = ''3388'' AND TXSTATUS = ''1'') TL
WHERE CA.VALUE = TL.MSGACCT
AND CA.CATYPE = A1.CDVAL
AND CA.PITRATEMETHOD = A3.CDVAL
AND CA.STATUS = A2.CDVAL
AND NVL(CA.FORMOFPAYMENT,''000'') = A4.CDVAL
AND CA.STATUS = ''C''', 'CAMAST', 'frmCAMAST', 'AUTOID DESC', NULL, 0, 500, 'N', 1, 'YYYYYYNNNNY', 'Y', 'T', NULL, 'N', NULL);COMMIT;