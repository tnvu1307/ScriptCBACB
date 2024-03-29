SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CAMAST_STATUS_ALL','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CAMAST_STATUS_ALL', 'Quản lý thực hiện quyền', 'Coporate action management', 'SELECT VALUE, AUTOID, SYMBOL, CAMASTID, CODEID, EXCODEID, TYPEID, A1.<@CDCONTENT> CATYPE, KHQDATE,
REPORTDATE, DUEDATE, ACTIONDATE, BEGINDATE, EXPRICE, EXRATE, RIGHTOFFRATE,
OPTCODEID, DEVIDENTSHARES, SPLITRATE, INTERESTRATE, DESCRIPTION, CONTENTS,
INTERESTPERIOD, case when ca.deltd=''Y'' then ''Cancelled'' else A2.<@CDCONTENT> end STATUS, FRDATERETAIL, TODATERETAIL, TRFLIMIT, ROPRICE,
TVPRICE,(CASE WHEN CATYPE =''011'' AND DEVIDENTRATE <> 0 THEN DEVIDENTRATE||''%''
WHEN CATYPE =''011'' AND DEVIDENTRATE = 0 THEN DEVIDENTSHARES ELSE  RATE END ) RATE, PITRATE, PITRATEMETHOD_CD, A3.<@CDCONTENT> PITRATEMETHOD, CATYPEVAL, FRDATETRANSFER,
TODATETRANSFER, PITRATESE, INACTIONDATE, AMT, QTTY, TAXAMT, AMTAFTER,
STATUSVAL, ISCHANGESTT, MAKERID, APPRVID, ISRIGHTOFF, TRADE, TRADE3375,
TOSYMBOL, TOCODEID, CAQTTY, CANCELDATE, RECEIVEDATE, ISINCODE, ADVDESC,
TYPERATE, DEVIDENTRATE, DEVIDENTVALUE, REMAINDEVIDENTRATE, REMAINDEVIDENTVALUE,
RATE1, STATUS1, A4.<@CDCONTENT>   FORMOFPAYMENT,
(CASE WHEN TRADEDATE IS NULL THEN '''' ELSE TO_CHAR(TRADEDATE,''DD/MM/RRRR'') END) TRADEDATE,
(CASE WHEN STATUS IN (''P'',''N'') and deltd=''N'' THEN ''Y'' ELSE ''N'' END) EDITALLOW,
(CASE WHEN STATUS IN (''P'',''N'') and deltd=''N'' THEN ''Y'' ELSE ''N'' END) APRALLOW,
(CASE WHEN STATUS IN (''P'',''N'') and deltd=''N'' THEN ''Y'' ELSE ''N'' END) DELALLOW,CA.INSTRUCTION,CA.DEBITDATE,CA.RIGHTTRANSDL
FROM v_camast_cancelled CA, ALLCODE A1, ALLCODE A2, ALLCODE A3,ALLCODE A4
WHERE A1.CDTYPE = ''CA''
AND A1.CDNAME = ''CATYPE'' AND A1.CDVAL = CA.CATYPE
AND A3.CDTYPE = ''CA'' AND A3.CDNAME = ''PITRATEMETHOD''
AND CA.PITRATEMETHOD = A3.CDVAL
AND CA.DELTD = ''N''
AND A2.CDTYPE = ''CA'' AND A2.CDNAME = ''CASTATUS''
AND CA.STATUS = A2.CDVAL
AND A4.CDTYPE = ''CA'' AND A4.CDNAME = ''FORMOFPAYMENT''
AND nvl(CA.FORMOFPAYMENT,''000'') = A4.CDVAL', 'CAMAST', 'frmCAMAST', 'AUTOID DESC', NULL, 0, 500, 'N', 1, 'YYYYYYNNNNY', 'Y', 'T', NULL, 'N', NULL);COMMIT;