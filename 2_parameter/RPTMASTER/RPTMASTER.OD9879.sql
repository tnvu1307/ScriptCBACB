SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('OD9879','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('OD9879', 'HOST', 'OD', '12', '5', '5', '60', '5', '5', ' Putthourgh order', 'Y', 1, '1', 'P', 'OD9879', 'N', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, NULL, NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;