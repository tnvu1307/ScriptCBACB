SET DEFINE OFF;DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('1712','NULL');Insert into TLTX   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE) Values   ('1712', 'Gửi yêu cầu chuyển đổi ngoại tệ ', 'Foreign Exchange Order', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'Y', 'N', ' ', 'Y', 'M', '2', 'N', 'N', 'N', '', '', '', '88', ' ', '', 0, 'Y', 'N', 'Y', 'N', '', '', 'DB', 'N', '', '', '', 'N', '##', '##', 'Y', 'Y', 0, 'N');COMMIT;