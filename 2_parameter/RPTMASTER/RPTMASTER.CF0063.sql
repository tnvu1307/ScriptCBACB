SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CF0063','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CF0063', 'HOST', 'CF', '12', '5', '5', '60', '5', '5', 'Chuyển tiểu khoản sang kết nối corebank (Giao dịch 0063)', 'Y', 1, '1', 'P', 'AFMAST', 'N', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'View Change contract to core bank (wait for 0063)', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;