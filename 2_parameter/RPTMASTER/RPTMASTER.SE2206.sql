SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('SE2206','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('SE2206', 'HOST', 'SE', '12', '5', '5', '60', '5', '5', 'Màn hình theo dõi số dư chứng khoán theo tiểu khoản', 'Y', 1, '1', 'P', 'SE2206', 'N', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'View the securities balance by sub account', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;