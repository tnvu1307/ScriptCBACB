SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('BA0005','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('BA0005', 'HOST', 'BA', '12', '5', '5', '60', '5', '5', 'CHUYỂN NHƯỢNG TP/ CHỨNG QUYỀN (BA)(1911)', 'Y', 1, '1', 'P', NULL, 'Y', 'S', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'BOND/ WARRANT TRANSFER (BA) (1911)', NULL, 0, 0, 0, 0, 'N', 'Y', 'Y', NULL);COMMIT;