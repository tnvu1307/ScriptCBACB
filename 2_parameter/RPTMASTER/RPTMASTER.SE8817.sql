SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('SE8817','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('SE8817', 'HOST', 'SE', '12', '5', '5', '60', '5', '5', 'Danh sách giao dịch quản lý lô lẻ chờ hủy(Giao dịch 8817)', 'Y', 1, '1', 'P', 'SE8817', 'Y', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'List of odd lot pending for canceling (8817)', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;