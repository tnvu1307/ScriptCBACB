SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CAMAST_SUBS','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CAMAST_SUBS', 'Quản lý thực hiện quyền', 'Coporate action management', 'SELECT VALUE, AUTOID, SYMBOL, CAMASTID, CODEID, EXCODEID, TYPEID, A1.<@CDCONTENT> CATYPE, KHQDATE,
REPORTDATE, DUEDATE, ACTIONDATE, BEGINDATE, EXPRICE, EXRATE, RIGHTOFFRATE,
OPTCODEID, DEVIDENTSHARES, SPLITRATE, INTERESTRATE, DESCRIPTION, CONTENTS,
INTERESTPERIOD, A2.<@CDCONTENT> STATUS, FRDATERETAIL, TODATERETAIL, TRFLIMIT, ROPRICE,
TVPRICE, (CASE WHEN CATYPE =''011'' AND DEVIDENTRATE <> 0 THEN DEVIDENTRATE||''%''
WHEN CATYPE =''011'' AND DEVIDENTRATE = 0 THEN DEVIDENTSHARES ELSE  RATE END ) RATE, PITRATE, PITRATEMETHOD_CD, A3.<@CDCONTENT> PITRATEMETHOD, CATYPEVAL, FRDATETRANSFER,
TODATETRANSFER, PITRATESE, INACTIONDATE, AMT, QTTY, TAXAMT, AMTAFTER,
STATUSVAL, ISCHANGESTT, MAKERID, APPRVID, ISRIGHTOFF, TRADE, TRADE3375,
TOSYMBOL, TOCODEID, CAQTTY, CANCELDATE, RECEIVEDATE, ISINCODE, ADVDESC,
TYPERATE, DEVIDENTRATE, DEVIDENTVALUE, REMAINDEVIDENTRATE, REMAINDEVIDENTVALUE,
TRADEDATE, RATE1, STATUS1,
CASE WHEN STATUS IN (''P'',''N'') THEN ''Y'' ELSE ''N'' END EDITALLOW,
CASE WHEN STATUS IN (''P'',''N'') THEN ''Y'' ELSE ''N'' END APRALLOW,
CASE WHEN STATUS IN (''P'',''N'') THEN ''Y'' ELSE ''N'' END DELALLOW
FROM V_CAMAST CA, ALLCODE A1, ALLCODE A2, ALLCODE A3
WHERE CA.CATYPE =''014'' AND CA.STATUS =''M''
AND A1.CDTYPE = ''CA''
AND A1.CDNAME = ''CATYPE'' AND A1.CDVAL = CA.CATYPE
AND A3.CDTYPE = ''CA'' AND A3.CDNAME = ''PITRATEMETHOD''
AND CA.PITRATEMETHOD = A3.CDVAL
AND A2.CDTYPE = ''CA'' AND A2.CDNAME = ''CASTATUS''
AND CA.STATUS = A2.CDVAL', 'CAMAST_SUBS', 'frmCAMAST', 'AUTOID DESC', NULL, 0, 5000, 'N', 1, 'YYYYYYNNNNY', 'Y', 'T', NULL, 'N', NULL);COMMIT;