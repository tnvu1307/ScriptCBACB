SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('SE2211','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('SE2211', 'HOST', 'SE', '12', '5', '5', '60', '5', '5', 'Danh sách các hợp đồng mua OTC chờ đi tiền(Giao dịch 2211)', 'Y', 1, '1', 'P', 'SE2211', 'Y', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'List of OTC purchase contracts waiting for transfer (2211)', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;