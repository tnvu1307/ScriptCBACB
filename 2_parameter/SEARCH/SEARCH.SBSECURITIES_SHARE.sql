SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SBSECURITIES_SHARE','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SBSECURITIES_SHARE', 'Quản lý chứng khoán', 'Securities management', 'SELECT SB.CODEID,SB.ISSUERID,SB.SYMBOL,SB.SECTYPE FROM SBSECURITIES SB WHERE SB.SECTYPE IN (''001'',''002'')', 'SBSECURITIES', 'frmSBSECURITIES', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;