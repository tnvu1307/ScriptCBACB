SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('RM6690','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('RM6690', 'HOST', 'RM', '12', '5', '5', '60', '5', '5', 'Danh sách tài khoản cần HOLD từ BIDV (6690)', 'Y', 1, '1', 'P', 'SE2203', 'N', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'List of account hold from BIDV (6690)', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;