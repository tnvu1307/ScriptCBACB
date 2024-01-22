SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_demo_send_cop_action (p_camastid varchar2)
IS
v_status varchar2(10);
BEGIN
    select status into v_status from camast where camastid = p_camastid;
    if v_status='A' then

        update camast set status ='S' where camastid = p_camastid;
        commit;

        update caschd set status ='S' where camastid = p_camastid and deltd <> 'Y' and status ='A';

        commit;

    end if;

end;
/
