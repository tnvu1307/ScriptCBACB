SET DEFINE OFF;DELETE FROM FILEMAP WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('P002','NULL');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('P002', 'ACCOUNTTYPE', 'ACCOUNTTYPE', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('P002', 'CUSTODYCD', 'CUSTODYCD', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('P002', 'ORDERSEQ', 'ORDERSEQ', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('P002', 'ORDERNO', 'ORDERNO', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('P002', 'PRICE', 'PRICE', 'N', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('P002', 'QUANTITY', 'QUANTITY', 'N', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('P002', 'SYMBOL', 'SYMBOL', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('P002', 'EXECTYPE', 'EXECTYPE', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, '', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('P002', 'CONFIRMNUMBER', 'CONFIRMNUMBER', 'C', 'Y', 500, 'U', 'N', 'Y', 'Y', 0, '', 'N');COMMIT;