SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('TTDIENR_VSTP','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('TTDIENR_VSTP', 'Điện nhận từ VSD', 'Receive from VSD  ', 'SELECT DTL.CAPTION, DTL.FLDVAL VALUE
FROM VSDTRFLOGDTL_VSTP DTL, VSDTRFLOG_VSTP LOG
WHERE LOG.AUTOID = DTL.REFAUTOID
AND LOG.AUTOID = to_char(''<$KEYVAL>'') 
ORDER BY DTL.AUTOID', 'ST.TTDIENR_VSTP', 'frmTTDIENR_VSTP', '', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;