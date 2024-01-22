SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('TRANSFERCASH','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('NOTES', 'TRANSFERCASH', '002', 'Chú ý: Phí chuyển tiền tính theo qui định của Ngân hàng và do khách hàng chịu. Thời gian đặt lệnh chuyển khoản ra bên ngoài trong ngày bắt đầu từ 08h00 đến 16h00', 'Note: Transfer fee is based on Bank regulations and will be charged to customer. Time for bank transfer is from 08:00 to 16:00 everyday', 'N', 'C');COMMIT;