SET DEFINE OFF;DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('0096','NULL');Insert into TLTX   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE) Values   ('0096', 'Thay đổi thông tin OD ICCFTIER ', 'Adjust OD ICCFTIER', 0, 'Y', 'N', 'Y', '0', 2, 'Y', 'N', 'N', 'N', ' ', 'Y', 'M', '1', 'N', 'N', 'N', '0096', 'DEFODICCF', '10', '00', ' ', NULL, 0, 'Y', 'N', 'Y', 'N', NULL, '##', 'NET', 'N', NULL, NULL, NULL, 'N', '##', '##', 'N', 'Y', 0, 'N');COMMIT;