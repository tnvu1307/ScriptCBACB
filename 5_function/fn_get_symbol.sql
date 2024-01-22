SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_SYMBOL( PV_CODEID IN VARCHAR2)
    RETURN VARCHAR2 IS
-- Purpose: Phi giao dich 2244
-- MODIFICATION HISTORY
-- Person      Date         Comments
-- ---------   ------       -------------------------------------------
-- LONGNH   22/10/2014     Created
    V_RESULT VARCHAR2(20);

BEGIN
SELECT SYMBOL INTO V_RESULT FROM sbsecurities WHERE CODEID = PV_CODEID;


RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN PV_CODEID;
END;
 
 
 
 
/
