SET DEFINE OFF;

DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('HEADOFFICE','NULL');

Insert into SYSVAR
   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE)
 Values
   ('SYSTEM', 'HEADOFFICE', 'Ngân hàng thương mại cổ phần Á Châu', 'Tên tiếng anh', 'Vietnamese Name', 'Y', 'C');
COMMIT;
