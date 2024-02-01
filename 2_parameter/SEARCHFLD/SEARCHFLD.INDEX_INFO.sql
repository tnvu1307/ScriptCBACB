SET DEFINE OFF;DELETE FROM SEARCHFLD WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('INDEX_INFO','NULL');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (-1, 'AUTOID', 'AUTOID', 'N', 'INDEX_INFO', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.#0', 'N', 'N', 'Y', 100, NULL, 'AUTOID', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (0, 'INDEXCODE', 'Mã chỉ số', 'C', 'INDEX_INFO', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 100, NULL, 'Index code', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (1, 'TOTALSTOCK', 'Tổng số cổ phiếu trong rổ', 'N', 'INDEX_INFO', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.#0', 'Y', 'Y', 'N', 120, NULL, 'No. of securities', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (2, 'MARKETCAP', 'Tổng vốn hóa thị trường', 'N', 'INDEX_INFO', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.#0', 'Y', 'Y', 'N', 120, NULL, 'Total market cap (Bn dong)', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (3, 'LISTINGVOLUME', 'Tổng khối lượng niêm yết', 'N', 'INDEX_INFO', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.#0', 'Y', 'Y', 'N', 120, NULL, 'Total listing volume (thousand)', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (4, 'OUTSTANDING', 'Tổng khối lượng lưu hành', 'N', 'INDEX_INFO', 100, NULL, '<,<=,=,>=,>,<>', '#,##0.#0', 'Y', 'Y', 'N', 120, NULL, 'Total outstanding (thousand)', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (5, 'CINDEXCATEGORY', 'Loại chỉ số', 'N', 'INDEX_INFO', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 120, NULL, 'Index category', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (6, 'CEXCHANGE', 'Sàn Giao dịch', 'N', 'INDEX_INFO', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 120, NULL, 'Exchange', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (10, 'CREQSTATUS', 'Trạng thái đồng bộ Aither', 'C', 'INDEX_INFO', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 120, NULL, 'Sync Aither Status', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (11, 'DESCRIPTION', 'Diễn giải', 'N', 'INDEX_INFO', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 120, NULL, 'Description', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);COMMIT;