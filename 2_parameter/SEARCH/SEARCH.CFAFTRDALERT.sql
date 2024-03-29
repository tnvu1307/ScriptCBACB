SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CFAFTRDALERT','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CFAFTRDALERT', 'Cảnh báo đầu tư', 'Trading alert', 'SELECT MST.AUTOID, MST.NOTES, MST.FRDATE, MST.TODATE, SB.SYMBOL, 
A0.CDCONTENT STATUS, A1.CDCONTENT ALERTTYP, A2.CDCONTENT ALERTCD, A3.CDCONTENT OPERATORCD, A4.CDCONTENT SRCREFFIELD, MST.TRGVAL,
(CASE WHEN MST.STATUS=''P'' THEN ''Y'' ELSE ''N'' END) APRALLOW
FROM CFAFTRDALERT MST, SBSECURITIES SB, ALLCODE A0, ALLCODE A1, ALLCODE A2, ALLCODE A3, ALLCODE A4
WHERE MST.CODEID=SB.CODEID 
AND A0.CDVAL=MST.STATUS AND A0.CDTYPE = ''SY'' AND A0.CDNAME = ''TYPESTS''
AND A1.CDVAL=MST.ALERTTYP AND A1.CDTYPE = ''SY'' AND A1.CDNAME = ''ALERTTYP''
AND A2.CDVAL=MST.ALERTCD AND A2.CDTYPE = ''SY'' AND A2.CDNAME = ''ALERTCD''
AND A3.CDVAL=MST.OPERATORCD AND A3.CDTYPE = ''SY'' AND A3.CDNAME = ''OPERATORCD''
AND A4.CDVAL=MST.SRCREFFIELD AND A4.CDTYPE = ''SY'' AND A4.CDNAME = ''SRCREFFIELD''', 'CFAFTRDALERT', 'frmCFAFTRDALERT', NULL, 'EXEC', NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;