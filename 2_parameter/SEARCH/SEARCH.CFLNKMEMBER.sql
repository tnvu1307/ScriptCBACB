SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CFLNKMEMBER','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CFLNKMEMBER', 'Assign member for STC', 'Assign member for STC', 'SELECT MST.MEMBERID, FA.SHORTNAME, FA.FULLNAME MEMBERNAME, CF.CUSTODYCD, CF.FULLNAME, 
        CF.IDCODE, A1.CDCONTENT ROLESNAME
FROM CFLNKMEMBER MST, FAMEMBERS FA, CFMAST CF, ALLCODE A1
WHERE MST.MEMBERID = FA.AUTOID AND MST.CUSTODYCD= CF.CUSTODYCD
      AND FA.ROLES = A1.CDVAL AND A1.CDNAME =''FAROLES'' AND A1.CDTYPE=''FA''
    ', 'CFLNKMEMBER', '', '', '', 0, 1000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;