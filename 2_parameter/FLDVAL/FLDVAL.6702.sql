SET DEFINE OFF;

DELETE FROM FLDVAL WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('6702','NULL');

COMMIT;