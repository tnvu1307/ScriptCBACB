SET DEFINE OFF;DELETE FROM FILEMASTER WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('I075','NULL');Insert into FILEMASTER   (EORI, FILECODE, FILENAME, FILEPATH, TABLENAME, SHEETNAME, ROWTITLE, DELTD, EXTENTION, PAGE, PROCNAME, PROCFILLTER, OVRRQD, MODCODE, RPTID, CMDCODE, IMPBYINDEX, TABLENAME_HIST, TRADEDATE) Values   ('T', 'I075', 'Import transaction result from Broker template 3', NULL, 'ODMASTCMP_TEMP_3', '1', 1, 'N', '.xls', 100, 'PR_FILLTER_TBLI068_3', 'PR_CHECK_I068_3', 'Y', 'OD', NULL, 'OD', 'Y', 'ODMASTCMP_TEMP_3HIST', 'N');COMMIT;