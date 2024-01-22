SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CF0035','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CF0035', 'T?o file excel m? tài kho?n cho h? th?ng VSD', 'Create excel file - list of account opening VSD', 'SELECT ROWNUM AUTOID,CF.FULLNAME,
    (CASE WHEN SUBSTR(CUSTODYCD,4,1) = ''F'' THEN CF.tradingcode ELSE CF.idcode END) idcode,
    (CASE WHEN SUBSTR(CUSTODYCD,4,1) = ''F'' THEN CF.tradingcodedt ELSE CF.IDDATE END) IDDATE, CF.idplace, CF.CUSTODYCD,
    (CASE WHEN CF.IDTYPE = ''001'' THEN ''1''
        WHEN CF.IDTYPE = ''002'' THEN ''2''
        WHEN CF.IDTYPE = ''005'' THEN ''3''
        ELSE ''4'' END) IDTYPE,
    (CASE WHEN CF.CUSTTYPE = ''I'' THEN
            (CASE WHEN SUBSTR(CUSTODYCD,4,1) = ''C'' THEN ''3''
                  WHEN SUBSTR(CUSTODYCD,4,1) = ''F'' THEN ''4'' ELSE ''7'' END)
            ELSE (CASE WHEN SUBSTR(CUSTODYCD,4,1) IN (''C'',''P'') THEN ''5''
                    WHEN SUBSTR(CUSTODYCD,4,1) = ''F'' THEN ''6'' ELSE ''7'' END) END) CUSTTYPE,
    CF.country, CF.address, CF.mobile, CF.email,CF.opndate
FROM cfmast CF
WHERE CF.activests = ''N'' AND CF.ISBANKING <> ''Y'' AND (CF.status = ''A'') AND CF.CUSTODYCD IS NOT NULL and cf.custodycd not like ''OTC%''
AND CF.custatcom = ''Y''', 'CFMAST', 'frmSATLID', '', '', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;