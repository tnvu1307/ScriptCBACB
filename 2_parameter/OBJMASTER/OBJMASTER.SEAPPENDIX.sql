SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SE.APPENDIX','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SE', 'SE.APPENDIX', 'Danh sách phụ lục ', 'Appendixes list', 'Y', 'N', 'NNNYYYY', 'NET');COMMIT;