SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_gen_desc_camast_024 (p_codeid varchar2,p_Reportdate varchar2, p_typeRate varchar2,p_rate varchar2, p_value varchar2,p_EXPRICE varchar2) return string
is
v_desc varchar2(500);
v_symbol varchar2(20);
begin
    v_desc:='Covered warrant payment, <$CODEID>, record date <$REPORTDATE>, <$DES>, settlement price <$EXPRICE>' ;

    if length(p_codeid)>0 then
    begin
    select symbol into v_symbol from sbsecurities where codeid=p_codeid;
    EXCEPTION
    WHEN OTHERS
       THEN
       v_symbol := p_codeid;

    END;
          v_desc:= replace(v_desc,'<$CODEID>',v_symbol);
       end if;
       v_desc:= replace(v_desc,'<$REPORTDATE>',p_Reportdate);
       if (p_typeRate ='R') then
         v_desc:= replace(v_desc,'<$DES>','rate '||trim(to_char(to_number(p_rate),'FM9,999,999,999,999,999,990.099999'))||'%');
       else
          v_desc:= replace(v_desc,'<$DES>','allocation amount '||trim(to_char(to_number(p_value),'FM9,999,999,999,999,999,990.0999')));
       end if;
       v_desc:= replace(v_desc,'<$EXPRICE>',trim(to_char(to_number(p_EXPRICE),'FM9,999,999,999,999,999,999')));
       return v_desc;
exception when others then
       return 'Covered warrant payment';
end;
/
