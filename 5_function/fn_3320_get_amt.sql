SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_3320_get_amt( pv_codeid varchar2, pv_custodycd varchar2)
    RETURN NUMBER IS
    v_Result  NUMBER;
    v_wftcodeid   varchar2(6);
    v_custid varchar2(20);

BEGIN
    begin
    select codeid into v_wftcodeid from sbsecurities where nvl(refcodeid,'a')=pv_codeid;
    exception
    when others then
    v_wftcodeid:=pv_codeid;
    end;


    begin
    select custid  into v_custid from cfmast where custodycd = pv_custodycd;
    exception
    when others then
        v_custid:='0';
    end;

     if(pv_custodycd ='ALL') THEN
       v_custid:='%';
     end if;

   select sum( trade+margin+wtrade+mortage+BLOCKED+secured+repo+netting+dtoclose+withdraw)
   into v_Result from semast where (codeid=pv_codeid or codeid=v_wftcodeid) and custid like v_custid ;
   RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
 
 
/
