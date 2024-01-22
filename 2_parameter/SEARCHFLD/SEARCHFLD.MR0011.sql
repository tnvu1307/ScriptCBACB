SET DEFINE OFF;DELETE FROM SEARCHFLD WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR0011','NULL');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (5, 'CUSTODYCD', 'Số TK lưu ký', 'C', 'MR0011', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 100, '', 'Trading account', 'N', '88', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (10, 'AFACCTNO', 'Số tiểu khoản', 'C', 'MR0011', 100, '', 'LIKE,=', '_', 'Y', 'Y', 'Y', 100, '', 'Sub account', 'N', '03', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (15, 'FULLNAME', 'Tên khách hàng', 'C', 'MR0011', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 100, '', 'Customer name', 'Y', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (25, 'BRID', 'Chi nhánh', 'C', 'MR0011', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 100, '', 'Branch', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (25, 'MNEMONIC', 'Loại tài khoản', 'C', 'MR0011', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 100, '', 'Account type', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (30, 'BALANCE', 'Số dư tiền', 'N', 'MR0011', 200, '', '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 120, '', 'Available balance', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (35, 'ODAMT', 'Dư nợ', 'N', 'MR0011', 200, '', '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 120, '', 'Debit', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (36, 'DUEAMT', 'Dư nợ đến hạn', 'N', 'MR0011', 200, '', '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 120, '', 'Due outstanding', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (40, 'DEPOFEEAMT', 'Phí LK đến hạn', 'N', 'MR0011', 200, '', '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 120, '', 'Maturity depository fee', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (42, 'TOTALDUEAMT', 'Tổng dư nợ đến hạn', 'N', 'MR0011', 200, '', '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 120, '', 'Total due outstanding', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (45, 'TRFBUYAMT', 'Mua trả chậm', 'N', 'MR0011', 200, '', '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 120, '', 'Lat payment', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (50, 'EXECBUYAMT', 'Mua khớp trong ngày', 'N', 'MR0011', 200, '', '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 120, '', 'Buying match on day', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (55, 'ADDBALANCE', 'Số tiền cần Hold tối đa', 'N', 'MR0011', 200, '', '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 120, '', 'Hold max amount', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (60, 'BANKAVLBAL', 'Số dư khả dụng NH', 'N', 'MR0011', 200, '', '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 120, '', 'Bank available balance ', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (65, 'BANKHOLDAMT', 'Số tiền có thể Hold', 'N', 'MR0011', 200, '', '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 120, '', 'Available Hold Amount', 'N', '10', '', 'N', '', '', '', 'N', 'Y', '', '');COMMIT;