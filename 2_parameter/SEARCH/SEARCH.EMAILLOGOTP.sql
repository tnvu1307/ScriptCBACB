SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('EMAILLOGOTP','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('EMAILLOGOTP', 'Quản lý log OTP', 'Management OTP log', 'SELECT RECEIVERMAIL, RECEIVERNAME, OTPVALUE, CREATED_AT, TO_CHAR(CREATED_AT, ''DD/MM/RRRR'') CREATEDDATE, TO_CHAR(CREATED_AT, ''HH24:MI:SS'') CREATEDTIME 
FROM EMAILLOG_OTP 
WHERE 0 = 0', 'EMAILLOGOTP', NULL, 'CREATED_AT DESC', NULL, NULL, 500, 'N', 1, 'NNNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;