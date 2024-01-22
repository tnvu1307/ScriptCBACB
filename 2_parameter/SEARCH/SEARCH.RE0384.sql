SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RE0384','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RE0384', 'Tra cứu khách hàng để rút khỏi môi giới (Giao dịch 0384)', 'View customer to remove from remiser (0384)', 'SELECT LNK.AUTOID, LNK.REACCTNO, LNK.AFACCTNO, 
LNK.FRDATE, LNK.TODATE, MST.ACTYPE, MST.CUSTID, NVL(TL.TLNAME,'''') RETLNAME, TYP.REROLE, TYP.RETYPE,
CFREREF.FULLNAME REFULLNAME, CFAFREF.FULLNAME AFFULLNAME, CFAFREF.CUSTODYCD, A0.CDCONTENT DESC_REROLE, A1.CDCONTENT DESC_RETYPE
FROM REMAST MST, RETYPE TYP, REAFLNK LNK, CFMAST CFREREF, CFMAST CFAFREF, ALLCODE A0, ALLCODE A1, 
(SELECT   g.*
              FROM   recflnk g, (  SELECT   DISTINCT custid, MAX (autoid) autoid FROM   recflnk GROUP BY   custid) o
              WHERE   g.autoid = o.autoid) RF, 
TLPROFILES TL
WHERE TYP.ACTYPE=MST.ACTYPE AND MST.ACCTNO=LNK.REACCTNO AND CFREREF.CUSTID=MST.CUSTID
AND LNK.AFACCTNO=CFAFREF.CUSTID AND LNK.STATUS=''A''
AND A0.CDTYPE=''RE'' AND A0.CDNAME=''REROLE'' AND A0.CDVAL=TYP.REROLE
AND A1.CDTYPE=''RE'' AND A1.CDNAME=''RETYPE'' AND A1.CDVAL=TYP.RETYPE
AND MST.CUSTID = RF.CUSTID 
AND RF.TLID = TL.TLID(+)
AND (<$BRID> =''0001'' or RF.BRID = <$BRID>)', 'RE.REMAST', '', '', '0384', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;