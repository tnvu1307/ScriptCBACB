SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('INTTYPBRCD','NULL') AND NVL(CDTYPE,'NULL') = NVL('TD','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('TD', 'INTTYPBRCD', 'L', 'Kỳ hạn gần nhất', 0, 'Y', 'Latest term');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('TD', 'INTTYPBRCD', 'T', 'Chia kỳ hạn', 1, 'Y', 'Term');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('TD', 'INTTYPBRCD', 'S', 'Không kỳ hạn', 2, 'Y', 'Non-term');COMMIT;