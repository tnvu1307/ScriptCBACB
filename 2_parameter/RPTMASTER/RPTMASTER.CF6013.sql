SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CF6013','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CF6013', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'Báo cáo về sở hữu của nhóm nhà đầu tư nước ngoài có liên quan là cổ đông lớn/ nhà đầu tư lớn', 'N', 1, '1', 'P', 'CF6013#CF601301#CF601302', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Ownership report of group of related foreign shareholders/ investors as a major investor', '', 0, 0, 0, 0, 'Y', 'N', 'Y', '');COMMIT;