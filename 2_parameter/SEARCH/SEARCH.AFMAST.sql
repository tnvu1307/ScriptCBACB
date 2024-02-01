SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('AFMAST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('AFMAST', 'Quản lý tiểu khoản ', 'Sub account management', 'Select a.*, nvl(LIMITMAX,0)LIMITMAX ,nvl(USERHAVE,0)USERHAVE from
(SELECT FN_GET_LOCATION(af.brid) LOCATION, CF.SHORTNAME, AF.ACTYPE,AFT.TYPENAME ACNAME, (AF.CUSTID) CUSTID,CF.FULLNAME FULLNAME,CF.FULLNAME CUSTNAME,
(CF.CUSTODYCD) CUSTODYCD,
(CF.CUSTODYCD) CUSTODYCD_SRCH,
(AF.ACCTNO) ACCTNO, AF.AFTYPE,A10.CDCONTENT TYPENAME,CF.IDCODE,CF.IDDATE, CF.IDPLACE,  AF.TLID OLDTLID,
AF.BANKACCTNO,AF.SWIFTCODE, A11.CDCONTENT ISOTC, A12.CDCONTENT VIA, AF.LASTDATE, A8.CDCONTENT STATUS,  AF.TLID,
AF.ADVANCELINE,AF.BRATIO,A9.CDCONTENT TERMOFUSE,AF.DESCRIPTION,
GRP.GRPNAME CAREBY, GRP.grpid CAREBYID, CF.REFNAME, AF.corebank,AF.bankname,
AF.MRIRATE,AF.MRMRATE,AF.MRLRATE,AF.MRCRLIMIT,AF.MRCRLIMITMAX,NVL(USF.ACCLIMIT,0) ACCLIMIT,
'''' mrtype, A13.CDCONTENT COUNTRY, (CASE WHEN AF.STATUS IN (''B'',''C'',''N'') THEN ''N'' ELSE ''Y'' END) EDITALLOW, (CASE WHEN AF.STATUS IN (''P'') THEN ''Y'' ELSE ''N'' END) APRALLOW,
''N'' AS DELALLOW,A14.CDCONTENT BRKFEETYPE, AF.ISODDLOT, RE.REFULLNAME
FROM AFMAST AF,CFMAST CF,AFTYPE AFT, TLGROUPS GRP,
ALLCODE A8,ALLCODE A9 ,ALLCODE A10 ,ALLCODE A11,ALLCODE A12, ALLCODE A13,ALLCODE A14,ALLCODE A15,
(SELECT * FROM USERAFLIMIT WHERE  TLIDUSER=''<$TELLERID>'' AND  TYPERECEIVE=''MR'') USF,
(select re.afacctno, MAX(cf.fullname) refullname
    from reaflnk re, sysvar sys, cfmast cf,RETYPE
    where to_date(varvalue,''DD/MM/RRRR'') between re.frdate and re.todate
    and substr(re.reacctno,0,10) = cf.custid
    and varname = ''CURRDATE'' and grname = ''SYSTEM''
    and re.status <> ''C'' and re.deltd <> ''Y''
    AND   substr(re.reacctno,11) = RETYPE.ACTYPE
    AND  rerole IN ( ''RM'',''BM'')
    GROUP BY AFACCTNO
) re
WHERE AF.CUSTID=CF.CUSTID AND AF.ACTYPE=AFT.ACTYPE 
AND AF.ACCTNO =USF.ACCTNO (+)
AND AF.ACCTNO =re.afacctno (+)
AND AF.CAREBY = GRP.GRPID AND GRP.GRPTYPE = ''2''
AND AFT.ACTYPE = AF.ACTYPE
AND A8.CDTYPE = ''CF'' AND A8.CDNAME = ''STATUS'' AND A8.CDVAL = AF.STATUS
AND A9.CDTYPE = ''CF'' AND A9.CDNAME = ''TERMOFUSE'' AND A9.CDVAL = AF.TERMOFUSE
AND A10.CDTYPE = ''CF'' AND A10.CDNAME = ''AFTYPE'' AND A10.CDVAL = AF.AFTYPE
AND A11.CDTYPE = ''SY'' AND A11.CDNAME = ''YESNO'' AND A11.CDVAL= AF.ISOTC
AND A12.CDTYPE = ''CF'' AND A12.CDNAME = ''VIA'' AND A12.CDVAL= AF.VIA
AND A13.CDTYPE = ''CF'' AND A13.CDNAME = ''COUNTRY'' AND A13.CDVAL= CF.COUNTRY
AND A14.CDTYPE = ''CF'' AND A14.CDNAME = ''BRKFEETYPE'' AND A14.CDVAL = AF.BRKFEETYPE
AND A15.CDTYPE = ''SY'' AND A15.CDNAME = ''YESNO'' AND A15.CDVAL= AF.ISODDLOT
AND AF.CAREBY IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>''))a
LEFT JOIN
(Select NVL(US.ACCTLIMIT,0) LIMITMAX,NVL(US.ALLOCATELIMMIT-US.USEDLIMMIT,0) USERHAVE
  from userlimit US where US.tliduser=''<$TELLERID>'') us on 0=0', 'AFMAST', 'frmAFMAST', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;