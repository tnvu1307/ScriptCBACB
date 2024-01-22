SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE od600801(
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

    V_INDATE          DATE;
    V_NEXTINDATE        DATE;
    V_CURRDATE          DATE;
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
     ------------------------------------
     END IF;
     SELECT MIN(SBDATE) INTO V_NEXTINDATE
     FROM SBCLDR
     WHERE CLDRTYPE ='000' AND HOLIDAY='N'
        AND SBDATE > V_INDATE;
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
    ------------------------------------
    V_INDATE   :=     TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    V_CURRDATE    :=     GETCURRDATE;

OPEN PV_REFCURSOR FOR

SELECT RT.*
FROM (
    SELECT
        MST.FUNDNAME FUNDNAME,
        MST.CIFID CIFID,
        MST.CUSTID,
        MST.SYMBOL,
        MST.ISINCODE,
        MST.BONDNAME ISSFULLNAME,
        GREATEST(SUM(MST.NETTING + MST.NAMT_NETTING)*MST.PARVALUE,0) NETTING,
        GREATEST(SUM(MST.RECEIVING + MST.NAMT_RECEIVING)*MST.PARVALUE,0) RECEIVING,
        (SUM(MST.TRADE + MST.NAMT_TRADE) + SUM(MST.MORTAGE +  MST.NAMT_MORTAGE) + SUM(MST.TRADE1404)) * MST.PARVALUE CURRENTFACESETTLED, --CHECK LAI VOI CHI DIEM ==PARVALUE * TRADE
        (
            GREATEST(SUM(MST.RECEIVING + MST.NAMT_RECEIVING),0) +
            GREATEST(SUM(MST.NETTING + MST.NAMT_NETTING),0) +
            SUM(MST.TRADE +  MST.NAMT_TRADE) +
            SUM(MST.MORTAGE +  MST.NAMT_MORTAGE) + SUM(MST.TRADE1404)
        )* MST.PARVALUE AS CURRENTFACETOTAL,
        MST.CCYCD
    FROM (
        --LAY TOAN BO CO PHIEU CUA CUSTODYCD
        SELECT SE.FUNDNAME, SE.CIFID, SE.CUSTID, SE.SYMBOL, SE.ISINCODE, SE.FULLNAME, SE.BONDNAME, SE.ACCTNO, SE.NETTING, SE.RECEIVING, SE.TRADE, NVL(TR.NAMT_NETTING,0) NAMT_NETTING,
               NVL(TR.NAMT_RECEIVING,0) NAMT_RECEIVING, NVL(TR.NAMT_TRADE,0) NAMT_TRADE,SE.MORTAGE,
               NVL(TR.NAMT_MORTAGE,0) NAMT_MORTAGE, SE.CCYCD, SE.PARVALUE, SE.TRADE1404
        FROM (
            SELECT CF.FULLNAME FUNDNAME, CF.CIFID, CF.CUSTID, REPLACE(SB.ISINCODE,'_WFT','') SYMBOL, SB.ISINCODE, ISS.FULLNAME, SB.BONDNAME,
                   SE.ACCTNO ,SE.NETTING, SE.RECEIVING, SE.BLOCKED, SE.EMKQTTY, SE.TRADE, SE.MORTAGE, SC.SHORTCD CCYCD, SB.PARVALUE, SE.TRADE1404
            FROM SBSECURITIES SB, ISSUERS ISS, SBCURRENCY SC, AFMAST AF,
            (
                SELECT CUSTID, AFACCTNO, ACCTNO, CODEID, NETTING, WITHDRAW, BLOCKWITHDRAW, TRADE, HOLD, BLOCKED, MORTAGE, EMKQTTY, RECEIVING, TRADE1404
                FROM SEMAST
            ) SE,
            (
                SELECT CF.*
                FROM CFMAST CF
                LEFT JOIN (SELECT * FROM FAMEMBERS WHERE ROLES ='AMC') FA ON CF.AMCID= FA.AUTOID
                LEFT JOIN (SELECT * FROM FAMEMBERS WHERE ROLES ='GCB') FA1 ON CF.GCBID =FA1.AUTOID
                WHERE CF.CUSTODYCD LIKE V_CUSTODYCD
                AND NVL(FA.SHORTNAME,'%') LIKE V_AMC
                AND NVL(FA1.SHORTNAME,'%') LIKE V_GCB
                AND CF.STATUS <> 'C'
                AND CF.CUSTATCOM = 'Y'
            ) CF
            WHERE SB.ISSUERID=ISS.ISSUERID
            AND SB.SECTYPE NOT IN ('001','002','008','011','004') --trung.luu: 28-01-2021  SHBVNEX-2062 bo sectype 004 o sub_od6008_1( dem qua od6008)
            AND CF.CUSTID = AF.CUSTID
            AND AF.ACCTNO = SE.AFACCTNO
            AND SB.CODEID = SE.CODEID
            --AND SB.SYMBOL NOT LIKE('%_WFT')
            AND SB.CCYCD = SC.CCYCD (+)
            GROUP BY CF.FULLNAME, CF.CIFID, CF.CUSTID, ISS.FULLNAME, SB.BONDNAME, SE.ACCTNO ,SE.NETTING,
                     SE.RECEIVING, SE.BLOCKED,SE.EMKQTTY,SE.TRADE,SE.MORTAGE, SC.SHORTCD, SB.PARVALUE, SE.TRADE1404,
                     REPLACE(SB.ISINCODE,'_WFT',''), SB.ISINCODE
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
                         WHEN TXTYPE ='C' AND FIELD='TRADE' THEN -NAMT
                         WHEN TXTYPE ='D' AND FIELD='TRADE' THEN NAMT ELSE 0
                    END
                    ) NAMT_TRADE,
                SUM(
                    CASE
                         WHEN TXTYPE ='C' AND FIELD='MORTAGE' THEN -NAMT
                         WHEN TXTYPE ='D' AND FIELD='MORTAGE' THEN NAMT ELSE 0
                    END
                    ) NAMT_MORTAGE
            FROM VW_SETRAN_GEN VW, SBSECURITIES SB
            WHERE VW.CODEID = SB.CODEID
            AND SB.SECTYPE NOT IN ('001','002','008','011','004')--trung.luu: 28-01-2021  SHBVNEX-2062 bo sectype 004 o sub_od6008_1( dem qua od6008)
            AND FIELD IN ('NETTING','RECEIVING','TRADE','MORTAGE')
            AND BUSDATE > V_INDATE
            GROUP BY ACCTNO
        ) TR
        ON SE.ACCTNO=TR.ACCTNO
        -----------------------------------------
        GROUP BY SE.FUNDNAME, SE.CIFID, SE.CUSTID, SE.FULLNAME, SE.BONDNAME, SE.SYMBOL, SE.ISINCODE, SE.ACCTNO, SE.NETTING, SE.RECEIVING, SE.TRADE, TR.NAMT_NETTING, TR.NAMT_RECEIVING, TR.NAMT_TRADE, SE.MORTAGE, TR.NAMT_MORTAGE, SE.CCYCD, SE.PARVALUE, SE.TRADE1404
    )MST
    GROUP BY MST.FUNDNAME, MST.CIFID, MST.CUSTID, MST.FULLNAME, MST.BONDNAME, MST.SYMBOL, MST.ISINCODE, MST.CCYCD, MST.PARVALUE
)RT
WHERE (CASE WHEN NETTING = 0 AND RECEIVING = 0 AND CURRENTFACESETTLED = 0 AND CURRENTFACETOTAL = 0 THEN 0 ELSE 1 END) = 1

UNION ALL -------------------------------

SELECT NULL FUNDNAME,
       NULL CIFID,
       NULL CUSTID,
       NULL SYMBOL,
       NULL ISINCODE,
       NULL ISSFULLNAME,
       0 NETTING,
       0 RECEIVING,
       0 CURRENTFACESETTLED, --CHECK LAI VOI CHI DIEM ==PARVALUE * TRADE
       0 CURRENTFACETOTAL,
       NULL CCYCD
FROM DUAL
WHERE NOT EXISTS(
        SELECT 1
        FROM (
            SELECT
                MST.FUNDNAME FUNDNAME,
                MST.CIFID CIFID,
                MST.CUSTID,
                MST.SYMBOL,
                MST.ISINCODE,
                MST.BONDNAME ISSFULLNAME,
                GREATEST(SUM(MST.NETTING + MST.NAMT_NETTING)*MST.PARVALUE,0) NETTING,
                GREATEST(SUM(MST.RECEIVING + MST.NAMT_RECEIVING)*MST.PARVALUE,0) RECEIVING,
                (SUM(MST.TRADE + MST.NAMT_TRADE) + SUM(MST.MORTAGE +  MST.NAMT_MORTAGE) + SUM(MST.TRADE1404)) * MST.PARVALUE CURRENTFACESETTLED, --CHECK LAI VOI CHI DIEM ==PARVALUE * TRADE
                (
                    GREATEST(SUM(MST.RECEIVING + MST.NAMT_RECEIVING),0) +
                    GREATEST(SUM(MST.NETTING + MST.NAMT_NETTING),0) +
                    SUM(MST.TRADE +  MST.NAMT_TRADE) +
                    SUM(MST.MORTAGE +  MST.NAMT_MORTAGE) + SUM(MST.TRADE1404)
                )* MST.PARVALUE AS CURRENTFACETOTAL,
                MST.CCYCD
            FROM (
                --LAY TOAN BO CO PHIEU CUA CUSTODYCD
                SELECT SE.FUNDNAME, SE.CIFID, SE.CUSTID, SE.SYMBOL, SE.ISINCODE, SE.FULLNAME, SE.BONDNAME, SE.ACCTNO, SE.NETTING, SE.RECEIVING, SE.TRADE, NVL(TR.NAMT_NETTING,0) NAMT_NETTING,
                       NVL(TR.NAMT_RECEIVING,0) NAMT_RECEIVING, NVL(TR.NAMT_TRADE,0) NAMT_TRADE,SE.MORTAGE,
                       NVL(TR.NAMT_MORTAGE,0) NAMT_MORTAGE, SE.CCYCD, SE.PARVALUE, SE.TRADE1404
                FROM (
                    SELECT CF.FULLNAME FUNDNAME, CF.CIFID, CF.CUSTID, REPLACE(SB.ISINCODE,'_WFT','') SYMBOL, SB.ISINCODE, ISS.FULLNAME, SB.BONDNAME,
                           SE.ACCTNO ,SE.NETTING, SE.RECEIVING, SE.BLOCKED, SE.EMKQTTY, SE.TRADE, SE.MORTAGE, SC.SHORTCD CCYCD, SB.PARVALUE, SE.TRADE1404
                    FROM SBSECURITIES SB, ISSUERS ISS, SBCURRENCY SC, AFMAST AF,
                    (
                        SELECT CUSTID, AFACCTNO, ACCTNO, CODEID, NETTING, WITHDRAW, BLOCKWITHDRAW, TRADE, HOLD, BLOCKED, MORTAGE, EMKQTTY, RECEIVING, TRADE1404
                        FROM SEMAST
                    ) SE,
                    (
                        SELECT CF.*
                        FROM CFMAST CF
                        LEFT JOIN (SELECT * FROM FAMEMBERS WHERE ROLES ='AMC') FA ON CF.AMCID= FA.AUTOID
                        LEFT JOIN (SELECT * FROM FAMEMBERS WHERE ROLES ='GCB') FA1 ON CF.GCBID =FA1.AUTOID
                        WHERE CF.CUSTODYCD LIKE V_CUSTODYCD
                        AND NVL(FA.SHORTNAME,'%') LIKE V_AMC
                        AND NVL(FA1.SHORTNAME,'%') LIKE V_GCB
                        AND CF.STATUS <> 'C'
                        AND CF.CUSTATCOM = 'Y'
                    ) CF
                    WHERE SB.ISSUERID=ISS.ISSUERID
                    AND SB.SECTYPE NOT IN ('001','002','008','011','004') --trung.luu: 28-01-2021  SHBVNEX-2062 bo sectype 004 o sub_od6008_1( dem qua od6008)
                    AND CF.CUSTID = AF.CUSTID
                    AND AF.ACCTNO = SE.AFACCTNO
                    AND SB.CODEID = SE.CODEID
                    --AND SB.SYMBOL NOT LIKE('%_WFT')
                    AND SB.CCYCD = SC.CCYCD (+)
                    GROUP BY CF.FULLNAME, CF.CIFID, CF.CUSTID, ISS.FULLNAME, SB.BONDNAME, SE.ACCTNO ,SE.NETTING,
                             SE.RECEIVING, SE.BLOCKED,SE.EMKQTTY,SE.TRADE,SE.MORTAGE, SC.SHORTCD, SB.PARVALUE,SE.TRADE1404,
                             REPLACE(SB.ISINCODE,'_WFT',''), SB.ISINCODE
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
                                 WHEN TXTYPE ='C' AND FIELD='TRADE' THEN -NAMT
                                 WHEN TXTYPE ='D' AND FIELD='TRADE' THEN NAMT ELSE 0
                            END
                            ) NAMT_TRADE,
                        SUM(
                            CASE
                                 WHEN TXTYPE ='C' AND FIELD='MORTAGE' THEN -NAMT
                                 WHEN TXTYPE ='D' AND FIELD='MORTAGE' THEN NAMT ELSE 0
                            END
                            ) NAMT_MORTAGE
                    FROM VW_SETRAN_GEN VW, SBSECURITIES SB
                    WHERE VW.CODEID = SB.CODEID
                    AND SB.SECTYPE NOT IN ('001','002','008','011','004')--trung.luu: 28-01-2021  SHBVNEX-2062 bo sectype 004 o sub_od6008_1( dem qua od6008)
                    AND FIELD IN ('NETTING','RECEIVING','TRADE','MORTAGE')
                    AND BUSDATE > V_INDATE
                    GROUP BY ACCTNO
                ) TR
                ON SE.ACCTNO=TR.ACCTNO
                -----------------------------------------
                GROUP BY SE.FUNDNAME, SE.CIFID, SE.CUSTID, SE.FULLNAME, SE.BONDNAME, SE.SYMBOL, SE.ISINCODE, SE.ACCTNO, SE.NETTING, SE.RECEIVING, SE.TRADE, TR.NAMT_NETTING, TR.NAMT_RECEIVING, TR.NAMT_TRADE, SE.MORTAGE, TR.NAMT_MORTAGE, SE.CCYCD, SE.PARVALUE, SE.TRADE1404
            )MST
            GROUP BY MST.FUNDNAME, MST.CIFID, MST.CUSTID, MST.FULLNAME, MST.BONDNAME, MST.SYMBOL, MST.ISINCODE, MST.CCYCD, MST.PARVALUE
        )RT
        WHERE (CASE WHEN NETTING = 0 AND RECEIVING = 0 AND CURRENTFACESETTLED = 0 AND CURRENTFACETOTAL = 0 THEN 0 ELSE 1 END) = 1
);
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('OD600801: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
