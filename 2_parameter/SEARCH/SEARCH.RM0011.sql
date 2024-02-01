SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RM0011','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RM0011', 'Danh sách TK lệch số dư giữa số dư hold theo broker và số dư thực', 'List of accounts that have a balance difference between the hold balance according to broker and real balance', 'select CIFID,FULLNAME,CUSTODYCD,DDACCTNO,CCYCD CURRENCY,membername CTCK,HOLDBALANCE,ODAMT,(ODAMT -HOLDBALANCE) AMT
    from buf_dd_member
    where ODAMT > HOLDBALANCE', 'CRBTRFLOG', NULL, NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'Y', 'ACCTNO');COMMIT;