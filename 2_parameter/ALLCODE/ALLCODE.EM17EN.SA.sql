SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('EM17EN','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM17EN', 'LTV', 'LTV', 13, 'Y', 'LTV Ratio is increasing over the Maximum LTV Ratio of ');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'EM17EN', 'CCR', 'CCR', 14, 'Y', 'CCR Ratio is decreasing below the Minimum CCR Ratio of');COMMIT;