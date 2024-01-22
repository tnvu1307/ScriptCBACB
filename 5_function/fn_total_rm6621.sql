SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_total_rm6621(  pv_refcasaacct IN VARCHAR2 ,pv_custodycd IN VARCHAR2)
    RETURN NUMBER IS
     l_Result  NUMBER;
   BEGIN
   begin
        select (DD.BALANCE + DD.HOLDBALANCE+Dd.PENDINGHOLD+Dd.pendingunhold)TOTAL into l_Result
        from DDMAST DD,AFMAST AF, CFMAST CF
        where CF.custid = AF.CUSTID AND AF.ACCTNO = DD.AFACCTNO and CF.custodycd=pv_custodycd
        and  DD.ACCTNO = pv_refcasaacct;
    return l_Result;
    end;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
