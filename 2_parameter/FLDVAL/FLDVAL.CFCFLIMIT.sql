SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF.CFLIMIT','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('LMAMT', 'CF.CFLIMIT', 0, 'V', '>=', '@0', NULL, 'Hạn mức vay tối đa khách hàng phải lớn hơn 0!', 'The customer limit cannot less than 0!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('LMAMTMAX', 'CF.CFLIMIT', 0, 'V', '>=', '@0', NULL, 'Hạn mức vay tối đa phải lớn hơn 0!', 'Max limt of loan must be greater than 0!', NULL, NULL, 0);COMMIT;