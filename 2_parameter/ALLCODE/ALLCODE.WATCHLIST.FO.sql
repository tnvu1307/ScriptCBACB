SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('WATCHLIST','NULL') AND NVL(CDTYPE,'NULL') = NVL('FO','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FO', 'WATCHLIST', 'VS', 'HOSE', 0, 'Y', 'HOSE');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FO', 'WATCHLIST', 'VN', 'HNX', 1, 'Y', 'HNX');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FO', 'WATCHLIST', 'VO', 'HNX', 2, 'Y', 'HNX');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FO', 'WATCHLIST', 'VP', 'OTC private', 3, 'Y', 'OTC private');COMMIT;