SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OD8898','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OD8898', 'Tra cứu lệnh bán sửa lỗi (8898)', 'View  correct sell order (8898)', 'SELECT ORDERID, CODEID, SYMBOL,CUSTODYCD, FULLNAME, TYPENAME,
AFACCTNO, DESC_EXECTYPE, ORDERQTTY, ORDERPRICE, BRATIO, REMAINQTTY, EXECQTTY, EXECAMT, CANCELQTTY, ADJUSTQTTY FROM VW_CORRECTION_ORDERS WHERE EXECTYPE=''NS'' ', 'OD.ODMAST', NULL, NULL, '8898', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;