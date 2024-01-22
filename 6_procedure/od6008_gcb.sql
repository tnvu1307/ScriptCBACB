SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE od6008_gcb(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,

   I_DATE                 IN       VARCHAR2,
   PV_CUSTODYCD           IN       VARCHAR2,
   P_AMCCODE              IN       VARCHAR2, /*AMC */
   PV_GCB                 IN       VARCHAR2 /*GCM */
   )
IS

    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    V_INDATE            DATE;
    V_CURRDATE          DATE;
    V_NEXTINDATE        DATE;
    V_CUSTODYCD         VARCHAR(20);
    V_AMC               VARCHAR(200);
    V_GCB               VARCHAR(200);
   BEGIN
     V_STROPTION := OPT;
     IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
     ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
     ELSE
        V_STRBRID:=BRID;
     END IF;
     ------------------------------------
     IF (PV_GCB = 'ALL') THEN
        V_GCB := '%';
     ELSE
        V_GCB:= PV_GCB;
     END IF;
     ------------------------------------
     IF (P_AMCCODE = 'ALL') THEN
        V_AMC := '%';
     ELSE
        V_AMC:= P_AMCCODE;
     END IF;
     ------------------------------------
     V_CUSTODYCD := UPPER(REPLACE(PV_CUSTODYCD,'.',''));
     IF (V_CUSTODYCD = 'ALL') THEN
        V_CUSTODYCD := '%';
     ELSE
        V_CUSTODYCD:= V_CUSTODYCD;
     END IF;

     V_INDATE   :=     TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
     V_CURRDATE    :=     GETCURRDATE;
     ------------------------------------
     SELECT TO_DATE(TO_CHAR(MIN(SBDATE),'DD/MM/RRRR'),SYSTEMNUMS.C_DATE_FORMAT) INTO V_NEXTINDATE
     FROM SBCLDR
     WHERE CLDRTYPE ='000' AND HOLIDAY='N'
            AND SBDATE > V_INDATE;
     ------------------------------------

OPEN PV_REFCURSOR FOR

SELECT A.* ,TO_CHAR(V_INDATE,'DD/MM/YYYY') INDATE, A1.EN_CDCONTENT CDCONTENT
FROM
(
    SELECT FUNDNAME, ISSFULLNAME, CIFID, CUSTID, SYMBOL, ISINCODE, SECTYPE,
           SUM(NETTING) + SUM(SE2210_THIEU) NETTING,
           SUM(RECEIVING) RECEIVING,
           SUM(BLOCKED) BLOCKED,
           SUM(TRADE) TRADE,
           SUM(TRADE_WTF) TRADE_WTF,
           GREATEST(SUM(NETTING) + SUM(TRADE_WTF) + SUM(BLOCKED) + SUM(TRADE) + sum(se2210_thieu) + sum(TRADE_WTF_2210),0) TOTAL --TRUNG.LUU: 23-11-2020 SHBVNEX-1801(THIEU VSE2210)
    FROM (
         SELECT
            MST.FUNDNAME , MST.FULLNAME ISSFULLNAME, MST.CIFID CIFID, MST.CUSTID, MST.CODEID ISSCODEID, MST.SECTYPE,
            MST.ISINCODE, REPLACE(MST.SYMBOL,'_WFT','') SYMBOL, --GOM MACK CO WFT LAI
            GREATEST(SUM(MST.NETTING + MST.NAMT_NETTING - MST.QTTY_ETF_NETTING),0) NETTING, --     TRU SL 8864 NETTING
            GREATEST(SUM(CASE WHEN MST.SYMBOL LIKE '%_WFT' THEN 0 ELSE MST.RECEIVING + MST.NAMT_RECEIVING - MST.QTTY_ETF_RECEIVING END),0) RECEIVING,
            GREATEST(SUM(CASE WHEN MST.SYMBOL LIKE '%_WFT' THEN 0 ELSE MST.BLOCKED + MST.NAMT_BLOCKED +  MST.MORTAGE+ MST.EMKQTTY +  MST.NAMT_EMKQTTY + MST.NAMT_MORTAGE END),0) BLOCKED,
            GREATEST(SUM(CASE WHEN MST.SYMBOL LIKE '%_WFT' THEN 0 ELSE MST.TRADE + MST.NAMT_TRADE + MST.TRADE1404 END)) TRADE,
            GREATEST(SUM(MST.HOLD + MST.NAMT_HOLD + MST.WITHDRAW  + MST.NAMT_WITHDRAW + MST.BLOCKWITHDRAW + MST.NAMT_BLOCKWITHDRAW),0) se2210_thieu,
            GREATEST(SUM(CASE WHEN MST.SYMBOL LIKE '%_WFT' THEN  MST.emkqtty ELSE 0 END), 0) TRADE_WTF_2210,
            GREATEST(SUM(CASE WHEN MST.SYMBOL LIKE '%_WFT' THEN MST.TRADE + MST.BLOCKED + MST.NAMT_TRADE + MST.NAMT_BLOCKED ELSE 0 END), 0) TRADE_WTF

        FROM (
            --LAY TOAN BO CO PHIEU CUA CUSTODYCD
            SELECT SE.FUNDNAME, SE.CIFID, SE.CUSTID, SE.SYMBOL, SE.ISINCODE, SE.FULLNAME, SE.CODEID, SE.ACCTNO, SE.NETTING, SE.RECEIVING, SE.BLOCKWITHDRAW, SE.WITHDRAW, SE.HOLD, SE.BLOCKED, SE.EMKQTTY, SE.TRADE, SE.MORTAGE, NVL(TR.NAMT_NETTING,0) NAMT_NETTING,
            NVL(TR.NAMT_RECEIVING,0) NAMT_RECEIVING, NVL(TR.NAMT_BLOCKED,0) NAMT_BLOCKED, NVL(TR.NAMT_TRADE,0) NAMT_TRADE, NVL(TR.NAMT_EMKQTTY,0) NAMT_EMKQTTY, NVL(TR.NAMT_MORTAGE,0) NAMT_MORTAGE,
            NVL(TI.QTTY_ETF_RECEIVING,0) QTTY_ETF_RECEIVING, NVL(TE.QTTY_ETF_NETTING,0) QTTY_ETF_NETTING, SE.SECTYPE,NVL(TR.NAMT_HOLD,0) NAMT_HOLD,NVL(TR.NAMT_WITHDRAW,0)NAMT_WITHDRAW,
            NVL(TR.NAMT_BLOCKWITHDRAW,0) NAMT_BLOCKWITHDRAW, MAX(SE.TRADE1404) TRADE1404
            FROM (
                SELECT CF.FULLNAME FUNDNAME, CF.CIFID, CF.CUSTID, SB.SYMBOL, SB.ISINCODE, ISS.FULLNAME,
                       SE.CODEID, SE.ACCTNO ,SE.NETTING, SE.RECEIVING, SE.BLOCKED, SE.EMKQTTY, SE.TRADE, SE.MORTAGE, SB.SECTYPE, SE.BLOCKWITHDRAW, SE.WITHDRAW, SE.HOLD, SE.TRADE1404
                FROM SEMAST SE,SBSECURITIES SB, ISSUERS ISS, AFMAST AF,
                (
                    SELECT CF.*
                    FROM CFMAST CF
                    LEFT JOIN (SELECT * FROM FAMEMBERS WHERE ROLES ='GCB') FA1 ON CF.GCBID =FA1.AUTOID,(SELECT *FROM EMAILREPORT WHERE DELTD <> 'Y') E
                    WHERE CF.CUSTODYCD LIKE V_CUSTODYCD
                    AND NVL(FA1.SHORTNAME,'%') LIKE V_GCB
                    AND CF.STATUS <> 'C'
                    AND CF.CUSTATCOM = 'Y'
                    AND CF.CUSTID = E.CUSTID
                    AND E.REGISTTYPE ='GCB'
                ) CF
                WHERE SB.ISSUERID=ISS.ISSUERID
                AND SB.SECTYPE IN ('001','002','008','011','004') --trung.luu: 28-01-2021  SHBVNEX-2062 bo sectype 004 o sub_od6008_1( dem qua od6008)
                AND CF.CUSTID = AF.CUSTID
                AND AF.ACCTNO = SE.AFACCTNO
                AND SB.CODEID = SE.CODEID
                GROUP BY CF.FULLNAME, CF.CIFID, CF.CUSTID, SB.SYMBOL, SB.ISINCODE, ISS.FULLNAME, SE.CODEID, SE.ACCTNO, SE.NETTING, SE.RECEIVING, SE.BLOCKWITHDRAW, SE.WITHDRAW, SE.HOLD, SE.BLOCKED, SE.EMKQTTY, SE.TRADE, SE.MORTAGE, SB.SECTYPE, SE.TRADE1404
            ) SE
            LEFT JOIN (
            -- DANH SACH PHAT SINH GIAO DICH
                SELECT ACCTNO,
                    SUM(
                          CASE WHEN TLTXCD IN ('8895','8896') THEN 0
                               ELSE (
                                     CASE
                                          WHEN TXTYPE ='C' AND FIELD='NETTING' THEN -NAMT
                                          WHEN TXTYPE ='D' AND FIELD='NETTING' THEN NAMT ELSE 0
                                     END
                                     )
                          END

                        ) NAMT_NETTING,
                    SUM(
                            CASE WHEN TLTXCD IN ('8895','8896') THEN 0
                                 ELSE (
                                     CASE
                                          WHEN TXTYPE ='C' AND FIELD='RECEIVING' THEN -NAMT
                                          WHEN TXTYPE ='D' AND FIELD='RECEIVING' THEN NAMT ELSE 0
                                     END
                                      )
                             END
                        ) NAMT_RECEIVING,
                    SUM(
                        CASE
                             WHEN TXTYPE ='C' AND FIELD='BLOCKED' THEN -NAMT
                             WHEN TXTYPE ='D' AND FIELD='BLOCKED' THEN NAMT ELSE 0
                        END
                        ) NAMT_BLOCKED,
                    SUM(
                        CASE
                             WHEN TXTYPE ='C' AND FIELD='TRADE' THEN -NAMT
                             WHEN TXTYPE ='D' AND FIELD='TRADE' THEN NAMT ELSE 0
                        END
                        ) NAMT_TRADE,
                    SUM(
                        CASE
                             WHEN TXTYPE ='C' AND FIELD='EMKQTTY' THEN -NAMT
                             WHEN TXTYPE ='D' AND FIELD='EMKQTTY' THEN NAMT ELSE 0
                        END
                        ) NAMT_EMKQTTY,
                    SUM(
                        CASE
                             WHEN TXTYPE ='C' AND FIELD='MORTAGE' THEN -NAMT
                             WHEN TXTYPE ='D' AND FIELD='MORTAGE' THEN NAMT ELSE 0
                        END
                        ) NAMT_MORTAGE,
                    SUM(
                        CASE
                             WHEN TXTYPE ='C' AND FIELD='HOLD' THEN -NAMT
                             WHEN TXTYPE ='D' AND FIELD='HOLD' THEN NAMT ELSE 0
                        END
                        ) NAMT_HOLD,
                    SUM(
                        CASE
                             WHEN TXTYPE ='C' AND FIELD='WITHDRAW' THEN -NAMT
                             WHEN TXTYPE ='D' AND FIELD='WITHDRAW' THEN NAMT ELSE 0
                        END
                        ) NAMT_WITHDRAW,
                    SUM(
                        CASE
                             WHEN TXTYPE ='C' AND FIELD='BLOCKWITHDRAW' THEN -NAMT
                             WHEN TXTYPE ='D' AND FIELD='BLOCKWITHDRAW' THEN NAMT ELSE 0
                        END
                        ) NAMT_BLOCKWITHDRAW
                FROM VW_SETRAN_GEN VW, SBSECURITIES SB
                WHERE VW.CODEID = SB.CODEID
                AND SB.SECTYPE  IN ('001','002','008','011','004') --trung.luu: 28-01-2021  SHBVNEX-2062 bo sectype 004 o sub_od6008_1( dem qua od6008)
                AND FIELD IN ('NETTING','RECEIVING','BLOCKED','TRADE','MORTAGE','EMKQTTY','HOLD','WITHDRAW','BLOCKWITHDRAW')
                AND busdate > V_INDATE
                GROUP BY ACCTNO
            ) TR
            ON SE.ACCTNO=TR.ACCTNO
            ----------------------------------------
            LEFT JOIN
            (
                SELECT  ETF.AFACCTNO||ETF.CODEID AS ACCTNO,
                        SUM(ETF.QTTY) AS  QTTY_ETF_RECEIVING
                FROM ETFWSAP ETF,(SELECT * FROM ODMAST UNION ALL SELECT * FROM ODMASTHIST) OD
                WHERE ETF.ORDERID = OD.ORDERID
                AND OD.EXECTYPE ='NB'
                AND ETF.DELTD <>'Y'
                AND ETF.TXDATE =V_INDATE
                GROUP BY  ETF.AFACCTNO||ETF.CODEID
            )TI
            ON SE.ACCTNO=TI.ACCTNO
            ----------------------------------------
            LEFT JOIN
            (
                SELECT  ETF.AFACCTNO||ETF.CODEID AS ACCTNO, SUM(ETF.QTTY) AS  QTTY_ETF_NETTING
                FROM ETFWSAP ETF,(SELECT * FROM ODMAST UNION ALL SELECT * FROM ODMASTHIST) OD
                WHERE ETF.ORDERID = OD.ORDERID
                AND OD.EXECTYPE ='NS'
                AND ETF.DELTD <>'Y'
                AND ETF.TXDATE =V_INDATE
                GROUP BY  ETF.AFACCTNO||ETF.CODEID
            )TE
            ON SE.ACCTNO=TE.ACCTNO
            -----------------------------------------
            GROUP BY SE.FUNDNAME, SE.CIFID, SE.CUSTID, SE.FULLNAME, SE.SYMBOL, SE.ISINCODE, SE.CODEID, SE.NETTING, SE.RECEIVING,SE.BLOCKWITHDRAW,SE.WITHDRAW,SE.HOLD, SE.BLOCKED, SE.EMKQTTY, SE.TRADE, SE.MORTAGE, SE.ACCTNO,
            TR.NAMT_NETTING, TR.NAMT_RECEIVING, TR.NAMT_BLOCKED, TR.NAMT_TRADE, TR.NAMT_EMKQTTY, TR.NAMT_MORTAGE, TI.QTTY_ETF_RECEIVING, TE.QTTY_ETF_NETTING, SE.SECTYPE,TR.NAMT_HOLD,TR.NAMT_WITHDRAW,TR.NAMT_BLOCKWITHDRAW
        )MST
        GROUP BY MST.FUNDNAME, MST.FULLNAME, MST.CIFID, MST.CUSTID, MST.FULLNAME, MST.CODEID, MST.SECTYPE,
        REPLACE(MST.SYMBOL,'_WFT',''), MST.ISINCODE
    )RT
    GROUP BY RT.FUNDNAME, RT.ISSFULLNAME, RT.CIFID, RT.CUSTID, RT.SYMBOL, RT.ISINCODE, RT.SECTYPE
)A,
(SELECT * FROM ALLCODE WHERE CDNAME = 'SECTYPE' AND CDTYPE = 'SA') A1
WHERE  (CASE WHEN NETTING = 0 AND RECEIVING = 0 AND BLOCKED =0 AND TRADE = 0 AND TRADE_WTF = 0 THEN 0 ELSE 1 END) = 1
AND A.SECTYPE = A1.CDVAL

UNION ALL -------------------------------
SELECT NUll FUNDNAME,
    NULL ISSFULLNAME,
    NUll CIFID,
    NUll CUSTID,
    NULL SYMBOL,
    NULL ISINCODE,
    NULL SECTYPE,
    0 NETTING,
    0 RECEIVING,
    0 BLOCKED,
    0 TRADE,
    0 TRADE_WTF,
    0 TOTAL,
    TO_CHAR(V_INDATE,'DD/MM/YYYY') INDATE,
    NULL CDCONTENT
FROM DUAL
WHERE NOT EXISTS(
        SELECT 1
        FROM
        (
            SELECT FUNDNAME, ISSFULLNAME, CIFID, CUSTID, SYMBOL, ISINCODE, SECTYPE,
                   SUM(NETTING) + SUM(SE2210_THIEU) NETTING,
                   SUM(RECEIVING) RECEIVING,
                   SUM(BLOCKED) BLOCKED,
                   SUM(TRADE) TRADE,
                   SUM(TRADE_WTF) TRADE_WTF,
                   GREATEST(SUM(NETTING) + SUM(TRADE_WTF) + SUM(BLOCKED) + SUM(TRADE) + sum(se2210_thieu) + sum(TRADE_WTF_2210),0) TOTAL --TRUNG.LUU: 23-11-2020 SHBVNEX-1801(THIEU VSE2210)
            FROM (
                 SELECT
                    MST.FUNDNAME , MST.FULLNAME ISSFULLNAME, MST.CIFID CIFID, MST.CUSTID, MST.CODEID ISSCODEID, MST.SECTYPE,
                    MST.ISINCODE, REPLACE(MST.SYMBOL,'_WFT','') SYMBOL, --GOM MACK CO WFT LAI
                    GREATEST(SUM(MST.NETTING + MST.NAMT_NETTING - MST.QTTY_ETF_NETTING),0) NETTING, --     TRU SL 8864 NETTING
                    GREATEST(SUM(CASE WHEN MST.SYMBOL LIKE '%_WFT' THEN 0 ELSE MST.RECEIVING + MST.NAMT_RECEIVING - MST.QTTY_ETF_RECEIVING END),0) RECEIVING,
                    GREATEST(SUM(CASE WHEN MST.SYMBOL LIKE '%_WFT' THEN 0 ELSE MST.BLOCKED + MST.NAMT_BLOCKED +  MST.MORTAGE+ MST.EMKQTTY +  MST.NAMT_EMKQTTY + MST.NAMT_MORTAGE END),0) BLOCKED,
                    GREATEST(SUM(CASE WHEN MST.SYMBOL LIKE '%_WFT' THEN 0 ELSE MST.TRADE + MST.NAMT_TRADE + MST.TRADE1404 END)) TRADE,
                    GREATEST(SUM(MST.HOLD + MST.NAMT_HOLD + MST.WITHDRAW  + MST.NAMT_WITHDRAW + MST.BLOCKWITHDRAW + MST.NAMT_BLOCKWITHDRAW),0) se2210_thieu,
                    GREATEST(SUM(CASE WHEN MST.SYMBOL LIKE '%_WFT' THEN  MST.EMKQTTY ELSE 0 END), 0) TRADE_WTF_2210,
                    GREATEST(SUM(CASE WHEN MST.SYMBOL LIKE '%_WFT' THEN MST.TRADE + MST.BLOCKED + MST.NAMT_TRADE + MST.NAMT_BLOCKED ELSE 0 END), 0) TRADE_WTF

                FROM (
                    --LAY TOAN BO CO PHIEU CUA CUSTODYCD
                    SELECT SE.FUNDNAME, SE.CIFID, SE.CUSTID, SE.SYMBOL, SE.ISINCODE, SE.FULLNAME, SE.CODEID, SE.ACCTNO, SE.NETTING, SE.RECEIVING, SE.BLOCKWITHDRAW, SE.WITHDRAW, SE.HOLD, SE.BLOCKED, SE.EMKQTTY, SE.TRADE, SE.MORTAGE, NVL(TR.NAMT_NETTING,0) NAMT_NETTING,
                    NVL(TR.NAMT_RECEIVING,0) NAMT_RECEIVING, NVL(TR.NAMT_BLOCKED,0) NAMT_BLOCKED, NVL(TR.NAMT_TRADE,0) NAMT_TRADE, NVL(TR.NAMT_EMKQTTY,0) NAMT_EMKQTTY, NVL(TR.NAMT_MORTAGE,0) NAMT_MORTAGE,
                    NVL(TI.QTTY_ETF_RECEIVING,0) QTTY_ETF_RECEIVING, NVL(TE.QTTY_ETF_NETTING,0) QTTY_ETF_NETTING, SE.SECTYPE,NVL(TR.NAMT_HOLD,0) NAMT_HOLD,NVL(TR.NAMT_WITHDRAW,0)NAMT_WITHDRAW,
                    NVL(TR.NAMT_BLOCKWITHDRAW,0) NAMT_BLOCKWITHDRAW, MAX(SE.TRADE1404) TRADE1404
                    FROM (
                        SELECT CF.FULLNAME FUNDNAME, CF.CIFID, CF.CUSTID, SB.SYMBOL, SB.ISINCODE, ISS.FULLNAME,
                               SE.CODEID, SE.ACCTNO ,SE.NETTING, SE.RECEIVING, SE.BLOCKED, SE.EMKQTTY, SE.TRADE, SE.MORTAGE, SB.SECTYPE, SE.BLOCKWITHDRAW, SE.WITHDRAW, SE.HOLD, SE.TRADE1404
                        FROM SEMAST SE,SBSECURITIES SB, ISSUERS ISS, AFMAST AF,
                        (
                            SELECT CF.*
                            FROM CFMAST CF
                            LEFT JOIN (SELECT * FROM FAMEMBERS WHERE ROLES ='GCB') FA1 ON CF.GCBID =FA1.AUTOID,(SELECT *FROM EMAILREPORT WHERE DELTD <> 'Y') E
                            WHERE CF.CUSTODYCD LIKE V_CUSTODYCD
                            AND NVL(FA1.SHORTNAME,'%') LIKE V_GCB
                            AND CF.STATUS <> 'C'
                            AND CF.CUSTATCOM = 'Y'
                            AND CF.CUSTID = E.CUSTID
                            AND E.REGISTTYPE ='GCB'
                        ) CF
                        WHERE SB.ISSUERID=ISS.ISSUERID
                        AND SB.SECTYPE IN ('001','002','008','011','004') --trung.luu: 28-01-2021  SHBVNEX-2062 bo sectype 004 o sub_od6008_1( dem qua od6008)
                        AND CF.CUSTID = AF.CUSTID
                        AND AF.ACCTNO = SE.AFACCTNO
                        AND SB.CODEID = SE.CODEID
                        GROUP BY CF.FULLNAME, CF.CIFID, CF.CUSTID, SB.SYMBOL, SB.ISINCODE, ISS.FULLNAME, SE.CODEID, SE.ACCTNO, SE.NETTING, SE.RECEIVING, SE.BLOCKWITHDRAW, SE.WITHDRAW, SE.HOLD, SE.BLOCKED, SE.EMKQTTY, SE.TRADE, SE.MORTAGE, SB.SECTYPE, SE.TRADE1404
                    ) SE
                    LEFT JOIN (
                    -- DANH SACH PHAT SINH GIAO DICH
                        SELECT ACCTNO,
                            SUM(
                                  CASE WHEN TLTXCD IN ('8895','8896') THEN 0
                                       ELSE (
                                             CASE
                                                  WHEN TXTYPE ='C' AND FIELD='NETTING' THEN -NAMT
                                                  WHEN TXTYPE ='D' AND FIELD='NETTING' THEN NAMT ELSE 0
                                             END
                                             )
                                  END

                                ) NAMT_NETTING,
                            SUM(
                                    CASE WHEN TLTXCD IN ('8895','8896') THEN 0
                                         ELSE (
                                             CASE
                                                  WHEN TXTYPE ='C' AND FIELD='RECEIVING' THEN -NAMT
                                                  WHEN TXTYPE ='D' AND FIELD='RECEIVING' THEN NAMT ELSE 0
                                             END
                                              )
                                     END
                                ) NAMT_RECEIVING,
                            SUM(
                                CASE
                                     WHEN TXTYPE ='C' AND FIELD='BLOCKED' THEN -NAMT
                                     WHEN TXTYPE ='D' AND FIELD='BLOCKED' THEN NAMT ELSE 0
                                END
                                ) NAMT_BLOCKED,
                            SUM(
                                CASE
                                     WHEN TXTYPE ='C' AND FIELD='TRADE' THEN -NAMT
                                     WHEN TXTYPE ='D' AND FIELD='TRADE' THEN NAMT ELSE 0
                                END
                                ) NAMT_TRADE,
                            SUM(
                                CASE
                                     WHEN TXTYPE ='C' AND FIELD='EMKQTTY' THEN -NAMT
                                     WHEN TXTYPE ='D' AND FIELD='EMKQTTY' THEN NAMT ELSE 0
                                END
                                ) NAMT_EMKQTTY,
                            SUM(
                                CASE
                                     WHEN TXTYPE ='C' AND FIELD='MORTAGE' THEN -NAMT
                                     WHEN TXTYPE ='D' AND FIELD='MORTAGE' THEN NAMT ELSE 0
                                END
                                ) NAMT_MORTAGE,
                            SUM(
                                CASE
                                     WHEN TXTYPE ='C' AND FIELD='HOLD' THEN -NAMT
                                     WHEN TXTYPE ='D' AND FIELD='HOLD' THEN NAMT ELSE 0
                                END
                                ) NAMT_HOLD,
                            SUM(
                                CASE
                                     WHEN TXTYPE ='C' AND FIELD='WITHDRAW' THEN -NAMT
                                     WHEN TXTYPE ='D' AND FIELD='WITHDRAW' THEN NAMT ELSE 0
                                END
                                ) NAMT_WITHDRAW,
                            SUM(
                                CASE
                                     WHEN TXTYPE ='C' AND FIELD='BLOCKWITHDRAW' THEN -NAMT
                                     WHEN TXTYPE ='D' AND FIELD='BLOCKWITHDRAW' THEN NAMT ELSE 0
                                END
                                ) NAMT_BLOCKWITHDRAW
                        FROM VW_SETRAN_GEN VW, SBSECURITIES SB
                        WHERE VW.CODEID = SB.CODEID
                        AND SB.SECTYPE  IN ('001','002','008','011','004') --trung.luu: 28-01-2021  SHBVNEX-2062 bo sectype 004 o sub_od6008_1( dem qua od6008)
                        AND FIELD IN ('NETTING','RECEIVING','BLOCKED','TRADE','MORTAGE','EMKQTTY','HOLD','WITHDRAW','BLOCKWITHDRAW')
                        AND busdate > V_INDATE
                        GROUP BY ACCTNO
                    ) TR
                    ON SE.ACCTNO=TR.ACCTNO
                    ----------------------------------------
                    LEFT JOIN
                    (
                        SELECT  ETF.AFACCTNO||ETF.CODEID AS ACCTNO,
                                SUM(ETF.QTTY) AS  QTTY_ETF_RECEIVING
                        FROM ETFWSAP ETF,(SELECT * FROM ODMAST UNION ALL SELECT * FROM ODMASTHIST) OD
                        WHERE ETF.ORDERID = OD.ORDERID
                        AND OD.EXECTYPE ='NB'
                        AND ETF.DELTD <>'Y'
                        AND ETF.TXDATE =V_INDATE
                        GROUP BY  ETF.AFACCTNO||ETF.CODEID
                    )TI
                    ON SE.ACCTNO=TI.ACCTNO
                    ----------------------------------------
                    LEFT JOIN
                    (
                        SELECT  ETF.AFACCTNO||ETF.CODEID AS ACCTNO, SUM(ETF.QTTY) AS  QTTY_ETF_NETTING
                        FROM ETFWSAP ETF,(SELECT * FROM ODMAST UNION ALL SELECT * FROM ODMASTHIST) OD
                        WHERE ETF.ORDERID = OD.ORDERID
                        AND OD.EXECTYPE ='NS'
                        AND ETF.DELTD <>'Y'
                        AND ETF.TXDATE =V_INDATE
                        GROUP BY  ETF.AFACCTNO||ETF.CODEID
                    )TE
                    ON SE.ACCTNO=TE.ACCTNO
                    -----------------------------------------
                    GROUP BY SE.FUNDNAME, SE.CIFID, SE.CUSTID, SE.FULLNAME, SE.SYMBOL, SE.ISINCODE, SE.CODEID, SE.NETTING, SE.RECEIVING, SE.BLOCKWITHDRAW, SE.WITHDRAW, SE.HOLD, SE.BLOCKED, SE.EMKQTTY, SE.TRADE, SE.MORTAGE, SE.ACCTNO,
                    TR.NAMT_NETTING, TR.NAMT_RECEIVING, TR.NAMT_BLOCKED, TR.NAMT_TRADE, TR.NAMT_EMKQTTY, TR.NAMT_MORTAGE, TI.QTTY_ETF_RECEIVING, TE.QTTY_ETF_NETTING, SE.SECTYPE,TR.NAMT_HOLD,TR.NAMT_WITHDRAW,TR.NAMT_BLOCKWITHDRAW
                )MST
                GROUP BY MST.FUNDNAME, MST.FULLNAME, MST.CIFID, MST.CUSTID, MST.FULLNAME, MST.CODEID, MST.SECTYPE,
                REPLACE(MST.SYMBOL,'_WFT',''), MST.ISINCODE
            )RT
            GROUP BY RT.FUNDNAME, RT.ISSFULLNAME, RT.CIFID, RT.CUSTID, RT.SYMBOL, RT.ISINCODE, RT.SECTYPE
        )A,
        (SELECT * FROM ALLCODE WHERE CDNAME = 'SECTYPE' AND CDTYPE = 'SA') A1
        WHERE  (CASE WHEN NETTING = 0 AND RECEIVING = 0 AND BLOCKED =0 AND TRADE = 0 AND TRADE_WTF = 0 THEN 0 ELSE 1 END) = 1
        AND A.SECTYPE = A1.CDVAL
);
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('od6008_GCB: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
