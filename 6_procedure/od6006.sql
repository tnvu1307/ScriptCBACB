SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE od6006 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*TU NGAY */
   T_DATE                 IN       VARCHAR2/*DEN NGAY */
   )
IS
    -- TRADE06 REPORT02
    -- PERSON      DATE                 COMMENTS
    -- ---------   ------               -------------------------------------------
    -- THOAI.TRAN    01-11-2019           CREATED
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (400);       -- USED WHEN V_NUMOPTION > 0

    V_FROMDATE     DATE;
    V_TODATE       DATE;
BEGIN

    V_STROPTION := OPT;
    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID:=BRID;
    END IF;

    V_FROMDATE  :=     TO_DATE(F_DATE, 'DD/MM/RRRR');
    V_TODATE    :=     TO_DATE(T_DATE, 'DD/MM/RRRR');

OPEN PV_REFCURSOR FOR
select * from
(
    SELECT *
    FROM (
        SELECT
            CUSTODYCD,
            FULLNAME,
            SHORTNAME,
            SBDATE,
            DUETYPE,
            SECTYPE,
            TRANTYPE,
            ODR,
            AMOUNT,
            CLEARDATE,
            SUM(ABS(RM.AMOUNT)) OVER (PARTITION BY RM.CUSTODYCD) TOTAL
        FROM (
------------------------------------------------------------------------------
            SELECT MST.CUSTODYCD,MST.FULLNAME,MST.SHORTNAME,MST.SBDATE,MST.DUETYPE
                ,(CASE WHEN MST.SECTYPE='0' THEN 'STOCKS'
                    WHEN MST.SECTYPE='1' THEN 'C-BONDS'
                    WHEN MST.SECTYPE='2' THEN 'G-BONDS'
                    WHEN MST.SECTYPE='3' THEN 'CASH'
                    ELSE 'OTHERS             (BROKER FEE, TAX, ETC)' END )SECTYPE
                ,MST.TRANTYPE,MST.ODR
                ,(CASE
                        WHEN MST.SECTYPE IN ('0') THEN NVL(A1.AMOUNT,0)
                        WHEN MST.SECTYPE IN ('2') THEN NVL(A4.AMOUNT,0)
                        WHEN MST.SECTYPE IN ('1') THEN NVL(A5.AMOUNT,0)
                        WHEN MST.SECTYPE = '3' THEN NVL(A2.AMOUNT,0)
                        ELSE  NVL(A3.AMOUNT,0)
                    END) AMOUNT
                ,MST.SBDATE CLEARDATE
            FROM (
                SELECT CF.CUSTODYCD,CF.FULLNAME, FA.SHORTNAME, SB.SBDATE, A1.*
                FROM (
                    select * from cfmast where custodycd not like 'SHVE%' AND COUNTRY<>'234' --AND CUSTODYCD IN (SELECT DISTINCT CUSTODYCD FROM DDMAST WHERE accounttype = 'IICA')
                ) CF, FAMEMBERS FA,
                (
                   SELECT 'SM' DUETYPE, '0' SECTYPE, 'OUT (BUY)' TRANTYPE, '0' ODR FROM DUAL
                   UNION ALL
                   SELECT 'RM' DUETYPE, '0' SECTYPE, 'IN (SELL)' TRANTYPE, '0' ODR FROM DUAL
                   UNION ALL
                   SELECT 'SM' DUETYPE, '1' SECTYPE, 'OUT (BUY)' TRANTYPE, '1' ODR FROM DUAL
                   UNION ALL
                   SELECT 'RM' DUETYPE, '1' SECTYPE, 'IN (SELL)' TRANTYPE, '1' ODR FROM DUAL
                   UNION ALL
                   SELECT 'SM' DUETYPE, '2' SECTYPE, 'OUT (BUY)' TRANTYPE, '2' ODR FROM DUAL
                   UNION ALL
                   SELECT 'RM' DUETYPE, '2' SECTYPE, 'IN (SELL)' TRANTYPE, '2' ODR FROM DUAL
                   UNION ALL
                   SELECT 'SM' DUETYPE, '3' SECTYPE, 'OUT (PAYMENT)' TRANTYPE, '3' ODR FROM DUAL
                   UNION ALL
                   SELECT 'RM' DUETYPE, '3' SECTYPE, 'IN (INCOME)' TRANTYPE, '3' ODR FROM DUAL
                   UNION ALL
                   SELECT 'SM' DUETYPE, '4' SECTYPE, 'OUT (PAYMENT)' TRANTYPE, '4' ODR FROM DUAL
                   UNION ALL
                   SELECT 'RM' DUETYPE, '4' SECTYPE, 'IN (INCOME)' TRANTYPE, '4' ODR FROM DUAL
                ) A1,
                (
                    SELECT SBDATE
                    FROM SBCLDR
                    WHERE CLDRTYPE ='000' AND HOLIDAY='N'
                    AND SBDATE BETWEEN V_FROMDATE AND V_TODATE

                )SB
                WHERE CF.AMCID = FA.AUTOID (+)
                ORDER BY ODR
            )MST,
            (
                 SELECT SC.CUSTODYCD, SC.CLEARDATE, '0' SECTYPE, SC.DUETYPE,
                        SUM((CASE WHEN SC.DUETYPE = 'RM' THEN AMT
                             ELSE -AMT END))AMOUNT
                 FROM VW_STSCHD_ALL SC,  SBSECURITIES SB,VW_ODMAST_ALL OD
                 WHERE SC.CLEARDATE BETWEEN V_FROMDATE AND V_TODATE
                 AND DUETYPE IN ('SM','RM')
                 AND SC.CODEID = SB.CODEID
                 AND SB.SECTYPE IN ('001','002','008')
                 AND SC.ORDERID = OD.ORDERID
                 AND OD.ODTYPE NOT IN ('SWE')
                 GROUP BY SC.CUSTODYCD,SC.DUETYPE, SC.CLEARDATE
            )A1,
            (
                SELECT
                        DDTRAN.CUSTODYCD,
                        DDTRAN.BUSDATE CLEARDATE,
                        '3' SECTYPE,
                        (CASE WHEN DDTRAN.TXTYPE='D' THEN 'SM' ELSE 'RM' END)DUETYPE,
                        SUM((CASE WHEN DDTRAN.TXTYPE = 'C' THEN NAMT ELSE -NAMT END))AMOUNT

                FROM VW_DDTRAN_GEN DDTRAN, DDMAST DD, (SELECT * FROM CRBTXREQ UNION ALL SELECT * FROM CRBTXREQHIST) CR,
                (
                    SELECT CR.REQCODE, CQ.REFTXNUM,CQ.TXDATE
                    FROM (SELECT * FROM CRBTXREQ UNION ALL SELECT * FROM CRBTXREQHIST) CR, (SELECT * FROM CRBBANKREQUEST UNION ALL SELECT * FROM CRBBANKREQUESTHIST) CQ
                    WHERE CR.REFVAL= CQ.TRNREF
                ) CQ
                WHERE DDTRAN.FIELD ='BALANCE'
                AND DDTRAN.ACCTNO=DD.ACCTNO
                AND DD.CCYCD='VND'
                AND DDTRAN.TXNUM = CR.OBJKEY (+) AND DDTRAN.TXDATE = CR.TXDATE (+)
                AND DDTRAN.TXNUM = CQ.REFTXNUM (+) AND DDTRAN.TXDATE =CQ.TXDATE (+)
                AND DDTRAN.BUSDATE BETWEEN V_FROMDATE AND V_TODATE
                AND DDTRAN.TXTYPE IN ('D','C')
                AND DDTRAN.TLTXCD NOT IN ('8818','8869','8820','8880','6690','6691','6697','8866','8893','6652','6674')
                AND DDTRAN.TLTXCD LIKE
                    (
                    CASE
                        WHEN DDTRAN.TLTXCD ='6673' THEN
                            CASE WHEN CR.REQCODE IN ('PAYMENTSELLORDER','PAYMENTBUYORDER','BANKTRANSFEROUT8869','PAYMENTFEE','PAYMENT_NOSTROWTRANFER') THEN 'IGNOR' ELSE '6673' END
                         ELSE '%'
                    END
                    )
                AND DDTRAN.TLTXCD LIKE
                    (
                    CASE
                        WHEN DDTRAN.TLTXCD ='6621' THEN
                            CASE WHEN CR.REQCODE IN ('PAYMENTSELLORDER','PAYMENTBUYORDER','BANKTRANSFEROUT8869','PAYMENTFEE','PAYMENT_NOSTROWTRANFER') THEN 'IGNOR' ELSE '6621' END
                         ELSE '%'
                    END
                    )
                AND DDTRAN.TLTXCD LIKE
                    (
                    CASE
                        WHEN DDTRAN.TLTXCD ='6674' THEN
                            CASE WHEN CQ.REQCODE IN ('PAYMENTSELLORDER','PAYMENTBUYORDER','BANKTRANSFEROUT8869','PAYMENTFEE','PAYMENT_NOSTROWTRANFER') THEN 'IGNOR' ELSE '6674' END
                         ELSE '%'
                    END
                    )
                GROUP BY DDTRAN.CUSTODYCD,DDTRAN.BUSDATE,DDTRAN.TXTYPE
            )A2,
            (
                SELECT CUSTODYCD,CLEARDATE,'4' SECTYPE,
                (CASE  WHEN EXECTYPE IN ('NS','NB') THEN 'SM' ELSE 'RM' END) DUETYPE
                ,SUM(-FEEAMT) + SUM(-TAXAMT) AMOUNT
                FROM VW_ODMAST_ALL OD
                WHERE OD.DELTD <> 'Y' AND OD.ODTYPE NOT IN ('SWE') AND  CLEARDATE BETWEEN V_FROMDATE AND V_TODATE
                GROUP BY CUSTODYCD,CLEARDATE,EXECTYPE
            )A3,
            (

            /*
                 SELECT CUSTODYCD,CLEARDATE,SECTYPE, DUETYPE,SUM(AMOUNT) AMOUNT
                 FROM (
                 SELECT CUSTODYCD,CLEARDATE,
                 (CASE WHEN SB.SECTYPE IN ('003','006','222') AND SB.BONDTYPE IN ('001','002') THEN '2'
                                     WHEN SB.SECTYPE IN ('003','006','222') AND SB.BONDTYPE IN ('005') THEN '1'
                                     ELSE '' END) SECTYPE,
                    (CASE WHEN OD.EXECTYPE='NS' THEN 'RM' ELSE 'SM' END) DUETYPE,
                    (CASE WHEN  OD.EXECTYPE='NS' THEN  OD.EXECAMT ELSE  -OD.EXECAMT END) AMOUNT
                  FROM VW_ODMAST_ALL OD , SBSECURITIES SB
                  WHERE OD.CODEID=SB.CODEID AND SB.SECTYPE IN ('003','006','222')
                  AND SB.BONDTYPE IN ('001','002','005')
                  )
                  GROUP BY CUSTODYCD,CLEARDATE,SECTYPE, DUETYPE
            */
                 SELECT CUSTODYCD,CLEARDATE,SECTYPE, DUETYPE,SUM(AMOUNT) AMOUNT
                 FROM (
                 SELECT CUSTODYCD,CLEARDATE,'2' SECTYPE,
                    (CASE WHEN OD.EXECTYPE='NS' THEN 'RM' ELSE 'SM' END) DUETYPE,
                    (CASE WHEN  OD.EXECTYPE='NS' THEN  OD.EXECAMT ELSE  -OD.EXECAMT END) AMOUNT
                  FROM VW_ODMAST_ALL OD , SBSECURITIES SB
                  WHERE OD.CODEID=SB.CODEID AND OD.DELTD <> 'Y' AND SB.SECTYPE IN ('003','006','222')  AND SB.BONDTYPE IN ('001','002')
                      )
                  GROUP BY CUSTODYCD,CLEARDATE,SECTYPE, DUETYPE

            )A4, --G-BOND
            (
                 SELECT CUSTODYCD,CLEARDATE,SECTYPE, DUETYPE,SUM(AMOUNT) AMOUNT
                 FROM (
                 SELECT CUSTODYCD,CLEARDATE,'1' SECTYPE,
                    (CASE WHEN OD.EXECTYPE='NS' THEN 'RM' ELSE 'SM' END) DUETYPE,
                    (CASE WHEN  OD.EXECTYPE='NS' THEN  OD.EXECAMT ELSE  -OD.EXECAMT END) AMOUNT
                  FROM VW_ODMAST_ALL OD , SBSECURITIES SB
                  WHERE OD.CODEID=SB.CODEID AND OD.DELTD <> 'Y' AND SB.SECTYPE IN ('003','006','222')  AND SB.BONDTYPE IN ('005')
                      )
                  GROUP BY CUSTODYCD,CLEARDATE,SECTYPE, DUETYPE

            )A5 --C-BOND
            WHERE  MST.SECTYPE =A1.SECTYPE (+)
            AND MST.CUSTODYCD =A1.CUSTODYCD (+)
            AND MST.DUETYPE=A1.DUETYPE  (+)
            AND MST.SBDATE=A1.CLEARDATE (+)

            AND MST.SECTYPE =A2.SECTYPE (+)
            AND MST.CUSTODYCD =A2.CUSTODYCD (+)
            AND MST.DUETYPE=A2.DUETYPE  (+)
            AND MST.SBDATE=A2.CLEARDATE (+)


            AND MST.SECTYPE =A3.SECTYPE (+)
            AND MST.CUSTODYCD =A3.CUSTODYCD (+)
            AND MST.DUETYPE=A3.DUETYPE  (+)
            AND MST.SBDATE=A3.CLEARDATE (+)

            AND MST.SECTYPE =A4.SECTYPE (+)
            AND MST.CUSTODYCD =A4.CUSTODYCD (+)
            AND MST.DUETYPE=A4.DUETYPE  (+)
            AND MST.SBDATE=A4.CLEARDATE (+)

            AND MST.SECTYPE =A5.SECTYPE (+)
            AND MST.CUSTODYCD =A5.CUSTODYCD (+)
            AND MST.DUETYPE=A5.DUETYPE  (+)
            AND MST.SBDATE=A5.CLEARDATE (+)

            ORDER BY  MST.FULLNAME,MST.CUSTODYCD,MST.ODR
 -------------------------------------------------------------------------------
        )RM
    )RN WHERE RN.TOTAL <> 0
    ORDER BY RN.FULLNAME,RN.CUSTODYCD,RN.ODR
);
-- DBMS_OUTPUT.PUT_LINE('END');

EXCEPTION
  WHEN OTHERS
   THEN
   --   DBMS_OUTPUT.PUT_LINE('SQLERRM:' || SQLERRM);
      PLOG.ERROR ('OD6006: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
