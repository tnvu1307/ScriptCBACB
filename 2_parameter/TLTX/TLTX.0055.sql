SET DEFINE OFF;DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('0055','NULL');Insert into TLTX   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE) Values   ('0055', 'Thay đổi thông tin ủy quyền', 'Change authorize information', 0, 'Y', 'Y', '', '0', 2, 'Y', 'N', 'N', 'N', ' ', 'Y', 'M', '1', 'N', 'N', 'N', 'CF02', 'AFTCHG', '', '03', ' ', '', 0, 'Y', 'N', 'N', 'N', '', '##', 'NET', 'N', '', '', '', 'N', '##', '##', 'N', 'Y', 0, 'N');COMMIT;