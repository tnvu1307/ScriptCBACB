SET DEFINE OFF;

DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('2221','NULL');

Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('10', '2221', 1, 'V', '<=', '20', NULL, 'Số lượng CK HCCN không hợp lệ!', 'Số lượng CK HCCN không hợp lệ!', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('10', '2221', 2, 'V', '>>', '@0', NULL, 'So luong phai lon hon 0', 'Quantity should be greater than zero', NULL, NULL, 0);
COMMIT;
