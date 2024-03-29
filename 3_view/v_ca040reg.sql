SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_CA040REG
(AUTOID, CAMASTID, CUSTODYCD, AFACCTNO, CODEID, 
 SYMBOL, FORMOFPAYMENT, REPORTDATE, PQTTY, TRADE, 
 MAXQTTY, AQTTY, QTTY, BEGINDATE, DUEDATE, 
 FULLNAME, ISINCODE, CIFID, EXRATE, ROUNDMETHOD, 
 MCUSTODYCD, VSDID)
AS 
(
    SELECT SCHD.AUTOID, CA.CAMASTID, CF.CUSTODYCD, AF.ACCTNO AFACCTNO, SEC1.CODEID, SEC1.SYMBOL, CA.FORMOFPAYMENT,
    CA.REPORTDATE, SCHD.PQTTY, SCHD.TRADE, (SCHD.AQTTY - SCHD.QTTY) MAXQTTY, SCHD.AQTTY, SCHD.QTTY, CA.BEGINDATE, CA.DUEDATE, CF.FULLNAME,
    CA.ISINCODE, CF.CIFID, CA.EXRATE, CA.ROUNDMETHOD, CF.MCUSTODYCD, CA.VSDID
    FROM CAMAST CA, CASCHD SCHD, CFMAST CF, AFMAST AF, SBSECURITIES SEC1
    WHERE CA.CAMASTID = SCHD.CAMASTID
    AND SCHD.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID
    AND CA.CODEID = SEC1.CODEID
    AND CA.BEGINDATE <= GETCURRDATE
    AND CA.DUEDATE >= GETCURRDATE
    AND CA.CATYPE = '040'
    AND SCHD.STATUS = 'V'
    AND (SCHD.AQTTY - SCHD.QTTY) > 0
    AND SCHD.DELTD = 'N'
 )
/
