SET DEFINE OFF;DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('2318','NULL');Insert into TLTX   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE) Values   ('2318', 'Gửi hồ sơ cầm cố lên VSD (TPRL)', 'Send blockade securities to VSD (PPBs)', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'N', 'N', ' ', 'Y', 'M', '2', 'N', 'N', 'N', NULL, NULL, '10', '03', ' ', NULL, 0, 'Y', 'Y', 'Y', 'N', NULL, '01', 'DB', 'N', NULL, NULL, NULL, 'N', '88', '90', 'Y', 'Y', 0, 'N');COMMIT;