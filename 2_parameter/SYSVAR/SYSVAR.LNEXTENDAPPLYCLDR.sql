SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('LNEXTENDAPPLYCLDR','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'LNEXTENDAPPLYCLDR', 'N', 'Loại lịch DN sử dụng cộng thêm ngày khi đổi loại hình', 'Auto extend apply with business calendar', 'Y', 'C');COMMIT;