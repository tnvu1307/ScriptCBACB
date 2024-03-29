SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CFFEEEXP_1293','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CFFEEEXP_1293', 'Gán biểu phí cho Fund', 'Add fee scheme for Fund', 'SELECT CF.AUTOID,CFM.CIFID, CF.CUSTODYCD,CFM.FULLNAME, FE.REFCODE, FE.SUBTYPE, CF.EFFDATE, CF.EXPDATE, CF.FEEVAL
    , A1.<@CDCONTENT> REFCODECONTENT, A2.<@CDCONTENT> SUBTYPECONTENT, FE.FORP, A3.<@CDCONTENT> FEECALCCNT,FE.feecd
    , CF.FEEVAL FEFAMT
    , CF.VATRATE, A4.<@CDCONTENT> CCYCD
    , CF.FEEAMTVAT,CF.FEERATE,a5.<@CDCONTENT> STATUS,FE.feecode CSTD,cf.minval MINVALUE,cf.maxval MAXVALUE,cf.feecd FEECODE111611,fa.shortname AMCNAME
FROM CFFEEEXP CF, FEEMASTER FE, ALLCODE A1, ALLCODE A2, (select *from ALLCODE where  CDTYPE = ''SA'' AND CDNAME = ''FORP'')  A3, ALLCODE A4,
        (select *from allcode where CDTYPE=''SY'' AND CDNAME=''YESNO'') a5 ,
        (select *from famembers where roles = ''AMC'' and status <> ''C'') fa,cfmast cfm
WHERE CF.FEECD = FE.FEECD
AND CF.DELTD <> ''Y''
AND CF.STATUS = ''N''
AND A1.CDTYPE = ''CF'' AND A1.CDNAME = ''REFCODE'' AND A1.CDVAL = FE.REFCODE
AND A2.CDTYPE = ''SA'' AND A2.CDNAME = A1.CDVAL AND A2.CDVAL = FE.SUBTYPE
AND CF.FORP =A3.CDVAL(+)
and fe.status = a5.cdval
and cf.custodycd = cfm.custodycd
and cfm.amcid = fa.autoid(+)
AND A4.CDTYPE = ''FA'' AND A4.CDNAME = ''CCYCD'' AND A4.CDVAL = CF.CCYCD
AND CF.CUSTODYCD IS NOT NULL
AND CF.CUSTODYCD  = ''<@KEYVALUE>''', 'CFFEEEXP_1293', NULL, NULL, NULL, 0, 1000, 'N', 30, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;