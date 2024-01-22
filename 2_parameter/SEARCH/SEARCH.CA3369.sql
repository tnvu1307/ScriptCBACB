SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3369','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA3369', 'Thực cắt đăng kí quyền mua', 'Actual debit right issue register', 'SELECT MST.* FROM (
SELECT SUBSTR(CAMAST.CAMASTID,1,4) || ''.'' || SUBSTR(CAMAST.CAMASTID,5,6) || ''.'' || SUBSTR(CAMAST.CAMASTID,11,6) CAMASTID,
       A2.CDCONTENT CATYPE,
       SUM(CA.BALANCE)  BALANCE, SUM(CA.QTTY+CA.SENDQTTY+CA.CUTQTTY-CA.TQTTY)  QTTY,
       SUM(CA.NMQTTY) NMQTTY, SUM(CA.QTTY+CA.SENDQTTY+CA.CUTQTTY-CA.TQTTY-CA.NMQTTY ) MQTTY,
       SUM(CA.QTTY+CA.SENDQTTY+CA.CUTQTTY-CA.TQTTY) * CAMAST.EXPRICE AMT,
       SYM.SYMBOL, CAMAST.REPORTDATE REPORTDATE, CAMAST.ACTIONDATE,
       CAMAST.EXPRICE, SYM_ORG.SYMBOL SYMBOL_ORG, CAMAST.ISINCODE
FROM  SBSECURITIES SYM, CAMAST, CASCHD  CA, ALLCODE A2, SBSECURITIES SYM_ORG
WHERE CAMAST.TOCODEID = SYM.CODEID
      AND CAMAST.CAMASTID  = CA.CAMASTID
      AND CAMAST.CATYPE =''014''
      AND CAMAST.CATYPE = A2.CDVAL
      AND A2.CDTYPE = ''CA''
      AND A2.CDNAME = ''CATYPE''
      AND CA.STATUS IN(''M'',''O'') AND CA.STATUS <>''Y'' AND CA.DELTD <> ''Y''
      AND CA.BALANCE > 0 AND (CA.QTTY+ CA.SENDQTTY+CA.CUTQTTY- CA.TQTTY)  > 0
      AND SYM_ORG.CODEID=CAMAST.CODEID
GROUP BY CAMAST.CAMASTID, A2.CDCONTENT,
         SYM.SYMBOL, CAMAST.REPORTDATE, CAMAST.ACTIONDATE,
         CAMAST.EXPRICE, SYM_ORG.SYMBOL, CAMAST.ISINCODE
) MST WHERE 0=0 ', 'CAMAST', '', '', '', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;