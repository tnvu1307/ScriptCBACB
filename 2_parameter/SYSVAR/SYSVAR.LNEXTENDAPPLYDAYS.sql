SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('LNEXTENDAPPLYDAYS','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'LNEXTENDAPPLYDAYS', '15', 'Số ngày cộng thêm khi đổi loại hình', 'Auto extend apply days', 'Y', 'C');COMMIT;