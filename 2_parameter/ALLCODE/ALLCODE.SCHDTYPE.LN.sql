SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('SCHDTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('LN','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'SCHDTYPE', 'DFP', 'Cầm cố', 0, 'Y', 'Mortgage');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'SCHDTYPE', 'AFP', 'Margin', 1, 'Y', 'Margin');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'SCHDTYPE', 'AFGP', 'Bảo lãnh', 2, 'N', 'Underwrite');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'SCHDTYPE', 'AFI', 'Lịch lãi', 3, 'N', 'Interest schema');COMMIT;