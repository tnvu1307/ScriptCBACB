SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CF6036','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CF6036', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'Notice of Request-VN', 'N', 1, '1', 'P', 'CF6036', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Notice of Request-VN', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;