SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('2215','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('10', '2215', 1, 'V', '>=', '@0', NULL, 'Giá phải lớn hơn 0', 'Price must be greater than zero', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('11', '2215', 2, 'V', '>>', '@0', NULL, 'Giá phải lớn hơn 0', 'Price must be greater than zero', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('12', '2215', 4, 'V', '>=', '@0', NULL, 'Giá phải lớn hơn 0', 'Price must be greater than zero', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('13', '2215', 6, 'V', '>>', '@0', NULL, 'Giá phải lớn hơn 0', 'Price must be greater than zero', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('14', '2215', 8, 'V', '>=', '@0', NULL, 'Giá phải lớn hơn 0', 'Price must be greater than zero', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('15', '2215', 10, 'V', '>>', '@0', NULL, 'Giá phải lớn hơn 0', 'Price must be greater than zero', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('16', '2215', 12, 'V', '>>', '@0', NULL, 'Giá phải lớn hơn 0', 'Price must be greater than zero', NULL, NULL, 0);COMMIT;