SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CONTRACT_NOSB','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CONTRACT_NOSB', 'Quản lý hợp đồng', 'Contract Management', 'SELECT DISTINCT  SB.CONTRACTNO, SB.CONTRACTDATE, A0.CDCONTENT CONTRACTTYPE
FROM SBSECURITIES SB ,ALLCODE A0
WHERE
      SB.CONTRACTNO IS NOT NULL AND
      A0.CDTYPE = ''CB'' AND
      A0.CDNAME = ''CONTRACTTYPE'' AND
      A0.CDVAL = SB.CONTRACTTYPE', 'CONTRACT_NO', '', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;