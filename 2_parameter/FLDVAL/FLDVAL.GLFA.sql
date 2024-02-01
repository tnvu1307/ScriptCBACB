SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('GL.FA','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('PRICE', 'GL.FA', 0, 'V', '>>', '@0', NULL, 'Giá trị TS phải lớn hơn 0!', 'Value must be greater than zero!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('DEPTIME', 'GL.FA', 1, 'V', '>>', '@0', NULL, 'Thời gian khấu hao phải lớn hơn 0!', 'Depreciation time must be greater than zero!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('PERCENTAGE', 'GL.FA', 2, 'V', '>=', '@0', NULL, 'Phần trăm khấu hao phải lớn hơn 0!', 'Depreciation percentage must be greater than zero!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('ACCUMULATE', 'GL.FA', 3, 'V', '>=', '@0', NULL, 'Giá trị khấu hao phải lớn hơn 0!', 'Accumulate depreciation must be greater than zero!', NULL, NULL, 0);COMMIT;