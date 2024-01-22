SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_GET_COREBANK( pv_afacctno IN VARCHAR2)
    RETURN VARCHAR2 IS
    v_Result  varchar2(2);

BEGIN
                 -- select (case when af.corebank = 'Y' then af.corebank else af.alternateacct end) into v_Result from afmast af where ACCTNO=pv_afacctno;
                  select  af.corebank into v_Result from afmast af where ACCTNO=pv_afacctno;
 RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 'N';
END;
 
 
/
