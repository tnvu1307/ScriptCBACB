SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('SE0064','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('SE0064', 'HOST', 'SE', '12', '5', '5', '60', '5', '5', 'BÁO CÁO PHÁT SINH GIAO DỊCH LÔ LẺ', 'N', 1, '1', 'L', 'SE0064', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Report of odd lot trading', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;