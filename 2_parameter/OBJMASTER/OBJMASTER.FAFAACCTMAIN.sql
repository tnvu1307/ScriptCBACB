SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('FA.FAACCTMAIN','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('FA', 'FA.FAACCTMAIN', 'Gán biểu phí cho Fund', 'Add fee scheme for Fund', 'N', 'N', 'NNNYYYY', 'NET');COMMIT;