SET DEFINE OFF;DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('8807','NULL');Insert into TLTX   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE) Values   ('8807', 'Hỗ trợ Thanh Toán Bù Trừ Hằng Ngày', 'Support Daily Payment Versus Deliver', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'Y', 'Y', '', 'Y', 'T', '2', 'N', 'N', 'N', '', '', '', '00', '', '', 0, 'Y', 'N', 'Y', 'N', '', '##', 'DB', 'N', '', '', '', 'N', '##', '##', 'Y', 'Y', 0, 'N');COMMIT;