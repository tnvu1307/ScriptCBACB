SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('PRMASTER','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('PRMASTER', 'Kiểm soát Pool', 'Pool Master', 'SELECT MST.PRCODE, MST.PRNAME, A0.CDCONTENT PRTYPE, SB.SYMBOL, A1.CDCONTENT RPRSTATUS, MST.PRLIMIT,
        NVL(MST.PRINUSED,0) + NVL(prlog.prinused,0) PRINUSED, NVL(prlog.prinused,0) PRSECURED, GREATEST(MST.PRLIMIT - NVL(MST.PRINUSED,0) - NVL(prlog.prinused,0),0) PRAVLLIMIT, MST.EXPIREDDT,
        (CASE WHEN PRSTATUS IN (''P'') THEN ''Y'' ELSE ''N'' END) APRALLOW,MST.PRSTATUS PRSTATUS
FROM PRMASTER MST,
(SELECT CODEID, SYMBOL FROM SBSECURITIES UNION ALL SELECT CCYCD CODEID, SHORTCD SYMBOL FROM SBCURRENCY) SB,
ALLCODE A0, ALLCODE A1,
(select prcode, sum(prinused) prinused from prinusedlog where deltd <> ''Y'' group by prcode) prlog
WHERE MST.CODEID=SB.CODEID(+) AND A0.CDTYPE=''SY''
     AND A0.CDNAME=''PRTYPE'' AND A0.CDVAL=MST.PRTYP
     AND A1.CDTYPE=''SY'' AND A1.CDNAME=''PRSTATUS'' AND A1.CDVAL=MST.PRSTATUS
     and mst.prcode = prlog.prcode(+) and nvl(ROOMTYP, '' '')<>''SPR''', 'PRMASTER', 'PRCODE', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;