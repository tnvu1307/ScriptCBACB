SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('AFSEBASKET','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('AFSEBASKET', 'Loại hình ký quỹ', 'Margin type', 'SELECT TYP.AUTOID, TYP.ACTYPE, MST.TYPENAME, TYP.EFFDATE, TYP.EXPDATE FROM AFSEBASKET TYP, AFTYPE MST WHERE TYP.ACTYPE=MST.ACTYPE AND TYP.BASKETID=''<$KEYVAL>'' ORDER BY TYP.ACTYPE', 'SA.AFSEBASKET', 'frmAFSEBASKET', '', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;