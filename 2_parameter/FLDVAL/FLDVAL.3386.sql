SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('3386','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('81', '3386', 1, 'V', '<=', '80', NULL, 'Số lượng quyền hủy vượt quá số lượng đăng ký', 'Cancel quantity of rights exceed register quantity', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('81', '3386', 1, 'V', '>>', '@0', NULL, 'Số lượng quyền phải lớn hơn 0', 'Quantity of rights must be greater than zero', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('21', '3386', 2, 'V', '>>', '@0', NULL, 'Số lượng phải lớn hơn 0', 'Quantity must be greater than zero', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('21', '3386', 2, 'V', '<=', '20', NULL, 'Số lượng hủy vượt quá số lượng đăng ký', 'Cancel quantity exceed register quantity', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('21', '3386', 2, 'E', 'FX', 'FN_GET_QTTY_3386', '02##81', NULL, NULL, NULL, NULL, 0);COMMIT;