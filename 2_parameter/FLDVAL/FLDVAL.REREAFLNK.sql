SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('RE.REAFLNK','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('TODATE', 'RE.REAFLNK', 1, 'V', '>>', 'FRDATE', NULL, 'Ngày hết hạn phải sau ngày có hiệu lực!', 'The expired date must be later than effective date!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('REACCTNO', 'RE.REAFLNK', 11, 'V', 'FV', 'FN_CHECK_REMAST_STATUS', 'REACCTNO', 'Trạng thái biểu hoa hồng đang là Đóng!', 'Status of commission table Broker is Close!', NULL, NULL, 2);COMMIT;