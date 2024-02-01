SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('REGRPDEF','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('REGRPDEF', 'Loại hình đại lý/môi giới cho nhóm', 'Broker/Remiser product for group', 'SELECT RF.AUTOID, TYP.ACTYPE, TYP.TYPENAME,
A0.CDCONTENT DESC_REROLE, A1.CDCONTENT DESC_RETYPE, RF.EFFDATE, RF.EXPDATE
FROM REGRPDEF RF, RETYPE TYP, ALLCODE A0, ALLCODE A1
WHERE A0.CDTYPE=''RE'' AND A0.CDNAME=''REROLE'' AND A0.CDVAL=TYP.REROLE
AND A1.CDTYPE=''RE'' AND A1.CDNAME=''RETYPE'' AND A1.CDVAL=TYP.RETYPE
AND RF.REACTYPE=TYP.ACTYPE AND RF.REFRECFLNKID=''<$KEYVAL>'' ORDER BY EFFDATE, ACTYPE', 'RE.REGRPDEF', 'frmREGRPDEF', NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;