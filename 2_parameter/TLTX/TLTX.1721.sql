SET DEFINE OFF;DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('1721','NULL');Insert into TLTX   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE) Values   ('1721', 'Yêu cầu chuyển đổi ngoại tệ', 'Foreign currency conversion required', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'Y', 'N', ' ', 'Y', 'M', '2', 'Y', 'N', 'N', '', '', '10', '', ' ', '', 0, 'Y', 'Y', 'Y', 'N', '', '##', 'DB', 'N', '', '', '', 'N', '88', '##', 'Y', 'Y', 0, 'N');COMMIT;