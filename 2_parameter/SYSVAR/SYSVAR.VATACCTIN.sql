SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('VATACCTIN','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'VATACCTIN', '000100133001000', 'GL VAT account input', 'Tai khoan GL thue VAT dau vao', 'N', 'C');COMMIT;