SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE GEN_CASH_DEBITDATE IS
pkgctx   plog.log_ctx;
logrow   tlogdebug%ROWTYPE;
p_err_code VARCHAR2(4000);
l_currdate date;
l_Sysdate date;
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
-- Gen cat tien tu dong theo ngay debitdate su kien quyen.
-- NAMTV     17-12-2019           CREATED
Begin
    plog.setendsection (pkgctx, 'GEN_CASH_DEBITDATE');

    l_currdate:=getcurrdate;
    l_Sysdate:=to_date(sysdate,'DD/MM/RRRR');
    IF l_currdate=l_Sysdate THEN
        cspks_rmproc.pr_RunningRMBatch('CASHDEBITDATE', p_err_code);
        COMMIT;
    END IF;

    plog.setendsection (pkgctx, 'GEN_CASH_DEBITDATE');
  EXCEPTION
  WHEN OTHERS THEN
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'GEN_CASH_DEBITDATE');
  return;
END ;
/
