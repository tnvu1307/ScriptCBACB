SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SA1118','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SA1118', 'Tra cứu yêu cầu chuyển tiền nội bộ từ internet (1118)', 'Pending internal transfer request from internet (1118)', 'SELECT AUTOID, REQUESTID,
CUSTODYCD, FULLNAME, FRACCTNO, TRFAMT, TRFDESC, REGTYP, REG_CUSTID, REG_ACCTNO, REG_BENEFICARY_NAME, REG_BENEFICARY_INFO, REG_TYPE, EN_REG_TYPE
FROM VW_STRADE_PENDING_TRF_REQUEST WHERE REGTYP=0 ', 'LOOKUP', NULL, ' AUTOID', '1118', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;