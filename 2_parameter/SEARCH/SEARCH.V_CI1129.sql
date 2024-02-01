SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('V_CI1129','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('V_CI1129', 'Danh sách import giao dịch TỔNG hoàn thuế cho khách hàng (1129)', 'Import transaction sum of tax refunded (1129)', 'select * from (select fileid, sum(amt) amt from TBLCI1137 where nvl(deltd,''N'') <> ''Y'' group by fileid) where 0 = 0', 'CIMAST', 'frmCIMAST', NULL, '1129', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;