SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CA0015','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CA0015', 'HOST', 'CA', '12', '5', '5', '60', '5', '5', 'Danh sách người sở hữu chứng khoán lưu ký (TH quyền bỏ phiếu - 08/THQ)', 'N', 1, '1', 'L', 'CA0015', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'List of depository securities owners (execute voting right - 08/thq)', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;