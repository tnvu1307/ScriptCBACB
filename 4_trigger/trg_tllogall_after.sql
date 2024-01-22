SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_TLLOGALL_AFTER 
 AFTER
 UPDATE
 ON tllogall
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
declare
  -- local variables here
begin
    -- for revert
    IF :oldval.deltd ='N' AND :newval.deltd ='Y' and :oldval.tltxcd not in ('2212','2213') then
         insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime)
          values
            ('CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.txnum,seq_log_notify_cbfa.nextval,'REVERTTRAN','AUTOID',:newval.autoid,:newval.txdate,:newval.txnum,:newval.txdate,:newval.tltxcd,sysdate);
    end if;
end TRG_CAMAST_AFTER;
/
