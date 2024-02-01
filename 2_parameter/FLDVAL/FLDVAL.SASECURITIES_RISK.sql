SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.SECURITIES_RISK','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('MRMAXQTTY', 'SA.SECURITIES_RISK', 0, 'V', '>=', '@0', NULL, 'Khối lượng ký quỹ tối đa không được nhỏ hơn 0!', 'Max secured amount cannot <0', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('AFMAXAMT', 'SA.SECURITIES_RISK', 1, 'V', '>=', '@0', NULL, 'Giá trị vay tối đa theo tiểu khoản không được nhỏ hơn 0!', 'Max loan amount on sub account cannot be less than 0', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('MRPRICERATE', 'SA.SECURITIES_RISK', 2, 'V', '>=', '@0', NULL, 'Giá ký quỹ không được nhỏ hơn 0!', 'Margin price cannot less than 0!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('MRPRICELOAN', 'SA.SECURITIES_RISK', 3, 'V', '>=', '@0', NULL, 'Giá vay không được nhỏ hơn 0!', 'Loan price cannot be less than 0', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('MRRATIORATE', 'SA.SECURITIES_RISK', 4, 'V', '>=', '@0', NULL, 'Tỷ lệ ký quỹ không được nhỏ hơn 0!', 'Margin rate cannot less than 0!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('MRRATIOLOAN', 'SA.SECURITIES_RISK', 5, 'V', '>=', '@0', NULL, 'Tỷ lệ vay không được nhỏ hơn 0!', 'Loan rate cannot less than 0!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('MRRATIOLOAN', 'SA.SECURITIES_RISK', 6, 'V', '<<', '@100', NULL, 'Tỷ lệ vay không được lớn hơn 100!', 'MRRATE cannot >100!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('MRRATIORATE', 'SA.SECURITIES_RISK', 6, 'V', '<<', '@100', NULL, 'Tỷ lệ ký quỹ không được lớn hơn 100!', 'Secured rate must not be greater than 100!', NULL, NULL, 0);COMMIT;