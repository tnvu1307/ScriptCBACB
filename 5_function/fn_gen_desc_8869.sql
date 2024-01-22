SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_gen_desc_8869 (p_ddacctno varchar2, p_STATEBANK varchar2) return string
is
v_desc varchar2(500);

begin



            v_desc:= 'Payment For Buying Government Bonds For Customers STK ' || p_ddacctno || ' in ' || p_STATEBANK ;

       return v_desc;
exception when others then
       return 'Payment For Buying Government Bonds For Customers';
end;
/
