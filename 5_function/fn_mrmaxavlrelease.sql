SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_mrmaxavlrelease(p_afacctno varchar2) return number
is
l_result number(20,0);
l_currdate date;
l_chksysctrl varchar2(1);
l_mriratio number;
begin
    select to_date(varvalue,'DD/MM/RRRR') into l_currdate from sysvar where varname = 'CURRDATE' and grname = 'SYSTEM';
    select 100 - mriratio into l_mriratio from afmast where acctno = p_afacctno;
    
    l_result := 0;

    return l_result;
exception when others then
return 0;
end;
 
 
 
 
/
