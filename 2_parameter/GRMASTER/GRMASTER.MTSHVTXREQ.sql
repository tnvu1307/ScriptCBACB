SET DEFINE OFF;DELETE FROM GRMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('MT.SHVTXREQ','NULL');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('MT', 'MT.SHVTXREQ', 1, 'TTDIEN', 'G', 'NNNNNNNN', 'Chi tiet dien', 'Swift detail', 'N', 'TTDIEN', 'N');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('MT', 'MT.SHVTXREQ', 4, 'SWIFTVIEW', 'N', 'NNNNNNNN', 'Swift detail full', 'Swift detail full', 'N', NULL, 'N');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('MT', 'MT.SHVTXREQ', 5, 'SWIFTLIST', 'G', 'ENNNNNNN', 'List swift', 'List swift', 'N', 'SWIFTLIST', 'N');COMMIT;