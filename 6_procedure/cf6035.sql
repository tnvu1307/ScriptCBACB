SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CF6035 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,

   PV_CUSTODYCD         IN       VARCHAR2,
   PV_CONTRACTNUMBER    IN       VARCHAR2
)
IS

-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
   V_INBRID           VARCHAR2 (4);

   V_FROMDATE           DATE;
   V_TODATE           DATE;
   V_CUSTODYCD    varchar2(20);
   V_CONTRACTNUMBER varchar2(20);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN

    V_STROPTION := OPT;
    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID:=BRID;
    END IF;
    ------------------
   V_CUSTODYCD := REPLACE(PV_CUSTODYCD,'.','');   
   IF V_CUSTODYCD IS NULL THEN 
        V_CUSTODYCD :='%';
   END IF;
   -------------------
   V_CONTRACTNUMBER := PV_CONTRACTNUMBER;
   IF V_CONTRACTNUMBER IS NULL THEN 
        V_CONTRACTNUMBER :='%';
   END IF;
   -------------------
   V_FROMDATE := to_date(F_DATE,'DD/MM/YYYY');
   V_TODATE := to_date(T_DATE,'DD/MM/YYYY');


-- GET REPORT'S DATA
OPEN PV_REFCURSOR FOR

    SELECT 
             A.ESCROWID    --MA HD
            ,A.SIGNDATE -- NGAY KY
            ,A.SCUSTID    --MA KH BAN
            ,A.SCUSTODYCD --TK LUU KY KH BAN
            ,A.SFULLNAME  --HO TEN KH BAN
            ,A.SBANKACCOUNT   --SO TK NH
            ,A.BCUSTID    --MA NH MUA
            ,A.BCUSTODYCD --SO LUU KY MUA
            ,A.BFULLNAME  -- HO TEN KH MUA
            ,A.BDDACCTNO_ESCROW -- TK TIEN TIEN ESCROW 
            ,A.BDDACCTNO_IICA --TK TIEN IICA
            ,A.CODEID     --MA CK
            ,A.SYMBOL
            ,A.QTTY   --SL
            ,A.AMT    --GIA TRI
            ,A.SRCACCTNO  --TK NGUON
            ,B.BANKNAME AS BBANKNAME --TEN NGAN HANG BEN MUA
            ,C.REFCASAACCT AS BREFCASAACCT -- SO TK BEN MUA
            ,D.ADDRESS AS SADDRESS  --DIA CHI BEN A
            ,E.ADDRESS AS BADDRESS --DIA CHI BEN B
    FROM ESCROW A
        LEFT JOIN CRBBANKLIST B 
            ON A.BCUSTID=B.CITAD
        LEFT JOIN DDMAST C
            ON C.ACCTNO = (
                            CASE
                                WHEN SUBSTR(A.BCUSTODYCD,4,1) = 'F' THEN BDDACCTNO_IICA
                                ELSE BDDACCTNO_ESCROW
                             END
                          )
        LEFT JOIN CFMAST D
            ON A.SCUSTODYCD = D.CUSTODYCD
        LEFT JOIN CFMAST E
            ON A.BCUSTODYCD = E.CUSTODYCD

    WHERE   SIGNDATE >= V_FROMDATE AND SIGNDATE <= V_TODATE  
            --SIGNDATE >= to_date('25-04-2017','DD/MM/YYYY') AND SIGNDATE <= to_date('25-04-2017','DD/MM/YYYY')
            AND A.SCUSTODYCD LIKE V_CUSTODYCD 
            AND A.ESCROWID LIKE V_CONTRACTNUMBER  
;
 EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END; 
/
