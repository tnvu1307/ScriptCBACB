SET DEFINE OFF;DELETE FROM FILEMAP WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('C018','NULL');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('C018', 'IDDATE', 'IDDATE', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('C018', 'IDPLACE', 'IDPLACE', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('C018', 'VALDATE', 'VALDATE', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('C018', 'FULLNAME', 'FULLNAME', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('C018', 'LINKAUTH', 'LINKAUTH', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('C018', 'IDCODE', 'IDCODE', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('C018', 'CUSTODYCD', 'CUSTODYCD', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('C018', 'EXPDATE', 'EXPDATE', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');COMMIT;