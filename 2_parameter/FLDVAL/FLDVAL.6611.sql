SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('6611','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('08', '6611', 1, 'V', 'NI', '@F', '', 'Không được phép sửa trạng thái với bảng kê đã hoàn thành!', 'Cannot change status of lists which are already complete!', '', '', 0);COMMIT;