SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('FAMEMBERSCODE','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('FAMEMBERSCODE', 'Quản lý thành viên', 'Participant management', 'SELECT
AUTOID,SHORTNAME,FULLNAME,ROLES,BICCODE,BANKACCTNO BANKBICCCODE,
BANKNAME,BANKCITADCODE,BANKBICCODE,
        TAXCODE, A0.CDCONTENT STATUS, A2.CDCONTENT
ROLESNAME, ENGLISHNAME, TAXCODEDATE,
        taxccy, cifno, nationality,
address, ceoname, email, telephone, faxno,
        incdate, incorporation, language, opendate,
        (CASE WHEN STATUS IN (''P'') THEN ''Y'' ELSE ''N''
END) APRALLOW
FROM FAMEMBERS MST, ALLCODE A0, ALLCODE A2
WHERE MST.STATUS = A0.CDVAL AND A0.CDNAME =''APPRV_STS''
AND A0.CDTYPE=''SY''
    AND MST.ROLES = A2.CDVAL AND A2.CDNAME =''FAROLES''
AND A2.CDTYPE=''FA''', 'FAMEMBERSCODE', NULL, NULL, NULL, 0, 1000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;