SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE RMR0069(PV_REFCURSOR  IN OUT PKG_REPORT.REF_CURSOR,
                                    OPT           IN VARCHAR2,
                                    BRID          IN VARCHAR2,
                                    I_DATE        IN VARCHAR2,
                                    I_BRID        IN VARCHAR2,
                                    I_RECUSTODYCD IN VARCHAR2) IS
  ------------------------------------
  -- MODIFICATION HISTORY
  -- BAO CAO QUAN LY MARGIN VA TRA CHAM CHO TUNG MG
  -- PERSON      DATE    COMMENTS
  -- NHA(PHS)   17-DEC-14  CREATED
  -------------------------------------
  V_BRID        VARCHAR2(10);
  V_DATE        DATE;
  V_BRNAME      VARCHAR(50);
  V_RECUSTODYCD VARCHAR(50);
  -- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN

  -- GET REPORT'S PARAMETERS
  -- I_DATE
  V_DATE := TO_DATE(I_DATE, 'dd/MM/yyyy');
  -- T_BRID --
  IF (I_BRID <> 'ALL') THEN
    V_BRID := I_BRID;
  ELSE
    V_BRID := '%';
  END IF;
  -- BRNAME --
  BEGIN
    SELECT BRNAME INTO V_BRNAME FROM BRGRP WHERE BRID = I_BRID;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_BRNAME := 'ALL';
  END;
  -- RECUSTODYCD --
  IF (I_RECUSTODYCD <> 'ALL') THEN
    V_RECUSTODYCD := I_RECUSTODYCD;
  ELSE
    V_RECUSTODYCD := '%';
  END IF;
  -- GET REPORT'S DATA
  OPEN PV_REFCURSOR FOR
select * From dual;
/*
    SELECT TB1.BROKERID,
           TB1.BROKERNAME,
           TB1.BRID,
           BR.BRNAME,
           TB2.MRLOANLIMIT,
           TB1.DPODAMT,
           TB1.MRODAMT,
           (TB1.DPODAMT + TB1.MRODAMT) AS TOTAL_AMT,
           (TB2.MRLOANLIMIT - (TB1.DPODAMT + TB1.MRODAMT)) AS REMAIN_AMT,
           ROUND((((TB1.DPODAMT + TB1.MRODAMT) / TB2.MRLOANLIMIT) * 100), 3) AS RATE
      FROM (
            ---------------------- Du no theo tung loai vay -------------------------
            SELECT CUR.BROKERID,
                    CUR.BROKERNAME,
                    CF.BRID,
                    SUM(DECODE(LNT.LOANTYPE, 'DP', 1, 0) *
                        DECODE(CUR.FTYPE, 'AF', 1, 0) *
                        (CUR.CURRLOAN - (NVL(ARS.CR_AMT, 0) - NVL(DR_AMT, 0)))) DPODAMT,
                    SUM(DECODE(LNT.LOANTYPE, 'CL', 1, 0) *
                        DECODE(CUR.FTYPE, 'AF', 1, 0) *
                        (CUR.CURRLOAN - (NVL(ARS.CR_AMT, 0) - NVL(DR_AMT, 0)))) MRODAMT,
                    SUM(DECODE(LNT.LOANTYPE, 'T0', 1, 0) *
                        DECODE(CUR.FTYPE, 'AF', 1, 0) *
                        (CUR.CURRLOAN - (NVL(ARS.CR_AMT, 0) - NVL(DR_AMT, 0)))) T0ODAMT,
                    SUM(DECODE(CUR.FTYPE, 'DF', 1, 0) *
                        (CUR.CURRLOAN - (NVL(ARS.CR_AMT, 0) - NVL(DR_AMT, 0)))) DFODAMT
              FROM (SELECT LNA.*,
                            RE.CUSTID   AS BROKERID,
                            RE.FULLNAME AS BROKERNAME
                       FROM (SELECT LN.TRFACCTNO,
                                    LN.ACCTNO,
                                    LN.ACTYPE,
                                    LN.FTYPE,
                                    (LN.PRINNML + LN.PRINOVD + LN.INTNMLACR +
                                    LN.INTDUE + LN.INTOVDACR + LN.INTNMLOVD +
                                    LN.FEEINTNMLACR + LN.FEEINTDUE +
                                    LN.FEEINTOVDACR + LN.FEEINTNMLOVD +
                                    LN.OPRINOVD + LN.OPRINNML + LN.OINTNMLOVD +
                                    LN.OINTOVDACR + LN.OINTDUE + LN.OINTNMLACR) CURRLOAN
                               FROM VW_LNMAST_ALL LN) LNA,
                            (SELECT REA.AFACCTNO,
                                    REM.CUSTID,
                                    REA.REACCTNO,
                                    CF.FULLNAME
                               FROM REAFLNK REA, REMAST REM, CFMAST CF
                              WHERE REA.REACCTNO = REM.ACCTNO
                                AND REM.CUSTID = CF.CUSTID) RE
                      WHERE RE.AFACCTNO = LNA.TRFACCTNO) CUR,
                    /*(SELECT TRAN.ACCTNO,
                            SUM(CASE
                                  WHEN TX.TXTYPE = 'C' THEN
                                   TRAN.NAMT
                                  ELSE
                                   0
                                END) CR_AMT,
                            SUM(CASE
                                  WHEN TX.TXTYPE = 'D' THEN
                                   TRAN.NAMT
                                  ELSE
                                   0
                                END) DR_AMT
                       FROM VW_LNTRAN_ALL TRAN, APPTX TX
                      WHERE TRAN.TXCD = TX.TXCD
                        AND TX.APPTYPE = 'LN'
                        AND TX.TBLNAME = 'LNMAST'
                        AND TX.FIELD IN ('PRINNML',
                                         'PRINOVD',
                                         'INTNMLACR',
                                         'INTDUE',
                                         'INTOVDACR',
                                         'INTNMLOVD',
                                         'FEEINTNMLACR',
                                         'FEEINTDUE',
                                         'FEEINTOVDACR',
                                         'FEEINTNMLOVD',
                                         'OPRINOVD',
                                         'OPRINNML',
                                         'OINTNMLOVD',
                                         'OINTOVDACR',
                                         'OINTDUE',
                                         'OINTNMLACR')
                        AND TX.TXTYPE IN ('C', 'D')
                        AND TRAN.DELTD <> 'Y'
                        AND TRAN.TXDATE >= V_DATE
                      GROUP BY TRAN.ACCTNO) ARS,
                    --LNTYPE LNT,
                    (SELECT AF.ACCTNO, CF.CUSTID, CF.BRID
                       FROM CFMAST CF, AFMAST AF, BRGRP BR
                      WHERE CF.CUSTID(+) = AF.CUSTID
                        AND CF.BRID = BR.BRID) CF
             WHERE CUR.ACCTNO = ARS.ACCTNO(+)
               AND CUR.TRFACCTNO = CF.ACCTNO
               AND CUR.ACTYPE = LNT.ACTYPE
               AND CUR.FTYPE IN ('AF', 'DF')
             GROUP BY CUR.BROKERID, CUR.BROKERNAME, CF.BRID) TB1,
           ---------------------- Han muc theo tung moi gioi -------------------------
           (SELECT MRL.CUSTID AS BROKERID,
                   MRL.REACCTNO,
                   MRL.FULLNAME AS BROKERNAME,
                   SUM(MRL.MRLOANLIMIT) AS MRLOANLIMIT
              FROM (SELECT RE.*, CFA.MRLOANLIMIT_IDATE AS MRLOANLIMIT
                      FROM (SELECT AFT.ACCTNO,
                                   (CF.MRLOANLIMIT - SUM(AFT.NAMT)) AS MRLOANLIMIT_IDATE
                              FROM AFTRANA AFT, CFMAST CF
                             WHERE CF.CUSTID = AFT.ACCTNO
                               AND AFT.TLTXCD = '1802'
                               AND AFT.DELTD = 'N'
                               AND AFT.TXDATE >= V_DATE
                             GROUP BY AFT.ACCTNO, CF.MRLOANLIMIT) CFA,
                           (SELECT REA.AFACCTNO,
                                   REM.CUSTID,
                                   REA.REACCTNO,
                                   CF.FULLNAME
                              FROM REAFLNK REA, REMAST REM, CFMAST CF
                             WHERE REA.REACCTNO = REM.ACCTNO
                               AND REM.CUSTID = CF.CUSTID) RE
                     WHERE RE.AFACCTNO = CFA.ACCTNO) MRL
             GROUP BY MRL.CUSTID, MRL.REACCTNO, MRL.FULLNAME) TB2,
           BRGRP BR
     WHERE TB1.BROKERID = TB2.BROKERID
       AND BR.BRID = TB1.BRID
       AND TB1.BRID LIKE V_BRID
       AND TB1.BROKERID LIKE V_RECUSTODYCD;
       */
EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END;
-- PROCEDURE
/
