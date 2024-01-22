SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_ISSUERS_AFTER 
 AFTER
  INSERT OR DELETE OR UPDATE
 ON issuers
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
DECLARE
  pkgctx plog.log_ctx;
  l_action VARCHAR2(100);
  l_count   number;
BEGIN

    IF inserting THEN
    l_action := 'A';
    ELSIF updating THEN
    l_action := 'U';
    ELSIF deleting THEN
    l_action := 'D';
    END IF  ;

    --plog.setBeginSection(pkgctx, 'TRG_ISSUERS_AFTER');
  --Dong bo du lieu sang FA
  IF l_action ='D' THEN
     insert into log_notify_cbfa(globalid,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime)
      values
      ('CB.ISSUERS.'|| :OLDVAL.ISSUERID,seq_log_notify_cbfa.nextval,'ISSUERS','ISSUERID',:OLDVAL.ISSUERID,
      l_action,:OLDVAL.shortname,getcurrdate(),null,SYSDATE);
    END IF;
/*  IF :newval.status ='A' AND :newval.pstatus='P' THEN
      insert into log_notify_cbfa(globalid,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime)
      values
      ('CB.ISSUERS.'|| :newval.ISSUERID,seq_log_notify_cbfa.nextval,'ISSUERS','ISSUERID',:newval.ISSUERID,
      'A',:newval.shortname,getcurrdate(),null,SYSDATE);
     END IF;  */
  IF :newval.status ='A' THEN
     select count(*) into l_count from log_notify_cbfa where objname='ISSUERS' and keyname='ISSUERID' 
     and keyvalue=:newval.ISSUERID and txnum=:newval.shortname and action='A';
     if l_count = 0 then
         l_action :='A';
     end if;
     insert into log_notify_cbfa(globalid,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime)
      values
      ('CB.ISSUERS.'|| :newval.ISSUERID,seq_log_notify_cbfa.nextval,'ISSUERS','ISSUERID',:newval.ISSUERID,
      l_action,:newval.shortname,getcurrdate(),null,SYSDATE);
  END IF;

   --plog.setEndSection(pkgctx, 'TRG_ISSUERS_AFTER');
exception
  when others then
    plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
    plog.setEndSection(pkgctx, 'TRG_ISSUERS_AFTER');
end TRG_ISSUERS_AFTER;
/
