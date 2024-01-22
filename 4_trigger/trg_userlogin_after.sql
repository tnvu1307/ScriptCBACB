SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_USERLOGIN_AFTER 
 AFTER
  INSERT OR UPDATE
 ON userlogin
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
DECLARE
BEGIN
   insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime)
   values
   ('CB.USERLOGIN.'||:newval.username,seq_log_notify_cbfa.nextval,
   'USERLOGIN','USERNAME',:newval.username,'',null,getcurrdate(),null,sysdate); 

END;
/
