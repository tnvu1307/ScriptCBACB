SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_escrow_ccycd( pv_DDACCTNO IN VARCHAR2)
    RETURN varchar2 IS
    v_Result  varchar2(100);

BEGIN

    select max(dd.ccycd) into v_Result from ddmast dd where dd.acctno = pv_DDACCTNO and status <> 'C';
    RETURN nvl(v_Result,'VND');

EXCEPTION
   WHEN OTHERS THEN
   plog.error('fn_escrow_CCYCD: pv_DDACCTNO='||pv_DDACCTNO||'.Error: '||SQLERRM || dbms_utility.format_error_backtrace);
    RETURN 'VND';
END;
/
