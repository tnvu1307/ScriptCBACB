SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CAMAST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CAMAST', 'Quản lý thực hiện quyền', 'Coporate action management', 'SELECT distinct VALUE, AUTOID, SYMBOL, ca.CAMASTID, CODEID, EXCODEID, TYPEID, A1.<@CDCONTENT> CATYPE, KHQDATE,
REPORTDATE, DUEDATE, ACTIONDATE, BEGINDATE, EXPRICE, EXRATE, RIGHTOFFRATE,
OPTCODEID, DEVIDENTSHARES, SPLITRATE, INTERESTRATE, DESCRIPTION, CONTENTS,
INTERESTPERIOD, (CASE WHEN CA.DELTD = ''Y'' THEN ''Cancelled'' WHEN CAL.CAMASTID IS NOT NULL THEN CAL.<@CDCONTENT> ELSE A2.<@CDCONTENT> END) STATUS, FRDATERETAIL, TODATERETAIL, TRFLIMIT,
(CASE WHEN CATYPE = ''040'' THEN EXPRICE ELSE ROPRICE END) ROPRICE,
TVPRICE,(CASE WHEN CATYPE =''011'' AND DEVIDENTRATE <> 0 THEN DEVIDENTRATE||''%''
WHEN CATYPE =''011'' AND DEVIDENTRATE = 0 THEN DEVIDENTSHARES ELSE  RATE END ) RATE, PITRATE, PITRATEMETHOD_CD, A3.<@CDCONTENT> PITRATEMETHOD, CATYPEVAL, FRDATETRANSFER,
TODATETRANSFER, PITRATESE, INACTIONDATE, AMT, QTTY, TAXAMT, AMTAFTER,
STATUSVAL, ISCHANGESTT, MAKERID, APPRVID, ISRIGHTOFF, TRADE, TRADE3375,
TOSYMBOL, TOCODEID, CAQTTY, CANCELDATE, RECEIVEDATE, ISINCODE, ADVDESC,
TYPERATE, DEVIDENTRATE, DEVIDENTVALUE, REMAINDEVIDENTRATE, REMAINDEVIDENTVALUE,
RATE1, STATUS1, A4.<@CDCONTENT> FORMOFPAYMENT,
(CASE WHEN TRADEDATE IS NULL THEN '''' ELSE TO_CHAR(TRADEDATE,''DD/MM/RRRR'') END) TRADEDATE,
(CASE WHEN STATUS IN (''P'',''N'') AND DELTD =''N'' AND CAL.CAMASTID IS NULL THEN ''Y'' ELSE ''N'' END) EDITALLOW,
(CASE WHEN STATUS IN (''P'',''N'') AND DELTD =''N'' THEN ''Y'' ELSE ''N'' END) APRALLOW,
(CASE WHEN STATUS IN (''N'') AND DELTD=''N'' THEN ''Y'' ELSE ''N'' END) DELALLOW, CA.DEBITDATE, CA.RIGHTTRANSDL,
(CASE WHEN CA.CATYPE IN (''014'',''023'') THEN TO_CHAR(CA.INSDEADLINE,''DD/MM/RRRR'') ELSE CA.INSTRUCTION END) INSTRUCTION,
CA.VSDID
FROM V_CAMAST_CANCELLED CA, ALLCODE A1, ALLCODE A2, ALLCODE A3,ALLCODE A4, CAMAST_DELETELOG CAL
WHERE A1.CDTYPE = ''CA''
AND A1.CDNAME = ''CATYPE'' AND A1.CDVAL = CA.CATYPE
AND A3.CDTYPE = ''CA'' AND A3.CDNAME = ''PITRATEMETHOD''
AND CA.PITRATEMETHOD = A3.CDVAL
AND NOT (CA.DELTD=''Y'' OR  CA.STATUS=''C'')
AND A2.CDTYPE = ''CA'' AND A2.CDNAME = ''CASTATUS''
AND CA.STATUS = A2.CDVAL
AND A4.CDTYPE = ''CA'' AND A4.CDNAME = ''FORMOFPAYMENT''
AND NVL(CA.FORMOFPAYMENT,''000'') = A4.CDVAL
AND REPLACE(CA.CAMASTID,''.'','''') = CAL.CAMASTID(+)', 'CAMAST', 'frmCAMAST', 'AUTOID DESC', '', 0, 500, 'N', 1, 'YYYYYYNNNNY', 'Y', 'T', '', 'N', '');COMMIT;