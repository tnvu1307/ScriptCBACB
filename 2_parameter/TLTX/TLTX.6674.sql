SET DEFINE OFF;DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('6674','NULL');Insert into TLTX   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE) Values   ('6674', 'Hoàn tất nhận tiền nostro', 'Confirm nostro transaction', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'Y', 'Y', ' ', 'Y', 'M', '2', 'N', 'N', 'N', 'RM01', NULL, '10', '03', ' ', NULL, 0, 'N', 'N', 'Y', 'N', NULL, '##', 'DB', 'N', NULL, NULL, NULL, 'N', '##', '##', 'Y', 'Y', 0, 'N');COMMIT;