SET DEFINE OFF;DELETE FROM CELLSDEFINE WHERE 1 = 1 AND NVL(OBJECTNAME,'NULL') = NVL('OD8893','NULL');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('OD8893.NOTE', 'OD8893', 'NOTE', 'NOTE', 'Mismatched', '#F51D1D');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('OD8893.NOTE', 'OD8893', 'NOTE', 'NOTE', 'Matched', '#56B81D');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('OD8893.NOTE1', 'OD8893', 'NOTE1', 'NOTE1', 'Matched', '#56B81D');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('OD8893.NOTE1', 'OD8893', 'NOTE1', 'NOTE1', 'Mismatched', '#F51D1D');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('OD8893.NOTEVSBR', 'OD8893', 'NOTEVSBR', 'NOTEVSBR', 'Matched', '#56B81D');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('OD8893.NOTEVSBR', 'OD8893', 'NOTEVSBR', 'NOTEVSBR', 'Mismatched', '#F51D1D');COMMIT;