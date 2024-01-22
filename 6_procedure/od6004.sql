SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE od6004 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,

   F_DATE_PREVIOUS        IN       VARCHAR2, /*Tu ngay bao cao ky truoc*/
   T_DATE_PREVIOUS        IN       VARCHAR2, /*den ngay bao cao ky truoc*/
   F_DATE                 IN       VARCHAR2, /*Tu ngay bao cao ky nay*/
   T_DATE                 IN       VARCHAR2 /*den ngay bao cao ky nay*/
   )
IS

    V_STROPTION         VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID           VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    v_FromDate_Prev     DATE;
    v_ToDate_Prev       DATE;
    v_FromDate          DATE;
    v_ToDate            DATE;
    v_VNDUSD_Prev       NUMBER;
    v_VNDUSD            NUMBER;
    v_CCYCD_INFO        VARCHAR2 (100);
    v_Count             NUMBER;
    v_rate              number;
BEGIN
    V_STROPTION := OPT;
    if V_STROPTION = 'A' then
        V_STRBRID := '%';
    elsif V_STROPTION = 'B' then
        V_STRBRID := substr(BRID,1,2) || '__' ;
    else
        V_STRBRID:= BRID;
    end if;
    V_STRBRID:= '0001';
    v_FromDate_Prev      :=     TO_DATE(F_DATE_PREVIOUS, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate_Prev        :=     TO_DATE(T_DATE_PREVIOUS, SYSTEMNUMS.C_DATE_FORMAT);
    v_FromDate           :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate             :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

     --IN THONG TIN TY GIA RA BAO CAO--------------------------
     SELECT TO_CHAR(v_ToDate,'DD/MM/RRRR')||LISTAGG(TEXT) WITHIN GROUP(ORDER BY CCYCD),max(CCY_VND) INTO v_CCYCD_INFO,v_rate
     FROM (
         SELECT DISTINCT (CASE WHEN EX.FCCYCD ='VND' THEN EX.TCCYCD ELSE EX.FCCYCD END) CCYCD,
                EX.RATE CCY_VND, ', '||(CASE WHEN EX.FCCYCD ='VND' THEN EX.TCCYCD ELSE EX.FCCYCD END)||'/VND '||EX.RATE TEXT
         FROM (
                SELECT DISTINCT
                       DECODE(FX.FCCYCD,'VND',FX.TCCYCD,FX.FCCYCD) FCCYCD --LOAI TIEN CHUYEN
                     , DECODE(FX.FCCYCD,'VND',FX.FCCYCD,FX.TCCYCD) TCCYCD --LOAI TIEN NHAN
                     , EX.VND RATE
                FROM log_od6004 FX --SBFXTRF FX trung.luu: 13-05-2021 SHBVNEX-1680
                                LEFT JOIN (
                                            SELECT A.CURRENCY, A.VND
                                            FROM (
                                                SELECT * FROM EXCHANGERATE
                                                UNION ALL
                                                SELECT * FROM EXCHANGERATE_HIST
                                            ) A,
                                            (
                                                SELECT CURRENCY, MAX(LASTCHANGE) LASTCHANGE
                                                FROM (
                                                    SELECT * FROM EXCHANGERATE
                                                    UNION ALL
                                                    SELECT * FROM EXCHANGERATE_HIST
                                                )
                                                WHERE RTYPE = 'TTM' AND ITYPE = 'SBV' AND TRADEDATE <= v_ToDate --KY NAY
                                                GROUP BY CURRENCY
                                            ) B
                                            WHERE A.CURRENCY = B.CURRENCY
                                            AND A.LASTCHANGE = B.LASTCHANGE
                                       )EX ON (case when fx.tltxcd = '6703' then fx.fccycd
                                                    when fx.tltxcd = '6702' then fx.tccycd  else DECODE(FX.FCCYCD,'VND',FX.TCCYCD,FX.FCCYCD)
                                                 end ) = EX.CURRENCY
                                                --DECODE(FX.FCCYCD,'VND',FX.TCCYCD,FX.FCCYCD) = EX.CURRENCY
                WHERE FX.TXDATE BETWEEN v_FromDate AND v_ToDate --KY NAY
                      AND FX.FCCYCD <> FX.TCCYCD
               ) EX
      );
---------------------------------
--MAIN QUERY---------------------
OPEN PV_REFCURSOR FOR
     WITH RESULTS_PREV AS (
                       SELECT TMP.CUSTODYCD, TMP.CHANGE_TYPE,
                            SUM(TMP.AMOUNT/v_rate) AMT    --trung.luu: 13-05-2021 SHBVNEX-1680
                       FROM (
                                SELECT FX.FRACCOUNT FACCOUNT --TAI KHOAN TIEN TE CHUYEN trung.luu: 13-05-2021 SHBVNEX-1680
                                     , FX.TOACCOUNT TACCOUNT --TAI KHOAN TIEN TE NHAN   trung.luu: 13-05-2021 SHBVNEX-1680
                                     , FX.FCCYCD --LOAI TIEN CHUYEN
                                     , FX.TCCYCD --LOAI TIEN NHAN
                                     , FX.TXDATE --NGAY GIAO DICH
                                     , NVL(FX.AMOUNT,0) AMOUNT--SO TIEN
                                     , 1 RATE --NVL(EX.VND,0) RATE --TY GIA QUY DOI     trung.luu: 13-05-2021 SHBVNEX-1680
                                     , FX.CUSTODYCD --SO TAI KHOAN LUU KY
                                     /*, CASE WHEN FX.FCCYCD <> 'VND' AND FX.TCCYCD = 'VND' THEN 'CCY_VND' ELSE
                                       CASE WHEN FX.FCCYCD = 'VND' AND FX.TCCYCD <> 'VND' THEN 'VND_CCY' ELSE 'OTHER' END END CHANGE_TYPE*/
                                       ,case when fx.tltxcd = '6703' and FCCYCD <> 'VND' then 'CCY_VND' else
                                        case when fx.tltxcd = '6703' and FCCYCD = 'VND' then 'VND_CCY' else
                                        case when fx.tltxcd = '6702' AND TCCYCD = 'VND'  then 'CCY_VND' else
                                        case when fx.tltxcd = '6702' and TCCYCD <> 'VND' then 'VND_CCY' else
                                        CASE WHEN FCCYCD <> 'VND' AND TCCYCD = 'VND' THEN 'CCY_VND' ELSE
                                       CASE WHEN FCCYCD = 'VND' AND TCCYCD <> 'VND' THEN 'VND_CCY' ELSE 'OTHER' END END end end end end CHANGE_TYPE
                                FROM log_od6004 FX --SBFXTRF FX  trung.luu: 13-05-2021 SHBVNEX-1680
                                                LEFT JOIN (
                                                            SELECT A.CURRENCY, A.VND
                                                            FROM (
                                                                SELECT * FROM EXCHANGERATE
                                                                UNION ALL
                                                                SELECT * FROM EXCHANGERATE_HIST
                                                            ) A,
                                                            (
                                                                SELECT CURRENCY, MAX(LASTCHANGE) LASTCHANGE
                                                                FROM (
                                                                    SELECT * FROM EXCHANGERATE
                                                                    UNION ALL
                                                                    SELECT * FROM EXCHANGERATE_HIST
                                                                )
                                                                WHERE RTYPE = 'TTM' AND ITYPE = 'SBV' AND TRADEDATE <= v_ToDate_Prev --KY TRUOC
                                                                GROUP BY CURRENCY
                                                            ) B
                                                            WHERE A.CURRENCY = B.CURRENCY
                                                            AND A.LASTCHANGE = B.LASTCHANGE
                                                       )EX  on (case when fx.tltxcd = '6703' then fx.fccycd
                                                                    when fx.tltxcd = '6702' then fx.tccycd  else DECODE(FX.FCCYCD,'VND',FX.TCCYCD,FX.FCCYCD)
                                                                 end ) = EX.CURRENCY
                                                            --ON DECODE(FX.FCCYCD,'VND',FX.TCCYCD,FX.FCCYCD) = EX.CURRENCY
                                WHERE FX.TXDATE BETWEEN v_FromDate_Prev AND v_ToDate_Prev --KY TRUOC
                            ) TMP
                       WHERE TMP.CHANGE_TYPE IN ('CCY_VND','VND_CCY')
                       GROUP BY TMP.CUSTODYCD, TMP.CHANGE_TYPE
                      )
    , RESULTS_THIS AS (
                       SELECT TMP.CUSTODYCD, TMP.CHANGE_TYPE,
                              SUM(TMP.AMOUNT/v_rate) AMT    --trung.luu: 13-05-2021 SHBVNEX-1680
                       FROM (
                                SELECT FRACCOUNT FACCOUNT --TAI KHOAN TIEN TE CHUYEN   trung.luu: 13-05-2021 SHBVNEX-1680
                                     , TOACCOUNT TACCOUNT --TAI KHOAN TIEN TE NHAN     trung.luu: 13-05-2021 SHBVNEX-1680
                                     , FCCYCD --LOAI TIEN CHUYEN
                                     , TCCYCD --LOAI TIEN NHAN
                                     , TXDATE --NGAY GIAO DICH
                                     , NVL(AMOUNT,0) AMOUNT --SO TIEN
                                     , 1 RATE --NVL(EX.VND,0) RATE --TY GIA QUY DOI    trung.luu: 13-05-2021 SHBVNEX-1680
                                     , AMOUNT EXCAMOUNT --GIA TRI QUY DOI              trung.luu: 13-05-2021 SHBVNEX-1680
                                     , CUSTODYCD --SO TAI KHOAN LUU KY
                                     /*, CASE WHEN FCCYCD <> 'VND' AND TCCYCD = 'VND' THEN 'CCY_VND' ELSE
                                       CASE WHEN FCCYCD = 'VND' AND TCCYCD <> 'VND' THEN 'VND_CCY' ELSE 'OTHER' END END CHANGE_TYPE*/
                                       ,case when fx.tltxcd = '6703' and FCCYCD <> 'VND' then 'CCY_VND' else
                                        case when fx.tltxcd = '6703' and FCCYCD = 'VND' then 'VND_CCY' else
                                        case when fx.tltxcd = '6702' AND TCCYCD = 'VND'  then 'CCY_VND' else
                                        case when fx.tltxcd = '6702' and TCCYCD <> 'VND' then 'VND_CCY' else
                                        CASE WHEN FCCYCD <> 'VND' AND TCCYCD = 'VND' THEN 'CCY_VND' ELSE
                                       CASE WHEN FCCYCD = 'VND' AND TCCYCD <> 'VND' THEN 'VND_CCY' ELSE 'OTHER' END END end end end end CHANGE_TYPE
                                FROM log_od6004 FX --SBFXTRF FX  trung.luu: 13-05-2021 SHBVNEX-1680
                                                LEFT JOIN (
                                                            SELECT A.CURRENCY, A.VND
                                                            FROM (
                                                                SELECT * FROM EXCHANGERATE
                                                                UNION ALL
                                                                SELECT * FROM EXCHANGERATE_HIST
                                                            ) A,
                                                            (
                                                                SELECT CURRENCY, MAX(LASTCHANGE) LASTCHANGE
                                                                FROM (
                                                                    SELECT * FROM EXCHANGERATE
                                                                    UNION ALL
                                                                    SELECT * FROM EXCHANGERATE_HIST
                                                                )
                                                                WHERE RTYPE = 'TTM' AND ITYPE = 'SBV' AND TRADEDATE <= v_ToDate --KY NAY
                                                                GROUP BY CURRENCY
                                                            ) B
                                                            WHERE A.CURRENCY = B.CURRENCY
                                                            AND A.LASTCHANGE = B.LASTCHANGE
                                                       )EX  on (case when fx.tltxcd = '6703' then fx.fccycd
                                                                    when fx.tltxcd = '6702' then fx.tccycd  else DECODE(FX.FCCYCD,'VND',FX.TCCYCD,FX.FCCYCD)
                                                                 end ) = EX.CURRENCY
                                                            --ON DECODE(FX.FCCYCD,'VND',FX.TCCYCD,FX.FCCYCD) = EX.CURRENCY
                                WHERE FX.TXDATE BETWEEN v_FromDate AND v_ToDate --KY NAY
                            ) TMP
                       WHERE TMP.CHANGE_TYPE IN ('CCY_VND','VND_CCY')
                       GROUP BY TMP.CUSTODYCD, TMP.CHANGE_TYPE
                      )
SELECT FULLNAME,
        CUSTTYPE,
        CASE WHEN STT = 1 THEN CUSTTYPE_NAME ELSE '' END CUSTTYPE_NAME,
        ROUND(VND_TO_CCY,15) VND_TO_CCY,
        ROUND(CCY_TO_VND,15) CCY_TO_VND,
        ROUND(CAPITAL_INFLOWS,15) CAPITAL_INFLOWS,
        ROUND(CAPITAL_INFLOWS_PREV,15) CAPITAL_INFLOWS_PREV,
        ROUND(CAPITAL_DIFF,15) CAPITAL_DIFF,
        ROUND(GROWTH_RATE,15) GROWTH_RATE,
        v_CCYCD_INFO CCYCD_INFO
FROM (
    SELECT ROW_NUMBER() OVER (PARTITION BY CF.CUSTTYPE ORDER BY FULLNAME) STT,
           CF.FULLNAME FULLNAME,
           CF.CUSTTYPE CUSTTYPE,
           AL.CDCONTENT CUSTTYPE_NAME,
           NVL(TMP_B.VND_CCY,0) VND_TO_CCY,
           NVL(TMP_B.CCY_VND,0) CCY_TO_VND,
           NVL(TMP_B.CAPITAL_INFLOWS,0) CAPITAL_INFLOWS,
           NVL(TMP_A.CAPITAL_INFLOWS_PREV,0) CAPITAL_INFLOWS_PREV,
           NVL(TMP_B.CAPITAL_INFLOWS,0) - NVL(TMP_A.CAPITAL_INFLOWS_PREV,0) CAPITAL_DIFF,
           CASE WHEN NVL(TMP_A.CAPITAL_INFLOWS_PREV,0) <> 0
                THEN
                ((NVL(TMP_B.CAPITAL_INFLOWS,0)- NVL(TMP_A.CAPITAL_INFLOWS_PREV,0)) / NVL(TMP_A.CAPITAL_INFLOWS_PREV,0))*100
                ELSE 0 END GROWTH_RATE
    FROM (
            SELECT A.CUSTODYCD, NVL(A.CCY_VND,0) - NVL(A.VND_CCY,0) CAPITAL_INFLOWS_PREV
            FROM (
                    SELECT * FROM RESULTS_PREV
                    PIVOT (
                           SUM(AMT)
                           FOR CHANGE_TYPE IN ('CCY_VND' "CCY_VND",'VND_CCY' "VND_CCY")
                          )
                    ORDER BY CUSTODYCD
                 ) A
         ) TMP_A
        FULL JOIN
        (
        SELECT B.CUSTODYCD, NVL(B.CCY_VND,0) CCY_VND, NVL(B.VND_CCY,0) VND_CCY, NVL(B.CCY_VND,0) - NVL(B.VND_CCY,0) CAPITAL_INFLOWS
        FROM (
                SELECT * FROM RESULTS_THIS
                PIVOT (
                       SUM(AMT)
                       FOR CHANGE_TYPE IN ('CCY_VND' "CCY_VND",'VND_CCY' "VND_CCY")
                      )
                ORDER BY CUSTODYCD
             ) B
        )
        TMP_B ON TMP_A.CUSTODYCD = TMP_B.CUSTODYCD
        JOIN CFMAST CF ON CF.CUSTODYCD = (CASE WHEN TMP_A.CUSTODYCD IS NULL THEN TMP_B.CUSTODYCD ELSE TMP_A.CUSTODYCD END)
             --AND CF.IDTYPE ='009'
             --AND CF.CUSTATCOM ='Y'
        JOIN ALLCODE AL ON AL.CDNAME = 'CUSTTYPE' AND AL.CDTYPE ='CF' AND AL.CDVAL = CF.CUSTTYPE
    ORDER BY CF.CUSTTYPE, CF.FULLNAME
    );
EXCEPTION

  WHEN OTHERS
   THEN
   DBMS_OUTPUT.PUT_LINE('OD6004 ERROR');
   
      RETURN;
END;
/
