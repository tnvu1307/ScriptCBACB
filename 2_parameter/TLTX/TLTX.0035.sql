SET DEFINE OFF;DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('0035','NULL');Insert into TLTX   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE) Values   ('0035', 'Tạo yêu cầu mở tài khoản gửi VSD', 'Create open account request send to VSD', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'Y', 'N', ' ', 'Y', 'M', '2', 'N', 'N', 'N', 'CF02', 'OPNVSD', '', '03', '03', '', 0, 'Y', 'Y', 'Y', 'N', '', '##', 'DB', 'N', '', '', '', 'N', '03', '04', 'N', 'Y', 0, 'N');COMMIT;