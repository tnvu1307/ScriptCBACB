SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CA3330','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CA3330', 'HOST', 'CA', '12', '5', '5', '60', '5', '5', 'Điều chỉnh quyền được nhận về do chuyển khoản(3330)', 'Y', 1, '1', 'P', 'CA3330', 'Y', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Adjust CA schedule receive due to transfer', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;