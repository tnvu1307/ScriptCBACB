SET DEFINE OFF;DELETE FROM FILEMASTER WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('C010','NULL');Insert into FILEMASTER   (EORI, FILECODE, FILENAME, FILEPATH, TABLENAME, SHEETNAME, ROWTITLE, DELTD, EXTENTION, PAGE, PROCNAME, PROCFILLTER, OVRRQD, MODCODE, RPTID, CMDCODE, IMPBYINDEX, TABLENAME_HIST, TRADEDATE) Values   ('C', 'C010', 'CFMASTCV', NULL, 'CFMASTCV', '1', 1, 'N', '.xls', 100, NULL, NULL, 'N', NULL, NULL, NULL, 'N', NULL, 'N');COMMIT;