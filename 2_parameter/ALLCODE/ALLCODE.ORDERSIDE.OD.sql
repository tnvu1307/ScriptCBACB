SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('ORDERSIDE','NULL') AND NVL(CDTYPE,'NULL') = NVL('OD','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ORDERSIDE', 'NB', 'Mua', 0, 'Y', 'Buy');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ORDERSIDE', 'NS', 'Bán', 1, 'Y', 'Sell');COMMIT;