SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SBSECURITIES_CR','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SBSECURITIES_CR', 'Quản lý chứng khoán_Hợp đồng', 'Securities management_CRPHYSAGREE', 'SELECT SB.CODEID,SB.ISSUERID,ISS.FULLNAME ISSUERNAME,SB.SYMBOL,A0.CDCONTENT SECTYPE,A2.CDCONTENT TRADEPLACE,SB.PARVALUE,SB.FOREIGNRATE
    ,SB.ISSUEDATE,SB.EXPDATE,SB.INTCOUPON, SB.INTERESTDATE
FROM SBSECURITIES SB, ISSUERS ISS,ALLCODE A0, ALLCODE A2
WHERE   A0.CDTYPE = ''SA'' AND A0.CDNAME = ''SECTYPE''AND A0.CDVAL=SECTYPE AND SB.SECTYPE IN (''006'', ''009'',''013'',''003'',''012'')
AND  A2.CDTYPE = ''SA'' AND A2.CDNAME = ''TRADEPLACE'' AND A2.CDVAL= TRADEPLACE
AND SB.ISSUERID = ISS.ISSUERID', 'SBSECURITIES', 'frmSBSECURITIES', '', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;