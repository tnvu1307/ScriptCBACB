SET DEFINE OFF;DELETE FROM FILEMASTER WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('I040','NULL');Insert into FILEMASTER   (EORI, FILECODE, FILENAME, FILEPATH, TABLENAME, SHEETNAME, ROWTITLE, DELTD, EXTENTION, PAGE, PROCNAME, PROCFILLTER, OVRRQD, MODCODE, RPTID, CMDCODE, IMPBYINDEX, TABLENAME_HIST, TRADEDATE) Values   ('T', 'I040', 'Import điều chỉnh giá trị nhận cổ tức của KH (3343)', NULL, 'TBLCA3343', '1', 1, 'N', '.xls', 100, 'PR_FILE_TBLCA3343', NULL, 'N', 'CA', 'V_CA3343', 'CA', 'N', NULL, 'N');COMMIT;