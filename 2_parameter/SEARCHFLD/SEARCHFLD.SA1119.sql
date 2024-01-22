SET DEFINE OFF;DELETE FROM SEARCHFLD WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SA1119','NULL');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (0, 'AUTOID', 'Mã quản lý', 'N', 'SA1119', 100, '', '<,<=,=,>=,>,<>', '#,##0', 'N', 'N', 'Y', 0, '', 'Auto ID', 'N', '01', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (1, 'REQUESTID', 'Số hiệu yêu cầu', 'C', 'SA1119', 100, '', 'LIKE,=', '_', 'N', 'N', 'N', 100, '', 'Request ID', 'N', '02', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (2, 'CUSTODYCD', 'Số tài khoản lưu ký', 'C', 'SA1119', 100, '', 'LIKE,=', '_', 'Y', 'Y', 'N', 150, '', 'Trading account', 'N', '88', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (3, 'FRACCTNO', 'Số tiểu khoản chuyển', 'C', 'SA1119', 100, '9999.999999', 'LIKE,=', '_', 'Y', 'Y', 'N', 150, '', 'From sub account', 'N', '03', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (4, 'FULLNAME', 'Họ tên', 'C', 'SA1119', 100, '', 'LIKE,=', '_', 'Y', 'Y', 'N', 200, '', 'Full Name', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (5, 'TRFAMT', 'Số tiền chuyển', 'N', 'SA1119', 100, '', '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 100, '', 'Transfer amount', 'N', '13', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (6, 'REG_ACCTNO', 'Số tiểu khoản nhận', 'C', 'SA1119', 100, '9999.999999', 'LIKE,=', '_', 'Y', 'Y', 'N', 150, '', 'To sub account', 'N', '81', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (7, 'REG_BENEFICARY_NAME', 'Họ tên người nhận', 'C', 'SA1119', 100, '', 'LIKE,=', '_', 'Y', 'Y', 'N', 150, '', 'Receiver full name', 'N', '82', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (8, 'REG_BENEFICARY_INFO', 'Ngân hàng', 'C', 'SA1119', 100, '', 'LIKE,=', '_', 'Y', 'Y', 'N', 150, '', 'Bank', 'N', '79', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (9, 'TRFDESC', 'Diễn giải', 'C', 'SA1119', 100, '', 'LIKE,=', '_', 'Y', 'Y', 'N', 200, '', 'Description', 'N', '30', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (9, 'ACNIDCODE', 'Số CMND người nhận', 'C', 'SA1119', 100, '', 'LIKE,=', '_', 'Y', 'Y', 'N', 150, '', 'ID code reciever', 'N', '83', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (10, 'ACNIDDATE', 'Ngày cấp', 'C', 'SA1119', 100, '', 'LIKE,=', '_', 'Y', 'Y', 'N', 150, '', 'Issued date', 'N', '95', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (11, 'ACNIDPLACE', 'Nơi cấp', 'C', 'SA1119', 100, '', 'LIKE,=', '_', 'Y', 'Y', 'N', 150, '', 'Issued place', 'N', '96', '', 'N', '', '', '', 'N', 'Y', '', '');COMMIT;