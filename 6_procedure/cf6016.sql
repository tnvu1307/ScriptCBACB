SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CF6016 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*TU NGAY */
   T_DATE                 IN       VARCHAR2 /*DEN NGAY */
   )
IS
    -- GIAY DANG KY MA SO GIAO DICH
    -- PERSON      DATE                 COMMENTS
    -- ---------   ------               -------------------------------------------
    -- TRUONGLD    18-10-2019           CREATED
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    V_FROMDATE     DATE;
    V_TODATE       DATE;
    V_CURRDATE     DATE;
    V_CUSTODYCD    VARCHAR2(20);
BEGIN

   V_STROPTION := OPT;

   V_CURRDATE   := GETCURRDATE;

    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID:=BRID;
    END IF;

    V_FROMDATE  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    --V_TODATE    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);


OPEN PV_REFCURSOR FOR
SELECT A1.CDCONTENT, SB.SYMBOL, SB.ISINCODE, SI.LISTINGQTTY, SI.BASICPRICE CLOSEPRICE, SI.FOREIGNROOM TOTALROOM,
            -- ROOM DA DUNG
            SI.FOREIGNROOM - SI.CURRENT_ROOM USEDROOM,
            -- %CURRENT ROOM/TOTAL ROOM
            CASE WHEN SI.FOREIGNROOM > 0 THEN (SI.FOREIGNROOM - SI.CURRENT_ROOM) / SI.FOREIGNROOM END PERCENT_CURRROOM,
            -- ROOM CON LAI
            SI.CURRENT_ROOM,
            -- % REMAINING ROOM/TOTAL ROOM
            CASE WHEN SI.FOREIGNROOM > 0 THEN SI.CURRENT_ROOM / SI.FOREIGNROOM END PERCENT_REMAINROOM,
            -- MARKET CAPITALIZATION (VND) (8)
            SI.LISTINGQTTY * SI.BASICPRICE VND_CAPITALIZATION,
            --MARKET CAPITALIZATION (USD)
            ROUND(SI.LISTINGQTTY * SI.BASICPRICE / FX.VND,2) USD_CAPITALIZATION
        FROM SBSECURITIES SB, VW_SECURITIES_INFO_HIST SI, ALLCODE A1, --SBFXRT FX
            (
                SELECT CURRENCY,VND
                FROM (
                      SELECT * FROM EXCHANGERATE
                      UNION ALL
                      SELECT * FROM EXCHANGERATE_HIST
                      )
                WHERE (CURRENCY,RTYPE,ITYPE,LASTCHANGE)
                                                         IN (
                                                             SELECT CURRENCY,RTYPE,ITYPE,MAX(LASTCHANGE)
                                                             FROM (
                                                                    SELECT * FROM EXCHANGERATE
                                                                    UNION ALL
                                                                    SELECT * FROM EXCHANGERATE_HIST
                                                                   )
                                                             WHERE TRADEDATE <= V_FROMDATE
                                                                   AND RTYPE = 'TTM'
                                                                   AND ITYPE = 'SHV'
                                                                   AND CURRENCY = 'USD'
                                                             GROUP BY CURRENCY,RTYPE,ITYPE
                                                            )
            )FX
        WHERE SB.CODEID = SI.CODEID
            AND SB.TRADEPLACE = A1.CDVAL
            AND A1.CDNAME ='TRADEPLACE'
            AND A1.CDTYPE ='SE'
            AND HISTDATE = V_FROMDATE
            AND SB.TRADEPLACE IN ('001','002','005')
            AND SB.SECTYPE <> '004'
     ORDER BY SB.SYMBOL;

EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('CF6016: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
