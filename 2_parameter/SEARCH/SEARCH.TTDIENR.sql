SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('TTDIENR','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('TTDIENR', 'Điện nhận từ VSD', 'Receive from VSD  ', 'SELECT DTL.CAPTION, DTL.FLDVAL VALUE
FROM VSDTRFLOGDTL DTL, VSDTRFLOG LOG
WHERE LOG.AUTOID = DTL.REFAUTOID
AND LOG.AUTOID = to_char(''<$KEYVAL>'') 
ORDER BY DTL.AUTOID', 'ST.TTDIEN', 'frmRECFDEF', NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;