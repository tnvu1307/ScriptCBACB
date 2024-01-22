SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0093 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   PV_AFACCTNO    IN       VARCHAR2,
   PV_PAIDSTS     IN       VARCHAR2

)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
--
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- Hien.vu
-- ---------   ------  -------------------------------------------
   V_STROPTION          VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID            VARCHAR2 (4);              -- USED WHEN V_NUMOPTION > 0
   V_CUSTODYCD          VARCHAR2(50);
   V_AFACCTNO           VARCHAR2(50);
   V_PAIDSTS            VARCHAR2(50);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
-- insert into temp_bug(text) values('CF0001');commit;
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS
   IF (PV_CUSTODYCD <> 'ALL')
   THEN
      V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
      V_CUSTODYCD := '%%';
   END IF;
     -- GET REPORT'S PARAMETERS
   IF (PV_AFACCTNO <> 'ALL')
   THEN
      V_AFACCTNO := PV_AFACCTNO;
   ELSE
      V_AFACCTNO := '%%';
   END IF;
        -- GET REPORT'S PARAMETERS
   IF (PV_PAIDSTS <> 'ALL')
   THEN
      V_PAIDSTS := PV_PAIDSTS;
   ELSE
      V_PAIDSTS := '%%';
   END IF;

   OPEN PV_REFCURSOR
   FOR
        SELECT * FROM
            (SELECT a.*, PV_CUSTODYCD PV_CUSTODYCD, PV_AFACCTNO PV_AFACCTNO, PV_PAIDSTS PV_PAIDSTS,
            (CASE WHEN (FEEAMT_REMAIN+VATAMT_REMAIN) >0 THEN 'N' ELSE 'Y' END ) PAIDSTS
         FROM
            (
                SELECT SUM(SCHD.FEEAMT)  FEEAMT,SUM(SCHD.VATAMT) VATAMT,
                       SUM(SCHD.PAIDFEEAMT) PAIDFEEAMT, SUM(SCHD.PAIDVATAMT) PAIDVATAMT,
                       SUM(SCHD.FEEAMT)- SUM(SCHD.PAIDFEEAMT) FEEAMT_REMAIN, SUM(SCHD.VATAMT)-SUM(SCHD.PAIDVATAMT) VATAMT_REMAIN,
                       TO_CHar(SCHD.TODATE,'MM/RRRR') TODATE,TO_CHar(SCHD.TODATE,'MM/RRRR')
                FROM VW_SMSFEESCHD_ALL SCHD,
                AFMAST af, CFMAST CF
                WHERE SCHD.AFACCTNO=AF.ACCTNO AND AF.Custid=CF.CUSTID
                    AND CF.CUSTODYCD LIKE V_CUSTODYCD
                    AND SCHD.AFACCTNO LIKE V_AFACCTNO
                    AND SCHD.TXDATE>=TO_DATE(F_DATE,'DD/MM/RRRR')
                    AND SCHD.TXDATE<=TO_DATE(T_DATE,'DD/MM/RRRR')
                    AND SCHD.DELTD <> 'Y'
                GROUP BY TO_CHar(SCHD.TODATE,'MM/RRRR')
            ) A)
        WHERE PAIDSTS LIKE V_PAIDSTS
        ORDER BY TODATE
        ;
 EXCEPTION
   WHEN OTHERS
   THEN
    --insert into temp_bug(text) values('CF0001');commit;
      RETURN;
END;                                                              -- PROCEDURE
 
 
 
/
