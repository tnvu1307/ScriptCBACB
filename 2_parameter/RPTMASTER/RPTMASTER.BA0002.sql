SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('BA0002','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('BA0002', 'HOST', 'BA', '12', '5', '5', '60', '5', '5', 'Danh sách trái chủ được hưởng lãi', 'Y', 1, '1', 'P', 'BA0001', 'Y', 'S', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'List of bondholders', '', 0, 0, 0, 0, 'N', 'Y', 'Y', '');COMMIT;