SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE stopjobs_eod is

  pkgctx     plog.log_ctx;
  logrow     tlogdebug%ROWTYPE;

  job_is_running exception;
  PRAGMA EXCEPTION_INIT(job_is_running, -27366);
begin

  --Init log
  SELECT *
    INTO logrow
    FROM tlogdebug
   WHERE rownum <= 1;

  pkgctx := plog.init('stopjobs_eod',

                      plevel => logrow.loglevel,

                      plogtable => (logrow.log4table = 'Y'),

                      palert => (logrow.log4alert = 'Y'),

                      ptrace => (logrow.log4trace = 'Y'));

  plog.setbeginsection(pkgctx, 'stopjobs_eod');

  

  UPDATE SYSVAR SET VARVALUE = 'N' WHERE GRNAME='SYSTEM' AND VARNAME='GXJBS_STATUS';
  COMMIT;

  begin
    BEGIN
    
    dbms_scheduler.stop_job(job_name => 'GXJBS_#EXECUTE_FO2OD', force =>  true);
    dbms_scheduler.disable(name => 'GXJBS_#EXECUTE_FO2OD', force =>  true);
    EXCEPTION WHEN OTHERS THEN
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        dbms_scheduler.disable(name => 'GXJBS_#EXECUTE_FO2OD', force =>  true);
    END;

    BEGIN
    
    dbms_scheduler.stop_job(job_name => 'GTWJBS_#STRADE_CI', force =>  true);
    dbms_scheduler.disable(name => 'GTWJBS_#STRADE_CI', force =>  true);
    EXCEPTION WHEN OTHERS THEN
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        dbms_scheduler.disable(name => 'GTWJBS_#STRADE_CI', force =>  true);
    END;

    BEGIN
    
    dbms_scheduler.stop_job(job_name => 'GTWJBS_#STRADE_SE', force =>  true);
    dbms_scheduler.disable(name => 'GTWJBS_#STRADE_SE', force =>  true);
    EXCEPTION WHEN OTHERS THEN
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        dbms_scheduler.disable(name => 'GTWJBS_#STRADE_SE', force =>  true);
    END;

    BEGIN
    
    dbms_scheduler.stop_job(job_name => 'GXJBS_#CANCEL_ORDER', force =>  true);
    dbms_scheduler.disable(name => 'GXJBS_#CANCEL_ORDER', force =>  true);
    EXCEPTION WHEN OTHERS THEN
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
         dbms_scheduler.disable(name => 'GXJBS_#CANCEL_ORDER', force =>  true);
    END;

    BEGIN
    
    dbms_scheduler.stop_job(job_name => 'GXJBS_#EXECUTE_TRADE', force =>  true);
    dbms_scheduler.disable(name => 'GXJBS_#EXECUTE_TRADE', force =>  true);
    EXCEPTION WHEN OTHERS THEN
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        dbms_scheduler.disable(name => 'GXJBS_#EXECUTE_TRADE', force =>  true);
    END;

    BEGIN
    
    dbms_scheduler.stop_job(job_name => 'GTWJBS_#MONEYTRANSFER', force =>  true);
    dbms_scheduler.disable(name => 'GTWJBS_#MONEYTRANSFER', force =>  true);
    EXCEPTION WHEN OTHERS THEN
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        dbms_scheduler.disable(name => 'GTWJBS_#MONEYTRANSFER', force =>  true);
    END;

    BEGIN
    
    dbms_scheduler.stop_job(job_name => 'GTWJBS_#CARIGHTOFFREGISTER', force =>  true);
    dbms_scheduler.disable(name => 'GTWJBS_#CARIGHTOFFREGISTER', force =>  true);
    EXCEPTION WHEN OTHERS THEN
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        dbms_scheduler.disable(name => 'GTWJBS_#CARIGHTOFFREGISTER', force =>  true);
    END;
  exception
    when job_is_running then
         plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
         dbms_scheduler.disable(name => 'GXJBS_#EXECUTE_FO2OD', force =>  true);
         
         dbms_scheduler.disable(name => 'GXJBS_#CANCEL_ORDER', force =>  true);
         
         dbms_scheduler.disable(name => 'GXJBS_#EXECUTE_TRADE', force =>  true);
         
         dbms_scheduler.disable(name => 'GTWJBS_#MONEYTRANSFER', force =>  true);
         
         dbms_scheduler.disable(name => 'GTWJBS_#CARIGHTOFFREGISTER', force =>  true);
    when others then
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
  end;

  plog.setendsection(pkgctx, 'stopjobs_eod');

end stopjobs_eod;
/
