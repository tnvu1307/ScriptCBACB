SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('RATEMODE','NULL') AND NVL(CDTYPE,'NULL') = NVL('FN','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FN', 'RATEMODE', 'N', 'Không hưởng lãi', 1, 'Y', 'None interest');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FN', 'RATEMODE', 'F', 'Thả nổi', 2, 'Y', 'Floating');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FN', 'RATEMODE', 'S', 'Cố định', 3, 'Y', 'Fixed');COMMIT;