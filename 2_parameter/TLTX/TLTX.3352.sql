SET DEFINE OFF;DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('3352','NULL');Insert into TLTX   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE) Values   ('3352', 'Thực hiện quyền cho Tiểu khoản (không thu thuế)', 'Execute CA for sub account (no tax)', 0, 'Y', 'Y', 'N', '0', 2, 'Y', 'N', 'N', 'N', ' ', 'Y', 'M', '2', 'Y', 'N', 'N', 'CA01', 'CACAEXEC', '10', '03', ' ', NULL, 0, 'Y', 'Y', 'Y', 'N', NULL, '##', 'NET', 'N', NULL, NULL, NULL, 'N', '##', '##', 'Y', 'Y', 0, 'N');COMMIT;