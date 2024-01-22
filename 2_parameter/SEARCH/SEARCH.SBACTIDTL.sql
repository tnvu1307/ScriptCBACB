SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SBACTIDTL','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SBACTIDTL', 'Lịch sử theo dõi', 'Activity log', 'SELECT * FROM  (SELECT t.refid,
A2.CDCONTENT STATUS,a1.cdcontent actidtltyp,T.NOTES,t.autoid, '''' REFACTICODE,t.actidtltyp actidtltypval, '' '' REFACTICODEDES
FROM  SBACTIDTL T,ALLCODE A1,ALLCODE A2
WHERE A2.CDTYPE = ''SA'' and a2.cdname = ''MSTATUS'' AND a2.cdval = T.STATUS
    AND A1.CDNAME = ''ACTIDTLTYP'' and a1.cdtype = ''FA'' AND a1.cdval = t.actidtltyp
    AND t.actidtltyp =''N''

UNION ALL
SELECT t.refid,A2.CDCONTENT STATUS,a1.cdcontent actidtltyp,T.NOTES,
t.autoid,T.REFACTICODE,t.actidtltyp actidtltypval,
(case when t.actidtltyp = ''A'' then
  (select tlname from tlprofiles where tlid = t.refacticode )
  when t.actidtltyp = ''M'' then
  (select cdcontent FROM ALLCODE  WHERE CDNAME=''SBSTATUS'' AND CDTYPE=''SB'' AND cdval = t.refacticode )
  else '' '' end)   REFACTICODEDES
FROM  SBACTIDTL T,ALLCODE A1,ALLCODE A2
WHERE A2.CDTYPE = ''SA'' and a2.cdname = ''MSTATUS'' AND a2.cdval = T.STATUS
    AND A1.CDNAME = ''ACTIDTLTYP'' and a1.cdtype = ''SB'' AND a1.cdval = t.actidtltyp
    AND t.actidtltyp <>''N'' ORDER BY AUTOID DESC) WHERE 1=1', 'SBACTIDTL', 'frmSBACTIDTL', '', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;