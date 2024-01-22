SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('AMC_LISTS','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('AMC_LISTS', 'Danh sách quỹ', 'List of fund', 'SELECT AUTOID,SHORTNAME,FULLNAME,ROLES,BICCODE,BANKACCTNO,
BANKNAME,BANKCITADCODE,BANKBICCODE, TAXCODE, A0.CDCONTENT STATUS, A2.CDCONTENT
ROLESNAME, ENGLISHNAME, TAXCODEDATE, taxccy, cifno, nationality,
address, ceoname, email, telephone, faxno, incdate, incorporation, language, opendate
FROM FAMEMBERS MST, ALLCODE A0, ALLCODE A2
WHERE MST.STATUS = A0.CDVAL AND A0.CDNAME =''APPRV_STS'' AND A0.CDTYPE=''SY''
AND MST.ROLES = A2.CDVAL AND A2.CDNAME =''FAROLES'' AND A2.CDTYPE=''FA''
AND MST.ROLES=''AMC''', 'AMC_LISTS', '', '', '', 0, 1000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;