SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf600701 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   PV_AMC           IN       VARCHAR2, /*So TK Luu ky */
   P_LCB                IN       VARCHAR2, /*GCM ID */
   P_SYMBOL                IN       VARCHAR2, /*GCM ID */
   P_OPTION                IN       VARCHAR2, /*GCM ID */
   PV_TXNUM                 IN       VARCHAR2
   )
IS
    -- Giay dang ky ma so giao dich
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- truongld    18-10-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    v_FromDate     date;
    v_ToDate       date;
    v_CurrDate     date;
    v_NextDate     date;
    v_prev_fdate   date;
    v_Symbol       varchar2(20);
    v_AMC    varchar2(20);
    v_LCB        varchar2(20);
BEGIN

   V_STROPTION := OPT;

   v_CurrDate   := getcurrdate;
   v_FromDate  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
   v_prev_fdate := getprevdate(v_FromDate,1);
    if v_stroption = 'A' then
        v_strbrid := '%';
    elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
    else
        v_strbrid:=brid;
    end if;
    ---------------------------------------------------
    if (PV_AMC = 'ALL' or PV_AMC is null) then
        v_AMC := '%';
    else
        Begin
            select autoid into v_AMC from famembers fa where fa.shortname= PV_AMC  and fa.roles ='AMC' and rownum =1;
        EXCEPTION
          WHEN OTHERS
           THEN     v_AMC := '';
        End;
    end if;
    ---------------------------------------------------
    if (P_LCB = 'ALL' or P_LCB is null) then
        v_LCB := '%';
    else
        Begin
            select autoid into v_LCB from famembers fa where fa.shortname= P_LCB  and fa.roles ='LCB' and rownum =1;
        EXCEPTION
          WHEN OTHERS
           THEN     v_LCB := '';
        End;
    end if;
    ---------------------------------------------------
    if (P_SYMBOL = 'ALL' or P_SYMBOL is null) then
        v_Symbol := '%';
    else
        v_Symbol := P_SYMBOL;
    end if;

    --v_ToDate    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

OPEN PV_REFCURSOR FOR
        SELECT MST.CUSTODYCD, MST.FULLNAME, MST.SYMBOL, MST.DESCRIPTION, MST.EN_DESCRIPTION, MST.PREV_QUANTITY, MST.QUANTITY, MST.PREV_OTS, MST.OTS, MST.ISINCODE, MST.ISINCODE, MST.GC, MST.STC,
               ROUND(MST.PREV_RATEOW,20) PREV_RATEOW,
               ROUND(MST.RATEOW,20) RATEOW,
               ROUND((MST.RATEOW - MST.PREV_RATEOW),20) DELTACHANGE,
               TO_CHAR(V_PREV_FDATE,'DD/MM/RRRR') PRE, TO_CHAR(V_FROMDATE,'DD/MM/RRRR')  FROMDATE
        FROM (
            SELECT CF.CUSTODYCD, CF.FULLNAME, SE.SYMBOL, ISS.FULLNAME DESCRIPTION, ISS.EN_FULLNAME EN_DESCRIPTION, SI.PREV_LISTINGQTTY PREV_OTS, SI.LISTINGQTTY OTS, ISS.ISINCODE, FA.SHORTNAME GC,
                   SUM(SE.PREV_QTTY) PREV_QUANTITY,
                   SUM(SE.QTTY) QUANTITY,
                   SUM(CASE WHEN SI.PREV_LISTINGQTTY = 0 THEN 0 ELSE SE.PREV_QTTY/SI.PREV_LISTINGQTTY END) PREV_RATEOW,
                   SUM(CASE WHEN SI.LISTINGQTTY = 0 THEN 0 ELSE SE.QTTY/SI.LISTINGQTTY END) RATEOW,
                   (CASE WHEN COUNTRY ='234' THEN SUBSTR(CF.CUSTODYCD,5,6) ELSE TRADINGCODE END) STC
            FROM CFMAST CF, AFMAST AF, FAMEMBERS FA, FAMEMBERS FA1,
            (
                SELECT CODEID,
                    SUM(CASE WHEN HISTDATE=V_PREV_FDATE AND  P_OPTION='OLD' THEN NVL(OLDCIRCULATINGQTTY,0)
                             WHEN HISTDATE=V_PREV_FDATE AND  P_OPTION <> 'OLD' THEN  NVL(NEWCIRCULATINGQTTY,0)
                             ELSE 0 END) PREV_LISTINGQTTY,
                    SUM(CASE WHEN HISTDATE=V_FROMDATE AND  P_OPTION='OLD' THEN NVL(OLDCIRCULATINGQTTY,0)
                             WHEN HISTDATE=V_FROMDATE AND  P_OPTION <> 'OLD' THEN NVL(NEWCIRCULATINGQTTY,0)
                             ELSE 0 END) LISTINGQTTY
                FROM VW_SECURITIES_INFO_HIST
                WHERE SYMBOL LIKE V_SYMBOL AND HISTDATE BETWEEN V_PREV_FDATE AND V_FROMDATE
                GROUP BY CODEID
            ) SI,
            (
                SELECT SB.CODEID, SB.SYMBOL, SB.ISINCODE, MST.* FROM ISSUERS MST, SBSECURITIES SB WHERE MST.ISSUERID = SB.ISSUERID
            ) ISS,
            (
                SELECT SE_TMP.AFACCTNO, SE_TMP.ISSUERID, SE_TMP.ISINCODE, SE_TMP.CODEID, SE_TMP.SYMBOL, SUM(SE_TMP.PREV_QTTY) PREV_QTTY, SUM(SE_TMP.QTTY) QTTY
                FROM (
                    SELECT SE.AFACCTNO, SB.ISSUERID, SB.ISINCODE,
                          (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.CODEID ELSE SB.REFCODEID END) CODEID,
                          (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END) SYMBOL,
                           SUM(CASE WHEN SE.TXDATE = V_PREV_FDATE THEN SE.TRADE ELSE 0 END) PREV_QTTY,
                           SUM(CASE WHEN SE.TXDATE = V_FROMDATE THEN SE.TRADE ELSE 0 END) QTTY
                    FROM SENOCUSTATCOM SE,
                    (
                        SELECT SB.ISINCODE, SB.ISSUERID, SB.CODEID, SB.SYMBOL,(CASE WHEN SB.REFCODEID IS NULL THEN SB.TRADEPLACE ELSE SB1.TRADEPLACE END) TRADEPLACE, SB1.CODEID REFCODEID, SB1.SYMBOL REFSYMBOL
                        FROM SBSECURITIES SB, SBSECURITIES SB1
                        WHERE SB.REFCODEID = SB1.CODEID(+)  AND SB.SECTYPE IN ('001','002','008')
                    ) SB
                    WHERE SE.CODEID = SB.CODEID
                    AND SE.TXDATE BETWEEN V_PREV_FDATE AND V_FROMDATE
                    GROUP BY SE.AFACCTNO, SB.ISSUERID, SB.ISINCODE,SB.REFSYMBOL,SB.CODEID,SB.REFCODEID,SB.SYMBOL
                ) SE_TMP
                GROUP BY SE_TMP.AFACCTNO, SE_TMP.ISSUERID, SE_TMP.ISINCODE, SE_TMP.CODEID, SE_TMP.SYMBOL

                UNION ALL

                SELECT SE.AFACCTNO, SB.ISSUERID, SB.ISINCODE,
                       (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.CODEID ELSE SB.REFCODEID END) CODEID,
                       (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END) SYMBOL,
                        SUM(SE.TRADE + SE.NETTING + SE.BLOCKED + SE.HOLD - NVL(TR_PREV.NAMT,0)) PREV_QTTY,
                        SUM(SE.TRADE + SE.NETTING + SE.BLOCKED + SE.HOLD - NVL(TR.NAMT,0)) QTTY
                FROM SEMAST SE,
                (
                    SELECT * FROM SENOCUSTATCOM WHERE TXDATE = V_FROMDATE
                ) SEN,
                (
                    SELECT SB.ISINCODE, SB.ISSUERID, SB.CODEID, SB.SYMBOL, SB1.CODEID REFCODEID, SB1.SYMBOL REFSYMBOL,
                           (CASE WHEN SB.REFCODEID IS NULL THEN SB.TRADEPLACE ELSE SB1.TRADEPLACE END) TRADEPLACE
                    FROM SBSECURITIES SB, SBSECURITIES SB1
                    WHERE SB.REFCODEID = SB1.CODEID(+)  AND SB.SECTYPE IN ('001','002','008')
                 ) SB,
                (
                    SELECT CUSTODYCD, ACCTNO, SYMBOL, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                    FROM VW_SETRAN_GEN
                    WHERE BUSDATE > V_PREV_FDATE AND FIELD IN ('TRADE','NETTING','BLOCKED','HOLD')
                    GROUP BY CUSTODYCD, ACCTNO, SYMBOL
                )TR_PREV,
                 (
                     SELECT CUSTODYCD, ACCTNO, SYMBOL, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                     FROM VW_SETRAN_GEN
                     WHERE BUSDATE > V_FROMDATE AND FIELD IN ('TRADE','NETTING','BLOCKED','HOLD')
                     GROUP BY CUSTODYCD, ACCTNO, SYMBOL
                 )TR
                 WHERE SE.CODEID = SB.CODEID
                 AND SE.ACCTNO = TR_PREV.ACCTNO(+)
                 AND SE.ACCTNO = TR.ACCTNO(+)
                 AND SE.ACCTNO = SEN.ACCTNO(+)
                 AND SEN.ACCTNO IS NULL
                 GROUP BY SE.AFACCTNO, SB.ISSUERID, SB.ISINCODE,SB.REFSYMBOL,SB.CODEID,SB.REFCODEID,SB.SYMBOL
            ) SE
            WHERE CF.CUSTID = AF.CUSTID
            AND AF.ACCTNO = SE.AFACCTNO
            AND SI.CODEID = SE.CODEID
            AND SI.CODEID = ISS.CODEID
            AND CF.LCBID = FA.AUTOID (+)
            AND CF.AMCID = FA1.AUTOID (+)
            AND NVL(FA.AUTOID,'0') LIKE V_LCB
            AND SE.SYMBOL LIKE V_SYMBOL
            AND NVL(FA1.AUTOID,'0') LIKE  V_AMC
            GROUP BY CF.CUSTODYCD, CF.FULLNAME, SE.SYMBOL, ISS.FULLNAME, ISS.EN_FULLNAME, SI.PREV_LISTINGQTTY, SI.LISTINGQTTY, ISS.ISINCODE, FA.SHORTNAME,(CASE WHEN COUNTRY ='234' THEN SUBSTR(CF.CUSTODYCD,5,6) ELSE TRADINGCODE END)
        ) MST
        WHERE MST.PREV_QUANTITY <> 0 OR MST.QUANTITY <> 0
        ORDER BY MST.CUSTODYCD;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF600701: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
