SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_semast_avl_trade_otc(pv_afacctno In VARCHAR2, pv_codeid IN VARCHAR2, pv_otcodmastid IN VARCHAR2)
    RETURN number IS

    l_TRADE NUMBER(20,2);

BEGIN
    if length(trim(pv_otcodmastid)) <> 0 then
        SELECT NETTING INTO  l_TRADE FROM semast WHERE acctno = pv_afacctno||pv_codeid;
    else
        SELECT TRADE INTO  l_TRADE FROM semast WHERE acctno = pv_afacctno||pv_codeid;
    end if;

    RETURN l_TRADE ;
exception when others then
    return 0;
END;
/
