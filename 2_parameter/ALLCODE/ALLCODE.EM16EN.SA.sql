SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('EM16EN','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM16EN', 'LTV', 'LTV', 13, 'Y', 'LTV Ratio is increasing and very close to the Maximum LTV Ratio of');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM16EN', 'CCR', 'CCR', 14, 'Y', 'CCR Ratio is decreasing and very close to the Minimum CCR Ratio of');COMMIT;