SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_OD_ParentsOderid(p_orderid IN varchar2)
  RETURN VARCHAR2 IS
    v_Result VARCHAR2(200);
    l_reforderid varchar2(20);
    l_porderid varchar2(200);
BEGIN
/*
Truyen vao oderid cua cua 1 lenh
Ham nay tra ve list cac lenh goc cua lenh truyen vao.
*/
    v_Result:=p_orderid;
    select nvl(REFORDERID,'---') into l_reforderid from odmast where orderid=p_orderid ;
    if (l_reforderid='---') then
        return v_Result;
    else
        select FN_OD_ParentsOderid(l_reforderid) into l_porderid from dual;
        v_Result:=v_Result||'|'||l_porderid;
    end if;
    return v_Result;

    RETURN v_Result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN null;
END;
 
 
 
 
/
