SET DEFINE OFF;DELETE FROM TLTX WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('6613','NULL');Insert into TLTX   (TLTXCD, TXDESC, EN_TXDESC, LIMIT, OFFLINEALLOW, IBT, OVRRQD, LATE, OVRLEV, PRN, LOCAL, CHAIN, DIRECT, HOSTACNO, BACKUP, TXTYPE, NOSUBMIT, DELALLOW, FEEAPP, MSQRQR, VOUCHER, MNEM, MSG_AMT, MSG_ACCT, WITHACCT, ACCTENTRY, BGCOLOR, DISPLAY, BKDATE, ADJALLOW, GLGP, VOUCHERID, CCYCD, RUNMOD, RESTRICTALLOW, REFOBJ, REFKEYFLD, MSGTYPE, CHKBKDATE, CFCUSTODYCD, CFFULLNAME, VISIBLE, CHGTYPEALLOW, NUMBKDATE, CHKSINGLE) Values   ('6613', 'Xử lý yêu cầu thu phí lưu ký', 'Process the collect depository fee request', 0, 'Y', 'Y', 'N', '0', 2, 'Y', 'N', 'N', 'N', ' ', 'Y', 'M', '1', 'N', 'N', 'N', 'RM01', 'HLD', '10', '03', ' ', NULL, 0, 'Y', 'Y', 'Y', 'N', NULL, '##', 'NET', 'N', NULL, NULL, NULL, 'N', '##', '##', 'Y', 'Y', 0, 'N');COMMIT;