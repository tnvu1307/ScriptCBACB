SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CRPHYSAGREE_PY','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CRPHYSAGREE_PY', 'Quản lý thông tin hợp đồng ', 'Manage physical ', 'SELECT CR.CRPHYSAGREEID
, CASE WHEN CRLOG.AQTTY IS NULL THEN CR.QTTY ELSE (CR.QTTY - CRLOG.AQTTY) END REMQTTY
, CF.CUSTODYCD, CR.ACCTNO, CR.NO, CR.NAME, CR.SYMBOL, CR.CODEID, CF.FULLNAME
FROM (SELECT *fROM CRPHYSAGREE WHERE DELTD <>''Y'') CR, CFMAST CF,
(SELECT CRL.CRPHYSAGREEID, SUM(CRL.QTTY) AQTTY FROM CRPHYSAGREE_LOG CRL WHERE CRL.TYPE = ''R'' AND CRL.DELTD <> ''Y'' GROUP BY CRL.CRPHYSAGREEID) CRLOG
WHERE CR.CRPHYSAGREEID = CRLOG.CRPHYSAGREEID(+)
AND CR.STATUS = ''A''
AND CR.ACCTNO = CF.CUSTID', 'CRPHYSAGREE_PY', '', 'CRPHYSAGREEID DESC', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;