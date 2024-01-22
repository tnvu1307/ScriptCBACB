SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_CRBBANKREQUEST_AFTER 
 AFTER
  INSERT OR DELETE OR UPDATE
 ON CRBBANKREQUEST
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
declare
  pkgctx     plog.log_ctx;
  logrow     tlogdebug%ROWTYPE;
  v_txnum varchar2(20);
  v_txdate date;
  v_tltxcd varchar2(20);
  v_globalid varchar2(50);
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

  --Luong no/co khong co giao dich goc
  v_globalid := 'CB.'||TO_CHAR(:newval.txdate,'YYYYMMDD')||'.'||:newval.reftxnum;
  IF :newval.CFSTATUS IN ('C') and :newval.MSGTYPE = 'RQ' and :newval.bankobj in('11C','11D') THEN
    insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
    values
      (v_globalid,seq_log_notify_cbfa.nextval,'CRBBANKREQUEST_RESULT','AUTOID',:newval.autoid,'C',:newval.reftxnum,TO_DATE (:newval.txdate, systemnums.c_date_format),:newval.CBOBJ,SYSDATE,TO_DATE (:newval.txdate, systemnums.c_date_format));
  END IF;
  plog.setEndSection(pkgctx, 'trg_crbtxreq_after');

exception
  when others then
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setEndSection(pkgctx, 'trg_crbtxreq_after');
end;
/
