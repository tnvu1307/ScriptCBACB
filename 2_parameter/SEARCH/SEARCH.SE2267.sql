SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE2267','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE2267', 'Tra cứu danh sách các đợt phát hành chưa niêm yết', 'List of unlisted issuances', 'SELECT TBL.*, TBL.QTTYADD - TBL.QTTY MQTTY, SB.CODEID
FROM TBL_2260 TBL, SBSECURITIES SB
WHERE TBL.SYMBOL = SB.SYMBOL
AND TBL.DELTD = ''N''
AND TBL.STATUS = ''P''
AND TBL.QTTYADD > 0', 'SE2267', 'frmSE2267', 'TXDATE DESC, TXNUM DESC', '2267', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;