SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ba601302 (
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
    V_X            NUMBER;
    V_X1           NUMBER;
    V_X2           NUMBER;
    V_Y            NUMBER;
    V_Y1           NUMBER;
    V_Y2           NUMBER;
    V_RESULT       NUMBER;
    V_TYPERATE     VARCHAR2(3);
    pkgctx   plog.log_ctx;
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
               NULL ISSUECODE, --MA DOT PHAT HANH
               NULL CODEID,
               NULL SYMBOL,
               NULL ISSUEDATE, --NGAY PHAT HANH
               NULL MATURITYDATE, --NGAY DAO HAN
               0 RATE, --LAI SUAT
               0 FREQUENCY, --SO KY TRA LAI TRONG NAM
               0 REDEMPTION, --TI LE GOC THANH TOAN DAO HAN
               0 FACEAMOUNT, --MENH GIA
               NULL VALUATIONDATE, --NGAY DINH GIA
               NULL SETTLEDATE, --NGAY THANH TOAN
               0 TTM, -- KY HAN THUC TE
               0 TTM_LOWER, -- KY HAN CAN DUOI
               0 TTM_UPPER, -- KY HAN CAN TREN
               0 YTM_LOWER, -- LOI TUC CAN DUOI
               0 YTM_UPPER, -- LOI TUC CAN TREN
               NULL COUTINGDAY, --CACH TINH NGAY
               0 YIELD, -- LOI TUC
               NULL EN_SECTYPE_NAME, --LOAI CHUNG KHOAN
               0 XPARAM,
               0 BONDPRICE, --GIA TRAI PHIEU
               0 BONDVAL, --GIA TRI TRAI PHIEU CAM CO
               0 QTTY --SO LUONG TRAI PHIEU CAM CO
        FROM DUAL
        UNION ALL
        SELECT ISS.AUTOID ISSUESID,
               ISS.ISSUECODE, --MA DOT PHAT HANH
               SB.CODEID,
               SB.SYMBOL,
               SB.ISSUEDATE ISSUEDATE, --NGAY PHAT HANH
               SB.EXPDATE MATURITYDATE, --NGAY DAO HAN
               SB.INTCOUPON/100 RATE, --LAI SUAT
               DECODE(SB.PERIODINTEREST,'001',360,'002',12,'003',4,'004',2,'005',1) FREQUENCY, --SO KY TRA LAI TRONG NAM
               100 REDEMPTION, --TI LE GOC THANH TOAN DAO HAN
               SB.PARVALUE FACEAMOUNT, --MENH GIA
               V_REPORTDATE VALUATIONDATE, --NGAY DINH GIA
               IP.SETTLEDATE, --NGAY THANH TOAN
               IP.TTM, -- KY HAN THUC TE
               IP.TTM_LOWER, -- KY HAN CAN DUOI
               IP.TTM_UPPER, -- KY HAN CAN TREN
               IP.YTM_LOWER YTM_LOWER, -- LOI TUC CAN DUOI
               IP.YTM_UPPER YTM_UPPER, -- LOI TUC CAN TREN
               'ACT/'||SB.INTERESTDATE COUTINGDAY, --CACH TINH NGAY
               IP.YIELD YIELD, -- LOI TUC
               A1.EN_CDCONTENT EN_SECTYPE_NAME, --LOAI CHUNG KHOAN
               BI.XPARAM,
               BI.BONDPRICE, --GIA TRAI PHIEU
               SUM(MT.QTTY)*BI.BONDPRICE BONDVAL, --GIA TRI TRAI PHIEU CAM CO
               SUM(MT.QTTY) QTTY --SO LUONG TRAI PHIEU CAM CO
        FROM SBSECURITIES SB, ALLCODE A1, ISSUES ISS, BONDINTERPOLATE IP,
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
             ) MT --DANH SACH CK CAM CO
        WHERE     ISS.ISSUECODE = V_ISSUECODE
              AND ISS.AUTOID = MT.ISSUESID
              AND ISS.AUTOID = BI.ISSUESID
              AND BI.TXDATE = V_REPORTDATE
              AND MT.TXDATE <= V_REPORTDATE
              AND MT.CODEID = SB.CODEID
              AND SB.SECTYPE IN ('003','006')
              AND SB.SECTYPE = A1.CDVAL(+) AND A1.CDNAME(+) = 'SECTYPE' AND A1.CDTYPE(+) ='SA'
              AND BI.SYMBOL = SB.SYMBOL
              AND BI.TXDATE = IP.TXDATE
              AND IP.SYMBOL = SB.SYMBOL
        GROUP BY ISS.AUTOID, SB.CODEID, SB.SYMBOL, SB.SECTYPE, A1.EN_CDCONTENT, SB.INTERESTDATE,
                 ISS.ISSUECODE, BI.TXDATE, SB.SECTYPE, BI.XPARAM, SB.ISSUEDATE, BI.BONDPRICE,
                 SB.EXPDATE, SB.INTCOUPON, SB.PERIODINTEREST, SB.PARVALUE, IP.SETTLEDATE,
                 IP.TTM, IP.TTM_LOWER, IP.TTM_UPPER, IP.YTM_LOWER, IP.YTM_UPPER, IP.YIELD;
    EXCEPTION
      WHEN OTHERS
       THEN
       DBMS_OUTPUT.PUT_LINE('BA601302 ERROR');
       plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
          RETURN;
END;
/
