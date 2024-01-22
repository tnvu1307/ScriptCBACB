SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ba601301 (
    PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
    OPT            IN       VARCHAR2,
    BRID           IN       VARCHAR2,
    I_DATE         IN       VARCHAR2,
    PV_ISSUECODE   IN       VARCHAR2,
    PV_TYPERATE    IN       VARCHAR2
)
IS
    -- ReportName: LTV calculation Share, Bond, Cash
    -- BA6013:     Main proc
    -- BA601301:   LTV calculation Share proc
    -- BA601302:   LTV calculation Bond proc
    -- BA601303:   LTV calculation Cash proc
    -- Person      Date                 Comments
    -- ---------   ------               -------------------------------------------
    -- NAM.LY      06-04-2020           created
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
        SELECT 0 ISSUESID,
               NULL ISSUECODE,
               NULL CODEID,
               NULL SYMBOL,
               NULL EN_SECTYPE_NAME,
               0 XPARAM,
               NULL EN_XPARAM,
               NULL TRADINGDT, --NGAY THAM CHIEU
               0 PCLOSED, --NGAY DONG CUA DIEU CHINH
               0 VOLUME, --KHOI LUONG GIAO DICH KHOP
               0 TRANVALUE, --TONG GIA TRI GIAO DICH
               0 SHAREPRICE, --GIA CO PHIEU BINH QUAN
               0 SHAREVAL, --GIA TRI CO PHIEU CAM CO
               0 QTTY --SO LUONG CO PHIEU CAM CO
        FROM DUAL
        UNION ALL
        SELECT ISS.AUTOID ISSUESID,
               ISS.ISSUECODE,
               SB.CODEID,
               SB.SYMBOL,
               A1.EN_CDCONTENT EN_SECTYPE_NAME,
               BI.XPARAM,
               TO_CHAR (TO_DATE (BI.XPARAM, 'j'), 'jsp') EN_XPARAM,
               MRK.TRADINGDT, --NGAY THAM CHIEU
               MRK.PCLOSED, --NGAY DONG CUA DIEU CHINH
               MRK.VOLUME, --KHOI LUONG GIAO DICH KHOP
               MRK.TRANVALUE, --TONG GIA TRI GIAO DICH
               --BI.BONDPRICE SHAREPRICE, --GIA CO PHIEU BINH QUAN
               MRK2.SHAREPRICE SHAREPRICE, --GIA CO PHIEU BINH QUAN
               ROUND(SUM(MT.QTTY) * MRK2.SHAREPRICE,10) SHAREVAL, --GIA TRI CO PHIEU CAM CO
               SUM(MT.QTTY) QTTY --SO LUONG CO PHIEU CAM CO
        FROM SBSECURITIES SB, ALLCODE A1, ISSUES ISS,
             (
                SELECT BI.*, BO.XPARAM
                FROM (
                        SELECT DISTINCT TRIM(REGEXP_SUBSTR(BO.TICKERLIST,'[^,]+', 1, LEVEL)) SYMBOL,
                               BO.ACTYPE, BO.SECTYPE, BO.VALMETHOD, BO.ISSUESID, BO.XPARAM
                        FROM BONDTYPE BO
                        CONNECT BY REGEXP_SUBSTR(BO.TICKERLIST, '[^,]+', 1, LEVEL) IS NOT NULL
                     ) BO, BONDINFO BI
                WHERE BO.SYMBOL = BI.SYMBOL
                      AND BO.ACTYPE = BI.BONDACTYPE
                      AND BO.ISSUESID = BI.ISSUESID
                      AND BO.VALMETHOD = BI.PRICETYPE
             ) BI, --DINH GIA CK CAM CO
             (
                SELECT REPLACE(SE.ACCTNO,SE.AFACCTNO,'') CODEID, SE.ISSUESID, SE.TXDATE,
                    SUM(CASE WHEN SE.TLTXCD IN ('2232') THEN SE.QTTY
                             WHEN SE.TLTXCD IN ('2233') THEN -SE.QTTY ELSE 0 END) QTTY
                FROM SEMORTAGE SE
                WHERE SE.STATUS IN ('C')
                      AND SE.DELTD <> 'Y'
                      AND SE.ISSUESID IS NOT NULL
                GROUP BY SE.ACCTNO, SE.AFACCTNO, SE.ISSUESID, SE.TXDATE
                UNION ALL
                SELECT REPLACE(SE.ACCTNO,SE.AFACCTNO,'') CODEID, SE.ISSUESID, SE.TXDATE,
                    SUM(CASE WHEN SE.TLTXCD IN ('1900') THEN SE.QTTY
                             WHEN SE.TLTXCD IN ('1901') THEN -SE.QTTY ELSE 0 END) QTTY
                FROM SEMORTAGE SE
                WHERE SE.STATUS IN ('C')
                      AND SE.DELTD <> 'Y'
                      AND SE.ISSUESID IS NOT NULL
                GROUP BY SE.ACCTNO, SE.AFACCTNO, SE.ISSUESID, SE.TXDATE
             ) MT, --DANH SACH CK CAM CO
             (
                SELECT MK.*, BO.ISSUESID
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
             ) MRK,
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
           ) MRK2
        WHERE     ISS.ISSUECODE = V_ISSUECODE
              AND ISS.AUTOID = MT.ISSUESID
              AND ISS.AUTOID = BI.ISSUESID
              AND ISS.AUTOID = MRK.ISSUESID
              AND ISS.AUTOID = MRK2.ISSUESID
              AND BI.TXDATE = V_REPORTDATE
              AND MT.TXDATE <= V_REPORTDATE
              AND MT.CODEID = SB.CODEID
              AND SB.SECTYPE IN ('001','008','011')
              AND SB.SECTYPE = A1.CDVAL(+) AND A1.CDNAME(+) = 'SECTYPE' AND A1.CDTYPE(+) ='SA'
              AND BI.SYMBOL = SB.SYMBOL
              AND MRK.SYMBOL = SB.SYMBOL
              AND MRK2.SYMBOL = SB.SYMBOL
        GROUP BY ISS.AUTOID, SB.CODEID, SB.SYMBOL, SB.SECTYPE,SB.PARVALUE, A1.EN_CDCONTENT,
                 ISS.ISSUECODE, BI.TXDATE, SB.SECTYPE, BI.XPARAM, MRK.TRADINGDT, MRK.PCLOSED,
                 MRK.VOLUME, MRK.TRANVALUE, BI.BONDPRICE, MRK2.SHAREPRICE;
    EXCEPTION
      WHEN OTHERS
       THEN
       DBMS_OUTPUT.PUT_LINE('BA601301 ERROR');
       PLOG.ERROR('BA601301: - ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
          RETURN;
END;
/
