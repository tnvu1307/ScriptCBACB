SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CA3358','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CA3358', 'HOST', 'CA', '12', '5', '5', '60', '5', '5', 'Gửi hồ sơ chuyển nhượng quyền mua lên VSD (Giao dịch 3358)', 'Y', 1, '1', 'P', 'CA3358', 'Y', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Send outward Tranfer to VSD (Trans 3358)', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;