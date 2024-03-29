SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CAMAST_COMPARE','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CAMAST_COMPARE', 'Quản lý thực hiện quyền', 'Coporate action management', 'SELECT CAMAST.CAMASTID VALUE,CAMAST.AUTOID,SYM.SYMBOL,SUBSTR(CAMAST.CAMASTID,1,4)||''.''||SUBSTR(CAMAST.CAMASTID,5,6)||''.''||SUBSTR(CAMAST.CAMASTID,11,6) CAMASTID,
CAMAST.CODEID, CAMAST.EXCODEID, A1.CDVAL TYPEID, A1.CDCONTENT CATYPE, REPORTDATE ,DUEDATE,ACTIONDATE ,BEGINDATE, EXPRICE, EXRATE, RIGHTOFFRATE, DEVIDENTRATE,OPTCODEID,
DEVIDENTSHARES, SPLITRATE, INTERESTRATE, CAMAST.DESCRIPTION,CAMAST.DESCRIPTION CONTENTS, INTERESTPERIOD, A2.CDCONTENT STATUS, FRDATERETAIL, TODATERETAIL, TRFLIMIT, CAMAST.VSDCAID,CAMAST.VSDID VSDMSGID,
TOSYM.SYMBOL TOSYMBOL, A3.CDVAL PITRATEMETHOD_CD, A3.CDCONTENT PITRATEMETHOD,CAMAST.ISINCODE
FROM  CAMAST, SBSECURITIES SYM,SBSECURITIES TOSYM,ALLCODE A1,ALLCODE A2,ALLCODE A3
WHERE CAMAST.CODEID=SYM.CODEID
AND A1.CDTYPE = ''CA''
AND A1.CDNAME = ''CATYPE'' AND A1.CDVAL=CATYPE
AND A3.CDTYPE=''CA'' AND A3.CDNAME=''PITRATEMETHOD'' AND CAMAST.PITRATEMETHOD =A3.CDVAL
AND A2.CDTYPE = ''CA'' AND A2.CDNAME = ''CASTATUS''
AND CAMAST.STATUS=A2.CDVAL AND CAMAST.DELTD =''N''
AND CAMAST.STATUS NOT IN (''C'',''W'',''G'',''J'',''H'')
AND NVL(CAMAST.TOCODEID,CAMAST.CODEID)=TOSYM.CODEID', 'CAMAST_COMPARE', 'frmCAMAST_COMPARE', 'AUTOID DESC', NULL, NULL, 50, 'N', 30, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;