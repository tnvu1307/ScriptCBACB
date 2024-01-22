SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_FACB_STATEMENTGROUP_AFTER 
 AFTER
 INSERT OR DELETE OR UPDATE
 ON FACB_STATEMENTGROUP
 REFERENCING OLD AS OLDVAL NEW AS NEWVAL
 FOR EACH ROW
declare
  pkgctx     plog.log_ctx;
  logrow     tlogdebug%ROWTYPE;
  v_txnum varchar2(20);
  v_txdate date;
  v_tltxcd varchar2(20);
begin

  FOR i IN (SELECT * FROM tlogdebug) LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;
  pkgctx := plog.init('TRG_FACB_STATEMENTGROUP_AFTER',
                      plevel           => NVL(logrow.loglevel, 30),
                      plogtable        => (NVL(logrow.log4table, 'N') = 'Y'),
                      palert           => (NVL(logrow.log4alert, 'N') = 'Y'),
                      ptrace           => (NVL(logrow.log4trace, 'N') = 'Y'));

  plog.setbeginsection(pkgctx, 'TRG_FACB_STATEMENTGROUP_AFTER');

  --Xu ly gui ket qua di bang ke cho FA.
  --Bankstatus = 'C' --> sinh FA8686, = 'E', 'R' -> cap nhat trang thai bang ke

  IF :oldval.BANKSTATUS IN ('P','S') and :newval.BANKSTATUS IN ('C','E','R') THEN
    insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
    values
      (:newval.globalid,seq_log_notify_cbfa.nextval,'FACBSTATEMENT_RESULT','GLOBALID',:newval.globalid,:newval.bankstatus,:newval.reftxnum, TO_DATE (:newval.reftxdate, systemnums.c_date_format),:newval.reftltxcd,sysdate,TO_DATE (:newval.reftxdate, systemnums.c_date_format));
  END IF;
  plog.setEndSection(pkgctx, 'TRG_FACB_STATEMENTGROUP_AFTER');

exception
  when others then
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setEndSection(pkgctx, 'TRG_FACB_STATEMENTGROUP_AFTER');
end;
/
