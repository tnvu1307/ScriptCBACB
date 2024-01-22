SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_acctno(P_CUSTODYCD IN VARCHAR2)
    RETURN varchar2 IS

    V_RESULT varchar2(200);
    v_custid varchar2(200);



BEGIN

    select custid into v_custid from cfmast where custodycd = P_CUSTODYCD;

    select acctno into V_RESULT from afmast where custid  = v_custid and ROWNUM = 1;

RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
