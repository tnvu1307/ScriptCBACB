SET DEFINE OFF;DELETE FROM FILEMAP WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('P004','NULL');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('P004', 'REPORTDATE', 'REPORTDATE', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('P004', 'SYMBOL', 'SYMBOL', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('P004', 'QUANTITY', 'QUANTITY', 'N', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('P004', 'CUSTODYCD', 'CUSTODYCD', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('P004', 'TRANNO', 'TRANNO', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('P004', 'ACCOUNTTYPE', 'ACCOUNTTYPE', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('P004', 'TXDATE', 'TXDATE', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, '', 'N');COMMIT;