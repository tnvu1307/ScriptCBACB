SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ba601304 (
    PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
    OPT            IN       VARCHAR2,
    BRID           IN       VARCHAR2,
    I_DATE         IN       VARCHAR2,
    PV_ISSUECODE   IN       VARCHAR2,
    PV_TYPERATE    IN       VARCHAR2
)
IS
    V_STROPTION    VARCHAR2 (5);        -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);        -- USED WHEN V_NUMOPTION > 0
    --
    V_REPORTDATE   DATE;
    V_ISSUECODE    VARCHAR2(50);
    V_TYPERATE     VARCHAR2(3);
BEGIN
    V_STROPTION := OPT;
    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID:= BRID;
    END IF;
    --
    V_ISSUECODE  := PV_ISSUECODE;
    V_TYPERATE   := PV_TYPERATE;
    --
    V_REPORTDATE := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    ----------------------------------------------------------
    OPEN PV_REFCURSOR
    FOR
        SELECT DT.VALUEOFISSUE, DT.MAXLTVRATE, DT.TYPERATE_NAME,
            ROUND(
                CASE WHEN V_TYPERATE = '002' THEN (CASE WHEN SUM(DT.PRICE) = 0 THEN 0 ELSE DT.VALUEOFISSUE/SUM(DT.PRICE) END)
                     WHEN V_TYPERATE = '003' THEN (CASE WHEN DT.VALUEOFISSUE = 0 THEN 0 ELSE SUM(DT.PRICE)/DT.VALUEOFISSUE END)
                     ELSE 0
                END
            , 10) LTVRATE
        FROM
        (
            SELECT ISS.AUTOID ISSUESID, ISS.VALUEOFISSUE, ISS.MAXLTVRATE/100 MAXLTVRATE, ISS.TYPERATE, A2.CDCONTENT TYPERATE_NAME,
                  ROUND(
                    CASE WHEN SB.SECTYPE IN ('001','008','011','003','006') THEN SUM(MT.QTTY)*NVL(MRK.SHAREPRICE,BI.BONDPRICE)
                         ELSE (CASE WHEN SECTYPE IN ('014') THEN SUM(MT.AMT)
                                    WHEN SECTYPE IN ('009','013') THEN SUM(MT.QTTY)*SB.PARVALUE
                                    ELSE 0
                              END) *BI.TPERCENT/100
                    END
                   , 10) PRICE
            FROM SBSECURITIES SB, ISSUES_HIST ISS, BONDINFO BI,
                 (
                    SELECT * FROM ALLCODE WHERE CDNAME = 'SECTYPE' AND CDTYPE ='SA'
                 ) A1,
                 (
                    SELECT * FROM ALLCODE WHERE CDNAME ='TYPERATE' AND CDTYPE ='CB'
                 ) A2,
                 (
                    SELECT REPLACE(SE.ACCTNO,SE.AFACCTNO,'') CODEID, SE.ISSUESID, SE.TXDATE,
                           SUM(CASE WHEN SE.TLTXCD IN ('2232') THEN SE.QTTY
                                    WHEN SE.TLTXCD IN ('2233') THEN -SE.QTTY ELSE 0 END) QTTY, 0 AMT
                    FROM SEMORTAGE SE
                    WHERE SE.STATUS IN ('C')
                          AND SE.DELTD <> 'Y'
                          AND SE.ISSUESID IS NOT NULL
                    GROUP BY SE.ACCTNO, SE.AFACCTNO, SE.ISSUESID, SE.TXDATE
                    UNION ALL
                    SELECT REPLACE(SE.ACCTNO,SE.AFACCTNO,'') CODEID, SE.ISSUESID, SE.TXDATE,
                           SUM(CASE WHEN SE.TLTXCD IN ('1900') THEN SE.QTTY
                                    WHEN SE.TLTXCD IN ('1901') THEN -SE.QTTY ELSE 0 END) QTTY, 0 AMT
                    FROM SEMORTAGE SE
                    WHERE SE.STATUS IN ('C')
                          AND SE.DELTD <> 'Y'
                          AND SE.ISSUESID IS NOT NULL
                    GROUP BY SE.ACCTNO, SE.AFACCTNO, SE.ISSUESID, SE.TXDATE
                    UNION ALL
                    SELECT BL.CODEID, BL.ISSUESID, BL.TXDATE,
                           0 QTTY,
                           SUM(CASE WHEN BL.TLTXCD IN ('1909') THEN BL.AMT
                                    WHEN BL.TLTXCD IN ('1910') THEN -BL.AMT ELSE 0 END) AMT
                    FROM BLOCKAGE BL
                    WHERE BL.DELTD <> 'Y'
                          AND BL.ISSUESID IS NOT NULL
                    GROUP BY BL.CODEID, BL.ISSUESID, BL.TXDATE
                 ) MT, --DANH SACH CK CAM CO
                 (
                    SELECT MK.SYMBOL, BO.ISSUESID,
                           ROUND(
                                CASE WHEN BO.SECTYPE = '111' THEN (
                                     CASE WHEN BO.VALMETHOD = '001' THEN AVG(MK.PCLOSED)
                                          ELSE (CASE WHEN SUM(MK.TRANVALUE) = 0 THEN 0 ELSE SUM(MK.TRANVALUE)/SUM(MK.VOLUME) END)
                                     END)
                                ELSE 0 END
                            ,10) SHAREPRICE
                    FROM SBREFMRKDATA MK,
                    (
                        SELECT DISTINCT TRIM(REGEXP_SUBSTR(BO.TICKERLIST,'[^,]+', 1, LEVEL)) SYMBOL,
                               BO.ACTYPE, BO.SECTYPE, BO.VALMETHOD, BO.ISSUESID, BO.XPARAM
                        FROM BONDTYPE BO
                        CONNECT BY REGEXP_SUBSTR(BO.TICKERLIST, '[^,]+', 1, LEVEL) IS NOT NULL
                    ) BO
                    WHERE MK.SYMBOL = BO.SYMBOL
                    AND MK.TRADINGDT <= V_REPORTDATE
                    AND MK.TRADINGDT > (SELECT SBDATE
                                        FROM (
                                            SELECT ROWNUM DAY, CLDR.SBDATE
                                            FROM (
                                                SELECT SBDATE
                                                FROM SBCLDR
                                                WHERE SBDATE < V_REPORTDATE
                                                AND HOLIDAY = 'N'
                                                AND CLDRTYPE = '001'
                                                ORDER BY SBDATE DESC
                                            ) CLDR
                                        ) RL
                                        WHERE RL.DAY = BO.XPARAM)
                    GROUP BY MK.SYMBOL, BO.XPARAM, BO.VALMETHOD, BO.SECTYPE, BO.ISSUESID
                 ) MRK
            WHERE     ISS.ISSUECODE = V_ISSUECODE
                  AND ISS.HISTDATE = V_REPORTDATE
                  AND ISS.AUTOID = MT.ISSUESID
                  AND ISS.AUTOID = BI.ISSUESID
                  AND ISS.HISTDATE = BI.TXDATE
                  AND MT.TXDATE <= V_REPORTDATE
                  AND MT.CODEID = SB.CODEID
                  AND SB.SECTYPE IN ('001','008','011','003','006','009','013','014')
                  AND SB.SECTYPE = A1.CDVAL
                  AND SB.SYMBOL = BI.SYMBOL
                  AND A2.CDVAL = V_TYPERATE
                  AND SB.SYMBOL = MRK.SYMBOL(+)
                  AND ISS.AUTOID = MRK.ISSUESID(+)
            GROUP BY ISS.AUTOID, SB.CODEID, SB.SYMBOL, SB.SECTYPE, SB.PARVALUE, A1.CDCONTENT, A1.EN_CDCONTENT,
                     SB.EXPDATE, BI.TXDATE, SB.SECTYPE, BI.BONDPRICE, BI.TPERCENT, ISS.VALUEOFISSUE, ISS.LTVRATE,
                     ISS.TYPERATE, A2.CDCONTENT, ISS.MAXLTVRATE, MRK.SHAREPRICE
        ) DT
        GROUP BY DT.ISSUESID, DT.VALUEOFISSUE, DT.MAXLTVRATE, DT.TYPERATE, DT.TYPERATE_NAME
        ;
    EXCEPTION
      WHEN OTHERS
       THEN
       PLOG.ERROR('BA601304: - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
          RETURN;
END;
/
