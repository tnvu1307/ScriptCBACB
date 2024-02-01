SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.STCTICKSIZE','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('TICKSIZE', 'SA.STCTICKSIZE', 0, 'V', '>>', '@0', NULL, 'Tick size should be greater than zero!', 'Tick size should be greater than zero!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('FROMPRICE', 'SA.STCTICKSIZE', 1, 'V', '>=', '@0', NULL, 'From price should be greater than zero!', 'From price should be greater than zero!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('TOPRICE', 'SA.STCTICKSIZE', 2, 'V', '>>', '@0', NULL, 'To price should be greater than zero!', 'To price should be greater than zero!', NULL, NULL, 0);COMMIT;