SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('DD0003','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('DD0003', 'Theo dõi nợ phí của GCB ', 'Manage GCB charges', 'SELECT *
FROM(
     SELECT Row_number() OVER(ORDER BY ff.autoid, ff.bill, ff.CCYCDCDCONTENT) NO, ff.autoid, ff.bill, ff.shortname, ff.englishname, ff.CCYCDCDCONTENT, sum(ff.feeamt) FEEAMT , ff.email,
            TO_CHAR(ADD_MONTHS(TO_DATE(''20/'' || ff.bill, ''dd/mm/rrrr''), 1), ''dd fmMonth yyyy'') paiddate, ff.shortname gcbname,
            TRIM (TO_CHAR(sum(ff.feeamt), ''9,999,999,999,999,999,999,999.99'')) feeamttxt
     FROM
             (SELECT FM.AUTOID,SUBSTR(TO_CHAR(FE.TXDATE,''DD/MM/RRRR''),4,10) BILL,
             fe.ccycd, fm.shortname, fm.englishname, A1.CDCONTENT CCYCDCDCONTENT, fe.feeamt, fm.EMAIL
             FROM VW_FEETRAN_ALL fe, CFMAST CF, FAMEMBERS FM, ALLCODE A1
             WHERE fe.deltd <> ''Y''
             AND fe.type = ''F''
             AND fe.status IN (''N'', ''A'')
             AND fe.custodycd = cf.custodycd
             AND cf.gcbid = fm.autoid
             AND fm.roles = ''GCB''
             AND A1.CDTYPE=''FA'' AND A1.CDNAME=''CCYCD'' AND fe.ccycd = A1.CDVAL) ff
      GROUP BY AUTOID, BILL,CCYCDCDCONTENT,SHORTNAME, ENGLISHNAME, EMAIL)
WHERE 1 = 1', 'feegcb', 'frmFEEGCB', NULL, NULL, 0, 5000, 'N', 1, 'NNNNYYYNYN', 'Y', 'T', NULL, 'N', NULL);COMMIT;