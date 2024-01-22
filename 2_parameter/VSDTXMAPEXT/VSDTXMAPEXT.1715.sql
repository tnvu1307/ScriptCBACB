SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('1715','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'RECE_SAFE_ACCT', 'C', '$06', '', 'Số tài khoản nhận', '', 'C', 'N', 11);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'BROKER_BICCODE', 'C', '$16', '', 'Biccode của Broker đặt lệnh', '', 'C', 'N', 10);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'SAFE_ACCT', 'C', '$88', '', 'Số tài khoản đặt lệnh', '', 'C', 'N', 9);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'SETT_QTTY', 'C', '$12', '', 'Khối lượng khớp', '', 'C', 'N', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'SETT_UNIT', 'C', '@UNIT', '', 'UNIT: cổ phiếu. FAMT: trái phiếu', '', 'C', 'N', 7);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'TICKET_INFO', 'C', '$29', '', 'ISSIN', '', 'C', 'N', 6);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'MATCH_PRICE', 'C', '$11', '', 'Giá khớp', '', 'C', 'N', 5);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'CURRENCY', 'C', '@VND', '', 'Tiền tệ', '', 'C', 'N', 4);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'TRAD_DATE', 'D', '$20', '', 'Ngày giao dịch', '', 'C', 'N', 3);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'PREP_DATE', 'D', '<$BUSDATE>', '', 'Ngày tạo yêu cầu', '', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'REFREQID', 'C', '<$TXNUM>', 'SELECT REQID FROM SWIFT_OUT WHERE REFTXNUM = ''<$FILTERID>''', 'Số hiệu điện yêu cầu', '', 'C', 'N', 17);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'CICCODE', 'C', '$15', '', 'CICCODE Client', 'CICCODE Client', 'C', 'N', 0);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'SETT_DATE', 'D', '$21', '', 'Ngày thanh toán', '', 'C', 'N', 2);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'TOTAL_AMOUNT', 'C', '$10', '', 'Giá trị thanh toán', '', 'C', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'MATCH_AMOUNT', 'C', '$14', '', 'Giá trị khớp', '', 'C', 'N', 15);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'BICCODE', 'C', '$15', '', 'Biccode của bên bán', '', 'C', 'N', 14);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'VSD_BICCODE', 'C', '@VISDVNV1XXX', '', 'VSD Biccode', '', 'C', 'N', 13);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'RECE_BICCODE', 'C', '$17', '', 'Biccode của người nhận', '', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'RECE_SAFE_ACCT', 'C', '$06', '', 'Số tài khoản nhận', '', 'C', 'N', 11);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'RECE_BICCODE', 'C', '$17', '', 'Biccode của người nhận', '', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'BROKER_BICCODE', 'C', '$16', '', 'Biccode của Broker đặt lệnh', '', 'C', 'N', 10);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'SAFE_ACCT', 'C', '$88', '', 'Số tài khoản đặt lệnh', '', 'C', 'N', 9);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'SETT_QTTY', 'C', '$12', '', 'Khối lượng khớp', '', 'C', 'N', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'SETT_UNIT', 'C', '@UNIT', '', 'UNIT: cổ phiếu. FAMT: trái phiếu', '', 'C', 'N', 7);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'TICKET_INFO', 'C', '$29', '', 'ISSIN', '', 'C', 'N', 6);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'MATCH_PRICE', 'C', '$11', '', 'Giá khớp', '', 'C', 'N', 5);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'CURRENCY', 'C', '@VND', '', 'Tiền tệ', '', 'C', 'N', 4);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'TRAD_DATE', 'D', '$20', '', 'Ngày giao dịch', '', 'C', 'N', 3);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'PREP_DATE', 'D', '<$BUSDATE>', '', 'Ngày tạo yêu cầu', '', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.NEWM.SETR//TRAD', 'FEE_AMOUNT', 'C', '$25', '', 'Số tiền fee giao dịch', '', 'C', 'N', 17);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'SETT_DATE', 'D', '$21', '', 'Ngày thanh toán', '', 'C', 'N', 2);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'CICCODE', 'C', '$15', '', 'CICCODE Client', 'CICCODE Client', 'C', 'N', 0);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'FEE_AMOUNT', 'C', '$25', '', 'Số tiền fee giao dịch', '', 'C', 'N', 17);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'TOTAL_AMOUNT', 'C', '$10', '', 'Giá trị thanh toán', '', 'C', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'MATCH_AMOUNT', 'C', '$14', '', 'Giá trị khớp', '', 'C', 'N', 15);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'BICCODE', 'C', '$15', '', 'Biccode của bên bán', '', 'C', 'N', 14);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '1715', '541.CANC.SETR//TRAD', 'VSD_BICCODE', 'C', '@VISDVNV1XXX', '', 'VSD Biccode', '', 'C', 'N', 13);COMMIT;