SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('OD9017','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('OD9017', 'HOST', 'OD', '12', '5', '5', '60', '5', '5', 'Xóa lệnh khớp HOSE ', 'Y', 1, '1', 'P', 'OD9017', 'Y', 'B', 'N', 'D', 'N', 'N', 'M', '000', 'S', -1, 'Delete HO matching order (8812)', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;