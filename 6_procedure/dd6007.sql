SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE dd6007 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   PV_CUSTODYCD         IN       VARCHAR2,
   DATE_T         IN       VARCHAR2
)
IS
------------------------------------------------------------
   V_STROPTION        VARCHAR2 (200);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (200);        -- USED WHEN V_NUMOPTION > 0
   V_INBRID           VARCHAR2 (200);
   V_BILL_MONTH        VARCHAR2(200);
   V_CUSTODYCD    VARCHAR2(200);
   V_FULLNAME    VARCHAR2(1000);
   V_CIFID    VARCHAR2(200);
   V_AUC    NUMBER;
   V_FEEAMT NUMBER;
   V_TRAN    NUMBER;
   V_RE NUMBER;
   V_VND    NUMBER;
   V_CCYCD  VARCHAR2(3);
   V_MCIFID VARCHAR2(250);
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
   V_BILL_MONTH :=  DATE_T;
----------------EXCHANGERATE-------------
BEGIN
    SELECT MAX(VND) INTO V_VND
    FROM (
          SELECT * FROM EXCHANGERATE
          UNION ALL
          SELECT * FROM EXCHANGERATE_HIST
    )
    WHERE (CURRENCY,RTYPE,ITYPE,LASTCHANGE) IN (
         SELECT CURRENCY,RTYPE,ITYPE,MAX(LASTCHANGE)
         FROM (
                SELECT * FROM EXCHANGERATE
                UNION ALL
                SELECT * FROM EXCHANGERATE_HIST
         )
         WHERE TO_CHAR(TRADEDATE,'MMRRRR')=V_BILL_MONTH
         AND RTYPE = 'TTM'
         AND ITYPE = 'SHV'
         AND CURRENCY = 'USD'
         GROUP BY CURRENCY,RTYPE,ITYPE
    );
EXCEPTION
    WHEN NO_DATA_FOUND THEN V_VND:=0;
END;
----------------CCYCD-------------
BEGIN
   SELECT CCYCD INTO V_CCYCD
   FROM
   (
        SELECT DISTINCT (CASE WHEN OD.SETLDATE IS NULL THEN FE.TXDATE ELSE OD.SETLDATE END) TXDATE, FE.CUSTODYCD, FEEAMT, FE.ORDERID, CCYCD
        FROM (
            SELECT TXDATE,CUSTODYCD,FEEAMT,ORDERID,CCYCD FROM FEETRANDETAIL WHERE FORP ='F' AND CUSTODYCD =V_CUSTODYCD AND REFID NOT IN(SELECT AUTOID FROM FEETRAN WHERE DELTD ='Y') --TRUNG.LUU: SHBVNEX-1540 XOA GD 1293
            UNION ALL
            SELECT TXDATE,CUSTODYCD,FEEAMT,ORDERID,CCYCD FROM FEETRANDETAILHIST WHERE FORP ='F'  AND CUSTODYCD =V_CUSTODYCD AND REFID NOT IN(SELECT AUTOID FROM FEETRANA WHERE DELTD ='Y') --TRUNG.LUU: SHBVNEX-1540 XOA GD 1293
            UNION ALL
            SELECT TXDATE,CUSTODYCD,FEEAMT,ORDERID,CCYCD FROM VW_FEETRAN_ALL  WHERE DELTD <>'Y'  AND CUSTODYCD =V_CUSTODYCD
        )FE LEFT JOIN VW_ODMAST_IMPORT OD ON OD.ORDERID=FE.ORDERID
        WHERE TO_CHAR(CASE WHEN OD.SETLDATE IS NULL THEN FE.TXDATE ELSE OD.SETLDATE END,'MMRRRR') = V_BILL_MONTH
        AND FE.FEEAMT > 0
        ORDER BY TXDATE
    )
    WHERE ROWNUM=1;
EXCEPTION WHEN OTHERS THEN
     V_CCYCD:='USD';
END;
--------------------------------------------
BEGIN
    SELECT   SUM(FEE_TRAN) ,SUM(FEE_RE)
             INTO V_TRAN,V_RE
    FROM
    (
            SELECT CASE WHEN FE.SUBTYPE ='001'THEN (CASE WHEN FT.CCYCD  = 'VND' THEN ROUND(FE.FEEAMT + FT.VATAMT,0) ELSE ROUND(FE.FEEAMT + FT.VATAMT,2)END)
                        ELSE 0
                        END AS FEE_TRAN,       --PHI GIAO DICH
                        CASE WHEN FE.SUBTYPE ='002'THEN (CASE WHEN FT.CCYCD  = 'VND' THEN ROUND(FE.FEEAMT + FT.VATAMT,0) ELSE ROUND(FE.FEEAMT + FT.VATAMT,2)END)
                        ELSE 0
                        END AS FEE_RE         --PHI SUA LOI
            FROM (
                SELECT * FROM FEETRANDETAIL where refid not in(select autoid from feetran where deltd ='Y')
                UNION ALL
                SELECT * FROM FEETRANDETAILHIST where refid not in(select autoid from feetranA where deltd ='Y')
            ) FE
            LEFT JOIN CFMAST CF ON CF.CUSTODYCD= FE.CUSTODYCD
            LEFT JOIN VW_FEETRAN_ALL FT ON FT.AUTOID=FE.REFID
            LEFT JOIN VW_ODMAST_IMPORT OD ON OD.ORDERID=FE.ORDERID
            WHERE FE.FEETYPES ='TRANREPAIR'
            AND FE.FORP ='F'
            AND FE.TXNUM IS NOT NULL
            --AND FE.CCYCD=V_CCYCD
            and FT.deltd <>'Y' --trung.luu: SHBVNEX-1540 xoa gd 1293
            AND TO_CHAR(CASE WHEN OD.SETLDATE IS NULL THEN FE.TXDATE ELSE OD.SETLDATE END,'MMRRRR') = V_BILL_MONTH
            AND CF.CUSTODYCD =V_CUSTODYCD
    );
EXCEPTION WHEN OTHERS THEN
    V_TRAN:= NULL;
    V_RE:= NULL;
END;
---------------------------
--TRUNG.LUU: 19-02-2021 SHBVNEX-2067 LAY CIFID cua tai khoan me

--trung.luu: 18-03-2021 SHBVNEX-2161 khong dung tai khoan me, dung master cifid
BEGIN
    --SELECT CIFID INTO V_MCIFID FROM CFMAST WHERE CUSTODYCD IN (SELECT MCUSTODYCD FROM CFMAST WHERE CUSTODYCD = V_CUSTODYCD);
    --trung.luu: 28-04-2021 SHBVNEX-2161 khong co mastercif thi de null
    SELECT MCIFID INTO V_MCIFID FROM CFMAST WHERE CUSTODYCD = V_CUSTODYCD;
EXCEPTION WHEN OTHERS THEN
    V_MCIFID:= '';
END;
OPEN PV_REFCURSOR FOR
SELECT      INITCAP(TRIM(TO_CHAR(TO_DATE(V_BILL_MONTH,'MMRRRR'),'MONTH'))) || TO_CHAR(TO_DATE(V_BILL_MONTH,'MMRRRR'),' RRRR') MONTH_SUMMARY,
            TO_CHAR(TO_DATE(V_BILL_MONTH,'MMRRRR'),'MM/RRRR') BILLIN_MONTH,DUE_DATE--THANG DAO HANG TIEP THEO
            ,V_CCYCD CCYCD
            ,FULLNAME,FULLNAME_SEDEPO
            ,(CASE WHEN FEEAMT_PROXY IS NULL or FEEAMT_PROXY = 0 then '' else FULLNAME_PROXY end ) FULLNAME_PROXY
            ,(CASE WHEN FEEAMT_STC IS NULL or FEEAMT_STC = 0 then '' else FULLNAME_STC end ) FULLNAME_STC
            ,(CASE WHEN FEEAMT_OTHERS IS NULL or FEEAMT_OTHERS = 0 then '' else FULLNAME_OTHERS end )FULLNAME_OTHERS   --FULL NAME OTHERS
            ,CIFID,V_MCIFID MCIFID,CIFID_SEDEPO
            ,(CASE WHEN FEEAMT_PROXY IS NULL or FEEAMT_PROXY = 0 then '' else CIFID_PROXY end )CIFID_PROXY
            ,(CASE WHEN FEEAMT_STC IS NULL or FEEAMT_STC = 0 then '' else CIFID_STC end ) CIFID_STC
            ,(CASE WHEN FEEAMT_OTHERS IS NULL or FEEAMT_OTHERS = 0 then '' else CIFID_OTHERS end ) CIFID_OTHERS   --CIFID OTHERS
            ,RATEBCY     --TY GIA NGOAI TE
            ,FEETYPES   -- LOAI PHI
            ,CUSTODYCD   --TK LUU KY
            ,SUM_FEE_TRAN
            ,SUM_FEE_RE
            ,ASSET_SEDEPO --TONG GIA TRI TAI SAN LUU KY
            ,FEEAMT_SEDEPO --PHI LUU KY CUA THANG TAO BAO CAO
            ,FEETYPE_PROXY      -- DIEN GIAI GD PHAT SINH PHI
            ,FEEAMT_PROXY  --GIA TRI PHI
            ,FEETYPE_STC  -- DIEN GIAI GD PHAT SINH PHI
            ,FEEAMT_STC      --GIA TRI PHI
            ,FEETYPE_OTHERS
            ,FEEAMT_OTHERS
            ,STT FROM
(
    SELECT
             INITCAP(TRIM(TO_CHAR(FE.TXDATE,'MONTH')))|| TO_CHAR(FE.TXDATE,' RRRR') AS MONTH_SUMMARY   --KY TAO BAO CAO
            ,TO_CHAR(FE.TXDATE,'MM/RRRR') AS BILLIN_MONTH    --KY TAO BAO CAO
            ,'20/'||TO_CHAR(ADD_MONTHS(TO_DATE(V_BILL_MONTH,'MMRRRR'),1),'MM/RRRR') DUE_DATE  --THANG DAO HANG TIEP THEO
            ,CF.FULLNAME
           -- ,V_FULLNAME AS FULLNAME_SEDEPO --FULL NAME SEDEPO
            ,DECODE(FE.FEETYPES, 'SEDEPO', CF.FULLNAME, NULL) AS FULLNAME_SEDEPO --FULL NAME SEDEPO
            ,DECODE(FE.FEETYPES, 'PROXY', CF.FULLNAME, NULL) AS FULLNAME_PROXY --FULL NAME PROXY
            ,DECODE(FE.FEETYPES, 'STC', CF.FULLNAME, NULL) AS FULLNAME_STC --FULL NAME STC
            ,CASE WHEN FE.FEETYPES IN ('OTHER') THEN CF.FULLNAME ELSE NULL END AS FULLNAME_OTHERS   --FULL NAME OTHERS
            ,CF.CIFID,V_MCIFID MCIFID
            ,DECODE(FE.FEETYPES, 'SEDEPO', CF.CIFID, NULL) AS CIFID_SEDEPO --CIFID SEDEPO
            ,DECODE(FE.FEETYPES, 'PROXY', CF.CIFID, NULL) AS CIFID_PROXY --CIFID PROXY
            ,DECODE(FE.FEETYPES, 'STC', CF.CIFID, NULL) AS CIFID_STC --CIFID PROXY
            ,CASE WHEN FE.FEETYPES IN ('OTHER') THEN CF.CIFID ELSE NULL END AS CIFID_OTHERS   --CIFID OTHERS
            ,V_VND AS RATEBCY     --TY GIA NGOAI TE
            ,FE.FEETYPES   -- LOAI PHI
            ,FE.CUSTODYCD   --TK LUU KY
            ---------------------TRAN AND REPARE----------------------
            ,V_TRAN AS SUM_FEE_TRAN
            ,V_RE AS SUM_FEE_RE
            ---------------------Safe custody fee----------------------
            ,DECODE(FE.FEETYPES, 'SEDEPO', FE.TXAMT , NULL) AS ASSET_SEDEPO --TONG GIA TRI TAI SAN LUU KY
            --,V_AUC AS ASSET_SEDEPO --TONG GIA TRI TAI SAN LUU KY
            ,DECODE(FE.FEETYPES, 'SEDEPO', CASE WHEN TL.CCYCD  = 'VND' THEN ROUND(FE.FEEAMT + NVL(TL.VATAMT,0),0) ELSE ROUND(FE.FEEAMT + NVL(TL.VATAMT,0),2) END, NULL) AS FEEAMT_SEDEPO --PHI LUU KY CUA THANG TAO BAO CAO
            --,V_FEEAMT AS FEEAMT_SEDEPO --PHI LUU KY CUA THANG TAO BAO CAO
            ---------------------Proxy voting----------------------
            ,DECODE(FE.FEETYPES, 'PROXY',TL.TRDESC, NULL) AS FEETYPE_PROXY     -- DIEN GIAI GD PHAT SINH PHI
            ,DECODE(FE.FEETYPES, 'PROXY', CASE WHEN TL.CCYCD  = 'VND' THEN ROUND(FE.FEEAMT + NVL(TL.VATAMT,0),0) ELSE ROUND(FE.FEEAMT + NVL(TL.VATAMT,0),2) END, NULL) AS FEEAMT_PROXY  --GIA TRI PHI
            ---------------------STC application----------------------
            ,DECODE(FE.FEETYPES, 'STC', TL.TRDESC, NULL) AS FEETYPE_STC  -- DIEN GIAI GD PHAT SINH PHI
            ,DECODE(FE.FEETYPES, 'STC', CASE WHEN TL.CCYCD  = 'VND' THEN ROUND(FE.FEEAMT + NVL(TL.VATAMT,0),0) ELSE ROUND(FE.FEEAMT + NVL(TL.VATAMT,0),2) END, NULL) AS FEEAMT_STC      --GIA TRI PHI
            ---------------------Others----------------------
            ,DECODE(FE.FEETYPES, 'OTHER', TL.TRDESC, NULL) AS FEETYPE_OTHERS
            ,DECODE(FE.FEETYPES, 'OTHER', CASE WHEN TL.CCYCD  = 'VND' THEN ROUND(FE.FEEAMT + NVL(TL.VATAMT,0),0) ELSE ROUND(FE.FEEAMT + NVL(TL.VATAMT,0),2)END, NULL) AS FEEAMT_OTHERS
            ,ROW_NUMBER() OVER(ORDER BY FE.CUSTODYCD DESC) STT
    FROM (
            SELECT*FROM FEETRANDETAIL where refid not in(select autoid from feetran where deltd ='Y')
            UNION ALL
            SELECT*FROM FEETRANDETAILHIST where refid not in(select autoid from feetrana where deltd ='Y')
    ) FE
    LEFT JOIN CFMAST CF ON FE.CUSTODYCD = CF.CUSTODYCD
    LEFT JOIN VW_FEETRAN_ALL TL ON FE.REFID = TL.AUTOID
    LEFT JOIN VW_ODMAST_IMPORT OD ON OD.ORDERID=FE.ORDERID
    WHERE FE.CUSTODYCD =V_CUSTODYCD
    AND FE.FORP ='F'
    AND FE.SUBTYPE NOT IN ('014','015','003','016')
    --AND FE.CCYCD=V_CCYCD
    and TL.deltd <>'Y' --trung.luu: SHBVNEX-1540 xoa gd 1293
    AND TO_CHAR(CASE WHEN OD.SETLDATE IS NULL THEN FE.TXDATE ELSE OD.SETLDATE END,'MMRRRR') = V_BILL_MONTH

    UNION--------------GET SEDEPO

    SELECT
             INITCAP(TRIM(TO_CHAR(FE.TXDATE,'MONTH')))|| TO_CHAR(FE.TXDATE,' RRRR') AS MONTH_SUMMARY   --KY TAO BAO CAO
            ,TO_CHAR(FE.TXDATE,'MM/RRRR') AS BILLIN_MONTH    --KY TAO BAO CAO
            ,'20/'||TO_CHAR(ADD_MONTHS(TO_DATE(V_BILL_MONTH,'MMRRRR'),1),'MM/RRRR') DUE_DATE  --THANG DAO HANG TIEP THEO
            ,CF.FULLNAME
           -- ,V_FULLNAME AS FULLNAME_SEDEPO --FULL NAME SEDEPO
            ,CF.FULLNAME AS FULLNAME_SEDEPO --FULL NAME SEDEPO
            ,NULL AS FULLNAME_PROXY --FULL NAME PROXY
            ,NULL AS FULLNAME_STC --FULL NAME STC
            ,NULL AS FULLNAME_OTHERS   --FULL NAME OTHERS
            ,CF.CIFID,V_MCIFID MCIFID
            ,CF.CIFID AS CIFID_SEDEPO --CIFID SEDEPO
            ,NULL AS CIFID_PROXY --CIFID PROXY
            ,NULL AS CIFID_STC --CIFID PROXY
            ,NULL AS CIFID_OTHERS   --CIFID OTHERS
            ,V_VND AS RATEBCY     --TY GIA NGOAI TE
            ,NULL FEETYPES   -- LOAI PHI
            ,FE.CUSTODYCD   --TK LUU KY
            ---------------------TRAN AND REPARE----------------------
            ,NULL AS SUM_FEE_TRAN
            ,NULL AS SUM_FEE_RE
            ---------------------Safe custody fee----------------------
            ,0 AS ASSET_SEDEPO --TONG GIA TRI TAI SAN LUU KY
            --,V_AUC AS ASSET_SEDEPO --TONG GIA TRI TAI SAN LUU KY
            ,0 AS FEEAMT_SEDEPO --PHI LUU KY CUA THANG TAO BAO CAO
            --,V_FEEAMT AS FEEAMT_SEDEPO --PHI LUU KY CUA THANG TAO BAO CAO
            ---------------------Proxy voting----------------------
            ,NULL AS FEETYPE_PROXY     -- DIEN GIAI GD PHAT SINH PHI
            ,NULL AS FEEAMT_PROXY  --GIA TRI PHI
            ---------------------STC application----------------------
            ,NULL AS FEETYPE_STC  -- DIEN GIAI GD PHAT SINH PHI
            ,NULL AS FEEAMT_STC      --GIA TRI PHI
            ---------------------Others----------------------
            ,NULL AS FEETYPE_OTHERS
            ,NULL AS FEEAMT_OTHERS
            ,1 AS STT

    FROM (
            SELECT TXDATE,CUSTODYCD,ORDERID,CCYCD FROM FEETRANDETAIL where refid not in(select autoid from feetran where deltd ='Y')  --trung.luu: SHBVNEX-1540 xoa gd 1293
            UNION ALL
            SELECT TXDATE,CUSTODYCD,ORDERID,CCYCD FROM FEETRANDETAILHIST where refid not in(select autoid from feetrana where deltd ='Y')  --trung.luu: SHBVNEX-1540 xoa gd 1293
            UNION ALL
            SELECT TXDATE,CUSTODYCD,ORDERID,CCYCD FROM VW_FEETRAN_ALL where deltd <>'Y' ----trung.luu: SHBVNEX-1540 xoa gd 1293
    ) FE
    LEFT JOIN CFMAST CF ON FE.CUSTODYCD = CF.CUSTODYCD
    LEFT JOIN VW_ODMAST_IMPORT OD ON OD.ORDERID=FE.ORDERID
    WHERE FE.CUSTODYCD =V_CUSTODYCD
    --AND FE.CCYCD=V_CCYCD
    AND TO_CHAR(CASE WHEN OD.SETLDATE IS NULL THEN FE.TXDATE ELSE OD.SETLDATE END,'MMRRRR') = V_BILL_MONTH
    AND NOT EXISTS
    (
        SELECT 1
        FROM (
            SELECT*FROM FEETRANDETAIL where refid not in(select autoid from feetran where deltd ='Y')
            UNION ALL
            SELECT*FROM FEETRANDETAILHIST where refid not in(select autoid from feetrana where deltd ='Y')
        ) FE
        LEFT JOIN CFMAST CF ON FE.CUSTODYCD = CF.CUSTODYCD
        LEFT JOIN VW_FEETRAN_ALL TL ON FE.REFID = TL.AUTOID
        LEFT JOIN VW_ODMAST_IMPORT OD ON OD.ORDERID=FE.ORDERID
        WHERE FE.FEETYPES= 'SEDEPO'
        --AND FE.CCYCD=V_CCYCD
        AND FE.CUSTODYCD =V_CUSTODYCD
        AND FE.FORP ='F'
        and TL.deltd <>'Y' --trung.luu: SHBVNEX-1540 xoa gd 1293
        AND TO_CHAR(CASE WHEN OD.SETLDATE IS NULL THEN FE.TXDATE ELSE OD.SETLDATE END,'MMRRRR') = V_BILL_MONTH
    )

    UNION--------------GET PROXY

    SELECT
             INITCAP(TRIM(TO_CHAR(FE.TXDATE,'MONTH')))|| TO_CHAR(FE.TXDATE,' RRRR') AS MONTH_SUMMARY   --KY TAO BAO CAO
            ,TO_CHAR(FE.TXDATE,'MM/RRRR') AS BILLIN_MONTH    --KY TAO BAO CAO
            ,'20/'||TO_CHAR(ADD_MONTHS(TO_DATE(V_BILL_MONTH,'MMRRRR'),1),'MM/RRRR') DUE_DATE  --THANG DAO HANG TIEP THEO
            ,CF.FULLNAME
            ,NULL AS FULLNAME_SEDEPO --FULL NAME SEDEPO
            ,CF.FULLNAME AS FULLNAME_PROXY --FULL NAME PROXY
            ,NULL AS FULLNAME_STC --FULL NAME STC
            ,NULL AS FULLNAME_OTHERS   --FULL NAME OTHERS
            ,CF.CIFID,V_MCIFID MCIFID
            ,NULL AS CIFID_SEDEPO --CIFID SEDEPO
            ,CF.CIFID AS CIFID_PROXY --CIFID PROXY
            ,NULL AS CIFID_STC --CIFID STC
            ,NULL AS CIFID_OTHERS   --CIFID OTHERS
            ,V_VND AS RATEBCY     --TY GIA NGOAI TE
            ,NULL AS FEETYPES   -- LOAI PHI
            ,FE.CUSTODYCD   --TK LUU KY
            ---------------------TRAN AND REPARE----------------------
            ,V_TRAN AS SUM_FEE_TRAN
            ,V_RE AS SUM_FEE_RE
            ---------------------Safe custody fee----------------------
           -- ,DECODE(FE.FEETYPES, 'SEDEPO', FE1.TXAMT , NULL) AS ASSET_SEDEPO --TONG GIA TRI TAI SAN LUU KY
            ,NULL AS ASSET_SEDEPO --TONG GIA TRI TAI SAN LUU KY
           -- ,DECODE(FE.FEETYPES, 'SEDEPO', FE1.FEEAMT, NULL) AS FEEAMT_SEDEPO --PHI LUU KY CUA THANG TAO BAO CAO
            ,NULL AS FEEAMT_SEDEPO --PHI LUU KY CUA THANG TAO BAO CAO
            ---------------------Proxy voting----------------------
            ,NULL AS FEETYPE_PROXY     -- DIEN GIAI GD PHAT SINH PHI
            ,0 AS FEEAMT_PROXY  --GIA TRI PHI
            ---------------------STC application----------------------
            ,NULL AS FEETYPE_STC  -- DIEN GIAI GD PHAT SINH PHI
            ,NULL AS FEEAMT_STC      --GIA TRI PHI
            ---------------------Others----------------------
            ,NULL AS FEETYPE_OTHERS
            ,NULL AS FEEAMT_OTHERS
            ,2 AS STT

    FROM (
            SELECT TXDATE,CUSTODYCD,ORDERID,CCYCD FROM FEETRANDETAIL where  refid not in(select autoid from feetran where deltd ='Y')  --trung.luu: SHBVNEX-1540 xoa gd 1293
            UNION ALL
            SELECT TXDATE,CUSTODYCD,ORDERID,CCYCD FROM FEETRANDETAILHIST where  refid not in(select autoid from feetrana where deltd ='Y')  --trung.luu: SHBVNEX-1540 xoa gd 1293
            UNION ALL
            SELECT TXDATE,CUSTODYCD,ORDERID,CCYCD FROM VW_FEETRAN_ALL where deltd <>'Y' --trung.luu: SHBVNEX-1540 xoa gd 1293
    ) FE
    LEFT JOIN CFMAST CF ON FE.CUSTODYCD = CF.CUSTODYCD
    LEFT JOIN VW_ODMAST_IMPORT OD ON OD.ORDERID=FE.ORDERID
    WHERE FE.CUSTODYCD =V_CUSTODYCD
    --AND FE.CCYCD=V_CCYCD
    AND TO_CHAR(CASE WHEN OD.SETLDATE IS NULL THEN FE.TXDATE ELSE OD.SETLDATE END,'MMRRRR') = V_BILL_MONTH
    AND NOT EXISTS
    (
        SELECT 1
        FROM (
            SELECT*FROM FEETRANDETAIL where refid not in(select autoid from feetran where deltd ='Y')
            UNION ALL
            SELECT*FROM FEETRANDETAILHIST where refid not in(select autoid from feetrana where deltd ='Y')
        ) FE
        LEFT JOIN CFMAST CF ON FE.CUSTODYCD = CF.CUSTODYCD
        LEFT JOIN VW_FEETRAN_ALL TL ON FE.REFID = TL.AUTOID
        LEFT JOIN VW_ODMAST_IMPORT OD ON OD.ORDERID=FE.ORDERID
        WHERE FE.FEETYPES= 'PROXY'
        --AND FE.CCYCD=V_CCYCD
        AND FE.CUSTODYCD =V_CUSTODYCD
        AND FE.FORP ='F'
        and TL.deltd <>'Y' --trung.luu: SHBVNEX-1540 xoa gd 1293
        AND TO_CHAR(CASE WHEN OD.SETLDATE IS NULL THEN FE.TXDATE ELSE OD.SETLDATE END,'MMRRRR')=V_BILL_MONTH
    )

    UNION--------------GET STC

    SELECT
             INITCAP(TRIM(TO_CHAR(FE.TXDATE,'MONTH')))|| TO_CHAR(FE.TXDATE,' RRRR') AS MONTH_SUMMARY   --KY TAO BAO CAO
            ,TO_CHAR(FE.TXDATE,'MM/RRRR') AS BILLIN_MONTH    --KY TAO BAO CAO
            ,'20/'||TO_CHAR(ADD_MONTHS(TO_DATE(V_BILL_MONTH,'MMRRRR'),1),'MM/RRRR') DUE_DATE  --THANG DAO HANG TIEP THEO
            ,CF.FULLNAME
            ,NULL AS FULLNAME_SEDEPO --FULL NAME SEDEPO
            ,NULL AS FULLNAME_PROXY --FULL NAME PROXY
            ,CF.FULLNAME AS FULLNAME_STC --FULL NAME STC
            ,NULL AS FULLNAME_OTHERS   --FULL NAME OTHERS
            ,CF.CIFID,V_MCIFID MCIFID
            ,NULL AS CIFID_SEDEPO --CIFID SEDEPO
            ,NULL AS CIFID_PROXY --CIFID PROXY
            ,CF.CIFID AS CIFID_STC --CIFID STC
            ,NULL AS CIFID_OTHERS   --CIFID OTHERS
            ,V_VND AS RATEBCY     --TY GIA NGOAI TE
            ,NULL AS FEETYPES   -- LOAI PHI
            ,FE.CUSTODYCD   --TK LUU KY
            ---------------------TRAN AND REPARE----------------------
            ,V_TRAN AS SUM_FEE_TRAN
            ,V_RE AS SUM_FEE_RE
            ---------------------Safe custody fee----------------------
           -- ,DECODE(FE.FEETYPES, 'SEDEPO', FE1.TXAMT , NULL) AS ASSET_SEDEPO --TONG GIA TRI TAI SAN LUU KY
            ,NULL AS ASSET_SEDEPO --TONG GIA TRI TAI SAN LUU KY
           -- ,DECODE(FE.FEETYPES, 'SEDEPO', FE1.FEEAMT, NULL) AS FEEAMT_SEDEPO --PHI LUU KY CUA THANG TAO BAO CAO
            ,NULL AS FEEAMT_SEDEPO --PHI LUU KY CUA THANG TAO BAO CAO
            ---------------------Proxy voting----------------------
            ,NULL AS FEETYPE_PROXY     -- DIEN GIAI GD PHAT SINH PHI
            ,NULL AS FEEAMT_PROXY  --GIA TRI PHI
            ---------------------STC application----------------------
            ,NULL AS FEETYPE_STC  -- DIEN GIAI GD PHAT SINH PHI
            ,0 AS FEEAMT_STC      --GIA TRI PHI
            ---------------------Others----------------------
            ,NULL AS FEETYPE_OTHERS
            ,NULL AS FEEAMT_OTHERS
            ,3 AS STT
    FROM (
            SELECT TXDATE,CUSTODYCD,ORDERID,CCYCD FROM FEETRANDETAIL where  refid not in(select autoid from feetran where deltd ='Y') --trung.luu: SHBVNEX-1540 xoa gd 1293
            UNION ALL
            SELECT TXDATE,CUSTODYCD,ORDERID,CCYCD FROM FEETRANDETAILHIST where  refid not in(select autoid from feetrana where deltd ='Y')  --trung.luu: SHBVNEX-1540 xoa gd 1293
            UNION ALL
            SELECT TXDATE,CUSTODYCD,ORDERID,CCYCD FROM VW_FEETRAN_ALL where deltd <>'Y' --trung.luu: SHBVNEX-1540 xoa gd 1293
    ) FE
    LEFT JOIN CFMAST CF ON FE.CUSTODYCD = CF.CUSTODYCD
    LEFT JOIN VW_ODMAST_IMPORT OD ON OD.ORDERID=FE.ORDERID
    WHERE FE.CUSTODYCD =V_CUSTODYCD
    --AND FE.CCYCD=V_CCYCD
    AND TO_CHAR(CASE WHEN OD.SETLDATE IS NULL THEN FE.TXDATE ELSE OD.SETLDATE END,'MMRRRR') = V_BILL_MONTH
    AND NOT EXISTS
    (
        SELECT 1
        FROM (
            SELECT*FROM FEETRANDETAIL where refid not in(select autoid from feetran where deltd ='Y')
            UNION ALL
            SELECT*FROM FEETRANDETAILHIST where refid not in(select autoid from feetrana where deltd ='Y')
        ) FE
        LEFT JOIN CFMAST CF ON FE.CUSTODYCD = CF.CUSTODYCD
        LEFT JOIN VW_FEETRAN_ALL TL ON FE.REFID = TL.AUTOID
        LEFT JOIN VW_ODMAST_IMPORT OD ON OD.ORDERID=FE.ORDERID
        WHERE FE.FEETYPES= 'STC'
        --AND FE.CCYCD=V_CCYCD
        AND FE.CUSTODYCD =V_CUSTODYCD
        AND FE.FORP ='F'
        and TL.deltd <>'Y' --trung.luu: SHBVNEX-1540 xoa gd 1293
        AND TO_CHAR(CASE WHEN OD.SETLDATE IS NULL THEN FE.TXDATE ELSE OD.SETLDATE END,'MMRRRR')=V_BILL_MONTH
    )

    UNION--------------GET OTHER

    SELECT
             INITCAP(TRIM(TO_CHAR(FE.TXDATE,'MONTH')))|| TO_CHAR(FE.TXDATE,' RRRR') AS MONTH_SUMMARY   --KY TAO BAO CAO
            ,TO_CHAR(FE.TXDATE,'MM/RRRR') AS BILLIN_MONTH    --KY TAO BAO CAO
            ,'20/'||TO_CHAR(ADD_MONTHS(TO_DATE(V_BILL_MONTH,'MMRRRR'),1),'MM/RRRR') DUE_DATE  --THANG DAO HANG TIEP THEO
            ,CF.FULLNAME
            ,NULL AS FULLNAME_SEDEPO --FULL NAME SEDEPO
            ,NULL AS FULLNAME_PROXY --FULL NAME PROXY
            ,NULL AS FULLNAME_STC --FULL NAME STC
            ,CF.FULLNAME AS FULLNAME_OTHERS   --FULL NAME OTHERS
            ,CF.CIFID,V_MCIFID MCIFID
            ,NULL AS CIFID_SEDEPO --CIFID SEDEPO
            ,NULL AS CIFID_PROXY --CIFID PROXY
            ,NULL AS CIFID_STC --CIFID PROXY
            ,CF.CIFID  AS CIFID_OTHERS   --CIFID OTHERS
            ,V_VND AS RATEBCY     --TY GIA NGOAI TE
            ,NULL FEETYPES   -- LOAI PHI
            ,FE.CUSTODYCD   --TK LUU KY
            ---------------------TRAN AND REPARE----------------------
            ,V_TRAN AS SUM_FEE_TRAN
            ,V_RE AS SUM_FEE_RE
            ---------------------Safe custody fee----------------------
           -- ,DECODE(FE.FEETYPES, 'SEDEPO', FE1.TXAMT , NULL) AS ASSET_SEDEPO --TONG GIA TRI TAI SAN LUU KY
            ,NULL AS ASSET_SEDEPO --TONG GIA TRI TAI SAN LUU KY
           -- ,DECODE(FE.FEETYPES, 'SEDEPO', FE1.FEEAMT, NULL) AS FEEAMT_SEDEPO --PHI LUU KY CUA THANG TAO BAO CAO
            ,NULL AS FEEAMT_SEDEPO --PHI LUU KY CUA THANG TAO BAO CAO
            ---------------------Proxy voting----------------------
            ,NULL AS FEETYPE_PROXY     -- DIEN GIAI GD PHAT SINH PHI
            ,NULL AS FEEAMT_PROXY  --GIA TRI PHI
            ---------------------STC application----------------------
            ,NULL AS FEETYPE_STC  -- DIEN GIAI GD PHAT SINH PHI
            ,NULL AS FEEAMT_STC      --GIA TRI PHI
            ---------------------Others----------------------
            ,NULL AS FEETYPE_OTHERS
            ,0 AS FEEAMT_OTHERS
            ,4 AS STT
    FROM (
            SELECT TXDATE,CUSTODYCD,ORDERID,CCYCD FROM FEETRANDETAIL  where  refid not in(select autoid from feetran where deltd ='Y') --trung.luu: SHBVNEX-1540 xoa gd 1293
            UNION ALL
            SELECT TXDATE,CUSTODYCD,ORDERID,CCYCD FROM FEETRANDETAILHIST  where  refid not in(select autoid from feetrana where deltd ='Y')  --trung.luu: SHBVNEX-1540 xoa gd 1293
            UNION ALL
            SELECT TXDATE,CUSTODYCD,ORDERID,CCYCD FROM VW_FEETRAN_ALL where deltd <>'Y'--trung.luu: SHBVNEX-1540 xoa gd 1293
    ) FE
    LEFT JOIN CFMAST CF ON FE.CUSTODYCD = CF.CUSTODYCD
    LEFT JOIN VW_ODMAST_IMPORT OD ON OD.ORDERID=FE.ORDERID
    WHERE FE.CUSTODYCD =V_CUSTODYCD
    --AND FE.CCYCD=V_CCYCD
    AND TO_CHAR(CASE WHEN OD.SETLDATE IS NULL THEN FE.TXDATE ELSE OD.SETLDATE END,'MMRRRR')=V_BILL_MONTH
    AND NOT EXISTS (
        SELECT 1
        FROM (
                SELECT*FROM FEETRANDETAIL where refid not in(select autoid from feetran where deltd ='Y')
                UNION ALL
                SELECT*FROM FEETRANDETAILHIST where refid not in(select autoid from feetrana where deltd ='Y')
        ) FE
        LEFT JOIN CFMAST CF ON FE.CUSTODYCD = CF.CUSTODYCD
        LEFT JOIN VW_FEETRAN_ALL TL ON FE.REFID = TL.AUTOID
        LEFT JOIN VW_ODMAST_IMPORT OD ON OD.ORDERID=FE.ORDERID
        WHERE FE.FEETYPES= 'OTHER'
        --AND FE.CCYCD=V_CCYCD
        AND FE.CUSTODYCD =V_CUSTODYCD
        AND FE.FORP ='F'
        and TL.deltd <>'Y' --trung.luu: SHBVNEX-1540 xoa gd 1293
        AND FE.SUBTYPE NOT IN ('014','015','003','016')
        AND TO_CHAR(CASE WHEN OD.SETLDATE IS NULL THEN FE.TXDATE ELSE OD.SETLDATE END,'MMRRRR')=V_BILL_MONTH
    )
    AND NOT EXISTS (
        SELECT 1
        FROM (select *from VW_FEETRAN_ALL where deltd <>'Y') FE --trung.luu: SHBVNEX-1540 xoa gd 1293
        LEFT JOIN CFMAST CF ON FE.CUSTODYCD = CF.CUSTODYCD
        LEFT JOIN VW_ODMAST_IMPORT OD ON OD.ORDERID=FE.ORDERID
        WHERE FE.FEETYPES ='OTHER'
        --AND FE.CCYCD=V_CCYCD
        AND FE.FEEAMT > 0
        AND FE.SUBTYPE IN ('014','015','003','016')
        AND FE.CUSTODYCD =V_CUSTODYCD
        AND TO_CHAR(CASE WHEN OD.SETLDATE IS NULL THEN FE.TXDATE ELSE OD.SETLDATE END,'MMRRRR') = V_BILL_MONTH
     )

    UNION ALL--------------GET OTHER

    SELECT
             INITCAP(TRIM(TO_CHAR(FE.TXDATE,'MONTH')))|| TO_CHAR(FE.TXDATE,' RRRR') AS MONTH_SUMMARY   --KY TAO BAO CAO
            ,TO_CHAR(FE.TXDATE,'MM/RRRR') AS BILLIN_MONTH    --KY TAO BAO CAO
            ,'20/'||TO_CHAR(ADD_MONTHS(FE.TXDATE,1),'MM/RRRR') DUE_DATE  --THANG DAO HANG TIEP THEO
            ,CF.FULLNAME
            ,NULL AS FULLNAME_SEDEPO --FULL NAME SEDEPO
            ,NULL AS FULLNAME_PROXY --FULL NAME PROXY
            ,NULL AS FULLNAME_STC --FULL NAME STC
            ,CF.FULLNAME AS FULLNAME_OTHERS   --FULL NAME OTHERS
            ,CF.CIFID,V_MCIFID MCIFID
            ,NULL AS CIFID_SEDEPO --CIFID SEDEPO
            ,NULL AS CIFID_PROXY --CIFID PROXY
            ,NULL AS CIFID_STC --CIFID PROXY
            ,CF.CIFID  AS CIFID_OTHERS   --CIFID OTHERS
            ,V_VND AS RATEBCY     --TY GIA NGOAI TE
            ,NULL FEETYPES   -- LOAI PHI
            ,FE.CUSTODYCD   --TK LUU KY
            ---------------------TRAN AND REPARE----------------------
            ,V_TRAN AS SUM_FEE_TRAN
            ,V_RE AS SUM_FEE_RE
            ---------------------Safe custody fee----------------------
           -- ,DECODE(FE.FEETYPES, 'SEDEPO', FE1.TXAMT , NULL) AS ASSET_SEDEPO --TONG GIA TRI TAI SAN LUU KY
            ,NULL AS ASSET_SEDEPO --TONG GIA TRI TAI SAN LUU KY
           -- ,DECODE(FE.FEETYPES, 'SEDEPO', FE1.FEEAMT, NULL) AS FEEAMT_SEDEPO --PHI LUU KY CUA THANG TAO BAO CAO
            ,NULL AS FEEAMT_SEDEPO --PHI LUU KY CUA THANG TAO BAO CAO
            ---------------------Proxy voting----------------------
            ,NULL AS FEETYPE_PROXY     -- DIEN GIAI GD PHAT SINH PHI
            ,NULL AS FEEAMT_PROXY  --GIA TRI PHI
            ---------------------STC application----------------------
            ,NULL AS FEETYPE_STC  -- DIEN GIAI GD PHAT SINH PHI
            ,NULL AS FEEAMT_STC      --GIA TRI PHI
            ---------------------Others----------------------
            ,DECODE(FE.FEETYPES, 'OTHER', FE.TRDESC, NULL) AS FEETYPE_OTHERS
            ,DECODE(FE.FEETYPES, 'OTHER', CASE WHEN FE.CCYCD  = 'VND' THEN ROUND(FE.FEEAMT + FE.VATAMT,0) ELSE ROUND(FE.FEEAMT + FE.VATAMT,2)END, NULL) AS FEEAMT_OTHERS
            ,ROW_NUMBER() OVER(ORDER BY FE.CUSTODYCD DESC) STT
    FROM (select *from VW_FEETRAN_ALL where deltd <>'Y') FE --trung.luu: SHBVNEX-1540 xoa gd 1293
    LEFT JOIN CFMAST CF ON FE.CUSTODYCD = CF.CUSTODYCD
    LEFT JOIN VW_ODMAST_IMPORT OD ON OD.ORDERID=FE.ORDERID
    WHERE FE.FEETYPES ='OTHER'
    --AND FE.CCYCD=V_CCYCD
    AND FE.FEEAMT > 0
    AND FE.SUBTYPE IN ('014','015','003','016')
    AND FE.CUSTODYCD = V_CUSTODYCD
    AND TO_CHAR(CASE WHEN OD.SETLDATE IS NULL THEN FE.TXDATE ELSE OD.SETLDATE END,'MMRRRR') = V_BILL_MONTH
) A /*WHERE  EXISTS (
    SELECT 1
    FROM (
        SELECT TXDATE,CUSTODYCD,FEEAMT,ORDERID,CCYCD FROM FEETRANDETAIL WHERE FORP ='F' and refid not in(select autoid from feetran where deltd = 'Y') --trung.luu: SHBVNEX-1540 xoa gd 1293
        UNION ALL
        SELECT TXDATE,CUSTODYCD,FEEAMT,ORDERID,CCYCD FROM FEETRANDETAILHIST WHERE FORP ='F' and refid not in(select autoid from feetrana where deltd = 'Y') --trung.luu: SHBVNEX-1540 xoa gd 1293
        UNION ALL
        SELECT TXDATE,CUSTODYCD,FEEAMT,ORDERID,CCYCD FROM VW_FEETRAN_ALL  WHERE FEETYPES ='OTHER' AND FEEAMT > 0 AND SUBTYPE IN ('014','015','003','016') and deltd <> 'Y' --trung.luu: SHBVNEX-1540 xoa gd 1293
    )FE
    LEFT JOIN VW_ODMAST_IMPORT OD ON OD.ORDERID=FE.ORDERID
    WHERE FE.CUSTODYCD =V_CUSTODYCD
    --AND FE.CCYCD=V_CCYCD
    AND TO_CHAR(CASE WHEN OD.SETLDATE IS NULL THEN FE.TXDATE ELSE OD.SETLDATE END,'MMYYYY')=V_BILL_MONTH
    GROUP BY FE.CUSTODYCD,FE.TXDATE
    HAVING SUM(FE.FEEAMT) >0
)*/
;
 EXCEPTION
   WHEN OTHERS
   THEN plog.error ('DD6007: ' || SQLERRM || dbms_utility.format_error_backtrace);
   RETURN;
END;
/
