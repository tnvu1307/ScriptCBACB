SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CF6006','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CF6006', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'Giấy đề nghị hủy mã số giao dịch', 'N', 1, '1', 'P', 'CF6006', 'Y', 'S', 'Y', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Securities Trading Code Revoke', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;