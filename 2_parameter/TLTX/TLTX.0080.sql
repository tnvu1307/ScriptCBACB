SET DEFINE OFF;DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('0080','NULL');Insert into TLTX   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE) Values   ('0080', 'Tra cứu tiểu khoản chờ duyệt', 'Pending approve sub account inquiry', 0, 'Y', 'Y', 'N', '0', 2, 'Y', 'N', 'N', 'N', ' ', 'Y', 'M', '2', 'N', 'N', 'N', 'CF01', 'AFAPPR', '10', '03', ' ', NULL, 0, 'Y', 'N', 'Y', 'N', NULL, '##', 'NET', 'N', NULL, NULL, NULL, 'N', '##', '##', 'N', 'Y', 0, 'N');COMMIT;