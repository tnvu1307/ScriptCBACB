SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('EA1104','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('EA1104', 'HOST', 'EA', '12', '5', '5', '60', '5', '5', 'Giải tỏa tiền(GD 1104)', 'Y', 1, '1', 'P', 'EA1104', 'Y', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Unblock cash (Trans 1104)', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;