SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('VW_BACONTRACT','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('VW_BACONTRACT', 'Quản lý hợp đồng', 'Contracts management', 'SELECT * FROM (SELECT DISTINCT 
MST.AUTOID, MST.ISSUESID, ISS.ISSUECODE, A1.EN_CDCONTENT CONTRACTTYPE, MST.CONTRACTNO, MST.CONTRACTDATE, MST.DESCRIPTION 
FROM ISSUER_CONTRACTNO MST, ISSUES ISS, ALLCODE A1 
WHERE   A1.CDTYPE = ''CB''
        AND A1.CDVAL = MST.CONTRACTTYPE
        AND A1.CDNAME = ''CONTRACTTYPE''
        AND ISS.AUTOID = MST.ISSUESID
        AND ISS.ISSUECODE =''<@KEYVALUE>'' 
ORDER BY MST.CONTRACTDATE,MST.CONTRACTNO ) WHERE 0=0 ', 'BA.ISSUER_CONTRACTNO', NULL, NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;