SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('1290','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('27', '1290', 0, 'E', 'EX', '26++10', NULL, NULL, NULL, NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('27', '1290', 0, 'E', 'EX', '26++10', NULL, NULL, NULL, NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('10', '1290', 1, 'I', 'FX', 'fn_check_sothapphan', '21##10', 'Số phí không đúng với tiền tệ! ', 'Fee amount (VAT - exclusive) is incorrect with the currency!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('10', '1290', 1, 'I', 'FX', 'fn_check_sothapphan', '21##10', 'Số phí không đúng với tiền tệ! ', 'Fee amount (VAT - exclusive) is incorrect with the currency!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('26', '1290', 2, 'I', 'FX', 'fn_check_sothapphan', '21##26', 'Số thuế không đúng với tiền tệ! ', 'Tax amount is incorrect with the currency!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('26', '1290', 2, 'I', 'FX', 'fn_check_sothapphan', '21##26', 'Số thuế không đúng với tiền tệ! ', 'Tax amount is incorrect with the currency!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('27', '1290', 3, 'I', 'FX', 'fn_check_sothapphan', '21##27', 'Số phí sau thuế không đúng với tiền tệ! ', 'Fee amount (VAT - inclusive) is incorrect with the currency!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('27', '1290', 3, 'I', 'FX', 'fn_check_sothapphan', '21##27', 'Số phí sau thuế không đúng với tiền tệ! ', 'Fee amount (VAT - inclusive) is incorrect with the currency!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('30', '1290', 3, 'I', 'FX', 'fn_length100_description', '30', 'Diễn giải vuợt quá 100 ký tự!', 'Interpretation exceeding 100 characters!', NULL, NULL, 0);COMMIT;