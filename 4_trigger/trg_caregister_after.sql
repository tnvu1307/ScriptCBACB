SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_CAREGISTER_AFTER 
  after insert or UPDATE OF msgstatus
  on CAREGISTER
  for each row
declare
  -- local variables here
begin
  IF :new.Msgstatus = 'P' AND nvl(:old.Msgstatus, 'x') <> 'P' THEN
    insert into log_notify_cbfa(autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
    VALUES (seq_log_notify_cbfa.nextval,'CAALLOCATE_RIGHT','CAMASTID',:NEW.AUTOID,null,:NEW.Banktxnum,nvl(:NEW.banktxdate,getcurrdate),null,sysdate,nvl(:NEW.banktxdate,getcurrdate));
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    plog.error('TRG_CAREGISTER_AFTER ' || SQLERRM);
end TRG_CAREGISTER_AFTER;
/
