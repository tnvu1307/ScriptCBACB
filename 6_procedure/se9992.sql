SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se9992(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
                                   OPT          IN VARCHAR2,
                                   BRID         IN VARCHAR2,
                                   F_DATE       IN VARCHAR2,
                                   T_DATE       IN VARCHAR2,
                                   I_BRID       IN VARCHAR2,
                                   CUSTODYCD    IN VARCHAR2,
                                   AFACCTNO     IN VARCHAR2,
                                   RECUSTODYCD  IN VARCHAR2) IS
  ------------------------------------
  -- MODIFICATION HISTORY
  -- BAO CAO TONG HOP PHI LUU KY DON TICH
  -- PERSON      DATE    COMMENTS
  -- NHANV(PHS)   10-DEC-14  CREATED
  -------------------------------------

  V_STRSYMBOL   VARCHAR2(15);
  V_CUSTODYCD   VARCHAR2(20);
  V_AFACCTNO    VARCHAR2(20);
  V_RECUSTODYCD VARCHAR2(20);
  V_BRID        VARCHAR2(5);
  V_FDATE       DATE;
  V_TDATE       DATE;
  V_CURRDATE    DATE;
  -- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN

  -- GET REPORT'S PARAMETERS

  -- CUSTODYCD --
  IF CUSTODYCD = 'ALL' THEN
    V_CUSTODYCD := '%';
  ELSE
    V_CUSTODYCD := CUSTODYCD;
  END IF;

  -- AFACCTNO --
  IF AFACCTNO = 'ALL' THEN
    V_AFACCTNO := '%';
  ELSE
    V_AFACCTNO := AFACCTNO;
  END IF;

  -- I_BRID --
  IF I_BRID = 'ALL' THEN
    V_BRID := '%';
  ELSE
    V_BRID := I_BRID;
  END IF;

  -- DATE --
  V_FDATE := TO_DATE(F_DATE, 'dd/MM/rrrr');
  V_TDATE := TO_DATE(T_DATE, 'dd/MM/rrrr');
  -- I_RECUSTODYCD --
  IF RECUSTODYCD = 'ALL' THEN
    V_RECUSTODYCD := '%';
  ELSE
    V_RECUSTODYCD := RECUSTODYCD;
  END IF;

  -- GET REPORT'S DATA
  OPEN PV_REFCURSOR FOR
    /*WITH DEPO AS
    (   --SONLT 20150426 lay phi luu ky chi tiet.
        SELECT MST.FRdate TXDATE, MST.ACCTNO, MST.QTTY, MST.AMT AMT, MST.FEERATE
        FROM VW_SEDEPOBAL MST
        WHERE DAYS = 1
            AND DELTD <> 'Y'
            AND FRdate BETWEEN TO_DATE(F_DATE, 'dd/MM/yyyy') AND
                   TO_DATE(T_DATE, 'dd/MM/yyyy')
        UNION ALL
        SELECT  CLR.SBDATE TXDATE, MST.ACCTNO, MST.QTTY,
        ROUND((MST.AMT/DAYS),4) AMT, MST.FEERATE
        FROM VW_SEDEPOBAL MST, SBCLDR CLR
        WHERE DAYS > 1
            AND CLR.CLDRTYPE = '000'
            AND MST.frdate <= SBDATE AND MST.TODATE >= SBDATE
            AND SBDATE BETWEEN TO_DATE(F_DATE, 'dd/MM/yyyy') AND
                   TO_DATE(T_DATE, 'dd/MM/yyyy')
            AND DELTD <> 'Y'
    )*/
    SELECT V_FDATE         AS FDATEREPORT,
           V_TDATE         AS TDATEREPORT,
           AMT.CUSTODYCD, AMT.CUSTID, AMT.AFACCTNO, AMT.AMT,
           NVL(REAF.BRID,AMT.BRID) BRID, AMT.FULLNAME,
           NVL(REAF.BROKERNAME,'CHUA CO MOI GIOI') BROKERNAME
      FROM (SELECT CF.CUSTODYCD,
                   CF.CUSTID,
                   SEM.AFACCTNO AFACCTNO,
                   CF.FULLNAME,
                   CF.BRID,
                   SUM(SED.AMT) AS AMT
              FROM (

                select depo.acctno,
                       round(sum(case  when TO_DATE(F_DATE, 'dd/MM/yyyy') = TO_DATE(T_DATE, 'dd/MM/yyyy') then depo.amt/depo.days
                                WHEN TO_DATE(T_DATE, 'dd/MM/yyyy') - TO_DATE(F_DATE, 'dd/MM/yyyy') < days and depo.txdate<=TO_DATE(F_DATE, 'dd/MM/yyyy') THEN (TO_DATE(T_DATE, 'dd/MM/yyyy') - TO_DATE(F_DATE, 'dd/MM/yyyy') + 1)/depo.days * depo.amt
                                ELSE (CASE when depo.txdate = TO_DATE(T_DATE, 'dd/MM/yyyy') then depo.amt/depo.days
                                    when depo.txdate + depo.days > TO_DATE(T_DATE, 'dd/MM/yyyy') and txdate < TO_DATE(T_DATE, 'dd/MM/yyyy') then (TO_DATE(T_DATE, 'dd/MM/yyyy') - depo.txdate + 1)/depo.days * depo.amt
                                    when depo.txdate < TO_DATE(F_DATE, 'dd/MM/yyyy') and depo.txdate + days > TO_DATE(F_DATE, 'dd/MM/yyyy') then (depo.txdate + depo.days - TO_DATE(F_DATE, 'dd/MM/yyyy'))* depo.amt/depo.days
                                    else depo.amt end)
                            END ),4) amt
                from sedepobal depo
                where depo.deltd <> 'Y' and depo.days <> 0
                      ---and depo.txdate + days > TO_DATE(F_DATE, 'dd/MM/yyyy')
                      ---and depo.txdate <= TO_DATE(T_DATE, 'dd/MM/yyyy')
                group by depo.acctno
              ) SED, SEMAST SEM, AFMAST AF, CFMAST CF
             WHERE SED.ACCTNO = SEM.ACCTNO
               AND SEM.AFACCTNO = AF.ACCTNO
               AND AF.CUSTID = CF.CUSTID
               ---AND CF.CUSTODYCD LIKE V_CUSTODYCD
               ---AND SEM.AFACCTNO LIKE V_AFACCTNO
               --AND CF.BRID LIKE V_BRID
               /*AND (SED.TXDATE BETWEEN TO_DATE(F_DATE, 'dd/MM/yyyy') AND
                   TO_DATE(T_DATE, 'dd/MM/yyyy'))*/
             GROUP BY CF.CUSTODYCD,
                      SEM.AFACCTNO,
                      CF.CUSTID,
                      CF.FULLNAME,
                      CF.BRID
           ) AMT,
           (
            select --rec.autoid, recf.custid , reaf.status, recf.brid
                   recf.autoid, reaf.status,
                   reaf.afacctno CUSTODYCD,
                   recf.brid,
                   cf.custid BROKERID,
                   CF.FULLNAME  AS BROKERNAME
            from recflnk recf, reaflnk reaf, cfmast cf
            where recf.autoid=reaf.refrecflnkid
                  ---and reaf.frdate <= TO_DATE(T_DATE, 'dd/MM/yyyy')
                  ---and nvl(reaf.clstxdate,reaf.todate) > TO_DATE(T_DATE, 'dd/MM/yyyy')
                  ---and recf.effdate <= TO_DATE(T_DATE, 'dd/MM/yyyy')
                  ---and recf.expdate > TO_DATE(T_DATE, 'dd/MM/yyyy')
                  and recf.custid = cf.custid
           /*
           SELECT REA.AFACCTNO AS CUSTODYCD,
                   REM.CUSTID   AS BROKERID,
                   REA.REACCTNO,
                   CF.FULLNAME  AS BROKERNAME,
                   CF.BRID
              FROM recflnk rec, REAFLNK REA, REMAST REM, CFMAST CF
              WHERE CF.CUSTID = REM.CUSTID
                AND REM.ACCTNO = REA.REACCTNO
                and rea.frdate<=p_date and nvl(reaf.clstxdate,reaf.todate) > p_date
                and rec.autoid = rea.refrecflnkid
                AND REA.STATUS='A'
            */
             ) REAF
     WHERE AMT.CUSTID = REAF.CUSTODYCD(+)
           --24/08/2015, TruongLD sua lai, lay theo chi nhanh moi gioi
           ---AND NVL(REAF.BRID,AMT.BRID) LIKE V_BRID
      ---AND NVL(REAF.BROKERID,'NULL') LIKE V_RECUSTODYCD;
  --AND TB2.BROKERID LIKE V_RECUSTODYCD
  ;
EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END;
-- PROCEDURE
/
