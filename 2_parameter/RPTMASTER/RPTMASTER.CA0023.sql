SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CA0023','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CA0023', 'HOST', 'CA', '12', '5', '5', '60', '5', '5', 'Báo cáo xác nhận danh sách người sở hữu lưu ký CK', 'N', 1, '1', 'L', 'CA0023', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Báo cáo xác nhận danh sách người sở hữu lưu ký CK', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;