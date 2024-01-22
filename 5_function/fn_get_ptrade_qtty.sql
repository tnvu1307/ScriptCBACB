SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_GET_PTRADE_QTTY(pv_camastid varchar2 ,pv_codeid varchar2, pv_afacctno varchar2, pv_qtty number, pv_blocked number)
return number is
v_return number;
v_maxPTrade   number;
BEGIN
    v_maxPTrade := FN_GET_PTRADE(pv_camastid,pv_codeid,pv_afacctno);
    v_return := LEAST(pv_qtty-pv_blocked,v_maxPTrade);
    RETURN v_return;
exception when others then
    plog.error('FN_GET_PTRADE_QTTY error : '||SQLERRM
                || ', pv_camastid=' || pv_camastid
                || ', pv_codeid=' || pv_codeid
                || ', pv_afacctno=' || pv_afacctno
                || ', pv_qtty=' || pv_qtty
                || ', pv_blocked=' || pv_blocked
                );
    return 0;
end;
 
 
/
