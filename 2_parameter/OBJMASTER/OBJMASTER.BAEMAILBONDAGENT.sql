SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('BA.EMAILBONDAGENT','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('BA', 'BA.EMAILBONDAGENT', 'Quản lý danh sách Email Bond agent', 'Management of Email Bond agent', 'Y', 'N', 'NNNYYYY', 'NET');COMMIT;