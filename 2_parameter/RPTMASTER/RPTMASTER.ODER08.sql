SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('ODER08','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('ODER08', 'HOST', 'OD', '12', '5', '5', '60', '5', '5', 'Xóa đánh dấu ứng trước cầm cố VSD (8837)', 'Y', 1, '1', 'P', 'ODER08', 'Y', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Unmark mortgage advanced payment VSD (8837)', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;