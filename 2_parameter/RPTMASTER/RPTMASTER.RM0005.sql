SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('RM0005','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('RM0005', 'HOST', 'RM', '12', '5', '5', '60', '5', '5', 'Xác nhận tăng số dư tài khoản giao dịch chứng khoán -corebank (Pending for 6641)', 'Y', 1, '1', 'P', 'RM0005', 'N', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Complete hold balance (Pending for 6641)', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;