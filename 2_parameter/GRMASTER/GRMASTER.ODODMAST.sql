SET DEFINE OFF;DELETE FROM GRMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('OD.ODMAST','NULL');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('OD', 'OD.ODMAST', 1, 'ODMASTDETAIL', 'G', 'NNNNNNNN', 'Chi tiết lệnh', 'Order detail', 'N', 'ODMASTDETAIL', 'N');COMMIT;