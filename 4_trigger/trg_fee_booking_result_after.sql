SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_FEE_BOOKING_RESULT_AFTER 
 AFTER
 INSERT OR DELETE OR UPDATE
 ON FEE_BOOKING_RESULT
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
  pkgctx := plog.init('TRG_FEE_BOOKING_RESULT_AFTER',
                      plevel           => NVL(logrow.loglevel, 30),
                      plogtable        => (NVL(logrow.log4table, 'N') = 'Y'),
                      palert           => (NVL(logrow.log4alert, 'N') = 'Y'),
                      ptrace           => (NVL(logrow.log4trace, 'N') = 'Y'));

  plog.setbeginsection(pkgctx, 'TRG_FEE_BOOKING_RESULT_AFTER');

  --Xu ly gui ket qua di bang ke cho FA.
  --Bankstatus = 'C' --> sinh FA8686, = 'E', 'R' -> cap nhat trang thai bang ke

  IF :newval.STATUS IN ('X','R','C') AND instr(:newval.BANKGLOBALID,'FA.') > 0  THEN
    insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime)
    values
      (:newval.bankglobalid,seq_log_notify_cbfa.nextval,'FEE_BOOKING_RESULT','AUTOID',:newval.autoid,:newval.status,null, TO_DATE (:newval.txdate, systemnums.c_date_format),null,sysdate);
  END IF;
  plog.setEndSection(pkgctx, 'TRG_FEE_BOOKING_RESULT_AFTER');

exception
  when others then
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setEndSection(pkgctx, 'TRG_FEE_BOOKING_RESULT_AFTER');
end;
/
