SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('APPENDIX_CR','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('APPENDIX_CR', 'Quản lý thông tin phụ lục', 'Information management appendix', 'SELECT A1.<@CDCONTENT> TYPE, TMP.TLTXCD, TMP.ID, TMP.REFID, TMP.NO, TMP.NAME, TMP.REMQTTY, TMP.ACCTNO, TMP.SYMBOL, TMP.CODEID,
CF.FULLNAME, CF.CUSTODYCD
FROM (
        SELECT ''1400'' TLTXCD, TO_CHAR(AP.AUTOID) ID, AP.CRPHYSAGREEID REFID, AP.NO, AP.NAME,
               CASE WHEN CRLOG.AQTTY IS NULL THEN AP.AQTTY ELSE (AP.AQTTY - CRLOG.AQTTY) END REMQTTY,
               CR.CUSTODYCD, CR.ACCTNO, CR.SYMBOL, CR.CODEID
        FROM (SELECT *FROM APPENDIX WHERE DELTD <> ''Y'') AP, CRPHYSAGREE CR,
             (SELECT CRL.APPENDIXID, SUM(CRL.QTTY) AQTTY FROM CRPHYSAGREE_LOG CRL WHERE CRL.TYPE = ''W'' AND CRL.DELTD <> ''Y'' GROUP BY CRL.APPENDIXID) CRLOG
        WHERE AP.AUTOID = CRLOG.APPENDIXID(+)
              AND CR.CRPHYSAGREEID = AP.CRPHYSAGREEID
              AND (CRLOG.AQTTY IS NULL OR AP.AQTTY > CRLOG.AQTTY)
        UNION ALL
        SELECT ''1407'' TLTXCD, CR.CRPHYSAGREEID ID, '''' REFID, CR.NO, CR.NAME,
               CASE WHEN CRLOG.QTTY IS NULL THEN CR.QTTY ELSE (CR.QTTY - CRLOG.QTTY) END REMQTTY,
               CR.CUSTODYCD, CR.ACCTNO, CR.SYMBOL, CR.CODEID
        FROM CRPHYSAGREE CR,
             (SELECT CRL.CRPHYSAGREEID, SUM(CRL.QTTY) QTTY FROM CRPHYSAGREE_LOG CRL WHERE CRL.TYPE = ''W'' AND CRL.DELTD <> ''Y'' GROUP BY CRL.CRPHYSAGREEID) CRLOG
        WHERE CR.CRPHYSAGREEID = CRLOG.CRPHYSAGREEID(+)
              AND (CRLOG.QTTY IS NULL OR CR.QTTY > CRLOG.QTTY)
      ) TMP, ALLCODE A1, CFMAST CF
WHERE A1.CDTYPE = ''AP'' AND A1.CDNAME =''REFTYPE'' AND A1.CDVAL = TMP.TLTXCD
      AND TMP.ACCTNO = CF.CUSTID', 'APPENDIX_CR', '', 'TYPE, ID, REFID', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;