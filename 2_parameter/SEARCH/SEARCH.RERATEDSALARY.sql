SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RERATEDSALARY','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RERATEDSALARY', 'Định mức lương theo GTKL', 'Salary norm by matching amount', 'SELECT A.RERATEDTYPE,A.TORATED,A.FROMRATED,A.INDICATORS,A1.CDCONTENT STATUS FROM RERATEDSALARY A,ALLCODE A1 
WHERE A.RERATEDOBJID=''<$KEYVAL>'' AND A1.CDTYPE = ''RE'' AND A1.CDNAME = ''STATUS'' AND A1.CDVAL=A.STATUS ORDER BY A.RERATEDTYPE', 'RE.RERATEDSALARY', 'frmRERATEDSALARY', NULL, NULL, 0, 5000, 'N', 1, 'YYYNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;