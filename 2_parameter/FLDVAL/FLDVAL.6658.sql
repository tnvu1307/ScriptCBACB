SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('6658','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('10', '6658', 2, 'V', '>>', '@0', NULL, 'Số tiền chuyển phải lớn hơn 0', 'The transfer amount must be less than 0', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('10', '6658', 5, 'V', '<=', '14', NULL, 'Số tiền chuyển phải nhỏ hơn hoặc bằng số dư khả dụng', 'The transfer amount must be less than or equal the available balance', NULL, NULL, 0);COMMIT;