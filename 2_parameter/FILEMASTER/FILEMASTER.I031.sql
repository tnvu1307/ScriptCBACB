SET DEFINE OFF;DELETE FROM FILEMASTER WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('I031','NULL');Insert into FILEMASTER   (EORI, FILECODE, FILENAME, FILEPATH, TABLENAME, SHEETNAME, ROWTITLE, DELTD, EXTENTION, PAGE, PROCNAME, PROCFILLTER, OVRRQD, MODCODE, RPTID, CMDCODE, IMPBYINDEX, TABLENAME_HIST, TRADEDATE) Values   ('T', 'I031', 'Import GD cập nhật số dư tiền cho TK của thành viên LK khác (1187)', '', 'TBLCI1187', '1', 1, 'N', '.xls', 100, 'PR_FILE_TBLCI1187', '', 'N', 'CI', 'V_CI1187', 'OD', 'N', '', 'N');COMMIT;