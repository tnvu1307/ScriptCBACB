SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('SE8879','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('SE8879', 'HOST', 'SE', '12', '5', '5', '60', '5', '5', 'Thanh toán chứng khoán giao dịch bán chứng khoán lô lẻ (Giao dịch 8879)', 'Y', 1, '1', 'P', 'SSE', 'N', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Odd lot trading payment', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;