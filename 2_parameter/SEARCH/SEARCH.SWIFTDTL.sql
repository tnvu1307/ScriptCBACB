SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SWIFTDTL','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SWIFTDTL', 'Điện nhận từ client', 'Swift from client', 'SELECT DESCRIPTION CAPTION,DEFNAME,DEFVALUE VALUE
FROm SWIFTMSGMAPLOGDTL DTL
 WHERE DTL.MSGID = ''<$KEYVAL>'' order by DTL.MSGID desc', 'MT.SHVSWIFT', 'frmRECFDEF', NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;