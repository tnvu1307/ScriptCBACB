SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('OD6008_3','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('OD6008_3', 'HOST', 'OD', '12', '5', '5', '60', '5', '5', 'Report46', 'N', 1, '1', 'P', 'OD6008_TDA#OD600801_TDA#OD600802_TDA#OD600803_TDA', 'N', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Report46', NULL, 0, 0, 0, 0, 'Y', 'N', 'Y', NULL);COMMIT;