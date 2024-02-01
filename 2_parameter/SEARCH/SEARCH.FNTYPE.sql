SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('FNTYPE','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('FNTYPE', 'Loại hình quỹ, ủy thác vốn', 'Fund, trust unit product type', 'SELECT TYP.ACTYPE, TYP.TYPENAME, A0.CDCONTENT DESC_FNTYPE, A1.CDCONTENT DESC_STATUS
FROM FNTYPE TYP, ALLCODE A0, ALLCODE A1
WHERE A0.CDTYPE=''FN'' AND A0.CDNAME=''FNTYPE'' AND A0.CDVAL=TYP.FNTYPE
AND A1.CDTYPE=''SY'' AND A1.CDNAME=''TYPESTS'' AND A1.CDVAL=TYP.APPRV_STS', 'FNTYPE', 'frmFNTYPE', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;