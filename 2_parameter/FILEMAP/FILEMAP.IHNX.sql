SET DEFINE OFF;DELETE FROM FILEMAP WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('IHNX','NULL');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('IHNX', 'AUTOID', 'AUTOID', 'N', 'N', 18, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('IHNX', 'TRADING_DATE', 'TRADING_DATE', 'D', 'N', 18, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('IHNX', 'SYMBOL', 'SYMBOL', 'C', 'N', 18, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('IHNX', 'PRICE', 'PRICE', 'N', 'N', 18, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('IHNX', 'QTTY', 'QTTY', 'N', 'N', 18, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('IHNX', 'MATCHAMOUNT', 'MATCHAMOUNT', 'N', 'N', 18, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('IHNX', 'MATCHTIME', 'MATCHTIME', 'C', 'N', 18, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('IHNX', 'SELLACCOUNT', 'SELLACCOUNT', 'C', 'N', 18, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('IHNX', 'BUYACCOUNT', 'BUYACCOUNT', 'C', 'N', 18, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');COMMIT;