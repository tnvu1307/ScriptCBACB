SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CA6018','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CA6018', 'HOST', 'CA', '12', '5', '5', '60', '5', '5', 'NOTICE OF INSUFFICIENT FUND FOR RIGHT SUBSCRIPTION', 'N', 1, '1', 'P', 'CA6018', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'NOTICE OF INSUFFICIENT FUND FOR RIGHT SUBSCRIPTION', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;