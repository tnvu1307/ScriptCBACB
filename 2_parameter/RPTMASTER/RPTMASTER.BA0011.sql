SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('BA0011','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('BA0011', 'HOST', 'BA', '12', '5', '5', '60', '5', '5', 'APPLICATION FOR REMITTANCE', 'N', 1, '1', 'P', 'BA0011', 'Y', 'A', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'APPLICATION FOR REMITTANCE', NULL, 0, 0, 0, 0, 'Y', 'Y', 'Y', NULL);COMMIT;