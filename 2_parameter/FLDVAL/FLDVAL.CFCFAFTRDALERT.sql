SET DEFINE OFF;DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF.CFAFTRDALERT','NULL');Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('TRGVAL', 'CF.CFAFTRDALERT', 1, 'V', '>=', '@0', '', 'Tham số không được nhỏ hơn 0!', 'Parameters cannot <0!', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('FRDATE', 'CF.CFAFTRDALERT', 2, 'V', '>=', '@<$BUSDATE>', '', 'Ngày hiệu lực không nhỏ hơn ngày làm việc hiện tại!', 'Effective date must not earlier than current working date!', '', '', 0);Insert into FLDVAL   (FLDNAME, OBJNAME, ODRNUM, VALTYPE, OPERATOR, VALEXP, VALEXP2, ERRMSG, EN_ERRMSG, TAGFIELD, TAGVALUE, CHKLEV) Values   ('TODATE', 'CF.CFAFTRDALERT', 3, 'V', '>=', 'FRDATE', '', 'Ngày hết hiệu lực không nhỏ hơn ngày có hiệu lực!', 'Deadline must be later than effective date!', '', '', 0);COMMIT;