SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('TOFIIN','NULL') AND NVL(CDTYPE,'NULL') = NVL('SE','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SE', 'TOFIIN', 'SYNC_PRICE_FIIN', 'Đồng bộ giá về FIIN', 1, 'Y', 'Sync data on FIIN');COMMIT;