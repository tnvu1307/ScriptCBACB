SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('1911','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('07', '1911', 1, 'V', '<=', '06', NULL, 'Số lượng chuyển nhượng không được lớn hơn số lượng tối đa!', 'Transfer quantity cannot be greater than max transfer quantity!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('11', '1911', 2, 'E', '&&', '10&&03', NULL, NULL, NULL, NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('07', '1911', 3, 'V', '>>', '@0', NULL, 'Số lượng phải lớn hơn 0', 'Quantity must be greater than zero', NULL, NULL, 0);COMMIT;