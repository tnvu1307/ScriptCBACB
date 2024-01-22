SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_semast_avl_withdraw(pv_afacctno In VARCHAR2, pv_codeid IN VARCHAR2)
    RETURN number IS

    l_AVLSEWITHDRAW NUMBER(20,2);
    l_trade NUMBER(20,2);
    l_sewithdrawcheck_arr txpks_check.sewithdrawcheck_arrtype;
    l_semastcheck_arr txpks_check.semastcheck_arrtype;
    v_temp number;
BEGIN
   --  l_sewithdrawcheck_arr := txpks_check.fn_sewithdrawcheck(pv_afacctno || pv_codeid ,'SEWITHDRAW','ACCTNO');
     l_semastcheck_arr := txpks_check.fn_semastcheck(pv_afacctno || pv_codeid ,'SEMAST','ACCTNO');
    -- l_AVLSEWITHDRAW := l_sewithdrawcheck_arr(0).AVLSEWITHDRAW;
     l_trade:=l_semastcheck_arr(0).trade;
     --trung.luu: 31-07-2020 SHBVNEX-1310
     select temp into v_temp from semast where acctno = pv_afacctno || pv_codeid;
     l_trade := l_trade - v_temp;

    RETURN l_trade;
exception when others then
    return 0;
END;
/
