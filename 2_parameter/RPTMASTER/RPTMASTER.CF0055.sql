SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CF0055','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CF0055', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'Điều chỉnh thông tin ủy quyền (Giao dịch 0055)', 'Y', 1, '1', 'P', 'CF0055', 'N', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Adjust authorize information(wait for 0055)', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;