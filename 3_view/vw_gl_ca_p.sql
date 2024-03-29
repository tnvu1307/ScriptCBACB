SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_GL_CA_P
(CUSTODYCD, SYMBOL, TRADEPLACE, CADATE, REPORTDATE, 
 ACTIONDATE, DESCRIPTION, CATYPE, RATE, CDCONTENT, 
 CAQTTY, SEQTTY, CIAMT)
AS 
SELECT  CF.custodycd,SB.symbol,SB.tradeplace, get_t_date( cam.reportdate ,2) cadate ,  cam.reportdate,cam.actiondate,CAM.DESCRIPTION,CAM.CATYPE,
(CASE WHEN EXRATE IS NOT NULL THEN EXRATE ELSE (CASE WHEN RIGHTOFFRATE IS NOT NULL
       THEN RIGHTOFFRATE ELSE (CASE WHEN DEVIDENTRATE IS NOT NULL THEN DEVIDENTRATE  ELSE
       (CASE WHEN SPLITRATE IS NOT NULL THEN SPLITRATE ELSE (CASE WHEN INTERESTRATE IS NOT NULL
       THEN INTERESTRATE ELSE
       (CASE WHEN DEVIDENTSHARES IS NOT NULL THEN DEVIDENTSHARES ELSE '0' END)END)END)END) END)END) RATE,AL.cdcontent,CA.BALANCE CAQTTY,
       ca.QTTY SEQTTY ,CA.AMT CIAMT
       
FROM caschd ca,afmast af,cfmast cf ,camast cam,sbsecurities SB, ALLCODE AL 
WHERE ca.afacctno = af.acctno 
AND af.custid = cf.custid
AND SB.codeid = CA.codeid
AND CA.camastid= CAM.camastid
AND AL.cdname='CATYPE'
AND CDTYPE='CA'
AND AL.cdval= CAM.catype 
AND cf.custodycd ='002P000001'
/
