SET DEFINE OFF;DELETE FROM CELLSDEFINE WHERE 1 = 1 AND NVL(OBJECTNAME,'NULL') = NVL('VSDTXREQ','NULL');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('VSDTXREQ.MSGSTATUS', 'VSDTXREQ', 'CDVAL', 'MSGSTATUS', 'C', '#56B81D');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('VSDTXREQ.MSGSTATUS', 'VSDTXREQ', 'CDVAL', 'MSGSTATUS', 'A', '#E3CB32');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('VSDTXREQ.MSGSTATUS', 'VSDTXREQ', 'CDVAL', 'MSGSTATUS', 'N', '#F51D1D');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('VSDTXREQ.MSGSTATUS', 'VSDTXREQ', 'CDVAL', 'MSGSTATUS', 'E', '#F51D1D');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('VSDTXREQ.MSGSTATUS', 'VSDTXREQ', 'CDVAL', 'MSGSTATUS', 'R', '#F51D1D');Insert into CELLSDEFINE   (KEYS, OBJECTNAME, CFIELDNAME, FFIELDNAME, CVALUE, FORMAT) Values   ('VSDTXREQ.MSGSTATUS', 'VSDTXREQ', 'CDVAL', 'MSGSTATUS', 'S', '#E3CB32');COMMIT;