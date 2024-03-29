SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RSCTYPE','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RSCTYPE', 'Nguồn giải ngân', 'Drawdown source', '
select * from (
SELECT RESID, RESNAME
FROM (
SELECT ''ALL'' RESID, ''All'' RESNAME, -1 LSTODR FROM DUAL
union all
SELECT ''BSC'' RESID,''BSC'' RESNAME, 0 LSTODR FROM dual
union all
SELECT shortname RESID,fullname RESNAME, to_number(custid) LSTODR FROM cfmast where isbanking = ''Y''
) ORDER BY LSTODR
) where 0=0
', 'RSCTYPE', 'frmRSCTYPE', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;