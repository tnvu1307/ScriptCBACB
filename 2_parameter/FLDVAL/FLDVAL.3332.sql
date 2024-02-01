SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('3332','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('12', '3332', 0, 'V', '>>', '@0', NULL, 'Số chứng khoán chốt sở hữu phải lớn hơn 0', 'Trade quantity must greater than zero', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('17', '3332', 2, 'E', 'FX', 'FN_3332_GET_AMT', '18##02##12##14##09', NULL, NULL, NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('13', '3332', 3, 'E', 'FX', 'FN_3332_GET_QTTY', '18##02##12##09', NULL, NULL, '05', '@N', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('15', '3332', 4, 'E', 'FX', 'FN_3332_GET_AQTTY', '18##02##12##09', NULL, NULL, NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('16', '3332', 5, 'E', 'FX', 'FN_3332_GET_PQTTY', '18##02##12##14##09', NULL, NULL, '05', '@N', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('06', '3332', 6, 'E', 'FX', 'FN_3332_GET_PQTTY', '18##02##12##14##09', NULL, NULL, '05', '@Y', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('26', '3332', 6, 'E', 'FX', 'FN_3332_GET_MINPQTTY', '18##02##12##14##09', NULL, NULL, '05', '@Y', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('20', '3332', 7, 'E', 'FX', 'FN_3332_GET_RQTTY', '18##02##12##09', NULL, NULL, NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('13', '3332', 8, 'E', 'FX', 'FN_3332_GET_QTTY_014', '18##02##12##16##09', NULL, NULL, '05', '@Y', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('16', '3332', 9, 'V', '>=', '26', NULL, 'Số lượng CP chưa đăng kí phải lớn hơn hoặc bằng số lượng CP tối thiểu chưa đăng kí ', 'Unregister qtty must >= min unregister qtty', '05', '@Y', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('16', '3332', 9, 'V', '<=', '06', NULL, 'Số lượng CP chưa đăng kí không được vượt quá số lượng CP tối đa chưa đăng kí ', 'Unregister qtty cannot exceed max available qtty', '05', '@Y', 0);COMMIT;