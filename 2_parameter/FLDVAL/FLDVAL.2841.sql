SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('2841','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('10', '2841', 2, 'V', '>>', '@0', NULL, 'Giá trị phải lớn hơn 0', 'The amount must be greater than zero', NULL, NULL, 0);COMMIT;