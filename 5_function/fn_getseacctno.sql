SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getseacctno( pv_CUSTODYCD IN VARCHAR2,pv_CODEID IN NUMBER)
    RETURN VARCHAR2 IS
    v_Result  NUMBER;
    v_afacctno  varchar2(20);
    
BEGIN
    select max(af.acctno) into v_afacctno 
    from cfmast cf, afmast af 
    where cf.custid = af.custid and cf.custodycd = pv_CUSTODYCD;
    
    v_Result    := v_afacctno||pv_CODEID;
    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/
