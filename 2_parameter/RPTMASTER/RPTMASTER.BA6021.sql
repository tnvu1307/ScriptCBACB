SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('BA6021','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('BA6021', 'HOST', 'BA', '12', '5', '5', '60', '5', '5', 'Tra cứu lịch sử tỷ lệ LTV/ CCR của trái phiếu', 'N', 1, '1', 'P', 'BA6021', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'History of LTV/ CCR rate', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;