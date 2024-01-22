SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CA600701(
      PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_AMCCODE              IN       VARCHAR2, /* Ma AMC */
   P_FXPROFIT             IN       Number, /* FXPROFIT  */
   P_IDLEMONEYMARGIN      IN       Number, /* IDLE MONEY MARGIN   */
   P_CUSTODYFEE           IN       Number /* CUSTODY FEE   */
   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    --NAM.LY       13-12-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    v_FromDate          date;
    v_ToDate            date;
    v_CurrDate          date;
    v_issuedate         date;
    v_expdate           date;
    v_CustodyCD         varchar2(20);
    v_Symbol            varchar2(50);
    v_IDCODE           varchar2(200);
    v_OFFICE           varchar2(200);
    v_REFNAME          varchar2(200);
    v_shvstc           varchar2(200);
    v_shvcustodycd     varchar2(200);
    v_shvcifid         varchar2(200);

    v_tltitle          varchar2(200);
    v_tlfullname       varchar2(200);
    v_ExchangeRate     number;
    v_AMCCODE          varchar2(20);
BEGIN
     V_STROPTION := OPT;
     v_CurrDate   := getcurrdate;
     if v_stroption = 'A' then
        v_strbrid := '%';
     elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
     else
        v_strbrid:=brid;
     end if;
    if P_AMCCODE='ALL' then
        v_AMCCODE:='%';
    else
    v_AMCCODE:=P_AMCCODE;
        end if;


    v_FromDate  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
        BEGIN
        WITH TMPER AS(
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
                     WHERE TRADEDATE <= v_FromDate
                           AND RTYPE = 'REP'
                           AND ITYPE = 'SHV'
                           AND CURRENCY = 'USD'
                     GROUP BY CURRENCY,RTYPE,ITYPE
                    )
        )
        SELECT VND
        INTO V_EXCHANGERATE
        FROM   TMPER;
    EXCEPTION
        WHEN OTHERS  THEN
            V_EXCHANGERATE := 1;
            plog.error ('CA600701: '||'TY GIA USD/VND NGAY '||v_FromDate||' KHONG TON TAI!!!');
    END;

OPEN PV_REFCURSOR FOR
  WITH TMP_SB AS ( --BANG TAM SB
                        SELECT SB.CODEID, SB.SECTYPE, SB.SYMBOL, SB1.CODEID REFCODEID, SB1.SYMBOL REFSYMBOL, SB.EXPDATE, SB.PARVALUE
                              , (CASE WHEN SB.REFCODEID IS NULL THEN SB.TRADEPLACE ELSE SB1.TRADEPLACE END) TRADEPLACE
                        FROM SBSECURITIES SB, SBSECURITIES SB1
                        WHERE SB.REFCODEID = SB1.CODEID(+) AND SB.SECTYPE <> '004'
                      )
           , TMP_TR AS ( --BANG TEMP TR
                         SELECT CUSTODYCD, ACCTNO, SYMBOL, BUSDATE, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                         FROM VW_SETRAN_GEN
                         WHERE FIELD IN ('TRADE','NETTING','BLOCKED') AND BUSDATE > v_FromDate
                         GROUP BY CUSTODYCD, ACCTNO, SYMBOL, BUSDATE
                       )
           , TMP_DD AS ( --BANG TEMP TR
                         SELECT ACCTNO, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                         FROM VW_DDTRAN_GEN
                         WHERE FIELD IN ('BALANCE') AND BUSDATE > v_FromDate
                         GROUP BY ACCTNO
                        )
           , TMP_SI AS (
                        SELECT CODEID, BASICPRICE
                        FROM VW_SECURITIES_INFO_HIST
                        WHERE (CODEID,HISTDATE) IN (
                                                     SELECT CODEID, MAX(HISTDATE)
                                                     FROM VW_SECURITIES_INFO_HIST
                                                     WHERE HISTDATE <= v_FromDate
                                                     GROUP BY CODEID
                                                   )
                         )
           , TMP_EXCHANGERATE AS (
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
                                                 WHERE TRADEDATE <= v_FromDate
                                                       AND RTYPE = 'REP'
                                                       AND ITYPE = 'SHV'
                                                 GROUP BY CURRENCY,RTYPE,ITYPE
                                                )
                                      )
           , TMP_CK AS ( --BANG TEMP CHUNG KHOAN
                        SELECT SE.CUSTID
                               --,SB.SECTYPE
                               --,SB.TRADEPLACE
                               --,(CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END) SYMBOL
                               --,(CASE WHEN SB.REFCODEID IS NULL THEN SB.CODEID ELSE SB.REFCODEID END) CODEID
                               --,(CASE WHEN SB.SECTYPE IN ('001','002') AND TRADEPLACE IN ('001','002','005') THEN SI.BASICPRICE ELSE SB.PARVALUE END) PRICE
                               --,SUM(SE.TRADE + SE.NETTING + SE.BLOCKED - NVL(TR.NAMT,0)) QTTY
                               ,SUM((SE.TRADE + SE.NETTING + SE.BLOCKED - NVL(TR.NAMT,0))*(CASE WHEN SB.SECTYPE IN ('001','002') AND TRADEPLACE IN ('001','002','005') THEN SI.BASICPRICE ELSE SB.PARVALUE END)) AMT
                        FROM SEMAST SE JOIN TMP_SB SB ON SB.CODEID = SE.CODEID
                                       JOIN TMP_SI SI ON SI.CODEID = (CASE WHEN SB.REFCODEID IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
                                       LEFT JOIN TMP_TR TR ON SE.ACCTNO = TR.ACCTNO
                        WHERE SE.CUSTID IS NOT NULL
                        GROUP BY SE.CUSTID
                                 --,SB.SECTYPE
                                 --,SB.TRADEPLACE
                                 --,(CASE WHEN SB.SECTYPE IN ('001','002') AND TRADEPLACE IN ('001','002','005') THEN SI.BASICPRICE ELSE SB.PARVALUE END)
                                 --,(CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END)
                                 --,(CASE WHEN SB.REFCODEID IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
                       )
           , TMP_TM AS ( --BANG TEMP TIEN MAT
                           SELECT DD.CUSTID,
                                  SUM((DD.BALANCE - NVL(TR.NAMT,0))*(CASE WHEN DD.CCYCD <> 'VND' THEN EX.VND ELSE 1 END)) AMT
                           FROM DDMAST DD LEFT JOIN TMP_DD TR ON DD.ACCTNO = TR.ACCTNO
                                          LEFT JOIN TMP_EXCHANGERATE EX ON EX.CURRENCY = DD.CCYCD
                           GROUP BY DD.CUSTID
                        )
           , CK_TM AS ( --CHUNG KHOAN + TIEN MAT
                        SELECT A.CUSTID, SUM(A.AMT) AMT
                        FROM (
                                SELECT * FROM TMP_CK
                                UNION ALL
                                SELECT * FROM TMP_TM
                             ) A
                        GROUP BY CUSTID
                      )
        --==========================================MAIN SELECT QUERY=======================================================================
        SELECT ca6007.*
        FROM (
                SELECT FA.FULLNAME AMCName,
                       CF.CIFID CIF,
                       CF.FULLNAME FUNDName,
                       CF.OPNDATE InitialCustodyDate,
                       ROUND(NVL(TM.AMT/V_EXCHANGERATE,0),15) AvgBalance,
                       '' TargetAUC,
                       ROUND(CT.AMT/V_EXCHANGERATE/1000,15) AUC
                FROM CK_TM CT JOIN CFMAST CF ON CF.CUSTID = CT.CUSTID AND
                                                CF.CUSTATCOM ='Y' --LUU KY TAI SHINHAN
                              JOIN FAMEMBERS FA ON FA.AUTOID = CF.AMCID AND
                                                        FA.ROLES='AMC' AND
                                                        FA.SHORTNAME LIKE v_AMCCODE
                              LEFT JOIN TMP_TM TM ON CT.CUSTID = TM.CUSTID
                ORDER BY UPPER(CF.FULLNAME)
             ) ca6007;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CA600701: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
