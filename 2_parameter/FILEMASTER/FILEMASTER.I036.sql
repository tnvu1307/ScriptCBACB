SET DEFINE OFF;DELETE FROM FILEMASTER WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('I036','NULL');Insert into FILEMASTER   (EORI, FILECODE, FILENAME, FILEPATH, TABLENAME, SHEETNAME, ROWTITLE, DELTD, EXTENTION, PAGE, PROCNAME, PROCFILLTER, OVRRQD, MODCODE, RPTID, CMDCODE, IMPBYINDEX, TABLENAME_HIST, TRADEDATE) Values   ('T', 'I036', 'Import thực hiện quyền', '', 'CADTLIMP', '1', 1, 'N', '.xls', 100, 'PR_FILE_CADTLIMP', '', 'Y', '', '', 'CA', 'N', 'CADTLIMP_HIST', 'N');COMMIT;