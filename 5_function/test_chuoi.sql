SET DEFINE OFF;
CREATE OR REPLACE FUNCTION Test_chuoi (p_number IN VARCHAR2)
   RETURN VARCHAR2
AS
   l_num      VARCHAR2 (50);
   l_return   VARCHAR2 (4000); 
BEGIN
    l_num:=p_number;
    if instr(l_num,'.') > 0 then
        l_return:= utils.fnc_number2vie(substr(l_num,0,instr(l_num,'.')-1)) || ' phay ' 
        || Lower(utils.fnc_number2vie(substr(l_num,instr(l_num,'.')+1,length(l_num)-instr(l_num,'.'))));
    else
        l_return:= utils.fnc_number2vie(l_num);
    end if;
   RETURN l_return;
END;
/
