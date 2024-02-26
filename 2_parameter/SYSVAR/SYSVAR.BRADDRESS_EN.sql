SET DEFINE OFF;

DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('BRADDRESS_EN','NULL');

Insert into SYSVAR
   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE)
 Values
   ('SYSTEM', 'BRADDRESS_EN', '442, Nguyen Thi Minh Khai street, Ward 5, District 3, Ho Chi Minh City, Vietnam', 'Địa chỉ', 'Address', 'Y', 'C');
COMMIT;
