SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('EA1105','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('EA1105', 'HOST', 'EA', '12', '5', '5', '60', '5', '5', 'Thanh toán chứng khoán (GD 1105)', 'Y', 1, '1', 'P', 'EA1103', 'Y', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Settle securities (Trans 1105)', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;