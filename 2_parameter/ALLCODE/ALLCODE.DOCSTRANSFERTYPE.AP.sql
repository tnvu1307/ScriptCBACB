SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('DOCSTRANSFERTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('AP','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('AP', 'DOCSTRANSFERTYPE', 'R', 'Nhập kho', 1, 'Y', 'Deposit');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('AP', 'DOCSTRANSFERTYPE', 'W', 'Rút kho', 2, 'Y', 'Withdraw');COMMIT;