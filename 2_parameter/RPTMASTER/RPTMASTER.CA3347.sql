SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('CA3347','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('CA3347', 'HOST', 'CA', '12', '5', '5', '60', '5', '5', 'Giảm trái phiếu gốc tương ứng với SKQ trả gốc, lãi trái phiếu', 'Y', 1, '1', 'P', 'CA9998', 'Y', 'A', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Debit bond due to Bond maturity event', NULL, 0, 0, 0, 0, 'N', 'N', 'Y', NULL);COMMIT;