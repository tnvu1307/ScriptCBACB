SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('EA6001','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('EA6001', 'HOST', 'EA', '12', '5', '5', '60', '5', '5', 'Thông báo phong tỏa tiền và chứng khoán', 'N', 1, '1', 'P', 'EA6001', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Notice blockade of money and securities', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;