SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE "PRC_SYN_FROM_FINN" 
IS
    pkgctx   plog.log_ctx;
    logrow   tlogdebug%ROWTYPE;

BEGIN
prc_syn_stockinfo_from_finn();
sp_getmrktprice_from_finn (getcurrdate());
prc_syn_stockprice_from_finn();
-- DONG BO QUA KHU THEM LAN NUA SAU BATCH , VAO DAU NGAY HOM SAU DE CHAC CHAN DONG BO DC GIA MOI NHAT
prc_syn_stockprice_from_finn_hist_bydate(fn_get_prevdate(getcurrdate,1));
sp_getmrktprice_from_finn (fn_get_prevdate(getcurrdate,1));
    commit;
    plog.setendsection(pkgctx, 'prc_syn_stockprice_from_finn');
EXCEPTION
  WHEN others THEN
    rollback;
    plog.error('CONVERT:' || SQLERRM || '.At:' || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'prc_syn_stockprice_from_finn');
    RAISE errnums.E_SYSTEM_ERROR;
END;
/
