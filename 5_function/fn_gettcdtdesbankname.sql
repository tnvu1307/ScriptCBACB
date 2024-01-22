SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_gettcdtdesbankname(pv_brid varchar2) return varchar2
is
v_return varchar2(100);
v_bridBIDVHN varchar(60);

begin

    begin
        --29/09/2015 THCT DieuNDA: PHS chi co 1 TCDTHCM BIDVHCM
        /*if pv_brid ='0101' then
            --Chi nhanh HCM
            select refacctname into v_return from crbdefacct where  refbank = 'BIDVHCM' and trfcode = 'TCDT';
        else
            --Hoi so
            select refacctname into v_return from crbdefacct where  refbank = 'BIDVHN' and trfcode = 'TCDT';
        end if;*/
        --select refacctname into v_return from crbdefacct where  refbank = 'BIDVHCM' and trfcode = 'TCDT';

        --End 29/09/2015 THCT DieuNDA
        Begin
            select varvalue into v_bridBIDVHN from sysvar where grname='TCDT' and varname='BIDVBRGRPLIST' and rownum <= 1 ;
        exception when others then
            v_bridBIDVHN := '';
        End;        
        
        if instr(v_bridBIDVHN,pv_brid) > 0 then
            --Chi nhanh HN
            select refacctno into v_return from crbdefacct where  refbank = 'BIDVHN' and trfcode = 'TCDT';
        else
            --Hoi so
            select refacctno into v_return from crbdefacct where  refbank = 'BIDVHCM' and trfcode = 'TCDT';
        end if;

        return v_return;
    end;
exception when others then
    select refacctname into v_return from crbdefacct where  refbank = 'BIDVHCM' and trfcode = 'TCDT';
    return v_return;
end;
 
 
/
