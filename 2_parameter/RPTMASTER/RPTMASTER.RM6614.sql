SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('RM6614','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('RM6614', 'HOST', 'RM', '12', '5', '5', '60', '5', '5', 'Gửi lại điện lỗi', 'Y', 1, '1', 'P', 'RM6614', 'Y', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Resend error request', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;