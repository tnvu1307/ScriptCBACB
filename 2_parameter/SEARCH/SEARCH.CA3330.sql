SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3330','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA3330', 'Màn hình điều chỉnh lịch thực hiện quyền được nhận về do chuyển khoản ', 'View adjust CA schedule receive due to transfer', 'SELECT V.*,CF.CIFID 
FROM V_SE2226 V 
LEFT JOIN CFMAST CF ON CF.CUSTODYCD = V.CUSTODYCD 
WHERE 0=0', 'CAMAST', NULL, NULL, '3330', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;