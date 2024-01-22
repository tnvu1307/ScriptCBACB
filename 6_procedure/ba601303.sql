SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ba601303 (
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
      SELECT   0 ISSUESID,
               NULL ISSUECODE,
               NULL CODEID,
               NULL SYMBOL,
               NULL TERM, --KY HAN
               NULL EXPDATE, --NGAY DAO HAN
               NULL SECTYPE_NAME,
               NULL EN_SECTYPE_NAME,
               NULL TERM_NAME,
               NULL EN_TERM_NAME,
               0 RATIOVALUE, --TY SO GIA TRI
               0 CASHVAL,
               0 AMT  --SO LUONG TIEN CAM CO
      FROM DUAL
      UNION ALL
      SELECT ISS.AUTOID ISSUESID,
               ISS.ISSUECODE,
               SB.CODEID,
               SB.SYMBOL,
               SB.TERM, --KY HAN
               SB.EXPDATE, --NGAY DAO HAN
               A1.CDCONTENT SECTYPE_NAME,
               A1.EN_CDCONTENT EN_SECTYPE_NAME,
               A2.CDCONTENT TERM_NAME,
               A2.EN_CDCONTENT EN_TERM_NAME,
               BI.TPERCENT RATIOVALUE, --TY SO GIA TRI
               (CASE WHEN SECTYPE IN ('014') THEN SUM(MT.AMT)
                     WHEN SECTYPE IN ('009','013') THEN SUM(MT.QTTY)*SB.PARVALUE
               END)*BI.TPERCENT/100 CASHVAL,
               (CASE WHEN SECTYPE IN ('014') THEN SUM(MT.AMT)
                     WHEN SECTYPE IN ('009','013') THEN SUM(MT.QTTY)*SB.PARVALUE
               END) AMT  --SO LUONG TIEN CAM CO
        FROM SBSECURITIES SB, ALLCODE A1, ISSUES ISS, BONDINFO BI, ALLCODE A2,
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
             ) MT --DANH SACH CK CAM CO
        WHERE     ISS.ISSUECODE = V_ISSUECODE
              AND ISS.AUTOID = BI.ISSUESID
              AND ISS.AUTOID = MT.ISSUESID
              AND BI.TXDATE = V_REPORTDATE
              AND MT.TXDATE <=  V_REPORTDATE
              AND MT.CODEID = SB.CODEID
              AND SB.SECTYPE IN ('009','013','014')
              AND SB.SECTYPE = A1.CDVAL AND A1.CDNAME = 'SECTYPE' AND A1.CDTYPE ='SA'
              AND SB.TYPETERM = A2.CDVAL AND A2.CDNAME = 'TYPETERM' AND A2.CDTYPE ='SA'

              AND BI.SYMBOL = SB.SYMBOL
        GROUP BY ISS.AUTOID, SB.CODEID, SB.SYMBOL, SB.SECTYPE, SB.PARVALUE, A1.CDCONTENT, A1.EN_CDCONTENT, A2.CDCONTENT, A2.EN_CDCONTENT,
                  SB.TERM, SB.EXPDATE, BI.TPERCENT, ISS.ISSUECODE, BI.TXDATE, SB.SECTYPE, BI.BONDPRICE;
    EXCEPTION
      WHEN OTHERS
       THEN
       DBMS_OUTPUT.PUT_LINE('BA601303 ERROR');
       PLOG.ERROR('BA601303: - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
          RETURN;
END;
/
