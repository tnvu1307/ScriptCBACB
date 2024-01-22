SET DEFINE OFF;DELETE FROM SEARCHFLD WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('DF2669','NULL');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (1, 'AUTOID', 'Số tự tăng', 'C', 'DF2669', 100, '', 'LIKE,=', '_', 'N', 'N', 'N', 100, '', 'Auto ID', 'N', '01', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (2, 'ACCTNO', 'Số hợp đồng vay', 'C', 'DF2669', 100, 'ccccdcccccccccccc', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, '', 'Account no', 'N', '03', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (3, 'AFACCTNO', 'Số tiểu khoán', 'C', 'DF2669', 100, '', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, '', 'Contract No', 'N', '04', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (4, 'PRODUCTNAME', 'Tên sản phẩm', 'C', 'DF2669', 100, '', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, '', 'Product name', 'N', '13', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (4, 'CUSTODYCD', 'Sô tk lưu ký', 'C', 'DF2669', 10, 'ccc.c.cccccc', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, '', 'Trading account', 'N', '88', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (4, 'LICENSE', 'Cmnd', 'C', 'DF2669', 100, '', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, '', 'Contract No', 'N', '92', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (5, 'ADDRESS', 'Địa chỉ', 'C', 'DF2669', 100, '', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, '', 'Address', 'N', '91', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (6, 'CUSTNAME', 'Tên khách hàng', 'C', 'DF2669', 100, '', 'LIKE,=', '_', 'Y', 'Y', 'N', 100, '', 'Customer name', 'N', '90', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (7, 'AMT', 'Số tiền vay', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 100, '', 'Loan amount', 'N', '10', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (8, 'OINTNMLACR', 'Nợ lãi', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0', 'N', 'N', 'N', 100, '', 'Interest outstanding', 'N', '31', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (8, 'INTNMLACR', 'Nợ lãi', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 100, '', 'Interest outstanding', 'N', '20', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (9, 'OFEEINTNMLACR', 'Nợ phí', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0', 'N', 'N', 'N', 100, '', 'Fee outstanding', 'N', '32', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (9, 'FEEINTNMLACR', 'Nợ phí', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 100, '', 'Fee outstanding', 'N', '21', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (10, 'TOTALINT', 'Tổng lãi/phí', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 100, '', 'Total interest/Fee', 'N', '33', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (11, 'OVERDUEDATE', 'Ngày đến hạn', 'D', 'DF2669', 100, '', '<,<=,=,>=,>,<>', 'dd/MM/yyyy', 'Y', 'Y', 'N', 100, '', 'Due date', 'N', '06', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (12, 'RATE1', 'TL lãi trong hạn 1', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0.####', 'Y', 'Y', 'N', 100, '', 'Interest rate 1 ', 'N', '41', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (13, 'ORATE1', 'TL lãi trong hạn 1', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0.####', 'N', 'N', 'N', 100, '', 'Interest rate 1 ', 'N', '51', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (14, 'RATE2', 'TL lãi trong hạn 2', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0.####', 'Y', 'Y', 'N', 100, '', 'Interest rate 2', 'N', '42', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (15, 'ORATE2', 'TL lãi trong hạn 2', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0.####', 'N', 'N', 'N', 100, '', 'Interest rate 2', 'N', '52', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (16, 'RATE3', 'TL lãi trong hạn 3', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0.####', 'Y', 'Y', 'N', 100, '', 'Interest rate 3', 'N', '43', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (17, 'ORATE3', 'TL lãi trong hạn 3', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0.####', 'N', 'N', 'N', 100, '', 'Interest rate 3', 'N', '53', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (18, 'CFRATE1', 'TL phí trong hạn 1', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0.####', 'Y', 'Y', 'N', 100, '', 'Fee rate 1', 'N', '44', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (19, 'OCFRATE1', 'TL phí trong hạn 1', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0.####', 'N', 'N', 'N', 100, '', 'Fee rate 1', 'N', '54', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (20, 'CFRATE2', 'TL phí trong hạn 2', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0.####', 'Y', 'Y', 'N', 100, '', 'Fee rate 2', 'N', '45', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (21, 'OCFRATE2', 'TL phí trong hạn 2', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0.####', 'N', 'N', 'N', 100, '', 'Fee rate 2', 'N', '55', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (22, 'CFRATE3', 'TL phí trong hạn 3', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0.####', 'Y', 'Y', 'N', 100, '', 'Fee rate 3', 'N', '46', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (23, 'OCFRATE3', 'TL phí trong hạn 3', 'N', 'DF2669', 100, '', '<,<=,=,>=,>,<>', '#,##0.####', 'N', 'N', 'N', 100, '', 'Fee rate 3', 'N', '56', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (24, 'OAUTOAPPLY', 'Tự động áp luật', 'C', 'DF2669', 100, '', 'LIKE,=', '_', 'N', 'N', 'N', 100, '', 'Auto apply rule', 'N', '60', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (25, 'AUTOAPPLY', 'Tự động áp luật', 'C', 'DF2669', 100, '', 'LIKE,=', '_', 'N', 'N', 'N', 100, '', 'Auto apply rule', 'N', '61', '', 'N', '', '', '', 'N', 'Y', '', '');COMMIT;