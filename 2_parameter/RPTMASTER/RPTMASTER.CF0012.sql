SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CF0012','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CF0012', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'Xác nhận đã kích hoạt VSD', 'Y', 1, '1', 'P', 'CF0012', 'Y', 'S', 'N', 'V', 'N', 'Y', 'M', '000', 'S', -1, 'Confirmation of VSD activation', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;