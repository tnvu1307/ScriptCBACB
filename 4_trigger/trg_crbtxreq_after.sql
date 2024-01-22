SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_CRBTXREQ_AFTER 
 AFTER
  UPDATE
 ON crbtxreq
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
declare
  pkgctx     plog.log_ctx;
  logrow     tlogdebug%ROWTYPE;
begin

  FOR i IN (SELECT * FROM tlogdebug) LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;
  pkgctx := plog.init('trg_crbtxreq_after',
                      plevel           => NVL(logrow.loglevel, 30),
                      plogtable        => (NVL(logrow.log4table, 'N') = 'Y'),
                      palert           => (NVL(logrow.log4alert, 'N') = 'Y'),
                      ptrace           => (NVL(logrow.log4trace, 'N') = 'Y'));

  plog.setbeginsection(pkgctx, 'trg_crbtxreq_after');

  --Xu ly TCDT, neu Bank tra ve tu choi --> chuyen TT de user co the huy tu GD1114
/*
  If :oldval.trfcode='TCDT' and :newval.status ='R' Then
    Update ciremittance set rmstatus ='P' where txnum = :oldval.objkey and txdate = :oldval.txdate;
  End If;*/
  --Xu ly cap nhat ket qua (CBFA_BANKPAYMENT + FACB_STATEMENTGROUP)
  IF :newval.STATUS IN ('C','R') AND :newval.TRFCODE NOT IN ('HOLD','UNHOLD','FEEINVOICE') THEN
    insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
    values
      (:newval.reqtxnum,seq_log_notify_cbfa.nextval,'CRBTXREQ_RESULT','REQID',:newval.REQID,:newval.status,:newval.OBJKEY, TO_DATE (:newval.TXDATE, systemnums.c_date_format),:newval.OBJNAME,sysdate,nvl(:newval.busdate,:newval.AFFECTDATE));
  END IF;

  plog.setEndSection(pkgctx, 'trg_crbtxreq_after');

exception
  when others then
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setEndSection(pkgctx, 'trg_crbtxreq_after');
end;
/
