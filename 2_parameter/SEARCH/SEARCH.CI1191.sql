SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CI1191','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CI1191', 'Đồng bộ giao dịch báo có từ ngân hàng (eBanking)', 'Sync cash deposit (eBanking)', '
SELECT autoid, c.custodycd, acctno,cf.fullname,b.glaccount, c.amt, c.description, c.refnum, c.txdate,
case when b.shortname is NULL OR cf.custodycd IS NULL then ''R'' else c.status END status,
c.errordesc,b.bankacctno, c.fileid,cf.idcode, cf.idplace, cf.iddate, cf.address, c.deltd,b.glaccount glmast, c.bankid
FROM tblcashdeposit c, cfmast cf, banknostro b
WHERE c.custodycd = cf.custodycd(+) AND c.bankid = b.shortname(+) AND c.tltxcd = ''1191''
', 'CIMAST', '', '', '1191', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;