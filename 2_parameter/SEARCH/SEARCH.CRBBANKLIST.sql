SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CRBBANKLIST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CRBBANKLIST', 'Danh sách mã CITAD của ngân hàng', 'CITAD Bank code listing', 'SELECT crb.CITAD, crb.CITAD BANKCODE,crb.BANKACCOUNT, crb.BANKNAME,crb.BRANCHNAME,crb.BANKBICCODE,A1.cdcontent STATUS,
''Y'' EDITALLOW,
(CASE WHEN crb.STATUS IN (''P'') THEN ''Y'' ELSE ''N'' END) APRALLOW,
 ''Y'' AS DELALLOW,
    k.keyword1,k.keyword2,k.keyword3
FROM crbbanklist crb, allcode A1, (select citad, 
    max(case when prioritize=''1'' then  keyword else '''' end) keyword1,
    max(case when prioritize=''2'' then  keyword else '''' end) keyword2,
    max(case when prioritize=''3'' then  keyword else '''' end) keyword3
  from crbbankmapkword group by citad) k
where  0=0
AND A1.CDTYPE=''SY''
AND A1.CDNAME=''APPRV_STS''
AND A1.CDVAL=crb.STATUS
and crb.citad = k.citad(+)', 'CRBBANKLIST', 'frmCRBBANKLIST', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;