SET DEFINE OFF;DELETE FROM SEARCHFLD WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('PR0002','NULL');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (0, 'NO', 'STT', 'C', 'PR0002', 10, NULL, '=,<=,>=', NULL, 'N', 'N', 'N', 20, NULL, 'NO', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (1, 'CODEID', 'Tham chiếu chứng khoán', 'C', 'PR0002', 10, NULL, '<,<=,=,LIKE', NULL, 'N', 'N', 'Y', 10, NULL, 'Codeid', 'N', '01', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (2, 'SYMBOL', 'Mã chứng khoán', 'C', 'PR0002', 20, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 95, NULL, 'Symbol', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (3, 'LISTINGQTTY', 'SL CK niêm yết', 'N', 'PR0002', 20, NULL, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 90, NULL, 'Listed securities quantity', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (4, 'ROOMLIMITMAX', 'Room_Max', 'N', 'PR0002', 20, NULL, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 90, NULL, 'Room_Max', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (5, 'ROOMLIMIT', 'Room chứng khoán', 'N', 'PR0002', 20, NULL, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 90, NULL, 'Room limit', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (6, 'ROOMUSED', 'Room đã sử dụng', 'N', 'PR0002', 20, NULL, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 90, NULL, 'In used', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (7, 'ROOMREMAIN', 'Room còn lại', 'N', 'PR0002', 20, NULL, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 90, NULL, 'Remain room', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (8, 'MRPRICELOAN', 'Giá vay', 'N', 'PR0002', 20, NULL, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 90, NULL, 'Loan price', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (9, 'MARKETVAL', 'Giá trị TT CK cho vay', 'N', 'PR0002', 20, NULL, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 90, NULL, 'Loan market price', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (10, 'MRMAXBALANCE', 'Dư nợ MR tối đa', 'N', 'PR0002', 20, NULL, '<,<=,=,>=,>,<>', '#,##0', 'Y', 'Y', 'N', 90, NULL, 'Max MR balance', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (11, 'ROOMTYPE', 'Loại nguồn', 'C', 'PR0002', 10, NULL, 'LIKE,=', NULL, 'N', 'N', 'N', 20, NULL, 'Room Type', 'N', '29', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);COMMIT;