SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SERATIOAF','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SERATIOAF', 'Danh sách tiểu khoản miễn áp dụng', 'Sub account list not apply', 'SELECT S.*,O.fullname, B.DISPLAY STATUSTEXT, CF.FULLNAME CUSTNAME, CF.CUSTODYCD   FROM SERATIOS O,SERATIOAF S,
       AFMAST AF, CFMAST CF,( SELECT  A.CDVAL VALUECD, A.CDVAL VALUE, A.CDCONTENT DISPLAY, A.en_cdcontent EN_DISPLAY, A.CDCONTENT DESCRIPTION FROM ALLCODE A WHERE A.CDTYPE=''RE'' AND A.CDNAME=''STATUS'' AND CDVAL in(''A'',''E'') ORDER BY A.LSTODR) B
WHERE S.STATUS= B.VALUE
AND S.REFAUTOID = O.AUTOID
AND AF.ACCTNO=S.AFACCTNO
AND CF.CUSTID=AF.CUSTID
AND S.REFAUTOID=<$KEYVAL>', 'SA.SERATIOAF', 'frmSERATIOTIERS', '', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;