SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('2218','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('10', '2218', 1, 'V', '<=', '09', '', 'Số lượng giải tỏa <= Số lượng tối đa theo hợp đồng', 'Release quantitymust be less than or equal Maximum quantity', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('10', '2218', 11, 'V', '>>', '@0', '', 'Số lượng giải tỏa phải lớn hơn 0', 'Unhold value must be greater than zero', '', '', 0);COMMIT;