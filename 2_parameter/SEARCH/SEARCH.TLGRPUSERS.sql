SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('TLGRPUSERS','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('TLGRPUSERS', 'Định nghĩa người sử dụng cho nhóm', 'Assign users to group', 'SELECT AUTOID, GRPID, BRID, TLID, DESCRIPTION FROM TLGRPUSERS', 'TLGRPUSERS', 'frmTLGRPUSERS', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;