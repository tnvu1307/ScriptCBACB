SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getsebalance (p_afacctno IN VARCHAR2,p_codeid IN VARCHAR2)
RETURN NUMBER
  IS
    l_balance NUMBER(20,2);
    
BEGIN
 l_balance:= 0;

select trade into l_balance
from semast where afacctno = p_afacctno and codeid = p_codeid;



RETURN l_balance;

EXCEPTION WHEN others THEN
    return 0;
END;
/
