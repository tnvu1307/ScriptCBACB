SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SA0003','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SA0003', 'Change customize amplitude(Wait for 0003)', 'Change customize amplitude(Wait for 0003)', 'SELECT TL.ACTYPE,ENV.MODCODE, ENV.EVENTCODE,ENV.EVENTNAME,FLOORAMP,
CEILAMP,CREATEDBY,TO_CHAR(CREATEDDT,''DD/MM/YYYY'') CREATEDDT,
APPROVEDBY,TO_CHAR(APPROVEDDT,''DD/MM/YYYY'') APPROVEDDT FROM APPEVENTS ENV, TYPELINE TL
WHERE ENV.MODCODE=TL.MODCODE AND ENV.EVENTCODE=TL.EVENTCODE AND TL.DELTD<>''Y''', 'SYSVAR', NULL, NULL, '0003', NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;