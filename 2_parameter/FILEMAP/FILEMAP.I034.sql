SET DEFINE OFF;DELETE FROM FILEMAP WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('I034','NULL');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I034', 'CUSTODYCD', 'CUSTODYCD', 'C', NULL, 10, 'N', 'N', 'Y', 'Y', 0, 'Số TK lưu ký', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I034', 'ACCTNO', 'ACCTNO', 'C', NULL, 16, 'N', 'N', 'Y', 'Y', 1, 'Số tiểu khoản', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I034', 'CUSTNAME', 'CUSTNAME', 'C', NULL, 50, 'N', 'N', 'Y', 'Y', 2, 'Họ tên', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I034', 'ADDRESS', 'ADDRESS', 'C', NULL, 50, 'N', 'N', 'Y', 'Y', 3, 'Địa chỉ', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I034', 'LICENSE', 'LICENSE', 'C', NULL, 50, 'N', 'N', 'Y', 'Y', 4, 'Số giấy tờ', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I034', 'IDDATE', 'IDDATE', 'D', NULL, 10, 'N', 'N', 'Y', 'Y', 5, 'Ngày cấp', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I034', 'IDPLACE', 'IDPLACE', 'C', NULL, 50, 'N', 'N', 'Y', 'Y', 6, 'Nơi cấp', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I034', 'AMT', 'AMT', 'N', NULL, 15, 'N', 'N', 'Y', 'Y', 10, 'Số tiền', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I034', 'REFNUM', 'REFNUM', 'C', NULL, 150, 'N', 'N', 'Y', 'Y', 11, 'Số chứng từ NH', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I034', 'DES', 'DES', 'C', NULL, 250, 'N', 'N', 'Y', 'Y', 12, 'Diễn giải', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I034', 'FILEID', 'FILEID', 'C', NULL, 250, 'U', 'N', 'Y', 'Y', 20, 'FILE code', 'N');COMMIT;