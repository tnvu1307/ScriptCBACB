SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('FAMEMBERSEXTRA','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('FAMEMBERSEXTRA', 'Thông tin bổ sung', 'Extra infomation', 'SELECT
    MST.AUTOID, MST.MEMBERID, A1.<@CDCONTENT> EXTRACD,
    MST.EXTRAVAL,(CASE WHEN MST.EXTRACD=''B'' THEN MST.EXTRAVAL ELSE '''' END) BROKERNAME , MST.EMAIL,ST.<@CDCONTENT> STATUS,
    (CASE WHEN MST.EXTRACD=''B'' THEN MST.PHONE ELSE MST.EXTRAVAL END) PHONE
FROM FAMEMBERSEXTRA MST, ALLCODE A1 ,
    (SELECT CDVAL VALUECD, CDVAL VALUE, CDCONTENT,
EN_CDCONTENT, EN_CDCONTENT DESCRIPTION, LSTODR
FROM ALLCODE WHERE CDTYPE=''DF'' AND CDNAME=''STATUS'' ORDER
BY LSTODR)ST
WHERE MST.EXTRACD = A1.CDVAL
    AND A1.CDNAME =''FAEXTRACD''
    AND MST.MEMBERID=''<$KEYVAL>''
    AND ST.VALUECD = MST.STATUS
ORDER BY AUTOID', 'FA.FAMEMBERSEXTRA', NULL, NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;