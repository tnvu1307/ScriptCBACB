SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('DD6023','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('DD6023', 'HOST', 'DD', '12', '5', '5', '60', '5', '5', 'AUC fluctuation report (details)', 'N', 1, '1', 'P', 'DD6023#DD602301#DD602302', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'AUC fluctuation report (details)', '', 0, 0, 0, 0, 'Y', 'N', 'Y', '');COMMIT;