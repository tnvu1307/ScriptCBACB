SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('WARNING_QUANTITY','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('BROKERDESK', 'WARNING_QUANTITY', '100000', 'Khối lượng cảnh báo khi đặt lệnh trên BD', 'Warning quantity on BD', 'N', 'C');COMMIT;