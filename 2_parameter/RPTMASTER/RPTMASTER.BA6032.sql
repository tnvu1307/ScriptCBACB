SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('BA6032','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('BA6032', 'HOST', 'BA', '12', '5', '5', '60', '5', '5', 'TRÍCH LỤC SỔ ĐĂNG KÝ NGƯỜI SỞ HỮU TRÁI PHIẾU (ENG)', 'N', 1, '1', 'P', 'BA6032#BA603201', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'TRÍCH LỤC SỔ ĐĂNG KÝ NGƯỜI SỞ HỮU TRÁI PHIẾU (ENG)', '', 0, 0, 0, 0, 'Y', 'N', 'Y', '');COMMIT;