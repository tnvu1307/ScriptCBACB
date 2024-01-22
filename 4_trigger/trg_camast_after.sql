SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_CAMAST_AFTER 
 AFTER
   UPDATE OF status, autoid, deltd
 ON camast
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
declare
  -- local variables here
  v_count number;
  v_prevdate date;
  v_currentdate date;
begin

  --Gui mau email 216
/*  if :new.status = 'V' and :new.status <> :old.status and :new.catype in ('014','017','023') then
    insert into log_notify_event
      (autoid, msgtype, keyvalue, status, CommandType, CommandText, logtime)
    values
      (seq_log_notify_event.nextval, 'CAMASTSMS_V', :new.camastid, 'A', 'P', 'GENERATE_TEMPLATES', sysdate);
  end if;*/
  --thangpv SHBVNEX-2573 insert vào table log
   select getcurrdate() into v_currentdate from dual;
  IF :NEW.STATUS = 'N' AND :NEW.STATUS <> :OLD.STATUS THEN
        INSERT INTO tlog_camast(CAMASTID,STATUS,FROMDATE,AUTOID)
        VALUES (:new.CAMASTID, 'P', v_currentdate, :new.AUTOID) ;  
             
        DELETE FROM CAMAST_DELETELOG WHERE :new.CAMASTID = CAMASTID ;
  END IF;

  if :new.status = 'S' and :new.status <> :old.status and :new.catype not in ('014','017','023') and :new.catype in ('010','021','011','020') then
    insert into log_notify_event
      (autoid, msgtype, keyvalue, status, CommandType, CommandText, logtime)
    values
      (seq_log_notify_event.nextval, 'CAMAST_S', :new.camastid, 'A', 'P', 'GENERATE_TEMPLATES', sysdate);
  end if;
  --stt = A xong gd 3375 tao ds
  --stt = V xong gd 3370 chot ds
  if :new.status = 'V' and :new.status <> :old.status and :new.catype in ('014','017','023') then
    insert into log_notify_event
      (autoid, msgtype, keyvalue, status, CommandType, CommandText, logtime)
    values
      (seq_log_notify_event.nextval, 'CAMAST_A', :new.camastid, 'A', 'P', 'GENERATE_TEMPLATES', sysdate);
  end if;

  if :new.status = 'V' and :new.status <> :old.status and :new.catype in ('014','023') then
    insert into log_notify_event
      (autoid, msgtype, keyvalue, status, CommandType, CommandText, logtime)
    values
      (seq_log_notify_event.nextval, 'CAMASTBATC', :new.camastid, 'A', 'P', 'GENERATE_TEMPLATES', sysdate);
  end if;

  if :new.status = 'S' and :new.status <> :old.status and :new.catype in ('005','028','006') then
    insert into log_notify_event
      (autoid, msgtype, keyvalue, status, CommandType, CommandText, logtime)
    values
      (seq_log_notify_event.nextval, 'CAMASTBATC', :new.camastid, 'A', 'P', 'GENERATE_TEMPLATES', sysdate);
  end if;

    IF (:NEW.STATUS = 'N' AND :NEW.STATUS <> :OLD.STATUS) OR (:NEW.DELTD = 'Y' AND :NEW.DELTD <> :OLD.DELTD) THEN
        INSERT INTO LOG_NOTIFY_CBFA(GLOBALID,AUTOID,OBJNAME,KEYNAME,KEYVALUE,ACTION,TXDATE)
        VALUES ('CB.'||TO_CHAR(:NEW.ACTIONDATE,'YYYYMMDD')||'.'||:NEW.CAMASTID,SEQ_LOG_NOTIFY_CBFA.NEXTVAL,'CBFA_FACAMAST','CAMASTID',:NEW.CAMASTID,:NEW.ISINCODE,:NEW.ACTIONDATE);
    END IF;
    IF (:NEW.STATUS = 'N' AND :NEW.STATUS <> :OLD.STATUS) THEN
        SELECT COUNT(*) into v_count FROM CAREMINDER_LOG WHERE CAMASTID=:NEW.CAMASTID AND TEMPEM='EM98';
        v_prevdate := GETPREVDATE(:NEW.REPORTDATE,1);
        if v_count = 0 then
            -- Email EM98
            INSERT INTO CAREMINDER_LOG (camastid,symbol,reportdate,exdate,capturedate,tempem,status,autoid)
            SELECT :NEW.CAMASTID, SB.SYMBOL, :NEW.REPORTDATE,v_prevdate EXDATE,
            TO_CHAR(SYSDATE,'DD/MM/RRRR') CAPTUREDATE,'EM98','P',seq_careminder_log.NEXTVAL
            FROM SBSECURITIES SB
            WHERE SB.CODEID =:NEW.CODEID ;
            -- Email EM99 -- Lam bieng nen gen the nay -> thich thi dieu chinh lai nhe!!!
            INSERT INTO CAREMINDER_LOG (camastid,symbol,reportdate,exdate,capturedate,tempem,status,autoid)
            SELECT :NEW.CAMASTID, SB.SYMBOL, :NEW.REPORTDATE,v_prevdate EXDATE,
            TO_CHAR(SYSDATE,'DD/MM/RRRR') CAPTUREDATE,'EM99','P',seq_careminder_log.NEXTVAL
            FROM SBSECURITIES SB
            WHERE SB.CODEID =:NEW.CODEID ;
        else
            SELECT COUNT(*) into v_count FROM CAREMINDER_LOG WHERE CAMASTID=:NEW.CAMASTID AND TEMPEM='EM99' AND STATUS = 'A';
            if v_count = 0 then
                update CAREMINDER_LOG 
                SET reportdate=:NEW.REPORTDATE, exdate= v_prevdate
                WHERE CAMASTID=:NEW.CAMASTID AND TEMPEM='EM99' AND STATUS = 'P'; 
            else
                -- Email EM99 -- Lam bieng nen gen the nay -> thich thi dieu chinh lai nhe!!!
                SELECT COUNT(*) into v_count FROM CAREMINDER_LOG WHERE CAMASTID=:NEW.CAMASTID AND TEMPEM='EM99' 
                AND REPORTDATE = :NEW.REPORTDATE;
                IF v_count = 0 THEN
                    INSERT INTO CAREMINDER_LOG (camastid,symbol,reportdate,exdate,capturedate,tempem,status,autoid)
                    SELECT :NEW.CAMASTID, SB.SYMBOL, :NEW.REPORTDATE,v_prevdate EXDATE,
                    TO_CHAR(SYSDATE,'DD/MM/RRRR') CAPTUREDATE,'EM99','P',seq_careminder_log.NEXTVAL
                    FROM SBSECURITIES SB
                    WHERE SB.CODEID =:NEW.CODEID ;
                END IF;
            end if;
        end if;
    END IF;
    
end TRG_CAMAST_AFTER;
/
