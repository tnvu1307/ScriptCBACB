SET DEFINE OFF;

DELETE FROM SEARCHFLD WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SYN_AITHER_SEARCH','NULL');

Insert into SEARCHFLD
   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD)
 Values
   (-1, 'AUTOID', 'ID', 'N', 'SYN_AITHER_SEARCH', 100, NULL, '<,<=,=,>=,>,<>', NULL, 'Y', 'Y', 'Y', 100, NULL, 'ID', 'N', '01', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);
Insert into SEARCHFLD
   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD)
 Values
   (0, 'TYPEREQ', 'Loại dữ liệu đồng bộ', 'C', 'SYN_AITHER_SEARCH', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 100, NULL, 'Type of sync data', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);
Insert into SEARCHFLD
   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD)
 Values
   (1, 'APILINK', 'API link', 'C', 'SYN_AITHER_SEARCH', 100, NULL, 'LIKE,=', NULL, 'N', 'N', 'N', 100, NULL, 'API link', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);
Insert into SEARCHFLD
   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD)
 Values
   (2, 'OBJECTREQKEY', 'Mã đối tượng', 'C', 'SYN_AITHER_SEARCH', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 200, NULL, 'Object code', 'N', '22', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);
Insert into SEARCHFLD
   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD)
 Values
   (3, 'CTXDATE', 'Ngày giao dịch', 'C', 'SYN_AITHER_SEARCH', 100, NULL, '<,<=,=,>=,>,<>', 'dd/MM/yyyy', 'Y', 'Y', 'N', 120, NULL, 'Trading date', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);
Insert into SEARCHFLD
   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD)
 Values
   (4, 'CCREATED_AT', 'Ngày tạo', 'C', 'SYN_AITHER_SEARCH', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 150, NULL, 'Created date', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);
Insert into SEARCHFLD
   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD)
 Values
   (5, 'CSTATUS', 'Trạng thái đồng bộ Aither', 'C', 'SYN_AITHER_SEARCH', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 120, NULL, 'Sync Aither Status', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);
Insert into SEARCHFLD
   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD)
 Values
   (6, 'DESCRIPTION', 'Chi tiết', 'C', 'SYN_AITHER_SEARCH', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 300, NULL, 'Detail', 'N', '23', NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);
Insert into SEARCHFLD
   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD)
 Values
   (7, 'COUNTREQ', 'Số lần đã gửi', 'N', 'SYN_AITHER_SEARCH', 100, NULL, '<,<=,=,>=,>,<>', NULL, 'N', 'N', 'N', 100, NULL, 'Count Request', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);
COMMIT;
