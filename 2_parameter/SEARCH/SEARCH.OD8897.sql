SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OD8897','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OD8897', 'Tra cứu lệnh mua sửa lỗi (8897)', 'View  correct buy order (8897)', 'SELECT ORDERID, CODEID, SYMBOL,CUSTODYCD, FULLNAME, TYPENAME,
AFACCTNO, DESC_EXECTYPE, ORDERQTTY, ORDERPRICE, BRATIO, REMAINQTTY, EXECQTTY, EXECAMT, CANCELQTTY, ADJUSTQTTY,
ORDERPRICE*REMAINQTTY*BRATIO/100+EXECAMT AMT FROM VW_CORRECTION_ORDERS WHERE EXECTYPE=''NB'' ', 'OD.ODMAST', '', '', '8897', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;