SET DEFINE OFF;DELETE FROM FILEMAP WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('FI001','NULL');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('FI001', 'DERIVATIVECODE', 'DERIVATIVECODE', 'C', 'N', 24, 'U', 'N', 'Y', 'Y', 0, 'DERIVATIVECODE', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('FI001', 'COMGROUPCODE', 'COMGROUPCODE', 'C', 'N', 22, 'U', 'N', 'Y', 'Y', 1, 'COMGROUPCODE', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('FI001', 'STATUS_M', 'STATUS_M', 'N', 'N', 32, 'U', 'N', 'Y', 'Y', 2, 'STATUS_M', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('FI001', 'CREATEDATE', 'CREATEDATE', 'C', 'N', 17, 'U', 'N', 'Y', 'Y', 3, 'CREATEDATE', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('FI001', 'UPDATEDATE', 'UPDATEDATE', 'C', 'N', 17, 'U', 'N', 'Y', 'Y', 4, 'UPDATEDATE', 'N');COMMIT;