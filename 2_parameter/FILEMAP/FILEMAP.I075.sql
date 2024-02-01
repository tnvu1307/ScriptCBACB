SET DEFINE OFF;DELETE FROM FILEMAP WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('I075','NULL');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I075', 'TRADING_DATE', 'TRADING_DATE', 'C', NULL, 150, 'N', 'N', 'Y', 'Y', 0, 'Fund code', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I075', 'SETTLEMENT_DATE', 'SETTLEMENT_DATE', 'C', NULL, 150, 'N', 'N', 'Y', 'Y', 1, 'Ticker code', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I075', 'ACCOUNT_NO ', 'ACCOUNT_NO ', 'C', NULL, 150, 'N', 'N', 'Y', 'Y', 2, 'Type', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I075', 'CUSTODY_ID', 'CUSTODY_ID', 'C', NULL, 150, 'N', 'N', 'Y', 'Y', 3, 'Isin code', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I075', 'ACCOUNT_NAME', 'ACCOUNT_NAME', 'C', NULL, 150, 'N', 'N', 'Y', 'Y', 4, 'Description', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I075', 'MARKET', 'MARKET', 'C', NULL, 150, 'N', 'N', 'Y', 'Y', 5, 'Quantity', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I075', 'STOCK_NAME', 'STOCK_NAME', 'C', NULL, 150, 'N', 'N', 'Y', 'Y', 6, 'Price', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I075', 'BOARD', 'BOARD', 'C', NULL, 150, 'N', 'N', 'Y', 'Y', 7, 'Commission', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I075', 'ORDER_TYPE', 'ORDER_TYPE', 'C', NULL, 150, 'N', 'N', 'Y', 'Y', 8, 'Tax-order Fee', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I075', 'PRICE', 'PRICE', 'C', NULL, 150, 'N', 'N', 'Y', 'Y', 9, 'Principal amount', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I075', 'QTY', 'QTY', 'C', NULL, 150, 'N', 'N', 'Y', 'Y', 10, 'Net proceeds', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I075', 'AMOUNT', 'AMOUNT', 'C', NULL, 150, 'N', 'N', 'Y', 'Y', 11, 'Ccy', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I075', 'COMMISSION', 'COMMISSION', 'C', NULL, 150, 'N', 'N', 'Y', 'Y', 12, 'Trade date', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I075', 'PIT', 'PIT', 'C', NULL, 150, 'N', 'N', 'Y', 'Y', 13, 'Original settle date', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I075', 'NET_SETTLEMENT_AMOUNT', 'NET_SETTLEMENT_AMOUNT', 'C', NULL, 150, 'N', 'N', 'Y', 'Y', 14, 'Broker', 'N');COMMIT;