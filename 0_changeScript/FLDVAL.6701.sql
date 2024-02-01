SET DEFINE OFF;

DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('6701','NULL');

Insert into FLDVAL
   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV)
 Values
   ('02', '6701', 0, 'I', 'FX', 'fn_check_postdate_less_than_or_equal_current_date', '02', 'Ngày giao dịch phải bé hơn hoặc bằng ngày hiện tại', 'Trading date must be less than or equal to the current date', NULL, NULL, 0);
COMMIT;
