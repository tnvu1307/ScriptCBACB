SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('BA.BONDTYPEPAY','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('ACTUALPAYDATE', 'BA.BONDTYPEPAY', 0, 'E', 'FX', 'fn_get_ACTUALPAYDATE', 'PAYMENTDATE', NULL, NULL, 'STATUS', '@A', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('RECORDDATE', 'BA.BONDTYPEPAY', 1, 'E', 'FX', 'fn_get_RECORDDATE', 'ACTUALPAYDATE', NULL, NULL, 'STATUS', '@A', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('BEGINDATE', 'BA.BONDTYPEPAY', 2, 'E', 'FX', 'fn_get_begindate_allowedit', 'BONDCODE##BEGINDATE', NULL, NULL, 'STATUS', '@A', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('INTEREST', 'BA.BONDTYPEPAY', 3, 'E', 'FX', 'fn_get_INTEREST', 'BONDCODE##BEGINDATE##PAYMENTDATE##ACTUALPAYDATE', NULL, NULL, 'STATUS', '@A', 0);COMMIT;