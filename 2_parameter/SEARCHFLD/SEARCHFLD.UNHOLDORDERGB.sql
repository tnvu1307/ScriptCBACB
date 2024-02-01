SET DEFINE OFF;DELETE FROM SEARCHFLD WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('UNHOLDORDERGB','NULL');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (-3, 'ORDERID', 'Số hiệu lệnh', 'C', 'UNHOLDORDERGB', 150, NULL, 'LIKE,=', '_', 'Y', 'Y', 'N', 150, NULL, 'Order ID', 'N', '95', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (-2, 'TRADEDATE', 'Ngày thực hiện', 'D', 'UNHOLDORDERGB', 150, NULL, 'LIKE,=', 'dd/MM/yyyy', 'Y', 'Y', 'N', 150, NULL, 'Trade date', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (-1.1, 'SETTLE_DATE', 'Ngày thanh toán', 'D', 'UNHOLDORDERGB', 150, NULL, 'LIKE,=', 'dd/MM/yyyy', 'Y', 'Y', 'N', 150, NULL, 'Settle Date', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (0, 'CUSTODYCD', 'Số TK lưu ký', 'C', 'UNHOLDORDERGB', 10, NULL, 'LIKE', NULL, 'Y', 'Y', 'N', 100, NULL, 'Trading account', NULL, '88', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (0, 'REFTXNUM', 'Số HĐ t.chiếu', 'C', 'UNHOLDORDERGB', 20, NULL, 'LIKE', NULL, 'N', 'Y', 'Y', 100, NULL, 'Contract number', NULL, '91', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (1, 'SECACCOUNT', 'Số tiểu khoản', 'C', 'UNHOLDORDERGB', 17, '9999.999999', 'LIKE', '9999.999999', 'Y', 'Y', 'N', 100, NULL, 'Sub account', NULL, '03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (2, 'DDACCTNO', 'Tài khoản tiền', 'C', 'UNHOLDORDERGB', 17, '9999.999999', 'LIKE', '9999.999999', 'Y', 'Y', 'N', 100, NULL, 'Account No', NULL, '04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (3, 'CUSTNAME', 'Họ tên', 'C', 'UNHOLDORDERGB', 25, ' ', 'LIKE', ' ', 'Y', 'Y', 'N', 100, NULL, 'Full name', NULL, '90', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (4, 'REFCASAACCT', 'Số TK tại ngân hàng', 'C', 'UNHOLDORDERGB', 25, ' ', 'LIKE', ' ', 'Y', 'Y', 'N', 150, NULL, 'Bank acctno', NULL, '93', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (5, 'BALANCE', 'Số dư tiền tại FLEX', 'N', 'UNHOLDORDERGB', 100, NULL, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 120, NULL, 'Balance', NULL, '13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (6, 'HOLDBALANCE', 'Số đã HOLD', 'N', 'UNHOLDORDERGB', 100, NULL, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 120, NULL, 'Holded Balance', NULL, '12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (10, 'MEMBERID', 'Công ty chứng khoán', 'C', 'UNHOLDORDERGB', 17, NULL, 'LIKE', NULL, 'N', 'Y', 'N', 100, NULL, 'Broker', NULL, '05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (11, 'BRNAME', 'Tên nhân viên', 'C', 'UNHOLDORDERGB', 17, ' ', 'LIKE', ' ', 'N', 'Y', 'N', 100, NULL, 'Employee', NULL, '06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (12, 'BRPHONE', 'Số điện thoại', 'C', 'UNHOLDORDERGB', 17, ' ', 'LIKE', ' ', 'N', 'Y', 'N', 100, NULL, 'Tel', NULL, '07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (16, 'CCYCD', 'Tiền tệ', 'C', 'UNHOLDORDERGB', 25, ' ', 'LIKE', ' ', 'N', 'Y', 'N', 100, NULL, 'Currency', NULL, '20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (18, 'AMOUNT', 'Số tiền', 'N', 'UNHOLDORDERGB', 13, '#,##0', 'LIKE', '#,##0', 'Y', 'Y', 'N', 100, NULL, 'Amount', NULL, '10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (99, 'NOTE', 'Diễn giải', 'C', 'UNHOLDORDERGB', 50, ' ', 'LIKE', ' ', 'Y', 'Y', 'N', 100, NULL, 'Description', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);COMMIT;