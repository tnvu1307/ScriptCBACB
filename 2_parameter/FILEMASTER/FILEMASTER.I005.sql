SET DEFINE OFF;DELETE FROM FILEMASTER WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('I005','NULL');Insert into FILEMASTER   (EORI, FILECODE, FILENAME, FILEPATH, TABLENAME, SHEETNAME, ROWTITLE, DELTD, EXTENTION, PAGE, PROCNAME, PROCFILLTER, OVRRQD, MODCODE, RPTID, CMDCODE, IMPBYINDEX, TABLENAME_HIST, TRADEDATE) Values   ('I', 'I005', 'Coporate action Import', NULL, 'CASCHD_TEMP', '1', 1, 'N', '.xls', 100, 'CAL_COP_ACTION', NULL, 'N', NULL, NULL, NULL, 'N', 'CASCHD_TEMP_HIST', 'N');COMMIT;