SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_escrow_blockamt_usd( pv_AMT IN varchar2,pv_EXCHANGERATE IN varchar2)
    RETURN NUMBER IS
    v_Result  NUMBER;

BEGIN
    if pv_EXCHANGERATE <> '0' then
        v_Result    := round(to_number(nvl(pv_AMT,'0'))/to_number(nvl(pv_EXCHANGERATE,'0')),5);
    else
        v_Result    := 0;
    end if;

    RETURN nvl(Round(v_Result,2),0);

EXCEPTION
   WHEN OTHERS THEN
   plog.error('fn_escrow_blockamt_usd: pv_AMT='||pv_AMT||', pv_EXCHANGERATE='||pv_EXCHANGERATE||'.Error: '||SQLERRM || dbms_utility.format_error_backtrace);
    RETURN 0;
END;
/
