SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_cifid(P_CUSTODYCD IN VARCHAR2)
    RETURN varchar2 IS

    V_RESULT varchar2(200);




BEGIN

    select cifid into V_RESULT from cfmast where custodycd = P_CUSTODYCD;


RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
