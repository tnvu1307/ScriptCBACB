SET DEFINE OFF;DELETE FROM SEARCHFLD WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CUSTREGIST_OL','NULL');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (0, 'AUTOID', 'Số thứ tự', 'N', 'CUSTREGIST_OL', 100, NULL, '<,<=,=,>=,>,<>', NULL, 'Y', 'Y', 'N', 100, NULL, 'Auto ID', 'N', '05', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (1, 'CDCONTENT', 'Loại khách hàng', 'C', 'CUSTREGIST_OL', 100, NULL, 'LIKE,=', NULL, 'Y', 'N', 'N', 100, NULL, 'Customer type', 'N', '30', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (2, 'IDCODE', 'Số CMTND', 'C', 'CUSTREGIST_OL', 100, NULL, 'LIKE,=', '_', 'Y', 'Y', 'Y', 150, NULL, 'ID code', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (3, 'CUSTOMERNAME', 'Tên khách hàng', 'C', 'CUSTREGIST_OL', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 150, NULL, 'Customer name', 'Y', '31', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (4, 'CUSTOMERBIRTH', 'Ngày sinh', 'D', 'CUSTREGIST_OL', 100, NULL, 'LIKE,=', 'dd/MM/yyyy', 'Y', 'N', 'N', 100, NULL, 'Date of birth', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (5, 'ADDRESS', 'Địa chỉ', 'C', 'CUSTREGIST_OL', 100, NULL, 'LIKE,=', NULL, 'N', 'Y', 'N', 150, NULL, 'Address', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (6, 'PRIVATEPHONE', 'Số điện thoại(NR)', 'C', 'CUSTREGIST_OL', 20, NULL, 'LIKE,=', '_', 'N', 'N', 'N', 50, NULL, 'Home phone', 'N', '93', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (7, 'MOBILE', 'Số di động', 'C', 'CUSTREGIST_OL', 20, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 100, NULL, 'Mobile phone', NULL, NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (8, 'FAX', 'Số FAX', 'C', 'CUSTREGIST_OL', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 100, NULL, 'FAX', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (9, 'EMAIL', 'Email', 'C', 'CUSTREGIST_OL', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 100, NULL, 'Email', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);COMMIT;