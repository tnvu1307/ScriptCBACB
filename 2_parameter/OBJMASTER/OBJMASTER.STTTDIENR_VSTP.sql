SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('ST.TTDIENR_VSTP','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('ST', 'ST.TTDIENR_VSTP', 'Chi tiết điện nhận về từ VSD (VSTP)', 'Message receive from VSD (VSTP)', 'N', 'N', 'NNNNYYY', 'NET');COMMIT;