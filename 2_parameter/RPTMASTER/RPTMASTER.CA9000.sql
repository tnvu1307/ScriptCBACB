SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CA9000','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CA9000', 'HOST', 'CA', '12', '5', '5', '60', '5', '5', 'Danh sách sự kiện quyền (Lịch sử)', 'Y', 1, '1', 'P', NULL, 'Y', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'CA events list (history)', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;