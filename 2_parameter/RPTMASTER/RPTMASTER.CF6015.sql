SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CF6015','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CF6015', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'Thống kê danh mục đầu tư của nhà đầu tư nước ngoài', 'N', 1, '1', 'P', 'CF6015', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Portfolio of foreign investors', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;