SET DEFINE OFF;DELETE FROM FILEMAP WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('C026','NULL');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('C026', 'GIATRIGIAODICH', 'GIATRIGIAODICH', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('C026', 'DOANHTHU', 'DOANHTHU', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('C026', 'ACCTNO', 'ACCTNO', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('C026', 'MANHOM', 'MANHOM', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('C026', 'PHIGIAMTRU', 'PHIGIAMTRU', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, NULL, 'N');COMMIT;