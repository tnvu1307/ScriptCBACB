SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_gen_bondconvert(pv_camastid IN VARCHAR2,pv_BONDNUMBER IN NUMBER)
    RETURN NUMBER IS
    v_Result  number;
    l_dbl_left_exrate NUMBER;
    l_dbl_right_exrate NUMBER;  
    l_roundtype number;  
    l_exrate  VARCHAR2(50);
BEGIN
    SELECT nvl(exrate,'1/1'),nvl(roundtype,0)
    INTO l_exrate,l_roundtype FROM camast
    WHERE camastid=pv_camastid;
    l_dbl_left_exrate := nvl(to_number(substr(l_exrate,0,instr(l_exrate,'/') - 1)),'1');
    l_dbl_right_exrate :=nvl(to_number( substr(l_exrate,instr(l_exrate,'/') + 1,length(l_exrate))),1);        
    SELECT trunc (FLOOR( pv_BONDNUMBER * l_dbl_right_exrate / l_dbl_left_exrate ),l_roundtype) INTO v_Result FROM DUAL;
    RETURN v_Result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
