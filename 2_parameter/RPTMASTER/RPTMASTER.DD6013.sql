SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('DD6013','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('DD6013', 'HOST', 'DD', '12', '5', '5', '60', '5', '5', 'Transaction Fee Details (for VSD Fee checking)', 'N', 1, '1', 'P', 'DD6013', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Transaction Fee Details (for VSD Fee checking)', '', 0, 0, 0, 0, 'Y', 'N', 'Y', '');COMMIT;