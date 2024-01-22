SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getafmast(p_custodycd varchar2)
  RETURN  varchar2

  IS
    v_afmast varchar2(100);
    v_custid varchar2(100);
BEGIN
    select custid into v_custid from cfmast where custodycd = p_custodycd;
    select acctno into v_afmast from afmast where custid = v_custid;
    RETURN v_afmast;
EXCEPTION
   WHEN others THEN
    RETURN 0;
END;
/
