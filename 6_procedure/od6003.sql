SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE od6003 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE_PREVIOUS        IN       VARCHAR2, /*Tu ngay bao cao ky truoc*/
   T_DATE_PREVIOUS        IN       VARCHAR2, /*den ngay bao cao ky truoc*/
   F_DATE                 IN       VARCHAR2, /*Tu ngay bao cao ky nay*/
   T_DATE                 IN       VARCHAR2 /*den ngay bao cao ky nay*/
   )
IS
    -- Bao cao thong ke danh mcc luu ky cua nha dau tu nuoc ngoai(II)
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- NAM.LY      02-11-2019           created
    -- NAM.LY      10-11-2019           last updated
    V_STROPTION         VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID           VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    v_FromDate_Previous date;
    v_ToDate_Previous   date;
    v_FromDate          date;
    v_ToDate            date;
    v_CCYCD_INFO        VARCHAR2 (100);
    V_USD               NUMBER;
    V_USD_PREV          NUMBER;
BEGIN
    V_STROPTION := OPT;
    if V_STROPTION = 'A' then
        V_STRBRID := '%';
    elsif V_STROPTION = 'B' then
        V_STRBRID := substr(BRID,1,2) || '__' ;
    else
        V_STRBRID:= BRID;
    end if;
    v_FromDate_Previous      :=     TO_DATE(F_DATE_PREVIOUS, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate_Previous        :=     TO_DATE(T_DATE_PREVIOUS, SYSTEMNUMS.C_DATE_FORMAT);
    v_FromDate               :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate                 :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    -- LAY THONG TIN TI GIA DE IN RA BAO CAO
    SELECT TO_CHAR(v_ToDate,'DD/MM/RRRR')||LISTAGG(TEXT) WITHIN GROUP(ORDER BY CCYCD) INTO v_CCYCD_INFO
    FROM (
        SELECT DD.CCYCD, DD.VND CCY_VND, ', '||DD.CCYCD||'/VND '|| UTILS.SO_THANH_CHU2(NVL(DD.VND,0)) TEXT
        FROM (
            SELECT DD.CCYCD, EX.VND, NVL(SUM(DD.BALANCE*(CASE WHEN DD.CCYCD <> 'VND' THEN EX.VND ELSE 1 END) - NVL(TR.NAMT,0) * (CASE WHEN DD.CCYCD <> 'VND' THEN EX.VND ELSE 1 END)),0) QTTY
            FROM DDMAST DD
            LEFT JOIN (
                 SELECT ACCTNO, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                 FROM VW_DDTRAN_GEN
                 WHERE FIELD IN ('BALANCE') AND BUSDATE > v_ToDate --KY TRUOC
                 GROUP BY ACCTNO
            ) TR ON DD.ACCTNO = TR.ACCTNO
            LEFT JOIN  (
                SELECT CURRENCY, VND
                FROM (SELECT * FROM EXCHANGERATE UNION ALL SELECT * FROM EXCHANGERATE_HIST)
                WHERE (CURRENCY, RTYPE, ITYPE, LASTCHANGE) IN (
                    SELECT CURRENCY, RTYPE, ITYPE, MAX(LASTCHANGE)
                    FROM (SELECT * FROM EXCHANGERATE UNION ALL SELECT * FROM EXCHANGERATE_HIST)
                    WHERE (CURRENCY, RTYPE, ITYPE, TRADEDATE) IN (
                        SELECT CURRENCY, RTYPE, ITYPE, MAX(TRADEDATE)
                        FROM (SELECT * FROM EXCHANGERATE UNION ALL SELECT * FROM EXCHANGERATE_HIST)
                        WHERE TRADEDATE <= v_ToDate
                        AND RTYPE = 'TTM'
                        AND ITYPE = 'SBV'
                        AND CURRENCY = 'USD'
                        GROUP BY CURRENCY, RTYPE, ITYPE
                    )
                    GROUP BY CURRENCY, RTYPE, ITYPE
                )
            ) EX ON EX.CURRENCY = DD.CCYCD
            GROUP BY DD.CCYCD, EX.VND
        ) DD
        WHERE DD.QTTY > 0 AND DD.CCYCD <> 'VND'
     );
    --

    -------------------TI GIA KY NAY------------------------------------------------
BEGIN
    SELECT VND INTO V_USD
    FROM (SELECT * FROM EXCHANGERATE UNION ALL SELECT * FROM EXCHANGERATE_HIST)
    WHERE (CURRENCY, RTYPE, ITYPE, LASTCHANGE) IN (
        SELECT CURRENCY, RTYPE, ITYPE, MAX(LASTCHANGE)
        FROM (SELECT * FROM EXCHANGERATE UNION ALL SELECT * FROM EXCHANGERATE_HIST)
        WHERE (CURRENCY, RTYPE, ITYPE, TRADEDATE) IN (
            SELECT CURRENCY, RTYPE, ITYPE, MAX(TRADEDATE)
            FROM (SELECT * FROM EXCHANGERATE UNION ALL SELECT * FROM EXCHANGERATE_HIST)
            WHERE TRADEDATE <= v_ToDate
            AND RTYPE = 'TTM'
            AND ITYPE = 'SBV'
            AND CURRENCY = 'USD'
            GROUP BY CURRENCY, RTYPE, ITYPE
        )
        GROUP BY CURRENCY, RTYPE, ITYPE
    );
EXCEPTION WHEN NO_DATA_FOUND THEN
    V_USD := 1;
END;
-------------------TI GIA KY TRUOC------------------------------------------------
BEGIN
    SELECT VND INTO V_USD_PREV
    FROM (SELECT * FROM EXCHANGERATE UNION ALL SELECT * FROM EXCHANGERATE_HIST)
    WHERE (CURRENCY, RTYPE, ITYPE, LASTCHANGE) IN (
        SELECT CURRENCY, RTYPE, ITYPE, MAX(LASTCHANGE)
        FROM (SELECT * FROM EXCHANGERATE UNION ALL SELECT * FROM EXCHANGERATE_HIST)
        WHERE (CURRENCY, RTYPE, ITYPE, TRADEDATE) IN (
            SELECT CURRENCY, RTYPE, ITYPE, MAX(TRADEDATE)
            FROM (SELECT * FROM EXCHANGERATE UNION ALL SELECT * FROM EXCHANGERATE_HIST)
            WHERE TRADEDATE <= v_ToDate_Previous
            AND RTYPE = 'TTM'
            AND ITYPE = 'SBV'
            AND CURRENCY = 'USD'
            GROUP BY CURRENCY, RTYPE, ITYPE
        )
        GROUP BY CURRENCY, RTYPE, ITYPE
    );
EXCEPTION WHEN NO_DATA_FOUND THEN
    V_USD_PREV := 1;
END;

    --MAIN QUERY
    OPEN PV_REFCURSOR FOR
        WITH TMP_SB AS ( --BANG TAM SB
                        SELECT SB.CODEID, SB.SECTYPE, SB.SYMBOL, SB1.CODEID REFCODEID, SB1.SYMBOL REFSYMBOL, SB.EXPDATE, SB.PARVALUE, SB.CCYCD
                              , (CASE WHEN SB.REFCODEID IS NULL THEN SB.TRADEPLACE ELSE SB1.TRADEPLACE END) TRADEPLACE
                        FROM SBSECURITIES SB, SBSECURITIES SB1
                        WHERE SB.REFCODEID = SB1.CODEID(+) AND SB.SECTYPE <> '004'
                      )
                , TMP_TR_PREV AS ( --BANG TEMP TR_PREV
                         SELECT CUSTODYCD, ACCTNO, SYMBOL, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                         FROM VW_SETRAN_GEN
                         WHERE FIELD IN ('TRADE','HOLD','MORTAGE','NETTING','BLOCKED','WITHDRAW','BLOCKWITHDRAW','EMKQTTY') AND BUSDATE > v_ToDate_Previous --KY TRUOC
                         GROUP BY CUSTODYCD, ACCTNO, SYMBOL
                       )
                , TMP_TR AS ( --BANG TEMP TR
                         SELECT CUSTODYCD, ACCTNO, SYMBOL, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                         FROM VW_SETRAN_GEN
                         WHERE FIELD IN ('TRADE','HOLD','MORTAGE','NETTING','BLOCKED','WITHDRAW','BLOCKWITHDRAW','EMKQTTY') AND BUSDATE > v_ToDate --KY NAY
                         GROUP BY CUSTODYCD, ACCTNO, SYMBOL
                       )
                , TMP_DD_PREV AS ( --BANG TEMP TR
                                     SELECT ACCTNO, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                                     FROM VW_DDTRAN_GEN
                                     WHERE FIELD IN ('BALANCE', 'HOLDBALANCE') AND BUSDATE > v_ToDate_Previous --KY TRUOC
                                     GROUP BY ACCTNO
                                 )
                , TMP_DD AS ( --BANG TEMP TR
                             SELECT ACCTNO, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                             FROM VW_DDTRAN_GEN
                             WHERE FIELD IN ('BALANCE', 'HOLDBALANCE') AND BUSDATE > v_ToDate --KY NAY
                             GROUP BY ACCTNO
                            )
                , TMP_SI_PREV AS (
                                SELECT CODEID, CLOSEPRICE, AVGPRICE
                                FROM VW_SECURITIES_INFO_HIST
                                WHERE (CODEID,HISTDATE) IN (
                                     SELECT CODEID, MAX(HISTDATE)
                                     FROM VW_SECURITIES_INFO_HIST
                                     WHERE HISTDATE = v_ToDate_Previous --KY TRUOC
                                     GROUP BY CODEID
                                )
                            )
                , TMP_SI AS (
                            SELECT CODEID, CLOSEPRICE, AVGPRICE
                            FROM VW_SECURITIES_INFO_HIST
                            WHERE (CODEID,HISTDATE) IN (
                                 SELECT CODEID, MAX(HISTDATE)
                                 FROM VW_SECURITIES_INFO_HIST
                                 WHERE HISTDATE = v_ToDate --KY NAY
                                 GROUP BY CODEID
                            )
                        )
                , TMP_EXCHANGERATE AS (
                                         SELECT * FROM EXCHANGERATE
                                         UNION ALL
                                         SELECT * FROM EXCHANGERATE_HIST
                                      )
                , TMP_CPCCQ AS (
                        SELECT  SE.CUSTID,
                                SUM(
                                    (SE.TRADE + SE.HOLD + SE.MORTAGE + SE.NETTING + SE.BLOCKED + SE.WITHDRAW + SE.BLOCKWITHDRAW + SE.EMKQTTY - NVL(TR_PREV.NAMT,0))*
                                    (
                                        CASE
                                            WHEN SB.TRADEPLACE IN ('001','002') THEN SI_PREV.CLOSEPRICE --NY*CLOSEPRICE
                                            WHEN SB.TRADEPLACE IN ('005') THEN SI_PREV.AVGPRICE --UPCOM*AVGPRICE
                                            ELSE (CASE WHEN SB.CCYCD ='01' THEN SB.PARVALUE * V_USD_PREV ELSE SB.PARVALUE END)
                                        END
                                    )
                                ) QTTY_PREV,
                                SUM(
                                    (SE.TRADE + SE.HOLD + SE.MORTAGE + SE.NETTING + SE.BLOCKED + SE.WITHDRAW + SE.BLOCKWITHDRAW + SE.EMKQTTY - NVL(TR.NAMT,0))*
                                    (
                                        CASE
                                            WHEN SB.TRADEPLACE IN ('001','002') THEN SI.CLOSEPRICE --NY*CLOSEPRICE
                                            WHEN SB.TRADEPLACE IN ('005') THEN SI.AVGPRICE --UPCOM*AVGPRICE
                                            ELSE  (CASE WHEN SB.CCYCD ='01' THEN SB.PARVALUE * V_USD ELSE SB.PARVALUE END)
                                        END
                                    )
                                ) QTTY,
                                (
                                    CASE WHEN SB.SECTYPE IN ('001','002','008') AND SB.TRADEPLACE IN ('001','002') THEN 'NY'
                                         WHEN SB.SECTYPE IN ('001','002','008') AND SB.TRADEPLACE IN ('005') THEN 'UPCOM'
                                         WHEN (SB.SECTYPE IN ('001','002') AND SB.TRADEPLACE IN ('003')) OR SB.SECTYPE NOT IN ('001','002','003','006','008','012','013') THEN 'ETC'
                                         ELSE '' END
                                ) TYPE
                        FROM SEMAST SE JOIN TMP_SB SB ON SE.CODEID = SB.CODEID AND (
                            CASE WHEN SB.SECTYPE IN ('001','002','008') AND SB.TRADEPLACE IN ('001','002') THEN 'NY'
                                 WHEN SB.SECTYPE IN ('001','002','008') AND SB.TRADEPLACE IN ('005') THEN 'UPCOM'
                                 WHEN (SB.SECTYPE IN ('001','002') AND SB.TRADEPLACE IN ('003')) OR SB.SECTYPE NOT IN ('001','002','003','006','008','012','013') THEN 'ETC'
                                 ELSE '' END
                            ) IS NOT NULL
                        LEFT JOIN TMP_TR_PREV TR_PREV ON SE.ACCTNO = TR_PREV.ACCTNO
                        LEFT JOIN TMP_TR TR ON SE.ACCTNO = TR.ACCTNO
                        LEFT JOIN TMP_SI_PREV SI_PREV ON SI_PREV.CODEID = (CASE WHEN SB.REFCODEID IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
                        LEFT JOIN TMP_SI SI ON SI.CODEID = (CASE WHEN SB.REFCODEID IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
                        GROUP BY SE.CUSTID
                            ,(CASE
                                WHEN SB.TRADEPLACE IN ('001','002') THEN SI_PREV.CLOSEPRICE
                                WHEN SB.TRADEPLACE IN ('005') THEN SI_PREV.AVGPRICE
                                ELSE SB.PARVALUE
                             END)
                            ,(CASE
                                WHEN SB.TRADEPLACE IN ('001','002') THEN SI.CLOSEPRICE
                                WHEN SB.TRADEPLACE IN ('005') THEN SI.AVGPRICE
                                ELSE  SB.PARVALUE
                              END)
                            ,(
                                CASE WHEN SB.SECTYPE IN ('001','002','008') AND SB.TRADEPLACE IN ('001','002') THEN 'NY'
                                     WHEN SB.SECTYPE IN ('001','002','008') AND SB.TRADEPLACE IN ('005') THEN 'UPCOM'
                                     WHEN (SB.SECTYPE IN ('001','002') AND SB.TRADEPLACE IN ('003')) OR SB.SECTYPE NOT IN ('001','002','003','006','008','012','013') THEN 'ETC'
                                     ELSE '' END
                            )
                 )
                , CPCCQ AS (
                        SELECT CPCCQ_PREV.CUSTID,
                               CPCCQ_PREV.NY_PREV, CPCCQ_PREV.UPCOM_PREV, CPCCQ_PREV.ETC_PREV,
                               CPCCQ_PREV.NY NY, CPCCQ_PREV.UPCOM UPCOM, CPCCQ_PREV.ETC ETC
                        FROM (
                                SELECT * FROM ( SELECT CUSTID, QTTY_PREV, QTTY, TYPE FROM TMP_CPCCQ)
                                PIVOT (
                                    SUM(QTTY_PREV) AS PREV,
                                    SUM(QTTY)
                                    FOR TYPE IN ('NY' AS NY, 'UPCOM' AS UPCOM, 'ETC' AS ETC)
                             ) ORDER BY CUSTID
                        ) CPCCQ_PREV
                )
                , TMP_TR_P AS ( --BANG TEMP TRAI PHIEU
                               SELECT   SE.CUSTID
                                      , SB.EXPDATE
                                      , CASE WHEN MONTHS_BETWEEN(SB.EXPDATE,v_ToDate_Previous) > 0 AND MONTHS_BETWEEN(SB.EXPDATE,v_ToDate_Previous) < 12 THEN 'SHORT' ELSE
                                        CASE WHEN MONTHS_BETWEEN(SB.EXPDATE,v_ToDate_Previous) >= 12 AND MONTHS_BETWEEN(SB.EXPDATE,v_ToDate_Previous) < 24 THEN 'MEDIUM' ELSE
                                        CASE WHEN MONTHS_BETWEEN(SB.EXPDATE,v_ToDate_Previous) > 24 THEN 'LONG'
                                        ELSE 'EXPIRED' END END END TERM_PREV --KY TRUOC
                                       , CASE WHEN MONTHS_BETWEEN(SB.EXPDATE,v_ToDate) > 0 AND MONTHS_BETWEEN(SB.EXPDATE,v_ToDate) < 12 THEN 'SHORT' ELSE
                                        CASE WHEN MONTHS_BETWEEN(SB.EXPDATE,v_ToDate) >= 12 AND MONTHS_BETWEEN(SB.EXPDATE,v_ToDate) < 24 THEN 'MEDIUM' ELSE
                                        CASE WHEN MONTHS_BETWEEN(SB.EXPDATE,v_ToDate) > 24 THEN 'LONG'
                                        ELSE 'EXPIRED' END END END TERM --KY NAY
                                      , NVL(SUM((SE.TRADE + SE.HOLD + SE.MORTAGE + SE.NETTING + SE.BLOCKED + SE.WITHDRAW + SE.BLOCKWITHDRAW + SE.EMKQTTY - NVL(TR_PREV.NAMT,0)) * (CASE WHEN SB.CCYCD ='01' THEN SB.PARVALUE * V_USD_PREV ELSE SB.PARVALUE END)),0) QTTY_PREV
                                      , NVL(SUM((SE.TRADE + SE.HOLD + SE.MORTAGE + SE.NETTING + SE.BLOCKED + SE.WITHDRAW + SE.BLOCKWITHDRAW + SE.EMKQTTY - NVL(TR.NAMT,0)) * (CASE WHEN SB.CCYCD ='01' THEN SB.PARVALUE * V_USD ELSE SB.PARVALUE END)),0) QTTY
                                FROM SEMAST SE JOIN TMP_SB SB ON SB.CODEID = SE.CODEID AND SB.SECTYPE IN ('003','006')
                                LEFT JOIN TMP_TR_PREV TR_PREV ON SE.ACCTNO = TR_PREV.ACCTNO
                                LEFT JOIN TMP_TR TR ON SE.ACCTNO = TR.ACCTNO
                                GROUP BY SE.CUSTID, SB.EXPDATE
                           )
                , TR_P AS (
                    SELECT TR_P_PREV.CUSTID,
                           TR_P_PREV.SHORT_PREV, TR_P_PREV.MEDIUM_PREV, TR_P_PREV.LONG_PREV,
                           TR_P_PREV.SHORT, TR_P_PREV.MEDIUM, TR_P_PREV."LONG"
                    FROM (
                            SELECT * FROM (SELECT CUSTID, TERM_PREV, QTTY_PREV, QTTY FROM TMP_TR_P)
                            PIVOT (
                                SUM(QTTY_PREV) AS PREV,
                                SUM(QTTY)
                                FOR TERM_PREV IN ('SHORT' AS SHORT, 'MEDIUM' AS MEDIUM,'LONG' AS "LONG")
                            ) ORDER BY CUSTID
                     ) TR_P_PREV
                )
                , TP AS ( --TIN PHIEU
                       SELECT SE.CUSTID,
                              NVL(SUM((SE.TRADE + SE.HOLD + SE.MORTAGE + SE.NETTING + SE.BLOCKED + SE.WITHDRAW + SE.BLOCKWITHDRAW + SE.EMKQTTY - NVL(TR.NAMT,0)) * (CASE WHEN SB.CCYCD ='01' THEN SB.PARVALUE * V_USD ELSE SB.PARVALUE END)),0) QTTY
                       FROM TMP_SB SB JOIN SEMAST SE ON SB.CODEID = SE.CODEID AND SB.SECTYPE IN ('012')
                       LEFT JOIN TMP_TR TR ON SE.ACCTNO = TR.ACCTNO
                       GROUP BY SE.CUSTID
                 )
                 , TP_PREV AS (
                        SELECT SE.CUSTID,
                              NVL(SUM((SE.TRADE + SE.HOLD + SE.MORTAGE + SE.NETTING + SE.BLOCKED + SE.WITHDRAW + SE.BLOCKWITHDRAW + SE.EMKQTTY - NVL(TR_PREV.NAMT,0)) * (CASE WHEN SB.CCYCD ='01' THEN SB.PARVALUE * V_USD_PREV ELSE SB.PARVALUE END)),0) QTTY_PREV
                       FROM TMP_SB SB JOIN SEMAST SE ON SB.CODEID = SE.CODEID AND SB.SECTYPE IN ('012')
                       LEFT JOIN TMP_TR_PREV TR_PREV ON SE.ACCTNO = TR_PREV.ACCTNO
                       GROUP BY SE.CUSTID
                 )
                , TMP_CCTG AS ( --BANG TEMP CHUNG CHI TIEN GUI
                                SELECT SE.CUSTID,
                                       NVL(SUM((SE.TRADE + SE.HOLD + SE.MORTAGE + SE.NETTING + SE.BLOCKED + SE.WITHDRAW + SE.BLOCKWITHDRAW + SE.EMKQTTY - NVL(TR_PREV.NAMT,0)) * (CASE WHEN SB.CCYCD ='01' THEN SB.PARVALUE * V_USD_PREV ELSE SB.PARVALUE END)),0) QTTY_PREV,
                                       NVL(SUM((SE.TRADE + SE.HOLD + SE.MORTAGE + SE.NETTING + SE.BLOCKED + SE.WITHDRAW + SE.BLOCKWITHDRAW + SE.EMKQTTY - NVL(TR.NAMT,0)) * (CASE WHEN SB.CCYCD ='01' THEN SB.PARVALUE * V_USD ELSE SB.PARVALUE END)),0) QTTY
                                FROM TMP_SB SB JOIN SEMAST SE ON SB.CODEID = SE.CODEID AND SB.SECTYPE IN ('013')
                                LEFT JOIN TMP_TR_PREV TR_PREV ON SE.ACCTNO = TR_PREV.ACCTNO
                                LEFT JOIN TMP_TR TR ON SE.ACCTNO = TR.ACCTNO
                                GROUP BY SE.CUSTID
                              )
                 , TMP_TM AS ( --BANG TEMP TIEN MAT
                               -- BAO.NGUYEN CHINH SUA THEO JIRA SHBVNEX-2729
                               SELECT DD.CUSTID,
                                      NVL(SUM(
                                        CASE
                                            WHEN SUBSTR(CF.CUSTODYCD,4,1) <> 'E' AND CF.COUNTRY <> '245' AND DD.ACCOUNTTYPE IN ('IICA') THEN (DD.BALANCE + DD.HOLDBALANCE - NVL(TR_PREV.NAMT,0)) * (CASE WHEN DD.CCYCD <> 'VND' THEN V_USD_PREV ELSE 1 END)
                                            WHEN SUBSTR(CF.CUSTODYCD,4,1) <> 'E' AND CF.COUNTRY = '245' AND DD.ACCOUNTTYPE IN ('IICA', 'SSTA') THEN (DD.BALANCE + DD.HOLDBALANCE - NVL(TR_PREV.NAMT,0)) * (CASE WHEN DD.CCYCD <> 'VND' THEN V_USD_PREV ELSE 1 END)
                                            ELSE 0
                                        END
                                      ),0) QTTY_PREV,
                                      NVL(SUM(
                                        CASE
                                            WHEN SUBSTR(CF.CUSTODYCD,4,1) <> 'E' AND CF.COUNTRY <> '245' AND DD.ACCOUNTTYPE IN ('IICA') THEN (DD.BALANCE + DD.HOLDBALANCE - NVL(TR.NAMT,0)) * (CASE WHEN DD.CCYCD <> 'VND' THEN V_USD ELSE 1 END)
                                            WHEN SUBSTR(CF.CUSTODYCD,4,1) <> 'E' AND CF.COUNTRY = '245' AND DD.ACCOUNTTYPE IN ('IICA', 'SSTA') THEN (DD.BALANCE + DD.HOLDBALANCE - NVL(TR.NAMT,0)) * (CASE WHEN DD.CCYCD <> 'VND' THEN V_USD ELSE 1 END)
                                            ELSE 0
                                        END
                                      ),0) QTTY
                               FROM DDMAST DD
                               JOIN CFMAST CF ON CF.CUSTID = DD.CUSTID
                               LEFT JOIN TMP_DD_PREV TR_PREV ON DD.ACCTNO = TR_PREV.ACCTNO
                               LEFT JOIN TMP_DD TR ON DD.ACCTNO = TR.ACCTNO
                               /*LEFT JOIN (
                                    SELECT CURRENCY, VND
                                    FROM TMP_EXCHANGERATE
                                    WHERE (CURRENCY, RTYPE, ITYPE, LASTCHANGE) IN (
                                        SELECT CURRENCY, RTYPE, ITYPE, MAX(LASTCHANGE)
                                        FROM TMP_EXCHANGERATE
                                        WHERE (CURRENCY, RTYPE, ITYPE, TRADEDATE) IN (
                                            SELECT CURRENCY, RTYPE, ITYPE, MAX(TRADEDATE)
                                            FROM TMP_EXCHANGERATE
                                            WHERE TRADEDATE <= v_ToDate_Previous
                                            AND RTYPE = 'TTM'
                                            AND ITYPE = 'SBV'
                                            GROUP BY CURRENCY, RTYPE, ITYPE
                                        )
                                        GROUP BY CURRENCY, RTYPE, ITYPE
                                    )
                               ) EX_PREV ON EX_PREV.CURRENCY = DD.CCYCD
                               LEFT JOIN  (
                                    SELECT CURRENCY, VND
                                    FROM TMP_EXCHANGERATE
                                    WHERE (CURRENCY, RTYPE, ITYPE, LASTCHANGE) IN (
                                        SELECT CURRENCY, RTYPE, ITYPE, MAX(LASTCHANGE)
                                        FROM TMP_EXCHANGERATE
                                        WHERE (CURRENCY, RTYPE, ITYPE, TRADEDATE) IN (
                                            SELECT CURRENCY, RTYPE, ITYPE, MAX(TRADEDATE)
                                            FROM TMP_EXCHANGERATE
                                            WHERE TRADEDATE <= v_ToDate
                                            AND RTYPE = 'TTM'
                                            AND ITYPE = 'SBV'
                                            GROUP BY CURRENCY, RTYPE, ITYPE
                                        )
                                        GROUP BY CURRENCY, RTYPE, ITYPE
                                    )
                               ) EX ON EX.CURRENCY = DD.CCYCD*/
                               GROUP BY DD.CUSTID
                            )
                , CCTG_TM AS ( --CHUNG CHI TIEN GUI + TIEN MAT
                                SELECT A.CUSTID, SUM(A.QTTY_PREV) QTTY_PREV, SUM(A.QTTY) QTTY
                                FROM (
                                        SELECT * FROM TMP_CCTG --WHERE QTTY_PREV > 0 OR QTTY > 0
                                        UNION ALL
                                        SELECT * FROM TMP_TM --WHERE QTTY_PREV > 0 OR QTTY > 0
                                     ) A
                                GROUP BY CUSTID
                             )
--==========================================MAIN SELECT QUERY=======================================================================
                SELECT FULLNAME, STC, CUSTTYPE, CASE WHEN STT = 1 THEN CUSTTYPE_NAME ELSE '' END CUSTTYPE_NAME,
                       TP, TRP_NH, TRP_TH, TRP_DH, CPCCQ_NY, CPCCQ_UPCOM, CPCCQ_KHAC, CCTG,
                       TP_PREV, TRP_NH_PREV, TRP_TH_PREV, TRP_DH_PREV, CPCCQ_NY_PREV, CPCCQ_UPCOM_PREV, CPCCQ_KHAC_PREV, CCTG_PREV, v_CCYCD_INFO CCYCD_INFO
                FROM (
                        SELECT ROW_NUMBER() OVER (PARTITION BY CF.CUSTTYPE ORDER BY FULLNAME) STT,
                               CF.FULLNAME,
                               (CASE WHEN CF.COUNTRY ='234' THEN SUBSTR(CF.CUSTODYCD,5,6) ELSE CF.TRADINGCODE END) STC,
                               CF.CUSTTYPE,
                               CASE WHEN CF.CUSTTYPE ='B' THEN 'A- '||A1.CDCONTENT ELSE 'B- '||A1.CDCONTENT END CUSTTYPE_NAME,
                               (CASE WHEN CPCCQ.CUSTID IS NULL
                                    THEN CASE WHEN TR_P.CUSTID IS NULL
                                              THEN CASE WHEN CCTG_TM.CUSTID IS NULL THEN TP.CUSTID
                                              ELSE CCTG_TM.CUSTID END
                                    ELSE TR_P.CUSTID END
                               ELSE CPCCQ.CUSTID END) CUSTID,
                               NVL(CPCCQ.NY,0) CPCCQ_NY, NVL(CPCCQ.UPCOM,0) CPCCQ_UPCOM, NVL(CPCCQ.ETC,0) CPCCQ_KHAC,
                               NVL(CPCCQ.NY_PREV,0) CPCCQ_NY_PREV, NVL(CPCCQ.UPCOM_PREV,0) CPCCQ_UPCOM_PREV, NVL(CPCCQ.ETC_PREV,0) CPCCQ_KHAC_PREV,
                               NVL(TR_P.SHORT,0) TRP_NH, NVL(TR_P.MEDIUM,0) TRP_TH, NVL(TR_P."LONG",0) TRP_DH,
                               NVL(TR_P.SHORT_PREV,0) TRP_NH_PREV, NVL(TR_P.MEDIUM_PREV,0) TRP_TH_PREV, NVL(TR_P.LONG_PREV,0) TRP_DH_PREV,
                               NVL(CCTG_TM.QTTY,0) CCTG, NVL(CCTG_TM.QTTY_PREV,0) CCTG_PREV,
                               NVL(TP.QTTY,0) TP,  NVL(TP_PREV.QTTY_PREV,0) TP_PREV
                        FROM (
                                SELECT CUSTID FROM CPCCQ UNION
                                SELECT CUSTID FROM TR_P UNION
                                SELECT CUSTID FROM CCTG_TM UNION
                                SELECT CUSTID FROM TP UNION
                                SELECT CUSTID FROM TP_PREV
                             ) ALL_TMP
                             LEFT JOIN CPCCQ ON ALL_TMP.CUSTID = CPCCQ.CUSTID
                             LEFT JOIN TR_P ON ALL_TMP.CUSTID = TR_P.CUSTID
                             LEFT JOIN CCTG_TM ON ALL_TMP.CUSTID = CCTG_TM.CUSTID
                             LEFT JOIN TP ON ALL_TMP.CUSTID = TP.CUSTID
                             LEFT JOIN TP_PREV ON ALL_TMP.CUSTID = TP_PREV.CUSTID
                             JOIN CFMAST CF ON CF.CUSTID = (CASE WHEN CPCCQ.CUSTID IS NULL THEN
                                                                 CASE WHEN TR_P.CUSTID IS NULL THEN
                                                                      CASE WHEN CCTG_TM.CUSTID IS NULL THEN
                                                                           CASE WHEN TP.CUSTID IS NULL THEN TP_PREV.CUSTID
                                                                           ELSE TP.CUSTID END
                                                                      ELSE CCTG_TM.CUSTID END
                                                                 ELSE TR_P.CUSTID END
                                                             ELSE CPCCQ.CUSTID END)
                                                AND CF.CUSTTYPE IN ('I','B')
                                                AND CF.IDTYPE = '009' --NUOC NGOAI
                                                --AND CF.CUSTATCOM = 'Y' --LUU KY TAI SHINHAN trung.luu: 19-11-2020 SHBVNEX-1759
                                                AND CF.STATUS <> 'C'
                             LEFT JOIN ALLCODE A1 ON CF.CUSTTYPE = A1.CDVAL AND A1.CDNAME='CUSTTYPE' AND A1.CDTYPE ='CF'
                             JOIN (SELECT CUSTID FROM DDMAST WHERE ACCOUNTTYPE IN ('IICA','SSTA') AND STATUS <> 'C' GROUP BY CUSTID) DD ON CF.CUSTID  = DD.CUSTID --TriBui 04082020 fix, just get custodycd consist of IICA account type
                             ORDER BY CF.CUSTTYPE, FULLNAME
                        );
EXCEPTION
  WHEN OTHERS
   THEN
   DBMS_OUTPUT.PUT_LINE('OD6003 ERROR');
   PLOG.ERROR('OD6003: - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
