SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CBLOGNOTIFY','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CBLOGNOTIFY', 'Tra cứu trạng thái đồng bộ từ giữa CB và FA', 'Synchronization between CB and FA', 'SELECT * FROM VW_CBLOGNOTIFY WHERE 0=0', 'CBLOGNOTIFY', NULL, 'LOGTIME DESC,TXDATE DESC', NULL, 0, 100, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;