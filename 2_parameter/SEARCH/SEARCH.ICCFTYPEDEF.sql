SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ICCFTYPEDEF','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('ICCFTYPEDEF', 'Xử lý tự động cuối ngày', 'Batch events', 'SELECT TYP.AUTOID, TYP.EVENTCODE, TYP.ACTYPE, APPEVENTS.EVENTNAME, A0.CDCONTENT PERIOD FROM ICCFTYPEDEF TYP, APPEVENTS, ALLCODE A0 WHERE A0.CDTYPE=''SA'' AND A0.CDNAME=''PERIOD'' AND A0.CDVAL=TYP.PERIOD AND TYP.EVENTCODE=APPEVENTS.EVENTCODE AND TYP.MODCODE=APPEVENTS.MODCODE AND TYP.MODCODE=''<$MODCODE>'' AND TYP.ACTYPE=''<$KEYVAL>'' ORDER BY TYP.EVENTCODE', 'SA.ICCFTYPEDEF', 'frmICCFTYPEDEF', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;