SET DEFINE OFF;DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('6611','NULL');Insert into TLTX   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE) Values   ('6611', 'Đổi trạng thái bảng kê', 'Change status of lists', 0, 'Y', 'Y', 'N', '0', 2, 'Y', 'N', 'Y', 'N', NULL, 'Y', 'T', '2', 'Y', 'N', 'N', 'RM01', NULL, '10', '01', NULL, NULL, 0, 'Y', 'N', 'N', 'N', NULL, '##', 'DB', 'N', NULL, NULL, NULL, 'N', '##', '##', 'Y', 'Y', 0, 'N');COMMIT;