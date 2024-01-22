SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getseamt_3322 (PV_codeid varchar2, pv_txdate varchar2) return number
IS
    v_dblAVLBAL number;
    l_reftype varchar2(10);
    v_SEAMT     number;
BEGIN
    -- NAM.LY 03/04/2020
    v_SEAMT := 0;
    ---------------------------------------
    SELECT  SUM(NVL(DAT.TRADE,0)) INTO v_SEAMT
    FROM (SELECT SUM (
                     MST.TRADE
                   + MST.MARGIN
                   + MST.WTRADE
                   + MST.MORTAGE
                   + MST.BLOCKWITHDRAW
                   + MST.EMKQTTY
                   + MST.BLOCKDTOCLOSE
                   + MST.BLOCKED
                   + MST.SECURED
                   + MST.REPO
                   + MST.DTOCLOSE
                   + MST.WITHDRAW
                   + MST.NETTING
                   + MST.HOLD)
               - SUM (NVL(TR.AMOUNT,0))
                   TRADE,
               MST.AFACCTNO,
               MAX (SYM.PARVALUE) PARVALUE
          FROM SEMAST MST,
               SBSECURITIES SYM,
               --PHAT SINH-------------------------------------------------------------------------------------------------------------
               (
                SELECT (CASE WHEN TR_SELL.ACCTNO IS NOT NULL THEN TR_SELL.ACCTNO ELSE TR_BUY.ACCTNO END) ACCTNO,
                       (SUM (NVL (TR_SELL.AMT, 0)) - SUM (NVL (TR_BUY.AMT, 0))) AMOUNT
                FROM --LENH MUA---------------------------------------
                     (
                       SELECT TMP.SEACCTNO ACCTNO,
                              SUM (TMP.QTTY) AMT
                       FROM (
                               --ETF CA
                               SELECT ETF.ORDERID, ETF.QTTY, (ETF.AFACCTNO||ETF.CODEID) SEACCTNO, ST.STATUS, ST.DUETYPE, ST.CLEARDATE
                               FROM ETFWSAP ETF, STSCHD ST
                               WHERE ETF.ORDERID = ST.ORDERID
                               UNION ALL
                               --NORMAL CA & GBOND
                               SELECT NG.ORDERID, NG.QTTY, NG.SEACCTNO, NG.STATUS, NG.DUETYPE, NG.CLEARDATE
                               FROM STSCHD NG
                               WHERE NOT EXISTS (SELECT 1 FROM ETFWSAP WHERE ORDERID = NG.ORDERID)
                             ) TMP
                       WHERE TMP.STATUS <> 'C'
                             AND TMP.CLEARDATE <= TO_DATE(pv_txdate,'DD/MM/RRRR') --pv_txdate: NGAY CHOT
                             AND TMP.DUETYPE = 'RS'
                       GROUP BY TMP.SEACCTNO
                     ) TR_BUY
                     --------------------------------------------------
                     FULL JOIN
                     --LENH BAN----------------------------------------
                     (
                       SELECT TMP.SEACCTNO ACCTNO,
                              SUM (TMP.QTTY) AMT
                       FROM (
                               --ETF CA
                               SELECT ETF.ORDERID, ETF.QTTY, (ETF.AFACCTNO||ETF.CODEID) SEACCTNO, ST.STATUS, ST.DUETYPE, ST.CLEARDATE
                               FROM ETFWSAP ETF, STSCHD ST
                               WHERE ETF.ORDERID = ST.ORDERID
                               UNION ALL
                               --NORMAL CA & GBOND
                               SELECT NG.ORDERID, NG.QTTY, NG.SEACCTNO, NG.STATUS, NG.DUETYPE, NG.CLEARDATE
                               FROM STSCHD NG
                               WHERE NOT EXISTS (SELECT 1 FROM ETFWSAP WHERE ORDERID = NG.ORDERID)
                             ) TMP
                       WHERE TMP.STATUS <> 'C'
                             AND TMP.CLEARDATE <= TO_DATE(pv_txdate,'DD/MM/RRRR') --pv_txdate: NGAY CHOT
                             AND TMP.DUETYPE = 'SS'
                       GROUP BY TMP.SEACCTNO
                     ) TR_SELL
                     -------------------------------------------------
                     ON TR_BUY.ACCTNO = TR_SELL.ACCTNO
                GROUP BY TR_BUY.ACCTNO, TR_SELL.ACCTNO) TR
                ---------------------------------------------------------------------------------------------------------------------
         WHERE MST.CODEID = SYM.CODEID
               AND (SYM.CODEID = PV_codeid OR SYM.REFCODEID = PV_codeid)
               AND MST.ACCTNO = TR.ACCTNO (+)
        GROUP BY MST.AFACCTNO) DAT,
       AFMAST AF,
       CFMAST CF
    WHERE     DAT.AFACCTNO = AF.ACCTNO
       AND DAT.TRADE > 0
       AND AF.CUSTID = CF.CUSTID
       AND CF.CUSTATCOM = 'Y'
       AND CF.STATUS <> 'C'
       AND CF.SUPEBANK = 'Y';
    ---------------------------------------
    RETURN NVL(V_SEAMT,0);

EXCEPTION WHEN OTHERS THEN
    RETURN 0;
END;
/
