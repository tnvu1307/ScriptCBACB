SET DEFINE OFF;DELETE FROM SEARCHFLD WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3327','NULL');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (-10, 'ISINCODE', 'Mã ISIN', 'C', 'CA3327', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 120, '', 'ISIN code', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (0, 'AUTOID', 'Số tự tăng', 'C', 'CA3327', 100, 'cccc.cccccc.cccccc', 'LIKE,=', '_', 'N', 'N', 'N', 120, '', 'Auto ID', 'N', '01', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (1, 'CIFID', 'Mã KH tại NH', 'C', 'CA3327', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 120, '', 'Portfolio No.', 'N', '97', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (2, 'CAMASTID', 'Mã TH quyền', 'C', 'CA3327', 100, 'cccc.cccccc.cccccc', 'LIKE,=', '_', 'Y', 'Y', 'N', 120, '', 'CA code', 'N', '02', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (3, 'CUSTODYCD', 'Số lưu ký ', 'C', 'CA3327', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 100, '', 'Trading account', 'N', '96', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (4, 'MCUSTODYCD', 'Số TKLK mẹ', 'C', 'CA3327', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 100, '', 'Master account', 'N', '88', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (5, 'AFACCTNO', 'Mã tiểu khoản', 'C', 'CA3327', 100, '', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, '', 'Sub account', 'N', '03', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (6, 'FULLNAME', 'Tên khách hàng', 'C', 'CA3327', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 100, '', 'Customer name', 'N', '08', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (7, 'CODEID', 'Mã trái phiếu', 'C', 'CA3327', 100, '', 'LIKE,=', '', 'N', 'N', 'N', 100, '', 'Bond symbol', 'N', '24', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (8, 'SYMBOL', 'Trái phiếu', 'C', 'CA3327', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 100, '', 'Bond symbol', 'N', '04', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (9, 'TOCODEID', 'Mã chứng khoán', 'C', 'CA3327', 100, '', 'LIKE,=', '', 'N', 'N', 'N', 100, '', 'Symbol', 'N', '21', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (10, 'TOSYMBOL', 'Chứng khoán', 'C', 'CA3327', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 100, '', 'Symbol', 'N', '05', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (11, 'REPORTDATE', 'Ngày chốt', 'C', 'CA3327', 80, '', '=,>,<,>=,<=', '', 'Y', 'N', 'N', 100, '', 'Report date', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (12, 'PQTTY', 'SL CP còn được ĐK', 'N', 'CA3327', 80, '', '<,<=,=,>=,>', '#,##0', 'Y', 'N', 'N', 120, '', 'Available to register', 'N', '10', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (13, 'TRADE', 'SL TP sở hữu', 'N', 'CA3327', 80, '', '<,<=,=,>=,>', '#,##0', 'Y', 'N', 'N', 100, '', 'Bond owning rate', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (14, 'MAXQTTY', 'SL CP được ĐK tối đa', 'N', 'CA3327', 80, '', '<,<=,=,>=,>', '#,##0', 'Y', 'N', 'N', 100, '', 'Max registered quantity', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (15, 'QTTY', 'SL CP đã ĐK', 'N', 'CA3327', 80, '', '<,<=,=,>=,>', '#,##0', 'Y', 'N', 'N', 100, '', 'Registered quantity', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (16, 'BEGINDATE', 'Ngày bắt đầu ĐK', 'C', 'CA3327', 80, '', '=,>,<,>=,<=', '', 'Y', 'N', 'N', 100, '', 'Date of starting register right issue', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (17, 'QTTYBOND', 'SL TP Ðăng ký', 'N', 'CA3327', 80, '', '<,<=,=,>=,>', '#,##0', 'N', 'Y', 'N', 100, '', 'Bond owning rate', 'N', '09', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (18, 'DUEDATE', 'Ngày cuối cùng ĐK', 'C', 'CA3327', 80, '', '=,>,<,>=,<=', '', 'Y', 'N', 'N', 100, '', 'Last register date', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');COMMIT;