SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CA0028','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CA0028', 'HOST', 'CA', '12', '5', '5', '60', '5', '5', 'Thống kê sự kiện quyền đã hoàn tất - Tiền', 'N', 1, '1', 'L', 'CA0028', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Complete CA event - cash relate', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;