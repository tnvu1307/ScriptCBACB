SET DEFINE OFF;DELETE FROM CELLSDEFINE WHERE 1 = 1 AND NVL(OBJECTNAME,'NULL') = NVL('CRBBANKREQUESTHIST','NULL');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('CRBBANKREQUESTHIST.CFSTATUSTEXT', 'CRBBANKREQUESTHIST', 'CFSTATUS', 'CFSTATUSTEXT', 'C', '#56B81D');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('CRBBANKREQUESTHIST.CFSTATUSTEXT', 'CRBBANKREQUESTHIST', 'CFSTATUS', 'CFSTATUSTEXT', 'E', '#F51D1D');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('CRBBANKREQUESTHIST.CFSTATUSTEXT', 'CRBBANKREQUESTHIST', 'CFSTATUS', 'CFSTATUSTEXT', 'R', '#F51D1D');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('CRBBANKREQUESTHIST.STATUSTEXT', 'CRBBANKREQUESTHIST', 'STATUS', 'STATUSTEXT', 'N', '#F51D1D');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('CRBBANKREQUESTHIST.STATUSTEXT', 'CRBBANKREQUESTHIST', 'STATUS', 'STATUSTEXT', 'Y', '#56B81D');COMMIT;