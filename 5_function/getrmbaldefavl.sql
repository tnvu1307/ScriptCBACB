SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getrmbaldefavl (p_afacctno IN VARCHAR2,p_memberid IN VARCHAR2)
RETURN NUMBER
  IS
    l_baldefavl NUMBER(20,2);
     l_hold NUMBER(20,2);
      l_unhold NUMBER(20,2);
BEGIN
l_baldefavl := 0;

select holdbalance  into l_baldefavl
from buf_dd_member
where DDACCTNO = p_afacctno and memberid = p_memberid;
return l_baldefavl;
EXCEPTION WHEN others THEN
    return 0;
END;
/
