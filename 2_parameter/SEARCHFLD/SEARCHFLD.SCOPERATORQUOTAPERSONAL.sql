SET DEFINE OFF;DELETE FROM SEARCHFLD WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SCOPERATORQUOTAPERSONAL','NULL');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (1, 'OPERATORTYPEID', 'OPERATORTYPEID', 'C', 'SCOPERATORQUOTAPERSONAL', 250, '', 'LIKE,=', '', 'N', 'N', 'Y', 210, '', 'OPERATORTYPEID', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (2, 'OPERATORTYPENAME', 'Chức danh', 'C', 'SCOPERATORQUOTAPERSONAL', 250, '', 'LIKE,=', '', 'Y', 'Y', 'N', 240, '', 'Chức danh', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (3, 'DTPTTTQUOTA', 'Định mức doanh số ĐTPTTT', 'N', 'SCOPERATORQUOTAPERSONAL', 22, '', '<,<=,=,>=,>,<>', '#,##0.####', 'Y', 'Y', 'N', 165, '', 'Định mức doanh số ĐTPTTT', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (4, 'PERSONALQUOTA', 'Định mức doanh số cá nhân', 'N', 'SCOPERATORQUOTAPERSONAL', 22, '', '<,<=,=,>=,>,<>', '#,##0.####', 'Y', 'Y', 'N', 195, '', 'Định mức doanh số cá nhân', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (5, 'DEPARTMENTQUOTA', 'Định mức doanh số bộ phận', 'N', 'SCOPERATORQUOTAPERSONAL', 22, '', '<,<=,=,>=,>,<>', '#,##0.####', 'Y', 'Y', 'N', 225, '', 'Định mức doanh số bộ phận', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (6, 'PERFORMANCERATE', 'Tỷ lệ hiệu suất quản lý', 'N', 'SCOPERATORQUOTAPERSONAL', 22, '', '<,<=,=,>=,>,<>', '#,##0.####', 'Y', 'Y', 'N', 225, '', 'Tỷ lệ hiệu suất quản lý', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (7, 'COMMISSIONRATELESS', 'Doanh số nhỏ hơn mức tối thiểu', 'N', 'SCOPERATORQUOTAPERSONAL', 22, '', '<,<=,=,>=,>,<>', '#,##0.####', 'Y', 'Y', 'N', 270, '', 'Doanh số nhỏ hơn mức tối thiểu', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (8, 'COMMISSIONRATEMINEQUAL', 'Doanh số bằng mức tối thiểu', 'N', 'SCOPERATORQUOTAPERSONAL', 22, '', '<,<=,=,>=,>,<>', '#,##0.####', 'Y', 'Y', 'N', 330, '', 'Doanh số bằng mức tối thiểu', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (9, 'COMMISSIONRATEMINMAX', 'Doanh số lớn hơn mức tối đa', 'N', 'SCOPERATORQUOTAPERSONAL', 22, '', '<,<=,=,>=,>,<>', '#,##0.####', 'Y', 'Y', 'N', 300, '', 'Doanh số lớn hơn mức tối đa', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (10, 'RATENORMMIN', 'Tỷ lệ định mức tối thiểu (%)', 'N', 'SCOPERATORQUOTAPERSONAL', 22, '', '<,<=,=,>=,>,<>', '#,##0.####', 'Y', 'Y', 'N', 165, '', 'Tỷ lệ định mức tối thiểu', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (11, 'RATENORMMAX', 'Tỷ lệ định mức tối đa (%)', 'N', 'SCOPERATORQUOTAPERSONAL', 22, '', '<,<=,=,>=,>,<>', '#,##0.####', 'Y', 'Y', 'N', 165, '', 'Tỷ lệ định mức tối đa', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (12, 'STATUS', 'STATUS', 'C', 'SCOPERATORQUOTAPERSONAL', 10, '', 'LIKE,=', '', 'N', 'N', 'N', 90, '', 'STATUS', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '');COMMIT;