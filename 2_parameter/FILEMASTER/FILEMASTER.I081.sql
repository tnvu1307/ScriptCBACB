SET DEFINE OFF;DELETE FROM FILEMASTER WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('I081','NULL');Insert into FILEMASTER   (EORI, FILECODE, FILENAME, FILEPATH, TABLENAME, SHEETNAME, ROWTITLE, DELTD, EXTENTION, PAGE, PROCNAME, PROCFILLTER, OVRRQD, MODCODE, RPTID, CMDCODE, IMPBYINDEX, TABLENAME_HIST, TRADEDATE) Values   ('T', 'I081', 'Import transaction result from VSD for G-bond', '', 'ODMASTVSDGB_TEMP', '1', 1, 'N', '.xls', 100, 'PR_FILE_TBLI081', 'PR_FILLTER_TBLI081', 'Y', 'OD', '', 'OD', 'Y', 'ODMASTVSDGB_TEMP_HIST', 'Y');COMMIT;