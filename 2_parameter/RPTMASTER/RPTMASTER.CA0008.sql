SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CA0008','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CA0008', 'HOST', 'CA', '12', '5', '5', '60', '5', '5', 'THÔNG BÁO VỀ VIỆC SỞ HỮU QUYỀN MUA CHỨNG KHOÁN (15/THQ)', 'N', 1, '1', 'P', 'CA0008', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Owning right off statement (15/thq)', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;