SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('OD6006','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('OD6006', 'HOST', 'OD', '12', '5', '5', '60', '5', '5', 'Report02 (Domestic Invester)', 'N', 1, '1', 'P', 'OD600602#OD600604', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Report02', '', 0, 0, 0, 0, 'Y', 'N', 'Y', '');COMMIT;