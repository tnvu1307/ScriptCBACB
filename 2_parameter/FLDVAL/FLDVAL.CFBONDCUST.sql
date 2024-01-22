SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF.BONDCUST','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('TOTALBID', 'CF.BONDCUST', 0, 'E', 'EX', 'AMT|**|FEERATE|//|@100', '', '', '', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('TOTALTRAF', 'CF.BONDCUST', 1, 'E', 'EX', 'AMT|**|TRAFRATE|//|@100', '', '', '', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('TOTALPAYMNT', 'CF.BONDCUST', 2, 'E', 'EX', 'AMT|--|BIDBLK', '', '', '', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('BIDINT', 'CF.BONDCUST', 3, 'V', '>=', '@0', '', 'Lãi suất đặt thầu phải >= 0', 'Lãi suất đặt thầu phải >= 0 ', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('BIDQTTY', 'CF.BONDCUST', 4, 'V', '>=', '@0', '', 'Khối lượng đặt thầu phải >= 0', 'Khối lượng đặt thầu phải >= 0 ', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('BIDBLK', 'CF.BONDCUST', 5, 'V', '>=', '@0', '', 'Số tiền đặt cọc phải >= 0', 'Số tiền đặt cọc phải >= 0 ', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('WINQTTY', 'CF.BONDCUST', 6, 'V', '>=', '@0', '', 'Khối lượng trúng thầu phải >= 0', 'Khối lượng trúng thầu phải >= 0 ', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('AMT', 'CF.BONDCUST', 7, 'V', '>=', '@0', '', 'Số tiền thanh toán trái phiếu trúng thầu phải >= 0', 'Số tiền thanh toán trái phiếu trúng thầu phải >= 0 ', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('FEERATE', 'CF.BONDCUST', 8, 'V', '>=', '@0', '', '%Phí đấu thầu phải >= 0', '%Phí đấu thầu phải >= 0 ', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('TOTALBID', 'CF.BONDCUST', 9, 'V', '>=', '@0', '', 'Số phí đấu thầu phải >= 0', 'Số phí đấu thầu phải >= 0 ', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('TRAFRATE', 'CF.BONDCUST', 10, 'V', '>=', '@0', '', '%Phí chuyển tiền phải >= 0', '%Phí chuyển tiền phải >= 0 ', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('TOTALTRAF', 'CF.BONDCUST', 11, 'V', '>=', '@0', '', 'Số phí chuyển tiền phải >= 0', 'Số phí chuyển tiền phải >= 0 ', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('TOTALPAYMNT', 'CF.BONDCUST', 12, 'V', '>=', '@0', '', 'Tổng số tiền thanh toán còn lại phải >= 0', 'Tổng số tiền thanh toán còn lại phải >= 0 ', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('SHARERATE', 'CF.BONDCUST', 13, 'V', '>=', '@0', '', '%Chia sẻ cho KH phải >= 0', '%Chia sẻ cho KH phải >= 0 ', '', '', 0);COMMIT;