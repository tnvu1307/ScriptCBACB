SET DEFINE OFF;DELETE FROM SEARCHFLD WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR1809','NULL');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (2, 'CUSTODYCD', 'Số TK lưu ký', 'C', 'MR1809', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 80, '', 'Trading account', 'N', '88', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (3, 'FULLNAME', 'Họ tên KH', 'C', 'MR1809', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 80, '', 'Full Name', 'N', '05', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (4, 'CUSTID', 'Mã khách hàng', 'C', 'MR1809', 100, '', '<,<=,=,>=,>', '#,##0', 'N', 'N', 'N', 80, '', 'Customer ID', 'N', '03', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (5, 'OLDT0LIMIT', 'HM được đã cấp ', 'N', 'MR1809', 100, '', '<,<=,=,>=,>', '#,##0', 'Y', 'Y', 'N', 100, '', 'Allocated limit', 'N', '14', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (6, 'T0LOANLIMIT', 'HM cấp mới', 'N', 'MR1809', 100, '', '<,<=,=,>=,>', '#,##0', 'Y', 'Y', 'N', 100, '', 'New limit', 'N', '15', '', 'N', '', '', '', 'N', 'Y', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (8, 'DESCRIPTION', 'Mô tả', 'C', 'MR1809', 250, '', 'LIKE,=', '#,##0', 'Y', 'Y', 'N', 100, '', 'Description', 'N', '30', '', 'N', '', '', '', 'N', 'N', '', '');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (8, 'IDCODE', 'Chứng minh thư', 'C', 'MR1809', 100, '', 'LIKE,=', '#,##0', 'N', 'N', 'N', 100, '', 'ID code', 'N', '06', '', 'N', '', '', '', 'N', 'Y', '', '');COMMIT;