SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('RE.REPROMREVIEWTERM','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('RE', 'RE.REPROMREVIEWTERM', 'Tham số kỳ đánh giá thăng chức', 'Promotion review parameters', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;