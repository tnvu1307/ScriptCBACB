SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CA3354','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CA3354', 'HOST', 'CA', '12', '5', '5', '60', '5', '5', 'DS chờ phân bổ tiền vào TK-Thuế tại TCPH(GD 3354)', 'Y', 1, '1', 'P', 'CA3354', 'Y', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'List of account pending for money allocation - tax collecting at issuer (3354)', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;