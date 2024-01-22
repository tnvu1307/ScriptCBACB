SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE SE0001 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   SYMBOL         IN       VARCHAR2
    )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO TAI KHOAN SE TONG HOP CUA NGUOI DAU TU
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   20-DEC-06  CREATED
-- ---------   ------  -------------------------------------------

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0
   V_STRAFACCTNO  VARCHAR2 (20);
   V_STRSYMBOL    VARCHAR2(20);

BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS
   IF  (SYMBOL <> 'ALL')
   THEN
         V_STRSYMBOL := replace(SYMBOL,' ','_');
   ELSE
      V_STRSYMBOL := '%%';
   END IF;
    -- GET REPORT'S DATA

      OPEN PV_REFCURSOR
       FOR

 SELECT ACC.FULLNAME, ROUND(ACC.TRADE+ACC.SECURED+ACC.BLOCKED-NVL(NUM.AMT,0)) BE_BALANCE,ROUND( NVL(BALANCE.DRAMT,0)) DRAMT,
 ROUND(NVL(BALANCE.CRAMT,0)) CRAMT ,ACC.ACCTNO ,ACC.SYMBOL,ACC.AFACCTNO
FROM
(SELECT  AF.ACCTNO  AFACCTNO,CF.FULLNAME, SE.TRADE,SB.SYMBOL ,SE.ACCTNO ,SE.SECURED,SE.BLOCKED
        FROM AFMAST AF,CFMAST CF,SEMAST SE,SBSECURITIES SB
        WHERE CF.CUSTID =AF.CUSTID
        AND SUBSTR(SE.ACCTNO,1,10) =AF.ACCTNO
        AND SE.STATUS ='A'
        AND SB.CODEID = SE.CODEID
        AND SB.SYMBOL LIKE V_STRSYMBOL
        AND SUBSTR(SE.ACCTNO,1,4) LIKE V_STRBRID
        )ACC
  LEFT JOIN
(  SELECT NVL(SUM(AMT ),0) AMT, ACCTNO
  FROM
 ( SELECT   SUM ((CASE WHEN APP.TXTYPE = 'D'THEN -TR.NAMT WHEN
          APP.TXTYPE = 'C' THEN TR.NAMT ELSE 0  END )) AMT, TR.ACCTNO ACCTNO
          FROM APPTX APP, SETRAN TR, TLLOG TL
          WHERE TR.TXCD = APP.TXCD
               AND TL.TXNUM =TR.TXNUM
               AND APP.APPTYPE = 'SE'
               AND APP.TXTYPE IN ('C', 'D')
               AND TL.DELTD <>'Y'
               AND  TR.NAMT<>0
               AND TL.BUSDATE>=TO_DATE (F_DATE  ,'DD/MM/YYYY')
               AND TRIM (APP.FIELD) IN   ('TRADE','SECURED','BLOCKED')
               GROUP BY  TR.ACCTNO
  UNION ALL
         SELECT   SUM ((CASE WHEN APP.TXTYPE = 'D'THEN -TR.NAMT WHEN
         APP.TXTYPE = 'C' THEN TR.NAMT ELSE 0 END )) AMT, TR.ACCTNO ACCTNO
         FROM APPTX APP, SETRANA TR ,TLLOGALL TL
         WHERE TR.TXCD = APP.TXCD
               AND TL.TXNUM =TR.TXNUM
               AND TL.TXDATE =TR.TXDATE
               AND APP.APPTYPE = 'SE'
               AND APP.TXTYPE IN ('C', 'D')
               AND TL.DELTD <>'Y'
               AND  TR.NAMT<>0
               AND TL.BUSDATE  >=TO_DATE (F_DATE  ,'DD/MM/YYYY')
               AND TRIM (APP.FIELD) IN   ('TRADE','SECURED','BLOCKED')
               GROUP BY  TR.ACCTNO
                )
               GROUP BY ACCTNO
       ) NUM
      ON NUM.ACCTNO= ACC.ACCTNO

      LEFT JOIN
      (
      SELECT     NVL(SUM (DRAMT),0) DRAMT, NVL(SUM (CRAMT),0) CRAMT,ACCTNO
     FROM (


     SELECT   SUM  ((CASE WHEN APP.TXTYPE = 'D'THEN TR.NAMT  ELSE 0  END )) DRAMT,
              SUM  ((CASE WHEN APP.TXTYPE = 'C'THEN TR.NAMT  ELSE 0  END )) CRAMT
              ,TR.ACCTNO ACCTNO
         FROM APPTX APP, SETRAN TR ,TLLOG TL
         WHERE TR.TXCD = APP.TXCD
              AND TL.TXNUM =TR.TXNUM
              AND APP.APPTYPE = 'SE'
              AND APP.TXTYPE IN ('C', 'D')
               AND TRIM (APP.FIELD) IN   ('TRADE','SECURED','BLOCKED')
               AND TL.TLTXCD  IN( '8824' ,'8823', '8868', '8867','8879','8878')
               AND TL.DELTD <>'Y'
               AND  TR.NAMT<>0
               AND TL.BUSDATE >=TO_DATE (F_DATE ,'DD/MM/YYYY')
               AND TL.BUSDATE <=TO_DATE (T_DATE ,'DD/MM/YYYY')
              GROUP BY TR.ACCTNO
    UNION ALL
      SELECT   SUM  ((CASE WHEN APP.TXTYPE = 'D'THEN TR.NAMT  ELSE 0  END )) DRAMT,
               SUM  ((CASE WHEN APP.TXTYPE = 'C'THEN TR.NAMT  ELSE 0  END )) CRAMT
                  ,TR.ACCTNO ACCTNO
         FROM APPTX APP, SETRANA TR,TLLOGALL TL
         WHERE TR.TXCD = APP.TXCD
              AND TL.TXNUM =TR.TXNUM
              AND TL.TXDATE= TR.TXDATE
              AND APP.APPTYPE = 'SE'
              AND APP.TXTYPE IN ('C', 'D')
              AND TRIM (APP.FIELD) IN   ('TRADE','SECURED','BLOCKED')
              AND TL.TLTXCD  IN( '8824' ,'8823', '8868', '8867','8879','8878')
              AND TL.DELTD <>'Y'
               AND  TR.NAMT<>0
               AND TL.BUSDATE >=TO_DATE (F_DATE  ,'DD/MM/YYYY')
               AND TL.BUSDATE <=TO_DATE (T_DATE ,'DD/MM/YYYY')
             GROUP BY TR.ACCTNO
      UNION ALL
         SELECT   SUM  ((CASE WHEN APP.TXTYPE = 'D'THEN TR.NAMT  ELSE 0  END )) DRAMT,
              SUM  ((CASE WHEN APP.TXTYPE = 'C'THEN TR.NAMT  ELSE 0  END )) CRAMT
              ,TR.ACCTNO ACCTNO
         FROM APPTX APP, SETRAN TR ,TLLOG TL
         WHERE TR.TXCD = APP.TXCD
              AND TL.TXNUM =TR.TXNUM
              AND APP.APPTYPE = 'SE'
              AND APP.TXTYPE IN ('C', 'D')
               AND TRIM (APP.FIELD) IN   ('TRADE','SECURED','BLOCKED')
               AND TL.TLTXCD IN ( SELECT  TLTXCD FROM TLTX  WHERE  SUBSTR(TLTXCD,1,2) <> '88'
                    UNION ALL SELECT  TLTXCD FROM TLTX  WHERE  TLTXCD  IN('8878' ,'8879'))
               AND TL.DELTD <>'Y'
               AND  TR.NAMT<>0
               AND TL.BUSDATE >=TO_DATE (F_DATE ,'DD/MM/YYYY')
               AND TL.BUSDATE <=TO_DATE (T_DATE ,'DD/MM/YYYY')
              GROUP BY TR.ACCTNO
    UNION ALL
      SELECT   SUM  ((CASE WHEN APP.TXTYPE = 'D'THEN TR.NAMT  ELSE 0  END )) DRAMT,
               SUM  ((CASE WHEN APP.TXTYPE = 'C'THEN TR.NAMT  ELSE 0  END )) CRAMT
                  ,TR.ACCTNO ACCTNO
         FROM APPTX APP, SETRANA TR,TLLOGALL TL
         WHERE TR.TXCD = APP.TXCD
              AND TL.TXNUM =TR.TXNUM
              AND TL.TXDATE= TR.TXDATE
              AND APP.APPTYPE = 'SE'
              AND APP.TXTYPE IN ('C', 'D')
              AND TRIM (APP.FIELD) IN   ('TRADE','SECURED','BLOCKED')
              AND TL.TLTXCD IN ( SELECT  TLTXCD FROM TLTX  WHERE  SUBSTR(TLTXCD,1,2) <> '88'
                    UNION ALL SELECT  TLTXCD FROM TLTX  WHERE  TLTXCD  IN('8878' ,'8879'))
              AND TL.DELTD <>'Y'
               AND  TR.NAMT<>0
               AND TL.BUSDATE >=TO_DATE (F_DATE  ,'DD/MM/YYYY')
               AND TL.BUSDATE <=TO_DATE (T_DATE ,'DD/MM/YYYY')
             GROUP BY TR.ACCTNO

   )
   GROUP BY ACCTNO ) BALANCE
   ON ACC.ACCTNO =  BALANCE.ACCTNO

  WHERE (ROUND(ACC.TRADE+ACC.SECURED+ACC.BLOCKED-NVL(NUM.AMT,0)) <>0  OR  ROUND( NVL(BALANCE.DRAMT,0)) <> 0 OR ROUND(NVL(BALANCE.CRAMT,0))<>0 )
ORDER BY ACC.ACCTNO;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
/
