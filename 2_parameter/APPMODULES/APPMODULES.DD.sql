SET DEFINE OFF;DELETE FROM APPMODULES WHERE 1 = 1 AND NVL(MODCODE,'NULL') = NVL('DD','NULL');Insert into APPMODULES   (TXCODE, MODCODE, MODNAME, CLASSNAME) Values   ('12', 'DD', 'CASA', 'DD');COMMIT;