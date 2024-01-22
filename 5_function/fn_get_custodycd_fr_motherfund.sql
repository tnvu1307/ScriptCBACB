SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_custodycd_fr_motherfund(P_CUSTODYCD IN VARCHAR2)
    RETURN varchar2 IS

    V_RESULT varchar2(4000);
BEGIN

    for r in (select custodycd from cfmast where mcustodycd = P_CUSTODYCD and status <> 'C')
        loop
            V_RESULT:=V_RESULT || r.custodycd ||',' ;
        end loop;
    V_RESULT:= substr(V_RESULT,0,length(V_RESULT) - 1);
RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
