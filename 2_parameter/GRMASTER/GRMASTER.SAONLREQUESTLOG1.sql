SET DEFINE OFF;DELETE FROM GRMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.ONLREQUESTLOG1','NULL');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('sa', 'SA.ONLREQUESTLOG1', 1, 'DETAIL', 'G', 'NNNNNNNN', 'Nội dung', 'Content', 'N', 'VSDTXMAPEXT', 'N');COMMIT;