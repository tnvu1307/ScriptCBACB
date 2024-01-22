SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE "CF0011" (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   TLID            IN       VARCHAR2
)
IS
--
-- PHIEU TINH LAI
-- MODIFICATION HISTORY
-- PERSON         DATE           COMMENTS
-- QUOCTA      16/01/2012      EDIT FOR BVS
-- CHAUNH  27/2/2012  edit date
-- ---------   ------  -------------------------------------------

   V_STROPTION         VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID           VARCHAR2 (4);            -- USED WHEN V_NUMOPTION > 0

   V_FROMDATE          DATE;
   V_TODATE            DATE;
   V_STRCUSTODYCD      VARCHAR2(20);
   V_STRTLID           VARCHAR2(6);

BEGIN

    V_STROPTION := OPT;
     V_STRTLID:= TLID;

    IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
    THEN
         V_STRBRID := BRID;
    ELSE
         V_STRBRID := '%%';
    END IF;

-- GET REPORT'S PARAMETERS
    V_FROMDATE        := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    V_TODATE          := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

    IF (PV_CUSTODYCD <> 'ALL' OR PV_CUSTODYCD <> '' OR PV_CUSTODYCD <> NULL)
    THEN
         V_STRCUSTODYCD    :=    PV_CUSTODYCD;
    ELSE
         V_STRCUSTODYCD    :=    '%';
    END IF;


-- GET REPORT'S DATA
      OPEN PV_REFCURSOR
      FOR
         WITH SEC AS
         (
            SELECT MST.FRDATE INDATE, MST.ACCTNO, MST.INTBAL, MST.INTAMT INTAMT,MST.IRRATE
            FROM (SELECT * FROM DDINTTRAN UNION ALL SELECT * FROM DDINTTRANA) MST
            WHERE MST.TODATE - MST.FRDATE = 1
              AND MST.INTTYPE = 'CR'
            UNION ALL
            SELECT  CLR.SBDATE INDATE, MST.ACCTNO, MST.INTBAL,
              ROUND((MST.INTAMT/(MST.TODATE - MST.FRDATE)),4) INTAMT,MST.IRRATE
            FROM (SELECT * FROM DDINTTRAN UNION ALL SELECT * FROM DDINTTRANA) MST, SBCLDR CLR
            WHERE MST.TODATE - MST.FRDATE > 1
              AND CLR.CLDRTYPE = '000'
              AND MST.FRDATE <= SBDATE AND MST.TODATE > SBDATE
              AND MST.INTTYPE = 'CR'
         )
         SELECT CF.FULLNAME, CF.CUSTODYCD, CF.ADDRESS, 'VND' MNT,
                CIT.INDATE, CIT.IRRATE, CIT.INTBAL,
                CIT.INTAMT, AF.ACCTNO AFACCTNO
         FROM   AFMAST AF, CFMAST CF, SEC CIT
         WHERE  AF.CUSTID        =   CF.CUSTID
         AND    AF.ACCTNO        =   CIT.ACCTNO
         AND    CIT.INDATE >= V_FROMDATE AND  CIT.INDATE <= V_TODATE
         AND    CF.CUSTODYCD     LIKE V_STRCUSTODYCD
         and exists (select gu.grpid from tlgrpusers gu where af.careby = gu.grpid and gu.tlid = V_STRTLID )
         ORDER  BY CIT.INDATE
         ;
 EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
