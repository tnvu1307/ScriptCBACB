SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('BA0008','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('BA0008', 'Giải toả chứng khoán cầm cố không lưu ký', 'Release non depository collateral', 'SELECT SE.AFACCTNO AFACCTNO, SE.ACCTNO ACCTNO, CF.FULLNAME CUSTNAME, CF.CUSTATCOM, CF.CUSTODYCD, SB.SYMBOL,
    SB.PARVALUE, MT.QTTY QTTY, SB.CODEID,
    I1.ISSUERID, ISS.FULLNAME ISSUERNAME, I1.AUTOID ISSUESID, I1.ISSUECODE
FROM (
     SELECT SE.ACCTNO, SE.AFACCTNO, SE.ISSUESID,
     SUM(CASE WHEN SE.TLTXCD IN (''1900'') THEN SE.QTTY
              WHEN SE.TLTXCD IN (''1901'') THEN -SE.QTTY ELSE 0 END) QTTY
     FROM SEMORTAGE SE
     WHERE SE.STATUS IN (''C'')
           AND SE.ISSUESID IS NOT NULL
     GROUP BY SE.ACCTNO, SE.AFACCTNO,SE.ISSUESID
)MT, SEMAST SE, SBSECURITIES SB, AFMAST AF, CFMAST CF, ISSUERS ISS, ISSUES I1
WHERE MT.ACCTNO = SE.ACCTNO
      --AND SE.MORTAGE > 0
      AND SE.CODEID = SB.CODEID
      AND SE.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID AND MT.QTTY > 0
      AND I1.AUTOID = MT.ISSUESID
      AND ISS.ISSUERID = I1.ISSUERID', 'BONDTYPE', '', '', '1901', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;