SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('6672','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('06', '6672', 0, 'V', '>=', '05', NULL, ' Từ ngày không được lớn hơn đến ngày!', 'To date should be greater than from date!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('05', '6672', 1, 'V', '<=', '<$BUSDATE>', NULL, 'Từ ngày phải nhỏ hơn hoặc bằng ngày làm việc!', 'Begin date must be earlier than or equal working date!', NULL, NULL, 0);COMMIT;