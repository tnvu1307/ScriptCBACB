SET DEFINE OFF;DELETE FROM FILEMAP WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('I003','NULL');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I003', 'SYMBOL', 'SYMBOL', 'C', 'Y', 18, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I003', 'AFMAXAMTT3', 'AFMAXAMTT3', 'N', 'N', 24, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I003', 'AFMAXAMT', 'AFMAXAMT', 'N', 'N', 24, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I003', 'ISMARGINALLOW', 'ISMARGINALLOW', 'C', 'N', 10, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I003', 'MRPRICERATE', 'MRPRICERATE', 'N', 'N', 24, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I003', 'MRPRICELOAN', 'MRPRICELOAN', 'N', 'N', 24, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I003', 'MRMAXQTTY', 'MRMAXQTTY', 'N', 'N', 24, 'U', 'N', 'Y', 'Y', 0, '', 'N');COMMIT;