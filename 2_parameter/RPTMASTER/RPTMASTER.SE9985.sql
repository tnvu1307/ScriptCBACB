SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('SE9985','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('SE9985', 'HOST', 'SE', '12', '5', '5', '60', '5', '5', 'Số dư chứng khoán hiện có', 'Y', 1, '1', 'P', 'SE9985', 'Y', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Current stock balance', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;