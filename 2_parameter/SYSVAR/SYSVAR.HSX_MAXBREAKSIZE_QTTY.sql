SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('HSX_MAXBREAKSIZE_QTTY','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'HSX_MAXBREAKSIZE_QTTY', '500000', 'Khá»‘i lÆ°á»£ng tÃ¡ch lá»‡nh tá»‘i Ä‘a', 'HSX: Maximum quantiy break size', 'N', 'C');COMMIT;