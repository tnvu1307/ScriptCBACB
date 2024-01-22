SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE dd6006 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
   DATE_T         IN       VARCHAR2
)
IS
------------------------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
   V_INBRID           VARCHAR2 (4);
   V_BILL_MONTH        varchar2(6);
   V_CUSTODYCD    varchar2(20);
   V_VND    NUMBER;
   V_CCYCD  VARCHAR2 (4);
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
   -------------------
   V_BILL_MONTH :=REPLACE(DATE_T,'/','');  --phai replace neu ko tren online bi loi
-----------------------------
BEGIN
    SELECT MAX(VND)
    INTO V_VND
    FROM (
          SELECT * FROM EXCHANGERATE UNION ALL SELECT * FROM EXCHANGERATE_HIST
          )
    WHERE (CURRENCY,RTYPE,ITYPE,LASTCHANGE)
                                             IN (
                                                 SELECT CURRENCY,RTYPE,ITYPE,MAX(LASTCHANGE)
                                                 FROM (
                                                        SELECT * FROM EXCHANGERATE UNION ALL SELECT * FROM EXCHANGERATE_HIST
                                                       )
                                                 WHERE TO_CHAR(TRADEDATE,'MMYYYY')=V_BILL_MONTH
                                                       AND RTYPE = 'TTM'
                                                       AND ITYPE = 'SHV'
                                                       AND CURRENCY = 'USD'
                                                 GROUP BY CURRENCY,RTYPE,ITYPE
                                                );
EXCEPTION
    WHEN NO_DATA_FOUND THEN V_VND:=0;
END;
------------CCYCD--------------
BEGIN
SELECT CURRENCY INTO V_CCYCD
  FROM (SELECT *
          FROM     (SELECT *
                      FROM FEE_BOOKING_RESULT
                     WHERE DELTD <> 'Y') FE
               LEFT JOIN
                   CFMAST CF
               ON FE.CIFID = CF.CIFID
         WHERE CF.CUSTODYCD = V_CUSTODYCD
               AND TO_CHAR (FE.TXDATE, 'MMYYYY') = V_BILL_MONTH
        ORDER BY FE.AUTOID)
 WHERE ROWNUM = 1;
 EXCEPTION
    WHEN NO_DATA_FOUND THEN V_CCYCD:='USD';
END;
-- GET REPORT'S DATA
OPEN PV_REFCURSOR FOR
SELECT
             INITCAP(TRIM(TO_CHAR(FE.TXDATE,'MONTH')))|| TO_CHAR(FE.TXDATE,' YYYY') AS MONTH_SUMMARY   --KY TAO BAO CAO
            ,TO_CHAR(FE.TXDATE,'MM/YYYY') AS BILLIN_MONTH    --KY TAO BAO CAO
            ,'20/'||TO_CHAR(ADD_MONTHS(FE.TXDATE,1),'MM/YYYY') DUE_DATE  --THANG DAO HANG TIEP THEO
            ,V_CCYCD CCYCD
            ,CF.FULLNAME    --TEN KHACH HANG
            ,CF.CIFID       -- SO CIF
            ,FE.MCIFID  --MASTER CIFID --TRUNG.LUU: 19-02-2021 SHBVNEX-2067
            ,V_VND AS RATEBCY     --TY GIA NGOAI TE
            ,FE.feecode   -- LOAI PHI
            ,cf.CUSTODYCD   --TK LUU KY
            ---------------------Safe custody fee----------------------CSTD007
            ,DECODE(FE.feecode, 'CSTD007', (CASE WHEN FE.currency  = 'VND' THEN nvl(FE.feeamount,0)+nvl(FE.taxamount,0) ELSE nvl(FE.feeamount,0)+nvl(FE.taxamount,0) END), NULL) AS FEEAMT_SEDEPO --PHI LUU KY CUA THANG TAO BAO CAO
            ---------------------Transaction and repair charge----------------------CSTD005
            ,CASE
                WHEN FE.feecode='CSTD005'  THEN (CASE WHEN FE.currency  = 'VND' THEN nvl(FE.feeamount,0)+nvl(FE.taxamount,0) ELSE nvl(FE.feeamount,0)+nvl(FE.taxamount,0) END)
                ELSE NULL
             END FEE_TRAN       --PHI GIAO DICH--CSTD006
            ,CASE
                WHEN FE.feecode='CSTD006'  THEN (CASE WHEN FE.currency  = 'VND' THEN nvl(FE.feeamount,0)+nvl(FE.taxamount,0) ELSE nvl(FE.feeamount,0)+nvl(FE.taxamount,0) END)
                ELSE NULL
             END FEE_RE         --PHI SUA LOI
            ---------------------Proxy voting---------------------- CSTD008
            ,DECODE(FE.feecode, 'CSTD008', (CASE WHEN FE.currency  = 'VND' THEN nvl(FE.feeamount,0)+nvl(FE.taxamount,0) ELSE nvl(FE.feeamount,0)+nvl(FE.taxamount,0) END), NULL) AS FEEAMT_PROXY  --GIA TRI PHI
            ---------------------STC application----------------------CSTD009
            ,DECODE(FE.feecode, 'CSTD009', (CASE WHEN FE.currency  = 'VND' THEN nvl(FE.feeamount,0)+nvl(FE.taxamount,0) ELSE nvl(FE.feeamount,0)+nvl(FE.taxamount,0) END), NULL) AS FEEAMT_STC      --GIA TRI PHI
            ---------------------Others----------------------CSTD011
            ,DECODE(FE.feecode, 'CSTD011', (CASE WHEN FE.currency  = 'VND' THEN nvl(FE.feeamount,0)+nvl(FE.taxamount,0) ELSE nvl(FE.feeamount,0)+nvl(FE.taxamount,0) END), NULL) AS FEEAMT_OTHERS
    FROM (select *from FEE_BOOKING_RESULT where deltd <>'Y'
            union all
            select *from FEE_BOOKING_RESULTHIST where deltd <>'Y') FE
        LEFT JOIN CFMAST CF
            ON FE.cifid = CF.cifid
    WHERE cf.CUSTODYCD =V_CUSTODYCD --AND FE.CURRENCY= V_CCYCD
    AND TO_CHAR(FE.TXDATE,'MMYYYY')=V_BILL_MONTH
;
 EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
