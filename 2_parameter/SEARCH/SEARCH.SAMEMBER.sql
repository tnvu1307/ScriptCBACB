SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SAMEMBER','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SAMEMBER', 'Thanh vien TCPH', 'Issuer members', 'SELECT MST.AUTOID, CD.CDCONTENT MEMBERROLE, MST.FULLNAME, MST.LICENSENO, MST.IDPLACE, MST.IDDATE, MST.IDEXPIRED, MST.CUSTID, MST.DESCRIPTION FROM ISSUER_MEMBER MST, ALLCODE CD WHERE CD.CDTYPE=''SA'' AND CD.CDNAME=''ROLECD'' AND CD.CDVAL=MST.ROLECD AND MST.ISSUERID=''<$KEYVAL>''', 'SA.ISSUER_MEMBER', 'frmISSUER_MEMBER', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;