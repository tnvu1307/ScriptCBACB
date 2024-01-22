SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getddmastdefaul(p_custodycd varchar2)
  RETURN  varchar2

  IS
    v_ddmast varchar2(100);

BEGIN
    SELECT dd.acctno into v_ddmast from ddmast dd where dd.custodycd = p_custodycd and dd.status <> 'C' and dd.isdefault = 'Y';
    RETURN v_ddmast;
EXCEPTION
   WHEN others THEN
    RETURN 0;
END;
/
