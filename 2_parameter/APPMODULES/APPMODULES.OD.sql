SET DEFINE OFF;DELETE FROM APPMODULES WHERE 1 = 1 AND NVL(MODCODE,'NULL') = NVL('OD','NULL');Insert into APPMODULES   (TXCODE, MODCODE, MODNAME, CLASSNAME) Values   ('88', 'OD', 'Lệnh', 'OD');COMMIT;