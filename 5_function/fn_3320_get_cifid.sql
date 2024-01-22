SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_3320_get_cifid(pv_custodycd varchar2)
    RETURN varchar2 IS 
    v_cifid varchar2(10);

BEGIN
BEGIN
    select cf.cifid into v_cifid from CFMAST cf where cf.custodycd = pv_custodycd; 
   RETURN v_cifid;
END;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
