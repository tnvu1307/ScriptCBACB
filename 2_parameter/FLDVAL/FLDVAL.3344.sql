SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('3344','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('11', '3344', 1, 'V', '>=', '@0', NULL, 'Số tiền gốc phải lớn hơn 0', 'Principal amount must be greater than zero', NULL, NULL, 0);COMMIT;