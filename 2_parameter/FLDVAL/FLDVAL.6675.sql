SET DEFINE OFF;

DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('6675','NULL');

Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('10', '6675', 1, 'V', '>=', '@0', NULL, 'Số tiền chuyển phải lớn hơn hoặc bằng 0', 'Amount must be greater than 0 or equal 0', NULL, NULL, 0);
COMMIT;
