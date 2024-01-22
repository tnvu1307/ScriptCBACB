SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getexchangerate_1712( pv_DDACCTNO IN VARCHAR2,pv_DDACCTNO_R IN VARCHAR2,FXTYPE IN VARCHAR2,EXRATE varchar2)
    RETURN NUMBER IS
     N_RESULT NUMBER;
     v_ccycd varchar2(10);
     v_ccycd_r varchar2(10);
BEGIN
    select ccycd into v_ccycd from ddmast where acctno = pv_DDACCTNO;
    select ccycd into v_ccycd_r from ddmast where acctno = pv_DDACCTNO_R;
    if to_number(EXRATE) = 0 or to_number(EXRATE) = 0.000000 or to_number(EXRATE) = 1.000000 then
        if v_ccycd <> 'VND' then
            select vnd into N_RESULT from exchangerate where    itype= 'SHV' and currency = v_ccycd and rtype =FXTYPE;
        elsif v_ccycd_r <> 'VND' then
            select vnd into N_RESULT from exchangerate where    itype= 'SHV' and currency = v_ccycd_r and rtype =FXTYPE;
        end if;
        if v_ccycd = 'VND' and v_ccycd_r ='VND' then
            N_RESULT :=1;
        end if;
    else
        N_RESULT := EXRATE;
    end if;
    RETURN N_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 1;
END;
/
