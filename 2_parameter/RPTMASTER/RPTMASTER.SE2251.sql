SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('SE2251','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('SE2251', 'HOST', 'SE', '12', '5', '5', '60', '5', '5', 'Xác nhận cầm cố chứng khoán (Giao dịch 2251)', 'Y', 1, '1', 'P', 'SE2251', 'Y', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Confirm pledging (2251)', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;