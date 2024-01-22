SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE PR_CHANGE_BROKER_PASSWORD(p_tlid varchar2,p_password varchar2) is
BEGIN
  --plog.error('diennt p_tlid' || p_tlid );
  --plog.error('diennt p_password' || p_password );
  update tlprofiles
     set pin = genencryptpassword(p_password)
   where tlid = p_tlid;

  commit;
  exception
    when others then
      return;
end pr_change_broker_password;
 
 
/
