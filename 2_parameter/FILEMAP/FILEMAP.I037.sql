SET DEFINE OFF;DELETE FROM FILEMAP WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('I037','NULL');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'SYMBOL', 'SYMBOL', 'C', NULL, 20, 'N', 'N', 'Y', 'Y', 2, 'Symbol', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'OUTWARD', 'OUTWARD', 'C', NULL, 3, 'N', 'N', 'Y', 'Y', 3, 'Chuyển từ', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'CUSTODYCD', 'CUSTODYCD', 'C', NULL, 10, 'N', 'N', 'Y', 'Y', 4, 'Số TK lưu ký', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'AFACCTNO', 'AFACCTNO', 'C', NULL, 16, 'N', 'N', 'Y', 'Y', 5, 'Số tiểu khoản ghi có', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'PRICE', 'PRICE', 'N', NULL, 11, 'N', 'N', 'Y', 'Y', 10, 'Giá chuyển khoản', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'CAQTTY', 'CAQTTY', 'N', NULL, 11, 'N', 'N', 'Y', 'Y', 11, 'Lượng chứng khoán', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'TRADE', 'TRADE', 'N', NULL, 11, 'N', 'N', 'Y', 'Y', 11, 'Lượng chứng khoán', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'BLOCKED', 'BLOCKED', 'N', NULL, 11, 'N', 'N', 'Y', 'Y', 11, 'Lượng chứng khoán', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'DES', 'DES', 'C', NULL, 250, 'N', 'N', 'Y', 'Y', 20, 'Diễn giải', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'FILEID', 'FILEID', 'C', NULL, 250, 'U', 'N', 'Y', 'Y', 20, 'FILE code', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'RECUSTNAME', 'RECUSTNAME', 'C', NULL, 250, 'U', 'N', 'Y', 'Y', 20, 'FILE code', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'RECUSTODYCD', 'RECUSTODYCD', 'C', NULL, 250, 'U', 'N', 'Y', 'Y', 20, 'FILE code', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'TYPE', 'TYPE', 'C', NULL, 6, 'U', 'N', 'Y', 'Y', 21, 'Loai chuyen san', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'TRTYPE', 'TRTYPE', 'C', NULL, 6, 'U', 'N', 'Y', 'Y', 22, 'Loai chuyen khoan', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'CUSTODYCD2', 'CUSTODYCD2', 'C', NULL, 10, 'U', 'N', 'Y', 'Y', 23, 'So TK LK', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'AFACCTNO2', 'AFACCTNO2', 'C', NULL, 16, 'U', 'N', 'Y', 'Y', 24, 'So tieu khoan ghi co', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'FULLNAME', 'FULLNAME', 'C', NULL, 50, 'U', 'N', 'Y', 'Y', 25, 'Ho ten tieu khoan ghi co', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'CRIDCODE', 'CRIDCODE', 'C', NULL, 50, 'U', 'N', 'Y', 'Y', 26, 'CMND tiểu khoản ghi có', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'CRIDDATE', 'CRIDDATE', 'C', NULL, 50, 'U', 'N', 'Y', 'Y', 27, 'Ngày cấp tiểu khoản ghi có', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'CRIDPLACE', 'CRIDPLACE', 'C', NULL, 100, 'U', 'N', 'Y', 'Y', 28, 'Nơi cấp tiểu khoản ghi có', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I037', 'CRIDADDRESS', 'CRIDADDRESS', 'C', NULL, 250, 'U', 'N', 'Y', 'Y', 29, 'Địa chỉ tiểu khoản ghi có', 'N');COMMIT;