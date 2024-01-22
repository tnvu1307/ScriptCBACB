SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.ODPROBRKMST','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('FEERATE', 'SA.ODPROBRKMST', 0, 'V', '>=', '@0', '', 'Tỷ lệ phí không nhỏ hơn 0!', 'The fee rate can not less than 0!', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('MAXAMT', 'SA.ODPROBRKMST', 2, 'V', '>=', '@0', '', 'Giá trị tối đa không nhỏ hơn 0!', 'The maximum fee can not be less than 0!', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('MINAMT', 'SA.ODPROBRKMST', 3, 'V', '<=', 'MAXAMT', '', 'Giá trị tối thiểu không được lớn hơn giá trị tối đa!', 'The minimum value must be less than maximum value!', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('VALDATE', 'SA.ODPROBRKMST', 4, 'V', '<=', 'EXPDATE', '', 'Ngày hết hạn phải sau ngày có hiệu lực!', 'The expired date must be later than effective date!', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('EXPDATE', 'SA.ODPROBRKMST', 5, 'V', '>=', '<$BUSDATE>', '', 'Ngày hết hạn lớn hơn hay bằng ngày hiện tại!', 'The expired date must be later than current date!', '', '', 0);COMMIT;