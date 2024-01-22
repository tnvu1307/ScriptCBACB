SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_gen_desc_3369 (p_desccription varchar2,p_bankaccname varchar2, p_symbol varchar2) return string
is
v_desc varchar2(500);

begin



            v_desc:= p_bankaccname||' chuyển tiền thực hiện quyền mua cồ phiếu '|| p_symbol ;

       return v_desc;
exception when others then
       return 'Chuyen khoan noi bo';
end;

 
 
 
 
/
