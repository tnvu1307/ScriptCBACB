SET DEFINE OFF;DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('2841','NULL');Insert into TLTX   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE) Values   ('2841', 'Thanh toán tài khoản quỹ, ủy thác', 'Fund, trust unit payment', 0, 'Y', 'Y', 'Y', '0', 2, 'Y', 'N', 'Y', 'Y', ' ', 'Y', 'T', '2', 'Y', 'N', 'N', 'SE01', 'SEDEPO', '10', '03', ' ', '', 0, 'Y', 'Y', 'Y', 'N', 'CA005LK', '##', 'NET', 'N', '', '', '', 'N', '##', '##', 'N', 'Y', 0, 'N');COMMIT;