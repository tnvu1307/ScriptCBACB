SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CA1006','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CA1006', 'HOST', 'CA', '12', '5', '5', '60', '5', '5', 'Danh sách cổ phiếu thưởng (đối chiếu)', 'Y', 1, '1', 'P', 'CA1006', 'Y', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'List of bonus stock (comparison)', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;