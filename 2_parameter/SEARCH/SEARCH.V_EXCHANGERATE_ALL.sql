SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('V_EXCHANGERATE_ALL','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('V_EXCHANGERATE_ALL', 'Tra cứu tỷ giá', 'Exchange rates', 'select * from V_EXCHANGERATE_ALL WHERE  0 = 0', 'V_EXCHANGERATE_ALL', '', 'LASTCHANGE desc', '', NULL, 5000, 'N', 1, 'NNYNYYNNNNNY', 'N', 'T', '', 'N', '');COMMIT;