SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CF6010','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CF6010', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'Báo cáo về ngày trở thành-không còn là cổ đông lớn, nhà đầu tư nắm giữ từ 5% trở lên cổ phiếu', 'N', 1, '1', 'P', 'CF6010#CF601001#CF601002', 'Y', 'A', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Report on the day become/is no longer major shareholder, investors holding 5% or more of shares', NULL, 0, 0, 0, 0, 'Y', 'N', 'Y', NULL);COMMIT;