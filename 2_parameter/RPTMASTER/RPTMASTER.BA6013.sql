SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('BA6013','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('BA6013', 'HOST', 'BA', '12', '5', '5', '60', '5', '5', 'LTV calculation Share, Bond, Cash', 'N', 1, '1', 'P', 'BA6013#BA601301#BA601302#BA601303#BA601304', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'LTV calculation Share, Bond, Cash', NULL, 0, 0, 0, 0, 'Y', 'N', 'Y', NULL);COMMIT;