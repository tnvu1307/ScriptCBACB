SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('DF.DFTYPE','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('FEEMIN', 'DF.DFTYPE', 1, 'V', '>=', '@0', NULL, 'Số phí tối thiểu không được nhỏ hơn 0!', 'Minimum fee amount cannot less than 0!', NULL, NULL, 0);COMMIT;