SET DEFINE OFF;DELETE FROM FILEMAP WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('I009','NULL');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I009', 'FULLNAME', 'FULLNAME', 'C', NULL, 100, 'N', 'N', 'Y', 'Y', 1, 'FULLNAME', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I009', 'EMAIL', 'EMAIL', 'C', NULL, 100, 'N', 'N', 'Y', 'Y', 2, 'EMAIL', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I009', 'PHONENUMBER', 'PHONENUMBER', 'C', NULL, 100, 'N', 'N', 'Y', 'Y', 3, 'PHONENUMBER', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I009', 'ADDRESS', 'ADDRESS', 'C', NULL, 100, 'N', 'N', 'Y', 'Y', 4, 'ADDRESS', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I009', 'IDATE', 'IDATE', 'D', NULL, 100, 'N', 'N', 'Y', 'Y', 5, 'IDATE', 'N');COMMIT;