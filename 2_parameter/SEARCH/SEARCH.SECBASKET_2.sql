SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SECBASKET_2','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SECBASKET_2', 'Chứng khoán ký quỹ tài khoản', 'Securities for credit line', 'SELECT TYP.AUTOID, TYP.SYMBOL, TYP.MRRATIORATE, TYP.MRRATIOLOAN, TYP.MRPRICERATE, TYP.MRPRICELOAN
        FROM SECBASKET TYP
        WHERE BASKETID LIKE SUBSTR(''<$KEYVAL>'', 9, LENGTH(''<$KEYVAL>'')) ORDER BY SYMBOL', 'SA.SECBASKET', 'frmSECBASKET', NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;