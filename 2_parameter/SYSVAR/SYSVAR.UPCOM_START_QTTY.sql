SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('UPCOM_START_QTTY','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'UPCOM_START_QTTY', '10', 'Số lượng đặt tối thiểu', 'UPCOM: Minimum order size', 'N', 'C');COMMIT;