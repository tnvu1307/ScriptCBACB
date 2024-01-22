SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_SYMBOL_2245( PV_CODEID IN NUMBER)
    RETURN NUMBER IS
-- Purpose: Phi giao dich 2244
-- MODIFICATION HISTORY
-- Person      Date         Comments
-- ---------   ------       -------------------------------------------
-- LONGNH   22/10/2014     Created
    V_RESULT VARCHAR2(20);

BEGIN
SELECT SYMBOL INTO V_RESULT FROM sbsecurities WHERE CODEID = 'PV_CODEID';


RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
 
 
 
 
/
