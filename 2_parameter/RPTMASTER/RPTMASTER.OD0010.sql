SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('OD0010','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('OD0010', 'HOST', 'OD', '12', '5', '5', '60', '5', '5', 'Danh sách lệnh nhiều ngày', 'Y', 1, '1', 'P', 'OD8892', 'Y', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Good till cancel order', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;