SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SBSECURITIES_CASH','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SBSECURITIES_CASH', 'Quản lý tiền mặt', 'Cashes management', 'SELECT SB.CODEID,SB.ISSUERID,SB.SYMBOL,A0.EN_CDCONTENT SECTYPE, SB.CONTRACTNO, SB.CONTRACTDATE 
FROM SBSECURITIES SB, ALLCODE A0
WHERE SB.SECTYPE IN (''014'') 
AND SB.CONTRACTNO IS NOT NULL
AND A0.CDTYPE = ''SA'' AND A0.CDNAME = ''SECTYPE'' AND A0.CDVAL = SB.SECTYPE', 'SBSECURITIES_SYMBOL', NULL, NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;