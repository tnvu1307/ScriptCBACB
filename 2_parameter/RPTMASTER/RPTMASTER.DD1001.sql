SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('DD1001','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('DD1001', 'HOST', 'DD', '12', '5', '5', '60', '5', '5', 'Tất toán phí', 'Y', 1, '1', 'P', '', 'Y', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Fee settlement', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;