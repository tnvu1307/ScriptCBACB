SET DEFINE OFF;DELETE FROM CELLSDEFINE WHERE 1 = 1 AND NVL(OBJECTNAME,'NULL') = NVL('CF0019','NULL');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('CF0019.STATUS', 'CF0019', 'STATUSTX', 'STATUS', 'R', '#56B81D');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('CF0019.STATUS', 'CF0019', 'STATUSTX', 'STATUS', 'NR', '#F51D1D');COMMIT;