SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('DE065','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('DE065', 'HOST', 'STV', '12', '5', '5', '60', '5', '5', 'Thông tin số dư tài khoản lưu ký chứng khoán chi tiết của NĐT', 'N', 1, '1', 'P', 'MTREPORT', 'Y', 'S', 'N', 'R', 'N', 'Y', 'M', '000', 'M', -1, 'Securities depository account balance of investors', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;