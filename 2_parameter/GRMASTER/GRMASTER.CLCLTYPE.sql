SET DEFINE OFF;DELETE FROM GRMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CL.CLTYPE','NULL');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('CL', 'CL.CLTYPE', 0, 'MAIN', 'N', 'NNNNNNNN', 'TT chung', 'General', 'N', NULL, 'N');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('CL', 'CL.CLTYPE', 1, 'EXTREFVAL', 'G', 'EEEENNNN', 'TT mở rộng', 'Advance info', 'N', 'EXTREFVAL', 'N');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('CL', 'CL.CLTYPE', 2, 'BRIDTYPE', 'G', 'EEEENNNN', 'Phân quyền CN/PGD', 'Branch permission', 'N', 'BRIDTYPE', 'N');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('CL', 'CL.CLTYPE', 3, 'AFIDTYPE', 'G', 'EEEENNNN', 'Phân quyền dịch vụ', 'Service permission', 'N', 'AFIDTYPE', 'N');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('CL', 'CL.CLTYPE', 4, 'ICCFTYPEDEF', 'G', 'EEEENNNN', 'Xử lý tự động cuối ngày', 'EOD Batch events', 'N', 'ICCFTYPEDEF', 'N');COMMIT;