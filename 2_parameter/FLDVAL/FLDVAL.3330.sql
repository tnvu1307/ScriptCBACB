SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('3330','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('12', '3330', 0, 'V', '>>', '@0', NULL, 'Số chứng khoán chốt sở hữu phải lớn hơn 0', 'Trade quantity must greater than zero', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('14', '3330', 0, 'V', '>=', '@0', NULL, 'Số chứng khoán CK ĐKQM/CĐ nhận CK phải lớn hơn 0', 'Register quantity must greater than zero', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('17', '3330', 2, 'E', 'FX', 'FN_2226_GET_AMT', '18##12##14##19', NULL, NULL, NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('13', '3330', 3, 'E', 'FX', 'FN_2225_GET_QTTY', '18##12', NULL, NULL, NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('15', '3330', 4, 'E', 'FX', 'FN_2225_GET_AQTTY', '18##12', NULL, NULL, NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('16', '3330', 5, 'E', 'FX', 'FN_2226_GET_PQTTY', '18##12##14##19', NULL, NULL, NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('16', '3330', 6, 'V', '>=', '@0', NULL, 'Số chứng khoán ĐKQM/nhận CP vượt quá số lượng cho phép hoặc số CK chốt sở hữu không thỏa mãn với SLCK đã ĐK thêm', 'Register quantity exceed quantity amount or quantity own is not enough', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('20', '3330', 7, 'E', 'FX', 'FN_2225_GET_RQTTY', '18##12', NULL, NULL, NULL, NULL, 0);COMMIT;