SET DEFINE OFF;DELETE FROM SEARCHFLD WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('DF2620','NULL');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (-2, 'AUTOID', 'Số khế ước vay', 'C', 'DF2620', 100, NULL, 'LIKE,=', '_', 'Y', 'N', 'N', 100, NULL, 'Loan ID', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (-1, 'CUSTODYCD', 'TK lưu ký', 'C', 'DF2620', 100, NULL, 'LIKE,=', '_', 'Y', 'Y', 'N', 100, NULL, 'Trading account', 'N', '02', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (0, 'AFACCTNO', 'Số tiểu khoản', 'C', 'DF2620', 120, NULL, 'LIKE,=', '_', 'Y', 'Y', 'N', 100, NULL, 'Sub account', 'N', '03', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (1, 'GROUPID', 'Số deal tổng', 'C', 'DF2620', 18, 'cccc.cccccc.cccccc', 'LIKE,=', '_', 'Y', 'Y', 'Y', 120, NULL, 'Group deal ID', 'N', '05', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (2, 'SYMBOL', 'Chứng khoán', 'C', 'DF2620', 50, 'ccccccccccccccc', 'LIKE,=', '_', 'Y', 'Y', 'N', 50, NULL, 'Symbol', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (3, 'DFACCTNO', 'Tiểu khoản DF', 'C', 'DF2620', 100, NULL, 'LIKE,=', NULL, 'N', 'N', 'N', 100, NULL, 'DF Sub account', 'N', '11', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (4, 'SEACCTNO', 'Tiểu khoản SE', 'C', 'DF2620', 100, NULL, 'LIKE,=', NULL, 'N', 'N', 'N', 100, NULL, 'SE account', 'N', '10', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (5, 'CODEID', 'Mã code CK', 'C', 'DF2620', 100, NULL, 'LIKE,=', NULL, 'N', 'N', 'N', 100, NULL, 'Symbol', 'N', '04', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (6, 'FULLNAME', 'Họ và tên', 'C', 'DF2620', 100, NULL, 'LIKE,=', '_', 'Y', 'Y', 'N', 100, NULL, 'Full Name', 'N', '57', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (7, 'ADDRESS', 'Địa chỉ', 'C', 'DF2620', 100, NULL, 'LIKE,=', '_', 'Y', 'Y', 'N', 100, NULL, 'Address', 'N', '58', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (8, 'IDCODE', 'CMND', 'C', 'DF2620', 100, NULL, 'LIKE,=', '_', 'Y', 'Y', 'N', 100, NULL, 'ID Code', 'N', '59', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (9, 'DFQTTY', 'Số lượng cầm cố', 'N', 'DF2620', 100, NULL, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 100, NULL, 'DF quantity', 'N', '15', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (10, 'DESCRIPTION', 'DESCRIPTION', 'C', 'DF2620', 250, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 100, NULL, 'DESCRIPTION', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'N', NULL, NULL);COMMIT;