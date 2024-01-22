SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE DD6001 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,

   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2

)
IS

-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (40);        -- USED WHEN V_NUMOPTION > 0
   V_INBRID           VARCHAR2 (4);

   V_FROMDATE           DATE;
   V_TODATE           DATE;


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

   V_FROMDATE := to_date(F_DATE,'DD/MM/YYYY');
   V_TODATE := to_date(T_DATE,'DD/MM/YYYY');


-- GET REPORT'S DATA
OPEN PV_REFCURSOR FOR
SELECT  BRAND_NO
        ,TXDATE
        ,CIFID
        ,DR_CR_TYPE
        ,SETTLE_TYPE
        ,FEETYPES
        ,CCYCD
        ,SUM(FEEAMT) FEEAMT
        ,SUM(VATAMT) VATAMT
        ,FEE_BEN_OUR
        ,GLACCTNO
        ,REF_ACCOUNT
        ,REMARK_
FROM (
        SELECT BRAND_NO,TXDATE,FEECD,TXNUM,CIFID,DR_CR_TYPE,SETTLE_TYPE,MAX(FEETYPES)AS FEETYPES,CCYCD,SUM(FEEAMT)AS FEEAMT,SUM(VATAMT)AS VATAMT,FEE_BEN_OUR,GLACCTNO,REF_ACCOUNT,REMARK_
        FROM (
               SELECT


                        A.FEECD
                        ,'8146' AS BRAND_NO
                       ,TO_CHAR(A.TXDATE,'MMYYYY') TXDATE
                       ,A.TXNUM
                       ,B.CIFID --SI CIFID C?A KH
                       ,1 AS DR_CR_TYPE
                       ,55 AS SETTLE_TYPE
                       ,A2.CDCONTENT AS FEETYPES --LOAI PHI
                       ,A.CCYCD    --DON VI TIEN TE
                       ,SUM(A.FEEAMT)AS FEEAMT   --GIA TRI PHI
                       ,SUM(A.VATAMT) AS VATAMT --GIA TRI THUE GIA TRI GIA TANG
                       ,2 AS FEE_BEN_OUR
                       ,A.GLACCTNO -- TAI KHOAN HACH TOAN PHI
                       ,'FEE-'||INITCAP(TRIM(TO_CHAR(A.TXDATE,'MONTH')))||' '||TRIM(TO_CHAR(A.TXDATE,' YYYY')) AS REF_ACCOUNT
                       ,'FEE-'||INITCAP(TRIM(TO_CHAR(A.TXDATE,'MONTH')))||' '||TRIM(TO_CHAR(A.TXDATE,' YYYY')) AS REMARK_
                FROM
                      (
                      SELECT *
                      FROM FEETRANA
                      UNION ALL
                      SELECT *
                      FROM FEETRAN
                      ) A
                     LEFT JOIN ALLCODE A1
                        ON A1.CDNAME = A.FEETYPES AND A.SUBTYPE= A1.CDVAL
                     LEFT JOIN ALLCODE A2
                        ON A1.EN_CDCONTENT = A2.CDVAL
                     LEFT JOIN CFMAST B
                        ON A.CUSTODYCD=B.CUSTODYCD
                --WHERE A.CUSTODYCD in ('SHVB000014','SHVFIC7777')
                WHERE A.TXDATE BETWEEN  V_FROMDATE AND V_TODATE
                GROUP BY A.TXNUM,B.CIFID,A2.CDCONTENT,A.CCYCD,A.GLACCTNO,A.TXDATE,A.FEECD --CUNG TXNUM SUM LAI (GIAO DICH TU DONG)
             )
         GROUP BY BRAND_NO, TXDATE,FEECD,TXNUM,CIFID,DR_CR_TYPE,SETTLE_TYPE,CCYCD,FEE_BEN_OUR,GLACCTNO,REF_ACCOUNT,REMARK_   --CUNG THANG, CUNG FEECD GOM LAI (GIAO DICH MANUAL)
    )
GROUP BY TXDATE,CIFID,FEETYPES,BRAND_NO,DR_CR_TYPE,SETTLE_TYPE,CCYCD,FEE_BEN_OUR,REF_ACCOUNT,REMARK_,GLACCTNO --CUNG 1 THANG, CUNG TK, CUNG FEE TYPES GOM L?I.
ORDER BY CIFID,TXDATE
;
 EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
