SET DEFINE OFF;DELETE FROM FILEMASTER WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('I032','NULL');Insert into FILEMASTER   (EORI, FILECODE, FILENAME, FILEPATH, TABLENAME, SHEETNAME, ROWTITLE, DELTD, EXTENTION, PAGE, PROCNAME, PROCFILLTER, OVRRQD, MODCODE, RPTID, CMDCODE, IMPBYINDEX, TABLENAME_HIST, TRADEDATE) Values   ('T', 'I032', 'Import GD cập nhật số dư CK cho TK của thành viên LK khác (2287)', '', 'TBLSE2287', '1', 1, 'N', '.xls', 100, 'PR_FILE_TBLSE2287', '', 'N', 'SE', 'V_SE2287', 'OD', 'N', '', 'N');COMMIT;