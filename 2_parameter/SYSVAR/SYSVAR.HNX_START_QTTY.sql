SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('HNX_START_QTTY','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'HNX_START_QTTY', '100', 'Số lượng đặt tối thiểu', 'HNX: Minimum order size', 'N', 'C');COMMIT;