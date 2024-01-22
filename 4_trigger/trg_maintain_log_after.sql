SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_MAINTAIN_LOG_AFTER 
 AFTER
  INSERT OR DELETE OR UPDATE
 ON maintain_log
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
DECLARE
  pkgctx plog.log_ctx;
BEGIN

   plog.setBeginSection(pkgctx, 'TRG_MAINTAIN_LOG_AFTER');
  --Dong bo du lieu sang FA
  --IF updating AND :newval.APPROVE_DT is not null THEN
    IF :newval.table_name = 'ISSUERS' AND :newval.CHILD_TABLE_NAME = 'SBSECURITIES' AND :newval.COLUMN_NAME = 'SYMBOL' AND :newval.ACTION_FLAG ='ADD' AND :newval.APPROVE_DT is not null THEN
         insert into log_notify_cbfa(globalid,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime)
         values
        ('CB.MAINTAIN_LOG.'|| :newval.TO_VALUE,seq_log_notify_cbfa.nextval,'SBSECURITIES','SYMBOL',:newval.TO_VALUE,
         :newval.ACTION_FLAG,null,getcurrdate(),null,SYSDATE);
         --wft
          insert into log_notify_cbfa(globalid,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime)
         values
        ('CB.MAINTAIN_LOG.'|| :newval.TO_VALUE||'_WFT',seq_log_notify_cbfa.nextval,'SBSECURITIES','SYMBOL',:newval.TO_VALUE||'_WFT',
         :newval.ACTION_FLAG,null,getcurrdate(),null,SYSDATE);
    END IF;

    IF :NEWVAL.TABLE_NAME = 'CFMAST' AND :NEWVAL.CHILD_TABLE_NAME = 'CFAUTH' AND :NEWVAL.COLUMN_NAME = 'AUTOID' AND :NEWVAL.ACTION_FLAG ='ADD' AND :NEWVAL.APPROVE_DT IS NOT NULL THEN
        UPDATE CFAUTH SET STATUS = 'Y' WHERE AUTOID = :NEWVAL.TO_VALUE;
    END IF;

    IF :NEWVAL.TABLE_NAME = 'CFMAST' AND :NEWVAL.COLUMN_NAME = 'CUSTODYCD' AND :NEWVAL.ACTION_FLAG = 'EDIT' AND :NEWVAL.APPROVE_DT IS NOT NULL THEN
        UPDATE FILEUPLOAD SET CUSTODYCD = :NEWVAL.TO_VALUE WHERE CUSTODYCD = :NEWVAL.FROM_VALUE;
    END IF;
    
    IF :NEWVAL.TABLE_NAME = 'CAMAST' AND :NEWVAL.ACTION_FLAG = 'DELETE' AND :NEWVAL.CHILD_TABLE_NAME IS NULL AND :NEWVAL.APPROVE_DT IS NULL THEN
        INSERT INTO CAMAST_DELETELOG(CAMASTID) VALUES (substr(:NEWVAL.RECORD_KEY,13,16));
    END IF;
  --END IF;

  plog.setEndSection(pkgctx, 'TRG_MAINTAIN_LOG_AFTER');
exception
  when others then
    plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
    plog.setEndSection(pkgctx, 'TRG_MAINTAIN_LOG_AFTER');
end TRG_MAINTAIN_LOG_AFTER;
/
