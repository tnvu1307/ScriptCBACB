SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('SE0035','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('SE0035', 'HOST', 'SE', '12', '5', '5', '60', '5', '5', 'Danh sách người sở hữu đề nghị rút chứng khoán (11B/LK) ', 'N', 1, '1', 'L', 'SE0035', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'List of owner register to withdraw stock (11B/LK)', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;