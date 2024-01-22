SET DEFINE OFF;
CREATE OR REPLACE FUNCTION check_custodycd  (p_custodycd IN varchar2
)
  RETURN  number IS
    p_tmp number;
    p_count number;
    l_custid varchar2(20);
    l_activests varchar2(5);
    l_result number;
BEGIN
    if p_custodycd is null then
        l_result :=1;
        return l_result;
    end if;
    SELECT custid,activests into l_custid,l_activests
    FROM CFMAST CF
    WHERE cf.custodycd=p_custodycd;

    if l_activests ='Y' then
        l_result:=0;
    else
        if (SUBSTR(trim(p_custodycd),1,3)='OTC') then
            begin
                p_tmp:=0; p_count:=0;
                select count(*)  into  p_count from  vw_odmast_all od where od.custid =l_custid;
                p_tmp:=p_tmp+p_count;
                select count(*) into  p_count from semast se, setrana sea where se.acctno=sea.acctno and se.custid=l_custid;
                p_tmp:=p_tmp+p_count;
                --TRUNG.LUU : 23/06/2020 COMMENT LAI GIUM ANH lOC
                /*select count(*) into  p_count from vw_ddmast_all dd where dd.custid=l_custid;
                p_tmp:=p_tmp+p_count;*/
                select count(*) into  p_count from (select * from escrow where scustid =l_custid or bcustid =l_custid
                union all select * from escrowmemo where scustid =l_custid or bcustid =l_custid);
                p_tmp:=p_tmp+p_count;
                select count(*) into  p_count from otcodmast where scustid =l_custid or bcustid =l_custid;
                p_tmp:=p_tmp+p_count;
                if p_tmp <> 0 then
                    l_result:=0;
                else
                    l_result:=1;
                end if;
            end;
        else l_result:=1;
        end if;
     end if;
     return l_result;
EXCEPTION when others then
       RETURN 0;
END;
/
