SET DEFINE OFF;DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('2218','NULL');Insert into TLTX   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE) Values   ('2218', 'Giải tỏa chứng khoán phong tỏa tạm', 'Release Temporary Escrow Securities', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'Y', 'N', ' ', 'Y', 'M', '2', 'N', 'N', 'N', 'SE01', 'SEBLK', '10', '03', ' ', NULL, 0, 'Y', 'N', 'Y', 'N', NULL, '04', 'DB', 'N', NULL, NULL, NULL, 'N', '88', '90', 'Y', 'Y', 0, 'N');COMMIT;