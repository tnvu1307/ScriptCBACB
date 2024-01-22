SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_GET_PBLOCKED_QTTY(pv_camastid varchar2 ,pv_codeid varchar2, pv_afacctno varchar2, pv_qtty number)
return number is
v_return number;
v_maxPBlocked   number;
BEGIN
    v_maxPBlocked := FN_GET_PBLOCKED(pv_camastid,pv_codeid,pv_afacctno);
    v_return := LEAST(pv_qtty,v_maxPBlocked);
    RETURN v_return;
exception when others then
    plog.error('FN_GET_PBLOCKED_QTTY error : '||SQLERRM
                || ', pv_camastid=' || pv_camastid
                || ', pv_codeid=' || pv_codeid
                || ', pv_afacctno=' || pv_afacctno
                || ', pv_qtty=' || pv_qtty
                );
    return 0;
end;
 
 
/
