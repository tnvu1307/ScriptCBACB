SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('BA0006','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('BA0006', 'Tra cứu lịch sử chuyển nhượng trái phiếu', 'Browse bond transfer history', 'SELECT A.TXNUM, A.TXDATE, A.BUSDATE, A.SCIFID, A.SCUSTODYCD, A.SFULLNAME, A.SYMBOL, A.TQTTY, A.BALANCETRANS, A.BALANCERCV, A.RCIFID, A.RCUSTODYCD, A.RFULLNAME, A.SECTYPE , ISS.SHORTNAME TCPH
FROM DATALOG_1911 A, SBSECURITIES SB, ISSUERS ISS
WHERE A.SYMBOL = SB.SYMBOL AND SB.ISSUERID = ISS.ISSUERID', 'BA0006', '', '', '', 0, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;