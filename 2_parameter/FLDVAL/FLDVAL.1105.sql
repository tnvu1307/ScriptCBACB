SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('1105','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('10', '1105', 11, 'V', '>>', '@0', NULL, 'Số lượng phải lớn hơn 0', 'Quantity must be greater than zero', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('10', '1105', 12, 'V', '<=', '08', NULL, 'Số lượng phải bé hơn hoặc bằng Số lượng tối đa!', 'Quantity must must be less than or equal to Max quantity!', NULL, NULL, 0);COMMIT;