SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('SE2321','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('SE2321', 'HOST', 'SE', '12', '5', '5', '60', '5', '5', 'Danh sách hồ sơ cầm cố có thể giải cầm cố (TPRL)(2321)', 'Y', 1, '1', 'P', 'SE9001', 'Y', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'List of blockade documents can be released (PPBs)(2321)', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;