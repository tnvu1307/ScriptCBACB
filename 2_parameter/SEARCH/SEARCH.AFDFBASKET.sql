SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('AFDFBASKET','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('AFDFBASKET', 'Loại hình cầm cố/forward', 'Mortage/forward product', 'SELECT TYP.AUTOID, TYP.ACTYPE, MST.TYPENAME, TYP.EFFDATE, TYP.EXPDATE FROM AFDFBASKET TYP, DFTYPE MST WHERE TYP.ACTYPE=MST.ACTYPE AND TYP.BASKETID=''<$KEYVAL>'' ORDER BY TYP.ACTYPE', 'SA.AFDFBASKET', 'frmAFDFBASKET', NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;