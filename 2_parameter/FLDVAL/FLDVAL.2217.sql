SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('2217','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('10', '2217', 1, 'V', '<=', '09', '', 'Số lượng phong tỏa <= Số lượng hợp đồng Escrow', 'Block quantity must be less than or equal Escrow agreement quantity', '', '', 0);COMMIT;