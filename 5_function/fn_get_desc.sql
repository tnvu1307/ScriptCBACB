SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_desc(pv_symbol IN VARCHAR2,pv_amt IN varchar2)
    RETURN varchar2 IS
    v_Result  varchar2(250);

BEGIN

    select  'FCT_Securities transferring_'||pv_symbol||'_orginal amount: VND '||pv_amt into v_Result from dual;
    RETURN v_Result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/
