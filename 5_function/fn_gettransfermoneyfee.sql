SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_gettransfermoneyfee(PV_AMOUNT IN number,P_FEETYPE IN VARCHAR2)
    RETURN NUMBER IS
    V_RESULT NUMBER;

BEGIN
V_RESULT :=0;

SELECT  round(CASE WHEN FORP='F' THEN FEEAMT ELSE LEAST(GREATEST( FEERATE/100 * PV_AMOUNT  , MINVAL),MAXVAL) END) INTO V_RESULT
FROM FEEMASTER WHERE FEECD = P_FEETYPE AND STATUS ='Y';

RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;

 
 
 
 
 
 
 
 
 
 
/
