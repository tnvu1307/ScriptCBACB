SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('ST.VSDTXINFO_VSTP','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('ST', 'ST.VSDTXINFO_VSTP', 'Quản lý thông tin chi tiết điện VSD (VSTP)', 'VSD message management (VSTP)', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;