SET DEFINE OFF;DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('3312','NULL');Insert into TLTX   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE) Values   ('3312', 'Chốt tạm danh sách sở hữu', 'loosen the ownership list', 0, 'Y', 'Y', 'N', '0', 2, 'Y', 'N', 'Y', 'Y', ' ', 'Y', 'M', '1', 'N', 'N', 'N', 'CA01', 'CACAAPR', '23', '03', ' ', NULL, 0, 'Y', 'Y', 'Y', 'N', NULL, '16', 'DB', 'N', NULL, NULL, NULL, 'N', '##', '##', 'Y', 'Y', 0, 'N');COMMIT;