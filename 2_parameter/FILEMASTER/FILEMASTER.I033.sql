SET DEFINE OFF;DELETE FROM FILEMASTER WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('I033','NULL');Insert into FILEMASTER   (EORI, FILECODE, FILENAME, FILEPATH, TABLENAME, SHEETNAME, ROWTITLE, DELTD, EXTENTION, PAGE, PROCNAME, PROCFILLTER, OVRRQD, MODCODE, RPTID, CMDCODE, IMPBYINDEX, TABLENAME_HIST, TRADEDATE) Values   ('T', 'I033', 'Import giao dịch giải tỏa chứng khoán phong tỏa (2203)', NULL, 'TBLSE2203', '1', 1, 'N', '.xls', 100, 'PR_FILE_TBLSE2203', NULL, 'N', 'SE', 'V_SE2203', 'SE', 'N', NULL, 'N');COMMIT;