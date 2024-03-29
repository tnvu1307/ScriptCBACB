SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CR_AP1416','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CR_AP1416', 'Quản lý thông tin hợp đồng ', 'Manage physical subscription agreement ', 'SELECT CR.*, NVL(NH.QTTY_NHAP,0) - NVL(RUT.QTTY_RUT,0) TREMQTTY, 0 CHECKVAL
     , A0.EN_CDCONTENT STATUSCNT
     , A1.EN_CDCONTENT PAYSTATUSCNT
     , A2.EN_CDCONTENT BALANCESTATUSCNT
     , A3.EN_CDCONTENT REPOSSTATUSCNT
     , SB.PARVALUE, SB.INTERESTDATE
     , ISS.FULLNAME ISSUERNAME
     , CF.FULLNAME 
 FROM (SELECT *fROM CRPHYSAGREE WHERE DELTD <> ''Y'') CR,ISSUERS ISS, SBSECURITIES SB, ALLCODE A0, ALLCODE A1,ALLCODE A2,ALLCODE A3, CFMAST CF,
(SELECT CRPHYSAGREEID,SUM(REQTTY)QTTY_NHAP FROM CRPHYSAGREE_LOG WHERE TYPE =''TRADE1404''  GROUP BY CRPHYSAGREEID)NH ,
(SELECT CRPHYSAGREEID,SUM(QTTY)QTTY_RUT FROM CRPHYSAGREE_LOG WHERE TYPE =''RUT1404''  GROUP BY CRPHYSAGREEID)RUT  
WHERE CR.ISSUERID = ISS.ISSUERID 
AND CR.CODEID = SB.CODEID  
AND CR.CRPHYSAGREEID = NH.CRPHYSAGREEID(+)  
AND CR.CRPHYSAGREEID = RUT.CRPHYSAGREEID(+) 
AND CF.CUSTODYCD = CR.CUSTODYCD 
AND A0.CDVAL =CR.STATUS AND A0.CDTYPE=''AP'' AND A0.CDNAME=''STATUS'' 
AND A1.CDVAL =CR.PAYSTATUS AND A1.CDTYPE=''AP'' AND A1.CDNAME=''PAYSTATUS'' 
AND A2.CDVAL =CR.BALANCESTATUS AND A2.CDTYPE=''AP'' AND A2.CDNAME=''BALANCESTATUS'' 
AND A3.CDVAL =CR.REPOSSTATUS AND A3.CDTYPE=''AP'' AND A3.CDNAME=''REPOSSTATUS'' 
AND CR.STATUS = ''A'' 
AND CR.QTTY > CR.REQTTY', 'CR_AP1416', NULL, 'CRPHYSAGREEID DESC', NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;