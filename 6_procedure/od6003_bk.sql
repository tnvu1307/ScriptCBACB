SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE OD6003_BK (
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
    V_STROPTION         VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID           VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    v_FromDate_Previous date;
    v_ToDate_Previous   date;
    v_FromDate          date;
    v_ToDate            date;

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

    OPEN PV_REFCURSOR FOR
        WITH TMP_SB AS ( --BANG TAM SB
                SELECT SB.CODEID, SB.SECTYPE, SB.SYMBOL, SB1.CODEID REFCODEID, SB1.SYMBOL REFSYMBOL, SB.EXPDATE, SB.PARVALUE
                      , (CASE WHEN SB.REFCODEID IS NULL THEN SB.TRADEPLACE ELSE SB1.TRADEPLACE END) TRADEPLACE
                FROM SBSECURITIES SB, SBSECURITIES SB1
                WHERE SB.REFCODEID = SB1.CODEID(+) AND SB.SECTYPE <> '004'
              )
        , TMP_TR AS ( --BANG TEMP TR
                 SELECT CUSTODYCD, ACCTNO, SYMBOL, TXDATE, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                 FROM VW_SETRAN_GEN
                 WHERE FIELD IN ('TRADE','NETTING','BLOCKED')
                 GROUP BY CUSTODYCD, ACCTNO, SYMBOL, TXDATE
               )
        , TMP_CPCCQ AS ( --BANG TEMP CO PHIEU/CHUNG CHI QUY
                   -- CO PHIEU/CHUNG CHI QUY NIEM YET
                   SELECT SE.CUSTID, SUM(SE.TRADE - NVL(TR_PREV.NAMT,0)) QTTY_PREV, SUM(SE.TRADE - NVL(TR.NAMT,0)) QTTY, 'NY' TYPE
                   FROM SEMAST SE JOIN TMP_SB SB ON SE.CODEID = SB.CODEID AND SB.SECTYPE IN ('001','002','008') AND SB.TRADEPLACE IN ('001','002')
                                  LEFT JOIN TMP_TR TR_PREV ON SE.ACCTNO = TR_PREV.ACCTNO AND TR_PREV.TXDATE BETWEEN v_FromDate_Previous AND v_ToDate_Previous --KY TRUOC
                                  LEFT JOIN TMP_TR TR ON SE.ACCTNO = TR.ACCTNO AND TR.TXDATE BETWEEN v_FromDate AND v_ToDate  --KY NAY
                   GROUP BY SE.CUSTID,
                            (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END),
                            (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
                   UNION ALL
                   -- CO PHIEU/CHUNG CHI QUY UPCOM
                   SELECT SE.CUSTID, SUM(SE.TRADE - NVL(TR_PREV.NAMT,0)) QTTY_PREV, SUM(SE.TRADE - NVL(TR.NAMT,0)) QTTY, 'UPCOM' TYPE
                   FROM SEMAST SE JOIN TMP_SB SB ON SE.CODEID = SB.CODEID AND SB.SECTYPE IN ('001','002','008') AND SB.TRADEPLACE IN ('005')
                                  LEFT JOIN TMP_TR TR_PREV ON SE.ACCTNO = TR_PREV.ACCTNO AND TR_PREV.TXDATE BETWEEN v_FromDate_Previous AND v_ToDate_Previous --KY TRUOC
                                  LEFT JOIN TMP_TR TR ON SE.ACCTNO = TR.ACCTNO AND TR.TXDATE BETWEEN v_FromDate AND v_ToDate  --KY NAY
                   GROUP BY SE.CUSTID,
                            (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END),
                            (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
                   UNION ALL
                   -- CO PHIEU/CHUNG CHI QUY KHAC
                   SELECT SE.CUSTID, SUM(SE.TRADE - NVL(TR_PREV.NAMT,0)) QTTY_PREV, SUM(SE.TRADE - NVL(TR.NAMT,0)) QTTY, 'ETC' TYPE
                   FROM SEMAST SE JOIN TMP_SB SB ON SE.CODEID = SB.CODEID AND NOT (SB.SECTYPE IN ('001','002','008') AND SB.TRADEPLACE IN ('005'))
                                                                          AND NOT (SB.SECTYPE IN ('001','002','008') AND SB.TRADEPLACE IN ('001','002'))
                                  LEFT JOIN TMP_TR TR_PREV ON SE.ACCTNO = TR_PREV.ACCTNO AND TR_PREV.TXDATE BETWEEN v_FromDate_Previous AND v_ToDate_Previous --KY TRUOC
                                  LEFT JOIN TMP_TR TR ON SE.ACCTNO = TR.ACCTNO AND TR.TXDATE BETWEEN v_FromDate AND v_ToDate  --KY NAY
                   GROUP BY SE.CUSTID,
                            (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END),
                            (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)

                 )
        , CPCCQ AS ( --CO PHIEU/CHUNG CHI QUY
               SELECT CASE WHEN CPCCQ_PREV.CUSTID IS NULL THEN CPCCQ.CUSTID ELSE CPCCQ_PREV.CUSTID END CUSTID,
                      CPCCQ_PREV.NY_PREV NY_PREV, CPCCQ_PREV.UPCOM_PREV UPCOM_PREV, CPCCQ_PREV.ETC_PREV ETC_PREV,
                      CPCCQ.NY NY, CPCCQ.UPCOM UPCOM, CPCCQ.ETC ETC
               FROM (
                      SELECT * FROM ( SELECT CUSTID, QTTY_PREV, TYPE FROM TMP_CPCCQ)
                      PIVOT (SUM(QTTY_PREV) FOR TYPE IN ('NY' "NY_PREV",'UPCOM' "UPCOM_PREV",'ETC' "ETC_PREV")) ORDER BY CUSTID
                    ) CPCCQ_PREV
                    FULL JOIN
                    (
                      SELECT * FROM ( SELECT CUSTID, QTTY, TYPE FROM TMP_CPCCQ)
                      PIVOT (SUM(QTTY) FOR TYPE IN ('NY' "NY",'UPCOM' "UPCOM",'ETC' "ETC")) ORDER BY CUSTID
                    ) CPCCQ
                    ON CPCCQ_PREV.CUSTID = CPCCQ.CUSTID
            )
        , TMP_TR_P AS ( --BANG TEMP TRAI PHIEU
                       SELECT   SE.CUSTID
                              , SB.EXPDATE
                              , CASE WHEN MONTHS_BETWEEN(SB.EXPDATE,v_FromDate_Previous) > 0 AND MONTHS_BETWEEN(SB.EXPDATE,v_FromDate_Previous) < 12 THEN 'SHORT' ELSE
                                CASE WHEN MONTHS_BETWEEN(SB.EXPDATE,v_FromDate_Previous) >= 12 AND MONTHS_BETWEEN(SB.EXPDATE,v_FromDate_Previous) < 24 THEN 'MEDIUM' ELSE
                                CASE WHEN MONTHS_BETWEEN(SB.EXPDATE,v_FromDate_Previous) > 24 THEN 'LONG'
                                ELSE 'EXPIRED' END END END TERM_PREV --KY TRUOC
                               , CASE WHEN MONTHS_BETWEEN(SB.EXPDATE,v_FromDate) > 0 AND MONTHS_BETWEEN(SB.EXPDATE,v_FromDate) < 12 THEN 'SHORT' ELSE
                                CASE WHEN MONTHS_BETWEEN(SB.EXPDATE,v_FromDate) >= 12 AND MONTHS_BETWEEN(SB.EXPDATE,v_FromDate) < 24 THEN 'MEDIUM' ELSE
                                CASE WHEN MONTHS_BETWEEN(SB.EXPDATE,v_FromDate) > 24 THEN 'LONG'
                                ELSE 'EXPIRED' END END END TERM --KY NAY
                              , NVL(SUM(SE.TRADE + SE.NETTING + SE.BLOCKED - NVL(TR_PREV.NAMT,0)),0) QTTY_PREV
                              , NVL(SUM(SE.TRADE + SE.NETTING + SE.BLOCKED - NVL(TR.NAMT,0)),0) QTTY
                       FROM SEMAST SE JOIN TMP_SB SB ON SB.CODEID = SE.CODEID AND SB.SECTYPE IN ('003','006')
                                      LEFT JOIN TMP_TR TR_PREV ON SE.ACCTNO = TR_PREV.ACCTNO AND TR_PREV.TXDATE BETWEEN v_FromDate_Previous AND v_ToDate_Previous --KY TRUOC
                                      LEFT JOIN TMP_TR TR ON SE.ACCTNO = TR.ACCTNO AND TR.TXDATE BETWEEN v_FromDate AND v_ToDate  --KY NAY
                        GROUP BY SE.CUSTID, SB.EXPDATE,
                                 (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END),
                                 (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
                   )
        , TR_P AS ( --TRAI PHIEU
                SELECT CASE WHEN TR_P_PREV.CUSTID IS NULL THEN TR_P.CUSTID ELSE TR_P_PREV.CUSTID END CUSTID,
                       TR_P_PREV.SHORT_PREV SHORT_PREV, TR_P_PREV.MEDIUM_PREV MEDIUM_PREV, TR_P_PREV.LONG_PREV LONG_PREV,
                       TR_P.SHORT, TR_P.MEDIUM, TR_P."LONG"
                FROM (
                       SELECT * FROM (SELECT CUSTID, TERM_PREV, QTTY_PREV FROM TMP_TR_P)
                       PIVOT (SUM(QTTY_PREV) FOR TERM_PREV IN ('SHORT' "SHORT_PREV",'MEDIUM' "MEDIUM_PREV",'LONG' "LONG_PREV")) ORDER BY CUSTID
                     ) TR_P_PREV
                     FULL JOIN
                    (
                       SELECT * FROM (SELECT CUSTID, TERM, QTTY FROM TMP_TR_P)
                       PIVOT (SUM(QTTY) FOR TERM IN ('SHORT' "SHORT",'MEDIUM' "MEDIUM",'LONG' "LONG")) ORDER BY CUSTID
                     ) TR_P
                     ON TR_P_PREV.CUSTID = TR_P.CUSTID
                )

        , CCTG AS ( --CHUNG CHI TIEN GUI
                 SELECT SE.CUSTID,
                        NVL(SUM(SE.TRADE + SE.NETTING + SE.BLOCKED - NVL(TR_PREV.NAMT,0)),0) QTTY_PREV,
                        NVL(SUM(SE.TRADE + SE.NETTING + SE.BLOCKED - NVL(TR.NAMT,0)),0) QTTY
                 FROM TMP_SB SB JOIN SEMAST SE ON SB.CODEID = SE.CODEID AND SB.SECTYPE IN ('013')
                                LEFT JOIN TMP_TR TR_PREV  ON SE.ACCTNO = TR_PREV.ACCTNO AND TR_PREV.TXDATE BETWEEN v_FromDate_Previous AND v_ToDate_Previous --KY TRUOC
                                LEFT JOIN TMP_TR TR  ON SE.ACCTNO = TR.ACCTNO AND TR.TXDATE BETWEEN v_FromDate AND v_ToDate  --KY NAY
                 GROUP BY SE.CUSTID,
                          (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END),
                          (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
               )
        , TP AS ( --TIN PHIEU
               SELECT SE.CUSTID,
                      NVL(SUM(SE.TRADE + SE.NETTING + SE.BLOCKED - NVL(TR_PREV.NAMT,0)),0) QTTY_PREV,
                      NVL(SUM(SE.TRADE + SE.NETTING + SE.BLOCKED - NVL(TR.NAMT,0)),0) QTTY
               FROM TMP_SB SB JOIN SEMAST SE ON SB.CODEID = SE.CODEID AND SB.SECTYPE IN ('012')
                              LEFT JOIN TMP_TR TR_PREV  ON SE.ACCTNO = TR_PREV.ACCTNO AND TR_PREV.TXDATE BETWEEN v_FromDate_Previous AND v_ToDate_Previous --KY TRUOC
                              LEFT JOIN TMP_TR TR  ON SE.ACCTNO = TR.ACCTNO AND TR.TXDATE BETWEEN v_FromDate AND v_ToDate  --KY NAY
               GROUP BY SE.CUSTID,
                        (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END),
                        (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
             )
        SELECT FULLNAME, STC, CUSTTYPE, CASE WHEN STT = 1 THEN CUSTTYPE_NAME ELSE '' END CUSTTYPE_NAME,
               TP, TRP_NH, TRP_TH, TRP_DH, CPCCQ_NY, CPCCQ_UPCOM, CPCCQ_KHAC, CCTG,
               TP_PREV, TRP_NH_PREV, TRP_TH_PREV, TRP_DH_PREV, CPCCQ_NY_PREV, CPCCQ_UPCOM_PREV, CPCCQ_KHAC_PREV, CCTG_PREV
        FROM (
                SELECT ROW_NUMBER() OVER (PARTITION BY CF.CUSTTYPE ORDER BY FULLNAME) STT,
                       CF.FULLNAME,
                       (CASE WHEN CF.COUNTRY ='234' THEN SUBSTR(CF.CUSTODYCD,5,6) ELSE CF.TRADINGCODE END) STC,
                       CF.CUSTTYPE,
                       CASE WHEN CF.CUSTTYPE ='B' THEN 'A- '||A1.CDCONTENT ELSE 'B- '||A1.CDCONTENT END CUSTTYPE_NAME,
                       (CASE WHEN CPCCQ.CUSTID IS NULL
                            THEN CASE WHEN TR_P.CUSTID IS NULL
                                      THEN CASE WHEN CCTG.CUSTID IS NULL THEN TP.CUSTID
                                      ELSE CCTG.CUSTID END
                            ELSE TR_P.CUSTID END
                       ELSE CPCCQ.CUSTID END) CUSTID,
                       NVL(CPCCQ.NY,0) CPCCQ_NY, NVL(CPCCQ.UPCOM,0) CPCCQ_UPCOM, NVL(CPCCQ.ETC,0) CPCCQ_KHAC,
                       NVL(CPCCQ.NY_PREV,0) CPCCQ_NY_PREV, NVL(CPCCQ.UPCOM_PREV,0) CPCCQ_UPCOM_PREV, NVL(CPCCQ.ETC_PREV,0) CPCCQ_KHAC_PREV,
                       NVL(TR_P.SHORT,0) TRP_NH, NVL(TR_P.MEDIUM,0) TRP_TH, NVL(TR_P."LONG",0) TRP_DH,
                       NVL(TR_P.SHORT_PREV,0) TRP_NH_PREV, NVL(TR_P.MEDIUM_PREV,0) TRP_TH_PREV, NVL(TR_P.LONG_PREV,0) TRP_DH_PREV,
                       NVL(CCTG.QTTY,0) CCTG, NVL(CCTG.QTTY_PREV,0) CCTG_PREV,
                       NVL(TP.QTTY,0) TP,  NVL(TP.QTTY_PREV,0) TP_PREV
                FROM (
                        SELECT CUSTID FROM CPCCQ UNION
                        SELECT CUSTID FROM TR_P UNION
                        SELECT CUSTID FROM CCTG UNION
                        SELECT CUSTID FROM TP
                     )ALL_TMP LEFT JOIN CPCCQ ON ALL_TMP.CUSTID = CPCCQ.CUSTID
                              LEFT JOIN TR_P ON ALL_TMP.CUSTID = TR_P.CUSTID
                              LEFT JOIN CCTG ON ALL_TMP.CUSTID = CCTG.CUSTID
                              LEFT JOIN TP ON ALL_TMP.CUSTID = TP.CUSTID
                              LEFT JOIN CFMAST CF ON CF.CUSTID = (CASE WHEN CPCCQ.CUSTID IS NULL
                                                                       THEN CASE WHEN TR_P.CUSTID IS NULL
                                                                                 THEN CASE WHEN CCTG.CUSTID IS NULL THEN TP.CUSTID
                                                                                 ELSE CCTG.CUSTID END
                                                                       ELSE TR_P.CUSTID END
                                                                  ELSE CPCCQ.CUSTID END) AND CF.CUSTTYPE IN ('I','B')
                              LEFT JOIN ALLCODE A1 ON CF.CUSTTYPE = A1.CDVAL AND A1.CDNAME='CUSTTYPE' AND A1.CDTYPE ='CF'
                ORDER BY CF.CUSTTYPE, FULLNAME);

EXCEPTION
  WHEN OTHERS
   THEN
   DBMS_OUTPUT.PUT_LINE('OD6003 ERROR');
   PLOG.ERROR('OD6003: - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
