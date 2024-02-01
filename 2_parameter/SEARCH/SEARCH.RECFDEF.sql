SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RECFDEF','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RECFDEF', 'Loại hình đại lý/môi giới', 'Broker/Remiser product', 'SELECT RF.AUTOID, TYP.ACTYPE, TYP.TYPENAME, A2.CDCONTENT
AFSTATUS,
A0.CDCONTENT DESC_REROLE, A1.CDCONTENT DESC_RETYPE,
RF.EFFDATE, RF.EXPDATE,RF.ODRNUM, RF.EFFDAYS, RF.EFFORD
FROM RECFDEF RF, RETYPE TYP, ALLCODE A0, ALLCODE A1,
ALLCODE A2
WHERE A0.CDTYPE=''RE'' AND A0.CDNAME=''REROLE'' AND
A0.CDVAL=TYP.REROLE
AND A2.CDTYPE = ''RE'' AND A2.CDNAME = ''AFSTATUS'' AND
A2.CDVAL = TYP.AFSTATUS
AND A1.CDTYPE=''RE'' AND A1.CDNAME=''RETYPE'' AND
A1.CDVAL=TYP.RETYPE
AND RF.REACTYPE=TYP.ACTYPE AND
 RF.REFRECFLNKID=''<$KEYVAL>''
 ORDER BY EFFDATE, ACTYPE', 'RE.RECFDEF', 'frmRECFDEF', NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;