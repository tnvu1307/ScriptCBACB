SET DEFINE OFF;

DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('1400','NULL');

Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('15', '1400', 1, 'E', 'FX', 'fn_get_interest_rate', '88##05', NULL, NULL, NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('17', '1400', 2, 'E', 'FX', 'GET_SELLING_AMOUNT', '04##13##15##17', NULL, NULL, NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('05', '1400', 3, 'V', '<=', '<$BUSDATE>', NULL, 'Ngày ký phụ lục phải bé hơn ngày hiện tại !', 'EFFDATE must be smaller than current date !', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('13', '1400', 4, 'V', '>>', '@0', NULL, 'Số lượng bán phải lớn hơn 0', 'The number of sales must be more than 0', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('13', '1400', 5, 'V', '<=', '12', NULL, 'Số lượng bán phải nhỏ hơn số lượng khả dụng', 'The number of sales must be smaller than the amount available', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('11', '1400', 6, 'V', '>=', '@0', NULL, 'Giá trị thanh toán phải lớn hơn hoặc bằng 0', 'The net amount must be greater than 0 or equal 0', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('13', '1400', 8, 'I', 'FX', 'fn_check_aqtty_1400', '88##13', 'Vượt quá số lượng physical trong tài khoản khách hàng!', 'Exceeded the number of physical accounts in the client account!', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('14', '1400', 9, 'V', '>=', '@0', NULL, 'Giá trị thuế phải lớn hơn hoặc bằng 0', 'VAT must be greater than 0 or equal 0', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('38', '1400', 10, 'I', 'FX', 'fn_check_settlementDate_more_than_or_equal_current_date', '38', 'Ngày thanh toán không thể bé hơn ngày hiện tại', 'The settlement date cannot be earlier than the current date', NULL, NULL, 0);
COMMIT;