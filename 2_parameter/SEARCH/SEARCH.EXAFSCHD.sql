SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('EXAFSCHD','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('EXAFSCHD', 'Customize schedule management', 'Customize schedule management', 'SELECT EX.*, AV.EVENTNAME
FROM EXAFSCHD EX, APPEVENTS AV WHERE EX.EVENTCODE=AV.EVENTCODE AND EX.MODCODE = AV.MODCODE AND EX.AFACCTNO=''<@KEYVALUE>''', 'EXAFSCHD', 'frmEXAFSCHD', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;