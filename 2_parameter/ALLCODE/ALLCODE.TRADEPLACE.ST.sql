SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('TRADEPLACE','NULL') AND NVL(CDTYPE,'NULL') = NVL('ST','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'TRADEPLACE', '0001', 'HNX', 1, 'Y', 'HNX');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'TRADEPLACE', '0002', 'HOSE', 2, 'Y', 'HOSE');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'TRADEPLACE', '0003', 'UPCOM', 3, 'Y', 'UPCOM');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'TRADEPLACE', '0004', 'BOND', 4, 'Y', 'BOND');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'TRADEPLACE', '0005', 'USDBOND', 5, 'Y', 'USDBOND');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'TRADEPLACE', '0006', 'BOND_TP', 6, 'Y', 'BOND_TP');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'TRADEPLACE', '0007', 'DCCNY', 7, 'Y', 'DCCNY');COMMIT;