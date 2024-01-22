SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_tk_rm6621(pv_refcasaacct IN VARCHAR2)
    RETURN VARCHAR2 IS
     l_Result  VARCHAR2(1000);
   BEGIN 
   begin
        select DD.REFCASAACCT into l_Result
            from DDMAST DD 
            where DD.acctno=pv_refcasaacct;
    return l_Result;
    end;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
