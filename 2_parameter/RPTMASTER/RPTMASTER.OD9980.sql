SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('OD9980','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('OD9980', 'HOST', 'OD', '12', '5', '5', '60', '5', '5', 'Danh sách lệnh đặt  thừa so với sàn', 'Y', 1, '1', 'P', 'OD9980', 'Y', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'List of redundant order compared with exchange ', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;