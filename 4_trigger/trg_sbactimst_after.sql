SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_SBACTIMST_AFTER 
 AFTER
  INSERT OR UPDATE
 ON sbactimst
REFERENCING NEW AS NEWVAL OLD AS OLDVAL
 FOR EACH ROW
declare
  pkgctx     plog.log_ctx;
  logrow     tlogdebug%ROWTYPE;

  v_currdate date;
  v_count number;
begin

  FOR i IN (SELECT * FROM tlogdebug) LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;
  pkgctx := plog.init('trg_SBACTIMST_after',
                      plevel           => NVL(logrow.loglevel, 30),
                      plogtable        => (NVL(logrow.log4table, 'N') = 'Y'),
                      palert           => (NVL(logrow.log4alert, 'N') = 'Y'),
                      ptrace           => (NVL(logrow.log4trace, 'N') = 'Y'));

  plog.setbeginsection(pkgctx, 'trg_crbtxreq_after');
    v_currdate := getcurrdate;
    if :newval.reminddate = v_currdate and :newval.email is not null  then --reminddate = ngay hien tai thi dua vo bang log gui, khong phai ngay hien tai thi sinh lich gui trong batch
        select count(*) into v_count from SBACTIMST_EMAIL where sbactimst_autoid = :newval.autoid  and status = 'P';
        if v_count = 0 then
            insert into SBACTIMST_EMAIL 
            (autoid, sbactimst_autoid, reminddate, endreminddate,remindtime, repeat, numberremind, status)
            values
            (seq_SBACTIMST_EMAIL.nextval,:newval.autoid,:newval.reminddate,:newval.endreminddate,:newval.remindtime,:newval.repeat,:newval.numberremind,'P');
        else
            update SBACTIMST_EMAIL
                set reminddate = :newval.reminddate,
                    endreminddate = :newval.endreminddate,
                    remindtime = :newval.remindtime,
                    repeat = :newval.repeat,
                    numberremind = :newval.numberremind
            where sbactimst_autoid = :newval.autoid;
                    
        end if;
    end if;


  plog.setEndSection(pkgctx, 'trg_SBACTIMST_after');

exception
  when others then
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setEndSection(pkgctx, 'trg_SBACTIMST_after');
end;
/
