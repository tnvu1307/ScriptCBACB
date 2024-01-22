SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE gen_cash_bitdate IS
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
    plog.setendsection (pkgctx, 'GEN_CASH_BITDATE');
   -- plog.error (pkgctx, 'Begin GEN_CASH_BITDATE. ' || SYSTIMESTAMP );
    l_currdate:=getcurrdate;
    l_Sysdate:=to_date(sysdate,'DD/MM/RRRR');
    --IF l_currdate=l_Sysdate THEN
    cspks_rmproc.pr_RunningRMBatch('CASHBITDATE', p_err_code);
    COMMIT;
    --END IF;
   -- plog.error (pkgctx, 'End GEN_CASH_BITDATE '|| p_err_code || ' :' || SYSTIMESTAMP );
    plog.setendsection (pkgctx, 'GEN_CASH_BITDATE');
  EXCEPTION
  WHEN OTHERS THEN
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'GEN_CASH_BITDATE');
  return;
END ;
/
