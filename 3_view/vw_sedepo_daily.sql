SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_SEDEPO_DAILY
(CUSTODYCD, AFACCTNO, ACCTNO, SECTYPE, SETYPE, 
 CODEID, TRADEPLACE, TRDPLACE, SEBAL, PRICE, 
 ASSET, ASSET_VND, ASSET_USD, EX_RATED, EX_RATE_USD, 
 CCYCD)
AS 
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
       CASE
             WHEN TRADEPLACE IN ('001','002','005','006') THEN
                (
                CASE
                    WHEN SECTYPE IN ('001','002','007','008','011')
                        THEN INF.CLOSEPRICE
                    WHEN SECTYPE IN ('003','006','009','012','013')
                        THEN SB.PARVALUE
                    ELSE 0
                END
                )
            WHEN TRADEPLACE IN ('003','010','099')
                THEN SB.PARVALUE
            ELSE 0
         END PRICE,
       -----------------------------------------------------ASSET-----------------------------------------------------------------------------------
        CASE
            WHEN TRADEPLACE IN ('001','002','005','006') THEN
                (
                CASE
                    WHEN SECTYPE IN ('001','002','007','008','011')
                        THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*INF.CLOSEPRICE
                    WHEN SECTYPE IN ('003','006','009','012','013')
                        THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*SB.PARVALUE
                    ELSE 0
                END
                )
            WHEN TRADEPLACE IN ('003','010','099')
                THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*SB.PARVALUE
            ELSE 0
        END ASSET,
        -----------------------------------------------------ASSET VND--------------------------------------------------------------------------------
         CASE
            WHEN TRADEPLACE IN ('001','002','005','006') THEN
                (
                CASE
                    WHEN SECTYPE IN ('001','002','007','008','011')
                        THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*INF.CLOSEPRICE
                    WHEN SECTYPE IN ('003','006','009','012','013')
                        THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*SB.PARVALUE
                    ELSE 0
                END
                )
            WHEN TRADEPLACE IN ('003','010','099')
                THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*SB.PARVALUE
            ELSE 0
        END * NVL(EX1.VND,1) AS ASSET_VND,
        ------------------------------------------------------ASSET USD-------------------------------------------------------------------------------
        ROUND(
        CASE
            WHEN TRADEPLACE IN ('001','002','005','006') THEN
                (
                CASE
                    WHEN SECTYPE IN ('001','002','007','008','011')
                        THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*INF.CLOSEPRICE
                    WHEN SECTYPE IN ('003','006','009','012','013')
                        THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*SB.PARVALUE
                    ELSE 0
                END
                )
            WHEN TRADEPLACE IN ('003','010','099')
                THEN (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW+SE.HOLD)*SB.PARVALUE
            ELSE 0
        END * NVL(EX1.VND,1)/EX.VND
            ,4) AS ASSET_USD
        -------------------------------------------------------------------------------------------------------------------------------------
       ,NVL(EX1.VND,1) AS EX_RATED -- TI GIA CHUNG KHOAN
       ,EX.VND AS EX_RATE_USD -- TI GIA USD
       ,A3.SHORTCD AS CCYCD  --DON VI TIEN TE CHUNG KHOAN
FROM SEMAST SE, SBSECURITIES SB, ALLCODE A1, ALLCODE A2, SECURITIES_INFO INF, CFMAST CF,
    (
    SELECT CURRENCY,VND
    FROM EXCHANGERATE
    WHERE TRADEDATE <= GETCURRDATE
         AND RTYPE = 'TTM'
         AND ITYPE = 'SHV'
         AND CURRENCY = 'USD'
     )EX,-- LAY TI GIA USD
    (
    SELECT A.CURRENCY,A.VND,B.CCYCD
    FROM  (
          SELECT * FROM EXCHANGERATE
           WHERE TRADEDATE <= GETCURRDATE   AND RTYPE = 'TTM'   AND ITYPE = 'SHV'
          )A, -- LAY TI GIA
          (
          SELECT * from SBCURRENCY
          )B -- LAY DON VI TIEN TE
    WHERE A.CURRENCY= B.shortcd
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
      AND NVL(SB.MANAGEMENTTYPE,'LKCK') = 'LKCK'
      AND (SE.TRADE+SE.MARGIN+SE.MORTAGE+SE.BLOCKED+SE.SECURED+SE.REPO+SE.NETTING+SE.DTOCLOSE+SE.WITHDRAW) > 0
      AND A3.CDNAME='CCYCD' AND A3.CDTYPE ='FA' AND A3.CCYCD=SB.CCYCD
      AND SB.CCYCD=EX1.CCYCD(+)
/
