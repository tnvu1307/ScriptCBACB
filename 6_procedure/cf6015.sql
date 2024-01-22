SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CF6015 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   PV_REPORT_DT           IN       VARCHAR2, /*Ngay tao bao cao*/
   PV_CUSTODYCD           IN       VARCHAR2, /*So TK Luu ky */
   PV_TXNUM               IN       VARCHAR2 /*SO CHUNG TU*/
   )
IS
    -- Thong ke danh muc dau tu cua nha dau tu nuoc ngoai
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- LAMGK       22-10-2019           created
    -- NAM.LY      07-11-2019           updated
    V_STROPTION    VARCHAR2 (5);
    V_STRBRID      VARCHAR2 (4);

    --v_CurrDate     date;
    v_CustodyCD    varchar2(20);
    v_Report_Date  date;
    v_count_itemcd INT;
    v_TXNUM        VARCHAR2(10);
BEGIN

    V_STROPTION := OPT;
    v_TXNUM := PV_TXNUM;
    --v_CurrDate   := getcurrdate;
    v_Report_Date  :=  TO_DATE(PV_REPORT_DT, SYSTEMNUMS.C_DATE_FORMAT);
    if v_stroption = 'A' then
        v_strbrid := '%';
    elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
    else
        v_strbrid:=brid;
    end if;

    v_CustodyCD := REPLACE(PV_CUSTODYCD,'.','');

    /*
OPEN PV_REFCURSOR FOR
     SELECT CF.CUSTID
          , UPPER(CF.FULLNAME) FULLNAME --TEN KHACH HANG
          , CF.ADDRESS --DIA CHI
          , CST_TP.CDCONTENT CUST_TYPE --LOAI KHACH HANG
          --, CF.CUSTTYPE --LOAI KHACH HNAG
          , CST_COUNTRY.CDCONTENT NATIONALITY
          --, CF.COUNTRY
          , CF.CIFID -- MA GD CK
          , CF.IDCODE -- SO DK SO HUU
          , CF.IDDATE -- NGAY CAP
          , CF.IDPLACE -- NOI CAP
          , CF.CUSTODYCD -- TK luu ky CK
          , (
              CASE WHEN COUNTRY ='234' THEN SUBSTR(CF.CUSTODYCD,5,6)
                  ELSE TRADINGCODE
              END
            ) TRADING_CODE -- MA Giao dich CK, --tham khao CF6007
          , CF.TRADINGCODE
          , CF.TRADINGCODEDT  -- NGAY CAP GIAO DICH CK
          , SE_DETAIL.SYMBOL --MA CHUNG KHOAN
          , SE_DETAIL.CUSTODYCD --SO TAI KHOAN LUU KY
          , SE_DETAIL.SYMBOL_TYPE --LOAI CHUNG KHOAN
          , SE_DETAIL.QUANTITY --KHOI LUONG CHUNG KHOAN
          , DECODE(SE_DETAIL.SYMBOL_TYPE_ORDER, 0, 'A'
                                              , 5, 'B'
                  ) SYMBOL_TYPE_ORDER--SU DUNG DE XEP THU TU CUA LOAI CHUNG KHOAN
      FROM CFMAST CF
          --LOAI KHACH HANG
          LEFT JOIN (SELECT CDCONTENT, CDVAL FROM ALLCODE WHERE CDNAME ='CUSTTYPE' AND CDTYPE ='CF') CST_TP ON CST_TP.CDVAL = CF.CUSTTYPE
          --QUOC TICH
          LEFT JOIN (SELECT CDCONTENT, CDVAL FROM ALLCODE WHERE CDNAME ='COUNTRY' AND CDTYPE ='CF') CST_COUNTRY ON CST_COUNTRY.CDVAL = CF.COUNTRY
          --THONG TIN HIEN TAI KHOI LUONG CHUNG KHOAN CUA KHACH HANG
          LEFT JOIN
          (
              SELECT SE.CUSTID
                  , TR.CUSTODYCD --SO TAI KHOAN LUU KY
                  , TR.SYMBOL
                  , A1.CDCONTENT SYMBOL_TYPE --LOAI CHUNG KHOAN
                  , A1.LSTODR SYMBOL_TYPE_ORDER --SAP XEP THU TU CUA LOAI CHUNG KHOAN
                  --, SE.TRADE
                  --, TR.NAMT
                  , SE.TRADE - NVL(TR.NAMT,0) QUANTITY
              FROM SEMAST SE --THONG TIN HIEN TAI KHOI LUONG CHUNG KHOAN CUA KHACH HANG
                  , SBSECURITIES SB --THONG TIN CHUNG KHOAN, PHAN LOAI CHUNG KHOAN
                  , ALLCODE A1 --LAY LOAI CO PHIEU
                -- PHAT SINH TU NGAY FROM DATE - 1 DEN NGAY HIEN TAI
                , (
                    SELECT CUSTODYCD --SO TAI KHOAN LUU KY
                          , ACCTNO --SO TAI KHOAN
                          , SYMBOL --MA CHUNG KHOAN
                          , SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                    FROM VW_SETRAN_GEN
                    WHERE  FIELD IN ('TRADE') AND TXDATE > v_Report_Date --FILTER
                    GROUP BY CUSTODYCD, ACCTNO, SYMBOL
                )TR
                WHERE SE.ACCTNO = TR.ACCTNO (+)
                    AND SE.CODEID = SB.CODEID
                    AND A1.CDVAL = SB.SECTYPE AND A1.CDNAME ='SECTYPE' AND A1.CDTYPE='SA'
          )SE_DETAIL ON SE_DETAIL.CUSTID = CF.CUSTID
          WHERE CF.CUSTODYCD = v_CustodyCD; --FILTER;
          */
--XOA DU LIEU CU
DELETE FROM MIS_ITEM_NEW_RESULTS
WHERE GROUPID='CF6015'
      AND FDATE = v_Report_Date
      AND CUSTODYCD = v_CustodyCD;
COMMIT;

--THEM DU LIEU MOI
INSERT INTO MIS_ITEM_NEW_RESULTS (SUBBRID,GROUPID,ITEMCD,CUSTID,CUSTODYCD,FDATE,QTTY,SYMBOL)
(
    SELECT '0002' SUBBRID
         , 'CF6015' GROUPID
         , DECODE(SB.SECTYPE,'111','A','012','B','006','C') ITEMCD
         , SE.CUSTID CUSTID
         , v_CustodyCD CUSTODYCD
         , v_Report_Date FDATE
         , NVL(SUM(SE.TRADE + SE.NETTING + SE.BLOCKED - NVL(TR.NAMT,0)),0) QTTY
         , (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END) SYMBOL
    FROM CFMAST CF LEFT JOIN SEMAST SE ON CF.CUSTID = SE.CUSTID
                JOIN (
                       SELECT SB.CODEID
                            , SB.SYMBOL
                            , (CASE WHEN SB.SECTYPE IN ('001','002','008') THEN '111' ELSE --CO PHIEU, CHUNG CHI QUY
                              (CASE WHEN SB.SECTYPE IN ('003','006') THEN '006' ELSE SB.SECTYPE END) END) SECTYPE --TRAI PHIEU
                            , SB1.CODEID REFCODEID
                            , SB1.SYMBOL REFSYMBOL
                       FROM SBSECURITIES SB, SBSECURITIES SB1
                       WHERE SB.REFCODEID = SB1.CODEID(+) AND SB.SECTYPE <> '004'
                     ) SB ON SB.CODEID = SE.CODEID AND
                             SB.SECTYPE IN ('111','012','006') -- CO PHIEU, CHUNG CHI QUY/ TIN PHIEU / TRAI PHIEU
                 LEFT JOIN (
                              SELECT CUSTODYCD
                                   , ACCTNO
                                   , SYMBOL
                                   , TXDATE
                                   , SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                              FROM VW_SETRAN_GEN
                              WHERE TXDATE > v_Report_Date AND
                                    FIELD IN ('TRADE','NETTING','BLOCKED')
                              GROUP BY CUSTODYCD, ACCTNO, SYMBOL, TXDATE
                           ) TR ON SE.ACCTNO = TR.ACCTNO
    WHERE CF.CUSTODYCD = v_CustodyCD
    GROUP BY SE.CUSTID, SB.SECTYPE, TR.CUSTODYCD,
       (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END),
       (CASE WHEN SB.REFCODEID IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
UNION ALL
    SELECT '0002' SUBBRID
         , 'CF6015' GROUPID
         , 'D' ITEMCD
         , SE.CUSTID CUSTID
         , v_CustodyCD CUSTODYCD
         , v_Report_Date FDATE
         , NVL(SUM(SE.TRADE + SE.NETTING + SE.BLOCKED - NVL(TR.NAMT,0)),0) QTTY
         , (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END) SYMBOL
    FROM CFMAST CF LEFT JOIN SEMAST SE ON CF.CUSTID = SE.CUSTID
                 JOIN (
                       SELECT SB.CODEID
                            , SB.SYMBOL
                            , (CASE WHEN SB.SECTYPE IN ('001','002','008') THEN '111' ELSE --CO PHIEU, CHUNG CHI QUY
                              (CASE WHEN SB.SECTYPE IN ('003','006') THEN '006' ELSE SB.SECTYPE END) END) SECTYPE --TRAI PHIEU
                            , SB1.CODEID REFCODEID
                            , SB1.SYMBOL REFSYMBOL
                       FROM SBSECURITIES SB, SBSECURITIES SB1
                       WHERE SB.REFCODEID = SB1.CODEID(+) AND SB.SECTYPE <> '004'
                      ) SB ON SB.CODEID = SE.CODEID AND
                             SB.SECTYPE NOT IN ('111','012','006') -- CAC LOAI KHAC
                 LEFT JOIN (
                              SELECT CUSTODYCD
                                   , ACCTNO
                                   , SYMBOL
                                   , TXDATE
                                   , SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                              FROM VW_SETRAN_GEN
                              WHERE TXDATE > v_Report_Date AND
                                    FIELD IN ('TRADE','NETTING','BLOCKED')
                              GROUP BY CUSTODYCD, ACCTNO, SYMBOL, TXDATE
                           ) TR ON SE.ACCTNO = TR.ACCTNO
    WHERE CF.CUSTODYCD = v_CustodyCD
    GROUP BY SE.CUSTID, SB.SECTYPE, TR.CUSTODYCD,
       (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END),
       (CASE WHEN SB.REFCODEID IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
)
;

--KIEM TRA DU 3 LOAI SECTYPE CHUA, KHONG THI INSERT
FOR CHECK_ITEMCD IN (
           SELECT *
           FROM MIS_ITEMS_NEW
           WHERE GROUPID = 'CF6015')
LOOP
       SELECT COUNT(*)  INTO v_count_itemcd
       FROM MIS_ITEM_NEW_RESULTS
       WHERE FDATE = v_Report_Date AND
             ITEMCD = CHECK_ITEMCD.ITEMCD AND
             GROUPID = 'CF6015' AND
             CUSTODYCD = v_CustodyCD;

       IF (v_count_itemcd = 0 )
       THEN
           BEGIN
               INSERT INTO MIS_ITEM_NEW_RESULTS (SUBBRID,GROUPID,ITEMCD,CUSTID,CUSTODYCD,FDATE,QTTY,SYMBOL)
               SELECT '0002' SUBBRID
                    , 'CF6015' GROUPID
                    , CHECK_ITEMCD.ITEMCD ITEMCD
                    , (SELECT DISTINCT CUSTID FROM MIS_ITEM_NEW_RESULTS WHERE CUSTODYCD =v_CustodyCD AND CUSTID IS NOT NULL) CUSTID
                    , v_CustodyCD CUSTODYCD
                    , v_Report_Date FDATE
                    , 0 QTTY
                    , '' SYMBOL
               FROM DUAL;
           END;
       END IF;
END LOOP;

--
UPDATE MIS_ITEM_NEW_RESULTS SET GROUP1 = DECODE(ITEMCD,'A','1','B','1','C','1','D','2')
WHERE GROUPID = 'CF6015' AND FDATE = v_Report_Date;
--

OPEN PV_REFCURSOR FOR
    SELECT CF.CUSTID
        , UPPER(CF.FULLNAME) FULLNAME --TEN KHACH HANG
        , CF.ADDRESS --DIA CHI
        , CST_TP.CDCONTENT CUST_TYPE --LOAI KHACH HANG
        , CST_COUNTRY.CDCONTENT NATIONALITY --QUOC TICH
        , CF.CIFID -- MA GD CK
        , CF.IDCODE -- SO DK SO HUU
        , CF.IDDATE -- NGAY CAP
        , CF.IDPLACE -- NOI CAP
        , CF.CUSTODYCD -- TK luu ky CK
        , (CASE WHEN COUNTRY ='234' THEN SUBSTR(CF.CUSTODYCD,5,6) ELSE TRADINGCODE END) TRADINGCODE -- MA Giao dich CK, --tham khao CF6007
        , CF.TRADINGCODEDT  -- NGAY CAP GIAO DICH CK
        , SE_DETAIL.SYMBOL --MA CHUNG KHOAN
        , TO_NUMBER(SE_DETAIL.QTTY) QTTY --KHOI LUONG CHUNG KHOAN
        , SE_DETAIL.ITEMNAME SYMBOL_TYPE
        , SE_DETAIL.ITEMCD SYMBOL_ORDER
        , SE_DETAIL.GROUP1
        , TO_CHAR(v_Report_Date,'DD/MM/RRRR') REPORTED_DATE
        , v_TXNUM TXNUM
    FROM CFMAST CF LEFT JOIN (
                              SELECT ITEM.ITEMCD
                                   , ITEM.ITEMNAME
                                   , RESULTS.CUSTID CUSTID
                                   , RESULTS.SYMBOL
                                   , RESULTS.QTTY
                                   , RESULTS.GROUP1
                              FROM MIS_ITEM_NEW_RESULTS RESULTS LEFT JOIN MIS_ITEMS_NEW ITEM ON ITEM.ITEMCD = RESULTS.ITEMCD
                              WHERE RESULTS.GROUPID='CF6015' AND
                                    RESULTS.SUBBRID ='0002' AND
                                    ITEM.GROUPID = RESULTS.GROUPID AND
                                    RESULTS.FDATE = v_Report_Date
                             ) SE_DETAIL ON SE_DETAIL.CUSTID = CF.CUSTID
                   LEFT JOIN (
                              SELECT CDCONTENT, CDVAL
                              FROM ALLCODE
                              WHERE CDNAME ='CUSTTYPE' AND CDTYPE ='CF'
                              ) CST_TP ON CST_TP.CDVAL = CF.CUSTTYPE
                   LEFT JOIN (
                              SELECT CDCONTENT, CDVAL
                              FROM ALLCODE
                              WHERE CDNAME ='COUNTRY' AND CDTYPE ='CF'
                              ) CST_COUNTRY ON CST_COUNTRY.CDVAL = CF.COUNTRY
    WHERE CF.CUSTODYCD = v_CustodyCD;


EXCEPTION
  WHEN OTHERS
   THEN
   DBMS_OUTPUT.PUT_LINE('OD6015 ERROR');
   PLOG.ERROR('OD6015: - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
