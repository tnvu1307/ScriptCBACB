SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CA3392','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CA3392', 'HOST', 'CA', '12', '5', '5', '60', '5', '5', 'Hủy chuyển khoản nội bộ quyền mua (Giao dịch 3392)', 'Y', 1, '1', 'P', 'CA3392', 'N', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Cancel Transfer', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;