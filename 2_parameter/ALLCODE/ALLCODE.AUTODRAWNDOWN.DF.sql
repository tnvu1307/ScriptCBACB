SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('AUTODRAWNDOWN','NULL') AND NVL(CDTYPE,'NULL') = NVL('DF','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('DF', 'AUTODRAWNDOWN', '0', 'Không giải ngân', 0, 'Y', 'Not drawdown');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('DF', 'AUTODRAWNDOWN', '1', 'Giải ngân', 1, 'Y', 'Drawdown');COMMIT;