SET DEFINE OFF;DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('6697','NULL');Insert into TLTX   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE) Values   ('6697', 'Xác nhận giải phong tỏa số dư từ ngân hàng', 'Bank confirm unhold balance ', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'Y', 'Y', ' ', 'Y', 'M', '2', 'N', 'N', 'N', 'RM01', 'UHD', '10', '04', ' ', '', 0, 'Y', 'N', 'Y', 'N', '', '##', 'DB', 'N', '', '', '', 'N', '88', '90', 'Y', 'Y', 0, 'N');COMMIT;