SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CF6025','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CF6025', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'Handover to trea', 'N', 1, '1', 'P', 'CF6025#CF602501', 'Y', 'S', 'N', 'R', 'N', 'N', 'M', '000', 'S', -1, 'Handover to trea', '', 0, 0, 0, 0, 'Y', 'N', 'Y', '');COMMIT;