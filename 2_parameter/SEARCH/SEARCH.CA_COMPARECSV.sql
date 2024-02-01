SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA_COMPARECSV','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA_COMPARECSV', 'Danh sách file CSV', 'Danh sách file CSV', 'SELECT B.AUTOID, B.FILENAME, B.FILETYPE, B.TIMECREATED, B.TIMEPROCESS, B.STATUS, B.TXDATE, B.VSDCAID, B.REFVSDCAID, A1.CDCONTENT CATYPE, CA.CAMASTID CAMASTID, CA.DESCRIPTION CAMASTDESC, TO_CHAR(B.TIMECREATED,''HH24:MI:SS.'') CREATEDATE
FROM VSDCONTENTLOG B, CAMAST CA, 
(SELECT * FROM ALLCODE WHERE CDNAME = ''CATYPE'' AND CDTYPE = ''CA'') A1, 
(SELECT * FROM ALLCODE WHERE CDNAME = ''CATYPEVSD'' AND CDTYPE = ''CA'') A2
WHERE UPPER(B.FILENAME) LIKE ''%.CSV''
AND B.STATUS = ''C''
AND (INSTR(UPPER(B.FILENAME), ''ASREP'') > 0 OR INSTR(UPPER(B.FILENAME), ''PAREP'') > 0 OR INSTR(UPPER(B.FILENAME), ''CONFREP'') > 0)
AND B.CATYPE = A2.CDCONTENT(+)
AND B.VSDCAID = CA.VSDCAID(+)
AND NVL(A2.CDVAL,''XX'') = A1.CDVAL(+)', 'CA_COMPARECSV', 'frmCAMAST', 'AUTOID DESC', NULL, 0, 50, 'N', 30, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;