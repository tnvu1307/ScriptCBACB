SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('VATACCTOUT','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'VATACCTOUT', '000100333110000', 'GL VAT account output', 'Tai khoan GL thue VAT dau ra', 'N', 'C');COMMIT;