SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE GL0023 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   BANKCODE       IN       VARCHAR2
 )
IS
-- BAO CAO DANH SACH GIAO DICH GL
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   03-MAY-08  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);          -- USED WHEN V_NUMOPTION > 0
   V_STRBANKCODE      VARCHAR2 (30);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS
   

  IF  (BANKCODE <> 'ALL')
   THEN
      V_STRBANKCODE := BANKCODE;
   ELSE
      V_STRBANKCODE := '%%';
   END IF;
   -- END OF GETTING REPORT'S PARAMETERS
OPEN PV_REFCURSOR
        FOR

SELECT DT.BANKCODE , MAX(DT.CUSTID) CUSTID ,MAX(DT.ACCTNO) ACCTNO,MAX(AL.CDCONTENT) CDCONTENT, SUM (DT.GL1141)  NUM1141, SUM(DT.GL1121) NUM1121 FROM
(
SELECT  nvl(GL.DRAMT- GL.CRAMT, 0 ) GL1141, 0 GL1121, BA.BANKCODE, BA.CUSTID , BA.ACCTNO
FROM(
SELECT GL.TXDATE, GL.TXNUM, TL.TXDESC ,(CASE WHEN DORC='D' THEN GL.AMT ELSE 0 END) DRAMT,
    (CASE WHEN DORC='C' THEN GL.AMT ELSE 0 END) CRAMT,GL.DORC,GL.SUBTXNO,GL.ACCTNO,TL.BUSDATE
     FROM GLTRAN GL ,TLLOG TL
     WHERE  TL.TXNUM =GL.TXNUM AND TL.TXDATE =GL.TXDATE AND GL.DELTD <>'Y'
     AND TL.BUSDATE <= TO_DATE (I_DATE  , 'DD/MM/YYYY')
 UNION ALL
 SELECT GL.TXDATE, GL.TXNUM, TL.TXDESC ,(CASE WHEN DORC='D' THEN GL.AMT ELSE 0 END) DRAMT,
     (CASE WHEN DORC='C' THEN GL.AMT ELSE 0 END) CRAMT,GL.DORC,GL.SUBTXNO,GL.ACCTNO,TL.BUSDATE
     FROM GLTRANA GL ,TLLOGALL TL
     WHERE  TL.TXNUM =GL.TXNUM AND TL.TXDATE =GL.TXDATE AND GL.DELTD <>'Y'
     AND TL.BUSDATE < =TO_DATE (I_DATE , 'DD/MM/YYYY')
       )GL, (select * from mitran where DELTD <>'Y') MI , BANKCODE BA
 WHERE GL.TXNUM =MI.TXNUM (+) AND GL.TXDATE =MI.TXDATE (+)
  AND  GL.SUBTXNO =MI.SUBTXNO (+)AND  GL.DORC =MI.DORC (+)
  AND GL.ACCTNO=MI.ACCTNO (+)
  AND MI.CUSTID = BA.CUSTID
  AND SUBSTR(MI.ACCTNO,7,4) = '1141'
  AND BA.BANKCODE LIKE V_STRBANKCODE
UNION ALL
SELECT  0 GL1141,  nvl(GL.DRAMT- GL.CRAMT , 0 ) GL1121, BA.BANKCODE, BA.CUSTID , BA.ACCTNO
FROM
(
SELECT GL.TXDATE, GL.TXNUM, TL.TXDESC ,(CASE WHEN DORC='D' THEN GL.AMT ELSE 0 END) DRAMT,
    (CASE WHEN DORC='C' THEN GL.AMT ELSE 0 END) CRAMT,GL.DORC,GL.SUBTXNO,GL.ACCTNO,TL.BUSDATE
     FROM GLTRAN GL ,TLLOG TL
     WHERE  TL.TXNUM =GL.TXNUM AND TL.TXDATE =GL.TXDATE AND GL.DELTD <>'Y'
     AND TL.BUSDATE <= TO_DATE (I_DATE  , 'DD/MM/YYYY')
 UNION ALL
 SELECT GL.TXDATE, GL.TXNUM, TL.TXDESC ,(CASE WHEN DORC='D' THEN GL.AMT ELSE 0 END) DRAMT,
     (CASE WHEN DORC='C' THEN GL.AMT ELSE 0 END) CRAMT,GL.DORC,GL.SUBTXNO,GL.ACCTNO,TL.BUSDATE
     FROM GLTRANA GL ,TLLOGALL TL
     WHERE  TL.TXNUM =GL.TXNUM AND TL.TXDATE =GL.TXDATE AND GL.DELTD <>'Y'
     AND TL.BUSDATE < =TO_DATE (I_DATE , 'DD/MM/YYYY')
       )GL, (select * from mitran where DELTD <>'Y') MI , BANKCODE BA
 WHERE GL.TXNUM =MI.TXNUM (+) AND GL.TXDATE =MI.TXDATE (+)
  AND  GL.SUBTXNO =MI.SUBTXNO (+)AND  GL.DORC =MI.DORC (+)
  AND GL.ACCTNO=MI.ACCTNO (+)
  AND GL.ACCTNO = BA.ACCTNO
  AND BA.BANKCODE LIKE V_STRBANKCODE
  )DT, ALLCODE AL
  WHERE  DT.BANKCODE =AL.CDVAL
  AND AL.CDNAME ='BANKCODE'
 GROUP BY DT.BANKCODE
order by CUSTID
;

  


 EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
/
