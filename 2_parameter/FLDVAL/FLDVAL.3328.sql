SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('3328','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('10', '3328', 0, 'V', '>>', '@0', '', 'SL Hủy đăng ký phải lớn hơn 0', 'Quantity register cancel must be greater than zero', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('12', '3328', 0, 'V', '>>', '@0', '', 'SL TP hủy ĐK CĐ phải lớn hơn 0', 'The no. of bonds to be canceled must be greater than zero', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('12', '3328', 0, 'V', '<=', '11', '', 'SL TP hủy ĐK CĐ không được lớn hơn SL TP tối đa có thể hủy ĐK CĐ', 'The no. of bonds to be canceled should not bigger than the max qtty. of bonds to cancel', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('10', '3328', 5, 'E', 'FX', 'fn_gen_bondconvert', '02##12', '', '', '', '', 1);COMMIT;