SET DEFINE OFF;

DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('0029','NULL');

Insert into TLTX
   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE)
 Values
   ('0029', 'Trừ tiền tài khoản cá nhân', 'Deduct money from personal account', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'Y', 'N', ' ', 'Y', 'T', '2', 'Y', 'N', 'N', NULL, 'SETRFSE', '10', '36', ' ', NULL, 0, 'Y', 'Y', 'Y', 'N', NULL, '##', 'DB', 'N', NULL, NULL, 'SE.CREDIT', 'N', '88', '88', 'N', 'Y', 1, 'N');
COMMIT;
