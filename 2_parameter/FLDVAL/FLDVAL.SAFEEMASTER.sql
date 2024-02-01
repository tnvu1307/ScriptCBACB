SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.FEEMASTER','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('MINVAL', 'SA.FEEMASTER', 0, 'V', '<=', 'MAXVAL', NULL, 'Gia tri toi thieu phai nho hon gia tri toi da!', 'The minimum value must be less than maximum value!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('EXPIRATIONDATE', 'SA.FEEMASTER', 1, 'V', '>>', 'EFFECTIVEDATE', NULL, 'Ngày hết hạn không được nhỏ hơn ngày hiệu lực', 'The expiration date must not be smaller than the effective date', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('FEEAMT', 'SA.FEEMASTER', 1, 'V', '>=', '@0', NULL, 'Gia tri phi khong nho hon 0!', 'The fee amount can not be less than 0!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('FEECODE', 'SA.FEEMASTER', 1, 'E', 'FX', 'FN_GET_FEECODE', 'REFCODE##SUBTYPE', NULL, NULL, NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('FEERATE', 'SA.FEEMASTER', 1, 'V', '>=', '@0', NULL, 'Ty le phi khong nho hon 0!', 'The fee rate can not less than 0!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('VATRATE', 'SA.FEEMASTER', 1, 'V', '>=', '@0', NULL, 'Ty le VAT khong nho hon 0!', 'The VAT rate can not less than 0!', NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('FEEAMTVAT', 'SA.FEEMASTER', 2, 'E', 'FX', 'FN_GET_FEEAMT_VATINCL', 'FEEAMT##VATRATE##CCYCD', NULL, NULL, NULL, NULL, 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('EXPIRATIONDATE', 'SA.FEEMASTER', 3, 'V', 'FV', 'fn_check_expirationdate', 'STATUS##EXPIRATIONDATE', 'Ngày hết hạn đã trôi qua', 'The expiration date has already passed', NULL, NULL, 0);COMMIT;