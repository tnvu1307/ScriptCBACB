SET DEFINE OFF;DELETE FROM SEARCHFLD WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CLIENTVSDHIST','NULL');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (-5, 'NOTE1', 'Trạng thái đ/c KH-VSD', 'C', 'CLIENTVSDHIST', 250, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 100, NULL, 'Match Client VSD', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (-4, 'NOTE', 'Trạng thái', 'C', 'CLIENTVSDHIST', 250, NULL, 'LIKE,=', NULL, 'N', 'N', 'N', 100, NULL, 'Status', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (-3, 'ISODMAST', 'Đối chiếu', 'C', 'CLIENTVSDHIST', 250, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 150, NULL, 'Is compare?', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (-1.1, 'CUSTMEMBER', 'Mã thành viên KH', 'C', 'CLIENTVSDHIST', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 100, NULL, 'Member Client', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (-1, 'CMPMEMBER', 'Mã CTCK', 'C', 'CLIENTVSDHIST', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 100, NULL, 'Broker', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (-.1, 'VSDMEMBER', 'Mã thành viên VSD', 'C', 'CLIENTVSDHIST', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 100, NULL, 'Member VSD', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (-.05, 'SUPERBANK', 'Khách thuộc FA', 'C', 'CLIENTVSDHIST', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 100, NULL, 'FA customers', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (0, 'CUSTODYCD', 'Số TK lưu ký', 'C', 'CLIENTVSDHIST', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 100, NULL, 'STC', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (1, 'SYMBOL', 'Mã chứng khoán', 'C', 'CLIENTVSDHIST', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 100, NULL, 'Ticker', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (1.1, 'ASSETTYPE', 'Loại tài sản', 'C', 'CLIENTVSDHIST', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 120, NULL, 'Asset type', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (3, 'TRADEDATE', 'Ngày đặt lệnh KH', 'D', 'CLIENTVSDHIST', 100, NULL, 'LIKE,=', 'dd/MM/yyyy', 'Y', 'Y', 'N', 130, NULL, 'Trade date via Client', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (3, 'TRANSTYPE', 'Loại lệnh', 'C', 'CLIENTVSDHIST', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 100, NULL, 'Type', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (4, 'TRADEDATECTCK', 'Ngày đặt lệnh CTCK', 'D', 'CLIENTVSDHIST', 100, NULL, 'LIKE,=', 'dd/MM/yyyy', 'Y', 'Y', 'N', 120, NULL, 'Trade date via Bro', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (5, 'TRADEDATEVSD', 'Ngày đặt lệnh VSD', 'D', 'CLIENTVSDHIST', 100, NULL, 'LIKE,=', 'dd/MM/yyyy', 'Y', 'Y', 'N', 120, NULL, 'Trade date via VSD', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (6, 'CUSTSETTLEDATE', 'Ngày TTBT KH', 'D', 'CLIENTVSDHIST', 100, NULL, 'LIKE,=', 'dd/MM/yyyy', 'Y', 'Y', 'N', 160, NULL, 'Settlement date via Client', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (7, 'CMPSETTLEDATE', 'Ngày TTBT CTCK', 'D', 'CLIENTVSDHIST', 100, NULL, 'LIKE,=', 'dd/MM/yyyy', 'Y', 'Y', 'N', 160, NULL, 'Settlement date via Bro', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (8, 'VSDSETTLEDATE', 'Ngày TTBT VSD', 'D', 'CLIENTVSDHIST', 100, NULL, 'LIKE,=', 'dd/MM/yyyy', 'Y', 'Y', 'N', 160, NULL, 'Settlement date via VSD', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (20, 'CUSTPRICE', 'Giá KH', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'Y', 'Y', 'N', 100, NULL, 'Price via Client', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (21, 'CMPPRICE', 'Giá CTCK', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'Y', 'Y', 'N', 100, NULL, 'Price via Bro', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (22, 'VSDPRICE', 'Giá VSD', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'Y', 'Y', 'N', 100, NULL, 'Price via VSD', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (23, 'CUSTQTTY', 'Số lượng KH', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'Y', 'Y', 'N', 120, NULL, 'Quantity via Client', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (24, 'CMPQTTY', 'Số lượng CTCK', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'Y', 'Y', 'N', 120, NULL, 'Quantity via Broker', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (25, 'VSDQTTY', 'Số lượng VSD', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'Y', 'Y', 'N', 120, NULL, 'Quantity via VSD', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (26, 'CUSTAMOUNT', 'Giá trị khớp KH', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'Y', 'Y', 'N', 120, NULL, 'Amount via Client', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (27, 'CMPAMOUNT', 'Giá trị khớp CTCK', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'Y', 'Y', 'N', 100, NULL, 'Amount via Bro', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (28, 'AMOUNT', 'Giá trị khớp VSD', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'N', 'N', 'N', 100, NULL, 'Amount via VSD', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (29, 'VSDAMOUNT', 'Giá trị khớp VSD', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'Y', 'Y', 'N', 100, NULL, 'Amount via VSD', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (30, 'CUSTAMOUNTNET', 'Giá trị thanh toán KH', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'Y', 'Y', 'N', 150, NULL, 'Net amount Client', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (31, 'CMPAMOUNTNET', 'Giá trị thanh toán CTCK', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'Y', 'Y', 'N', 150, NULL, 'Net amount Broker', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (32, 'VSDAMOUNTNET', 'Giá trị thanh toán VSD', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'N', 'N', 'N', 150, NULL, 'Net amount VSD', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (33, 'CUSTFEE', 'Phí theo KH', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'Y', 'Y', 'N', 100, NULL, 'Fee via Client', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (34, 'CMPFEE', 'Phí theo CTCK', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'Y', 'Y', 'N', 100, NULL, 'Fee via Bro', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (35, 'CUSTTAX', 'Thuế theo KH', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'Y', 'Y', 'N', 100, NULL, 'Tax via Client', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (36, 'CMPTAX', 'Thuế theo CTCK', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'Y', 'Y', 'N', 100, NULL, 'Tax via Bro', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (38, 'STATUS', 'Trạng thái', 'C', 'CLIENTVSDHIST', 250, NULL, 'LIKE,=', NULL, 'N', 'Y', 'N', 100, NULL, 'Status', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (39, 'VSDQTTY', 'Số lượng từ VSD', 'N', 'CLIENTVSDHIST', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.######', 'N', 'N', 'N', 100, NULL, 'Quantity VSD', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (40, 'DESCT', 'Diễn giải', 'C', 'CLIENTVSDHIST', 250, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 250, NULL, 'Mismatched reason', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);COMMIT;