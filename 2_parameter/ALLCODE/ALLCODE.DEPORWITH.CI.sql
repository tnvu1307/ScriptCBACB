SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('DEPORWITH','NULL') AND NVL(CDTYPE,'NULL') = NVL('CI','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CI', 'DEPORWITH', 'DEPO', 'Nộp', 1, 'Y', 'Deposit');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CI', 'DEPORWITH', 'WITH', 'Rút', 2, 'Y', 'Withdraw');COMMIT;