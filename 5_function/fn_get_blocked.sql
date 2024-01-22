SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_blocked(pv_camastid varchar2 ,pv_codeid varchar2, pv_afacctno varchar2)
return number is
v_return number;
v_codeid varchar2(20);
BEGIN
    select codeid into v_codeid from camast where camastid=pv_camastid;

    select blocked - inblocked into v_return from caschd_log
    where camastid = pv_camastid
    and codeid = pv_codeid
    and afacctno = pv_afacctno
    and deltd = 'N';
    return v_return;
exception when others then
    plog.error('FN_GET_BLOCKED error: '||SQLERRM
                || ', pv_camastid=' || pv_camastid
                || ', pv_codeid=' || pv_codeid
                || ', pv_afacctno=' || pv_afacctno
                );
    return 0;
end;
/
