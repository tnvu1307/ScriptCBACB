SET DEFINE OFF;DELETE FROM SEARCHFLD WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('GRCAREBY','NULL');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (5, 'GRPID', 'Mã nhóm', 'C', 'GRCAREBY', 100, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'Y', 100, NULL, 'Group Id', 'N', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD) Values   (6, 'GRPNAME', 'Tên nhóm', 'C', 'GRCAREBY', 200, NULL, 'LIKE,=', NULL, 'Y', 'Y', 'N', 200, NULL, 'Group Name', 'Y', NULL, NULL, 'N', NULL, NULL, NULL, 'N', 'Y', NULL, NULL);COMMIT;