SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('OD6002','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('OD6002', 'HOST', 'OD', '12', '5', '5', '60', '5', '5', 'Báo cáo thống kê danh mục lưu ký của nhà đầu tư nước ngoài(I)', 'N', 1, '1', 'P', 'OD6002', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Report on statistical depository list of foreign investors(I)', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;