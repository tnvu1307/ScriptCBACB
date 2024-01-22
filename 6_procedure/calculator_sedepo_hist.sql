SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CALCULATOR_SEDEPO_HIST(TXDATE IN DATE)
IS
    V_FEEAMT NUMBER;
    V_FEEAMTORDER NUMBER;
    V_FEECALC VARCHAR2(1);
    V_AUTOID NUMBER;
    V_CCYCD VARCHAR2(10);
    V_FEECD VARCHAR2(10);
    V_FEERATE NUMBER;
    V_GETCURRENT DATE;
    V_RESULT NUMBER;
    V_DELTD VARCHAR2(1);
    V_TRDESC VARCHAR2(100);
    V_VATRATE NUMBER(20,4);
    V_TAX NUMBER(20,4);
    V_TAUTOID NUMBER;
    V_EOMDATE DATE;
    V_DESC VARCHAR2(500);
    V_AUTOIDDETAIL NUMBER(20);
    V_FEECODE VARCHAR2(20);
    L_FEETYPES VARCHAR2(20);
    L_SUBTYPES VARCHAR2(20);
    V_SYSVAR VARCHAR2(100);
BEGIN
    V_GETCURRENT := TXDATE;
    SELECT MAX(SB.SBDATE) INTO V_EOMDATE
    FROM SBCLDR SB
    WHERE SB.CLDRTYPE = '000'
    AND SB.HOLIDAY = 'N'
    AND TO_CHAR(SB.SBDATE,'MM/RRRR') = TO_CHAR(V_GETCURRENT,'MM/RRRR');

    SELECT VARVALUE INTO V_SYSVAR FROM SYSVAR WHERE VARNAME = 'DEALINGCUSTODYCD';

    IF V_EOMDATE = V_GETCURRENT THEN
        FOR REC IN
        (
            SELECT A.CUSTODYCD, SUM(A.SEBAL) SEBAL, SUM(A.ASSET_VND) ASSET_VND,SUM(A.ASSET_USD) ASSET_USD
            FROM (
                SELECT  CF.CUSTODYCD,
                SE.AFACCTNO,
                SE.ACCTNO,
                SB.SECTYPE,
                A2.CDCONTENT SETYPE,
                SB.CODEID,
                SB.TRADEPLACE,
                A1.CDCONTENT TRDPLACE,
                (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD) SEBAL,
                -----------------------------------------------------PRICE-----------------------------------------------------------------------------------
                CASE WHEN TRADEPLACE IN ('001','002','005','006') THEN
                (
                    CASE
                        WHEN SECTYPE IN ('001','002','007','008','011') THEN INF.CLOSEPRICE
                        WHEN SECTYPE IN ('003','006','009','012','013') THEN SB.PARVALUE
                        ELSE 0
                    END
                )
                    WHEN TRADEPLACE IN ('003','010') THEN SB.PARVALUE
                    ELSE 0
                END PRICE,
                -----------------------------------------------------ASSET-----------------------------------------------------------------------------------
                CASE WHEN TRADEPLACE IN ('001','002','005','006') THEN
                (
                    CASE
                        WHEN SECTYPE IN ('001','002','007','008','011') THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*INF.CLOSEPRICE
                        WHEN SECTYPE IN ('003','006','009','012','013') THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*SB.PARVALUE
                        ELSE 0
                    END
                )
                    WHEN TRADEPLACE IN ('003','010') THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*SB.PARVALUE
                    ELSE 0
                END ASSET,
                -----------------------------------------------------ASSET VND--------------------------------------------------------------------------------
                CASE WHEN TRADEPLACE IN ('001','002','005','006') THEN
                (
                    CASE
                        WHEN SECTYPE IN ('001','002','007','008','011') THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*INF.CLOSEPRICE
                        WHEN SECTYPE IN ('003','006','009','012','013') THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*SB.PARVALUE
                        ELSE 0
                    END
                )
                    WHEN TRADEPLACE IN ('003','010') THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*SB.PARVALUE
                    ELSE 0
                END * NVL(EX1.VND,1) AS ASSET_VND,
                ------------------------------------------------------ASSET USD-------------------------------------------------------------------------------
                ROUND(
                    CASE WHEN TRADEPLACE IN ('001','002','005','006') THEN
                    (
                        CASE
                            WHEN SECTYPE IN ('001','002','007','008','011') THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*INF.CLOSEPRICE
                            WHEN SECTYPE IN ('003','006','009','012','013') THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*SB.PARVALUE
                            ELSE 0
                        END
                    )
                        WHEN TRADEPLACE IN ('003','010') THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*SB.PARVALUE
                        ELSE 0
                    END * NVL(EX1.VND,1)/EX.VND
                ,4) AS ASSET_USD
                -------------------------------------------------------------------------------------------------------------------------------------
                ,NVL(EX1.VND,1) AS EX_RATED -- TI GIA CHUNG KHOAN
                ,EX.VND AS EX_RATE_USD -- TI GIA USD
                ,A3.SHORTCD AS CCYCD  --DON VI TIEN TE CHUNG KHOAN
                FROM SBSECURITIES SB, ALLCODE A1, ALLCODE A2, CFMAST CF,
                (
                    SELECT * FROM SEMAST_HIST WHERE HISTDATE = V_GETCURRENT
                ) SE,
                (
                    SELECT * FROM SECURITIES_INFO_HIST WHERE HISTDATE = V_GETCURRENT
                ) INF,
                (
                    SELECT CURRENCY,VND
                    FROM EXCHANGERATE_HIST
                    WHERE TRADEDATE = V_GETCURRENT
                    AND RTYPE = 'TTM'
                    AND ITYPE = 'SHV'
                    AND CURRENCY = 'USD'
                )EX,-- LAY TI GIA USD
                (
                    SELECT A.CURRENCY,A.VND,B.CCYCD
                    FROM  (
                        SELECT * FROM EXCHANGERATE_HIST
                        WHERE TRADEDATE = V_GETCURRENT AND RTYPE = 'TTM' AND ITYPE = 'SHV'
                    )A, -- LAY TI GIA
                    (
                        SELECT * FROM SBCURRENCY
                    )B -- LAY DON VI TIEN TE
                    WHERE A.CURRENCY= B.SHORTCD
                )EX1, --LAY TI GIA CHUNG KHOAN
                (
                    SELECT AL.*,SBC.CCYCD ,SBC.SHORTCD
                    FROM ALLCODE AL
                    JOIN SBCURRENCY SBC
                    ON AL.CDVAL=SBC.SHORTCD
                )A3 -- LAY TIEN TE CHUNG KHOAN
                WHERE SE.CODEID=SB.CODEID
                AND A1.CDTYPE = 'SE'
                AND A1.CDNAME = 'TRADEPLACE'
                AND A1.CDVAL = SB.TRADEPLACE
                AND A2.CDTYPE = 'SA'
                AND A2.CDNAME = 'SECTYPE'
                AND A2.CDVAL = SB.SECTYPE
                AND INF.CODEID = (CASE WHEN SB.TRADEPLACE ='006' THEN SB.REFCODEID ELSE SE.CODEID END)
                AND SE.CUSTID = CF.CUSTID
                AND CF.SUPEBANK='N'
                AND CF.CUSTATCOM = 'Y'
                AND CF.BONDAGENT <> 'Y'
                AND SUBSTR(CF.CUSTODYCD,0,4) <> V_SYSVAR
                AND NVL(SB.MANAGEMENTTYPE,'LKCK') = 'LKCK'
                AND (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW) > 0
                AND A3.CDNAME='CCYCD' AND A3.CDTYPE ='FA' AND A3.CCYCD=SB.CCYCD
                AND SB.CCYCD=EX1.CCYCD(+)
            ) A
            GROUP BY A.CUSTODYCD
        )
        LOOP
            BEGIN
                  SELECT AUTOID INTO V_AUTOID
                  FROM FEETRANA
                  WHERE TXNUM IS NULL AND TYPE = 'F' AND DELTD <> 'Y'
                  AND TO_CHAR(TO_DATE(TXDATE,SYSTEMNUMS.C_DATE_FORMAT), 'MM/RRRR') = TO_CHAR(TO_DATE(V_GETCURRENT,SYSTEMNUMS.C_DATE_FORMAT), 'MM/RRRR')
                  AND SUBTYPE = '001' AND FEETYPES = 'SEDEPO'
                  AND CUSTODYCD = REC.CUSTODYCD;
            EXCEPTION WHEN OTHERS THEN
                V_AUTOID := 0;
            END;
            IF V_AUTOID <> 0 THEN
                BEGIN
                    --LOCPT GOI LAN 1 DE LAY DC V_CCYCD
                    V_RESULT := CSPKS_FEECALC.FN_SEDEPO_CALC(REC.CUSTODYCD, REC.ASSET_USD, REC.SEBAL, V_FEECD, V_FEEAMT,V_FEERATE, V_CCYCD, V_FEECODE);
                    --LAN 2 MOI RA SO TIEN PHI DUNG
                    IF V_CCYCD = 'USD' THEN
                        V_RESULT := CSPKS_FEECALC.FN_SEDEPO_CALC(REC.CUSTODYCD, REC.ASSET_USD, REC.SEBAL, V_FEECD, V_FEEAMT,V_FEERATE, V_CCYCD, V_FEECODE);
                     ELSE
                        V_RESULT := CSPKS_FEECALC.FN_SEDEPO_CALC(REC.CUSTODYCD, REC.ASSET_VND, REC.SEBAL, V_FEECD, V_FEEAMT,V_FEERATE, V_CCYCD, V_FEECODE);
                     END IF;

                    --TRUNG.LUU: 21-09-2020  SHBVNEX-1569
                    IF V_FEECD IS NOT NULL OR V_FEECD <> '' THEN
                        V_RESULT := CSPKS_FEECALC.FN_TAX_CALC (REC.CUSTODYCD, V_FEEAMT,V_CCYCD,V_FEECD,2/*PV_ROUND IN NUMBER*/,V_TAX,V_VATRATE);
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    V_RESULT := -1;
                    PLOG.ERROR ('CSPKS_FEECALC.FN_SEDEPO_CALC.' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                END;

                IF V_RESULT = 0 THEN
                    UPDATE FEETRANA FE
                    SET FE.TXDATE = TO_DATE(V_GETCURRENT,SYSTEMNUMS.C_DATE_FORMAT),
                        FE.CCYCD = V_CCYCD,
                        FE.FEECD = V_FEECD,
                        FE.TXAMT = DECODE(V_CCYCD,'VND',REC.ASSET_VND,REC.ASSET_USD),
                        FE.FEEAMT = V_FEEAMT,
                        FE.FEERATE = V_FEERATE
                    WHERE FE.AUTOID = V_AUTOID;
                 END IF;

                 UPDATE FEETRANDETAILHIST
                 SET TXAMT = DECODE(V_CCYCD,'VND',REC.ASSET_VND,REC.ASSET_USD),
                     FEEAMT = V_FEEAMT,
                     ASSET = DECODE(V_CCYCD,'VND',REC.ASSET_VND,REC.ASSET_USD),
                     CCYCD = V_CCYCD,
                     SEBAL = REC.SEBAL
                 WHERE TXDATE = V_GETCURRENT --AND TXNUM IS NULL
                 AND FORP = 'F'
                 AND FEETYPES = 'SEDEPO'
                 AND CUSTODYCD = REC.CUSTODYCD;

                 IF V_VATRATE > 0 THEN
                    UPDATE FEETRANDETAILHIST
                    SET TXAMT = DECODE(V_CCYCD,'VND',REC.ASSET_VND,REC.ASSET_USD),
                        FEEAMT = V_FEEAMT,
                        ASSET = DECODE(V_CCYCD,'VND',REC.ASSET_VND,REC.ASSET_USD),
                        CCYCD = V_CCYCD,
                        SEBAL = REC.SEBAL
                    WHERE TXDATE = V_GETCURRENT AND TXNUM IS NULL
                    AND FORP = 'T'
                    AND FEETYPES = 'SEDEPO'
                    AND CUSTODYCD = REC.CUSTODYCD;
                 END IF;
             END IF;
        END LOOP;
    END IF;
EXCEPTION WHEN OTHERS THEN
    PLOG.ERROR ('CALCULATOR_SEDEPO: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN;
END;
/
