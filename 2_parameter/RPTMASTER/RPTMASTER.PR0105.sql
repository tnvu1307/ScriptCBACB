SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('PR0105','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('PR0105', 'HOST', 'PR', '12', '5', '5', '60', '5', '5', 'Tăng số lượng CK cho Room_ĐB', 'Y', 1, '1', 'P', NULL, 'Y', 'S', 'N', 'V', 'N', 'Y', 'M', '000', 'S', -1, 'Increase the quantity of securities for Special Room', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;