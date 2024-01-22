SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_intprice
(
PV_SYMBOL       IN VARCHAR2,
PV_DATE         IN DATE,
PV_X            OUT NUMBER,
PV_X1           OUT NUMBER,
PV_X2           OUT NUMBER,
PV_Y            OUT NUMBER,
PV_Y1           OUT NUMBER,
PV_Y2           OUT NUMBER
)
RETURN NUMBER
IS
    V_MATURITYDATE   DATE;
    V_CHECK          VARCHAR2(50);
    V_X              NUMBER:=0;
    V_Y              NUMBER:=0;
    V_X1             NUMBER:=0;
    V_X2             NUMBER:=0;
    V_Y1             NUMBER:=0;
    V_Y2             NUMBER:=0;
    V_RETURN         NUMBER;
    V_COUPONRATE     NUMBER;
    V_PARVALUE       NUMBER;
    V_YEAR           NUMBER;
    V_DENOMINATOR    NUMBER;
    V_INCOME         NUMBER;
    V_FREQUENCY      NUMBER;
    V_SETTLEDATE     DATE;
    pkgctx   plog.log_ctx;
BEGIN
  --GET EXPDATE-----------------------------------------------------------------
  BEGIN
      SELECT EXPDATE, INTCOUPON, PARVALUE, GETNEXTWORKINGDATE(PV_DATE), DECODE(PERIODINTEREST,'001',360,'002',12,'003',4,'004',2,'005',1)
      INTO V_MATURITYDATE, V_COUPONRATE, V_PARVALUE, V_SETTLEDATE, V_FREQUENCY
      FROM SBSECURITIES
      WHERE SYMBOL =PV_SYMBOL;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN  V_MATURITYDATE        := NULL;
                               V_COUPONRATE     := 0;
                               V_PARVALUE       := 0;
  END;
  --GET X-----------------------------------------------------------------------
  BEGIN
      SELECT ROUND(ABS((V_MATURITYDATE - TO_DATE(PV_DATE,'DD/MM/RRRR'))/365),10)
      INTO V_X
      FROM DUAL;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN  V_X := 0;
  END;
  IF (V_X <= 1 OR V_X >= 50) THEN
      V_RETURN:=0;
      PV_X:=0;
      PV_X1:=0;
      PV_X2:=0;
      PV_Y := 0;
      PV_Y1:=0;
      PV_Y2:=0;
  RETURN V_RETURN;
  END IF;
  --------------------GET CAN DUOI--------------------------------------
  BEGIN
     SELECT NVL(MAX(remaintime),0),NVL(MAX(intrate),0) INTO V_X1,V_Y1
     FROM (
          SELECT TO_NUMBER(remaintime)remaintime,intrate
          FROM (
                    SELECT *
                    FROM BONDPRICING
                    UNPIVOT(
                    INTRATE FOR REMAINTIME IN (
                                            Y1 AS '1',
                                            Y2 AS '2',
                                            Y3 AS '3',
                                            Y4 AS '4',
                                            Y5 AS '5',
                                            Y7 AS '7',
                                            Y10 AS '10',
                                            Y15 AS '15',
                                            Y20 AS '20',
                                            Y25 AS '25',
                                            Y30 AS '30',
                                            Y50 AS '50'
                                        )
                            )
                    WHERE TXDATE = TO_DATE(PV_DATE,'DD/MM/RRRR') AND REMAINTIME < V_X
              )
        );
  EXCEPTION WHEN NO_DATA_FOUND THEN V_X1 := 0;V_Y1 := 0;
  END;
  --------------------GET CAN TREN--------------------------------------
  BEGIN
     SELECT NVL(MIN(remaintime),0),NVL(MIN(intrate),0)  INTO V_X2,V_Y2
     FROM (
          SELECT TO_NUMBER(remaintime)remaintime,intrate
          FROM (
                    SELECT *
                    FROM BONDPRICING
                    UNPIVOT(
                    INTRATE FOR REMAINTIME IN (
                                            Y1 AS '1',
                                            Y2 AS '2',
                                            Y3 AS '3',
                                            Y4 AS '4',
                                            Y5 AS '5',
                                            Y7 AS '7',
                                            Y10 AS '10',
                                            Y15 AS '15',
                                            Y20 AS '20',
                                            Y25 AS '25',
                                            Y30 AS '30',
                                            Y50 AS '50'
                                        )
                            )
                    WHERE TXDATE = TO_DATE(PV_DATE,'DD/MM/RRRR') AND REMAINTIME > V_X
              )
        );
  EXCEPTION WHEN NO_DATA_FOUND THEN V_X2 := 0;V_Y2 := 0;
  END;
  --GET Y-----------------------------------------------------------------------
  PV_X:=V_X;
  PV_X1:=V_X1;
  PV_X2:=V_X2;
  IF ((V_X2 - V_X1) <> 0) THEN
     PV_Y := ROUND((V_Y1 + (V_Y2 - V_Y1) * ((V_X - V_X1)/(V_X2 - V_X1))),10);
  ELSE
     PV_Y := 0;
  END IF;
  PV_Y1:=V_Y1;
  PV_Y2:=V_Y2;

  --PRICE-----------------------------------------------------------------------
  /*V_YEAR := V_X;
  IF PV_Y =0 THEN
    V_INCOME:=1;
  ELSE
    V_INCOME:= PV_Y;
  END IF;
  V_DENOMINATOR := POWER(1+V_INCOME, V_YEAR);
  V_RETURN := (V_PARVALUE*(V_COUPONRATE/100)/V_INCOME)*(1-1/V_DENOMINATOR) + (V_PARVALUE/V_DENOMINATOR);*/
  --NAM.LY
  BEGIN

          SELECT XLS_FIN.PRICE(
                               P_SETTLEMENT => V_SETTLEDATE
                             , P_MATURITY => V_MATURITYDATE
                             , P_RATE => NVL(V_COUPONRATE,0)/100
                             , P_YLD => PV_Y --YIELD
                             , P_REDEMPTION => 100 --DEFAULT 100
                             , P_FREQUENCY => V_FREQUENCY -- IN (1,2,4)
                             , P_BASIS => 3 --Actual/actual
                             )/100*NVL(V_PARVALUE,0)
          INTO V_RETURN
          FROM DUAL;
          EXCEPTION WHEN OTHERS THEN V_RETURN := 0;
  END;
  RETURN V_RETURN;
EXCEPTION
  WHEN OTHERS THEN
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
END;
/
