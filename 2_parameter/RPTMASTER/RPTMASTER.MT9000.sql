SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('MT9000','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('MT9000', 'HOST', 'MT', '12', '5', '5', '60', '5', '5', 'Swift_in_list (history)', 'Y', 1, '1', 'L', 'MT9000', 'Y', 'S', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Swift_in_list (history)', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;