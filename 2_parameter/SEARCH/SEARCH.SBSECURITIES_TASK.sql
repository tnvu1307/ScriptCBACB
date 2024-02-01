SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SBSECURITIES_TASK','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SBSECURITIES_TASK', 'Quản lý trái phiếu', 'Securities management', 'SELECT BI.BONDCODE ,ISS.ISSUECODE, BI.BONDSYMBOL
FROM BONDISSUE BI, ISSUES ISS, ISSUERS ISR
WHERE BI.ISSUESID = ISS.AUTOID
AND ISS.ISSUERID = ISR.ISSUERID
AND ISS.EFFECTIVE = ''Y''
AND NVL(ISS.MATURITYDATE, GETCURRDATE) >= GETCURRDATE', 'SBSECURITIES', 'frmSBSECURITIES', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;