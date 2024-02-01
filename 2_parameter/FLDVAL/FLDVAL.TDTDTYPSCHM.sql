SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('TD.TDTYPSCHM','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('INTRATE', 'TD.TDTYPSCHM', 1, 'V', '>>', '@0', NULL, 'Lãi suất không được nhỏ hơn 0!', 'Interest rate cannot less than 0!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('FRTERM', 'TD.TDTYPSCHM', 3, 'V', '>=', '@0', NULL, 'Kỳ hạn mức dưới không được nhỏ hơn 0!', 'From term cannot be less than 0!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('FRAMT', 'TD.TDTYPSCHM', 4, 'V', '<=', 'TOAMT', NULL, 'Số dư mức dưới không được lớn hơn số dư mức trên!', 'From amount cannot greater than to amount!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('FRTERM', 'TD.TDTYPSCHM', 5, 'V', '<=', 'TOTERM', NULL, 'Kỳ hạn mức dưới không được lớn hơn kỳ hạn mức trên!', 'From term cannot greater than To term!', NULL, NULL, 0);COMMIT;