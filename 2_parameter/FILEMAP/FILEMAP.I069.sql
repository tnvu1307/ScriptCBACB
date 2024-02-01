SET DEFINE OFF;DELETE FROM FILEMAP WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('I069','NULL');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I069', 'Broker Code', 'BROKER_CODE', 'C', NULL, 10, 'U', 'N', 'Y', 'Y', 0, 'BROKER CODE', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I069', 'Trans Type', 'TRANS_TYPE', 'C', NULL, 16, 'U', 'N', 'Y', 'Y', 1, 'TRANS TYPE', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I069', 'ST Code', 'ST_CODE', 'C', NULL, 50, 'U', 'N', 'Y', 'Y', 2, 'ST CODE', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I069', 'Sec ID', 'SEC_ID', 'C', NULL, 50, 'U', 'N', 'Y', 'Y', 3, 'SEC ID', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I069', 'Trade date', 'TRADE_DATE', 'C', NULL, 50, 'U', 'N', 'Y', 'Y', 4, 'TRADE_DATE', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I069', 'Settle date', 'SETTLE_DATE', 'C', NULL, 50, 'U', 'N', 'Y', 'Y', 5, 'SETTLE_DATE', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I069', 'Quantity(shs)', 'QUANTITY', 'C', NULL, 10, 'U', 'N', 'Y', 'Y', 6, 'QUANTITY', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I069', 'Price(VND)', 'PRICE', 'C', NULL, 50, 'U', 'N', 'Y', 'Y', 7, 'PRICE', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I069', 'Gross  Amount(VND)', 'GROSS_AMOUNT', 'N', NULL, 19, 'U', 'N', 'Y', 'Y', 8, 'GROSS AMOUNT', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I069', 'Commission Fee(VND)', 'COMMISSION_FEE', 'C', NULL, 250, 'U', 'N', 'Y', 'Y', 9, 'COMMISSION FEE', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I069', 'Tax', 'TAX', 'C', NULL, 250, 'U', 'N', 'Y', 'Y', 10, 'TAX', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I069', 'Net Amount(VND)', 'NET_AMOUNT', 'C', NULL, 250, 'U', 'N', 'Y', 'Y', 11, 'NET AMOUNT', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I069', 'TRANSACTION TYPE', 'TRANSACTIONTYPE', 'C', NULL, 250, 'U', 'N', 'Y', 'Y', 12, 'TRANSACTION TYPE', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I069', 'AP', 'AP', 'C', NULL, 250, 'U', 'N', 'Y', 'Y', 12, 'AP', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I069', 'AP''s Trading account', 'APACCT', 'C', NULL, 250, 'U', 'N', 'Y', 'Y', 13, 'APACCT', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('I069', 'ETF trade date', 'ETFDATE', 'C', NULL, 250, 'U', 'N', 'Y', 'Y', 14, 'APACCT', 'N');COMMIT;