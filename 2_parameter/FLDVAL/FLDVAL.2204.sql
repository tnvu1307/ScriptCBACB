SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('2204','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('03', '2204', 0, 'E', '&&', '02&&01', NULL, NULL, NULL, NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('10', '2204', 0, 'V', '>>', '@0', NULL, 'Số lượng phải lớn hơn 0', 'Quantity must be greater than zero', NULL, NULL, 0);COMMIT;