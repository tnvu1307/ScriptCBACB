SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_HOLDBALANCE(P_CUSTODYCD IN VARCHAR2)
    RETURN number IS

    V_RESULT number(20,2);



BEGIN
    V_RESULT := 0;
    select HOLDBALANCE into V_RESULT from ddmast where isdefault = 'Y' and ccycd = 'VND' and custodycd = P_CUSTODYCD;
    if V_RESULT is null then
        V_RESULT := 0;
    end if;
RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
