SET DEFINE OFF;

DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('8864','NULL');

Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('21', '8864', 18, 'E', 'FX', 'fn_get_nextdate_8864', '20##33', NULL, NULL, NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('20', '8864', 19, 'I', 'FX', 'fn_check_postdate_less_than_or_equal_current_date', '20', 'Ngày giao dịch phải bé hơn hoặc bằng ngày hiện tại', 'Trading date must be less than or equal to the current date', NULL, NULL, 0);
Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('12', '8864', 1, 'V', '>>', '@0', NULL, 'Khối lượng giao dịch phải lớn hơn 0 !', 'Quantity must be greater than 0!', NULL, NULL, 0);
COMMIT;
