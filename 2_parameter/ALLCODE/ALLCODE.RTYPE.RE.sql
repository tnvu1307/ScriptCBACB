SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('RTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('RE','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RE', 'RTYPE', 'T', 'Thăng chức', 1, 'Y', 'Promote');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RE', 'RTYPE', 'G', 'Giáng chức', 2, 'Y', 'Demote');COMMIT;