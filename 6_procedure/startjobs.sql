SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE startjobs is
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

  pkgctx := plog.init('Startjobs',

                      plevel => logrow.loglevel,

                      plogtable => (logrow.log4table = 'Y'),

                      palert => (logrow.log4alert = 'Y'),

                      ptrace => (logrow.log4trace = 'Y'));

  plog.setbeginsection(pkgctx, 'Startjobs');

  

  UPDATE SYSVAR SET VARVALUE = 'Y' WHERE GRNAME='SYSTEM' AND VARNAME='GXJBS_STATUS';
  COMMIT;

  begin
  
  dbms_scheduler.enable(name => 'GXJBS_#EXECUTE_FO2OD');
  exception when others then
        plog.error(pkgctx, sqlerrm);
  end;

  begin
  
  dbms_scheduler.enable(name => 'GXJBS_#CANCEL_ORDER');
  exception when others then
        plog.error(pkgctx, sqlerrm);
  end;

  begin
  
  dbms_scheduler.enable(name => 'GXJBS_#EXECUTE_TRADE');
  exception when others then
        plog.error(pkgctx, sqlerrm);
  end;
  plog.setendsection(pkgctx, 'Startjobs');

    begin
  
  dbms_scheduler.enable(name => 'GTWJBS_#STRADE_CI');
  exception when others then
        plog.error(pkgctx, sqlerrm);
  end;

      begin
  
  dbms_scheduler.enable(name => 'GTWJBS_#STRADE_SE');
  exception when others then
        plog.error(pkgctx, sqlerrm);
  end;

  begin
  
  dbms_scheduler.enable(name => 'GTWJBS_#MONEYTRANSFER');
  exception when others then
        plog.error(pkgctx, sqlerrm);
  end;

  begin
  
  dbms_scheduler.enable(name => 'GTWJBS_#CARIGHTOFFREGISTER');
  exception when others then
        plog.error(pkgctx, sqlerrm);
  end;

  plog.setendsection(pkgctx, 'Startjobs');
end startjobs;
/
