SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('REGRPLEADERS','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('REGRPLEADERS', 'Quan ly truong nhom phu', 'Group vice leader', 'Select rl.autoid,rl.grpid,rl.custid,cf.fullname,rl.rate, rl.minincome
From regrpleaders rl, cfmast cf
where rl.custid=cf.custid AND RL.STATUS=''A'' AND RL.GRPID = <$KEYVAL> order by rl.autoid', 'RE.REGRPLEADERS', 'frmREGRPLEADERS', NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;