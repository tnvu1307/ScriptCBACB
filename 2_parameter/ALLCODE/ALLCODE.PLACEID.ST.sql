SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('PLACEID','NULL') AND NVL(CDTYPE,'NULL') = NVL('ST','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'PLACEID', 'XHNX', 'UPCOM', 1, 'Y', 'HANOI STOCK EXCHANGE');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'PLACEID', 'BUSD', 'USDBOND', 1, 'Y', 'USDBOND');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'PLACEID', 'XSTC', 'HOSE', 1, 'Y', 'HOCHIMINH STOCK EXCHANGE');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'PLACEID', 'BOND', 'BOND', 1, 'Y', 'BOND');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'PLACEID', 'BTNP', 'BOND_TP', 1, 'Y', 'BOND_TP');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'PLACEID', 'OTCO', 'OTC', 1, 'Y', 'OTC');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'PLACEID', 'HSTC', 'HNX', 1, 'Y', 'HANOI STOCK EXCHANGE');COMMIT;