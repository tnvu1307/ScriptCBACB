SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('SE2237','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('SE2237', 'HOST', 'SE', '12', '5', '5', '60', '5', '5', 'Gửi hồ sơ giải tỏa cầm cố lên VSD(GIAO DỊCH 2237)', 'Y', 1, '1', 'P', 'SE2237', 'Y', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'VIEW PENDING TO SEND RELEASE MORTAGE CENTER (WAIT FOR 2237)', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;