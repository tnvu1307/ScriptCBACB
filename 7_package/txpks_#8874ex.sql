SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8874ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8874EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      08/11/2019     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/


CREATE OR REPLACE PACKAGE BODY txpks_#8874ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_feenum           CONSTANT CHAR(2) := '04';
   c_amt              CONSTANT CHAR(2) := '10';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS

BEGIN
   plog.setbeginsection (pkgctx, 'fn_txPreAppCheck');
   plog.debug(pkgctx,'BEGIN OF fn_txPreAppCheck');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppCheck;

FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAftAppCheck');
   plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppCheck>>');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
   plog.debug (pkgctx, '<<END OF fn_txAftAppCheck>>');
   plog.setendsection (pkgctx, 'fn_txAftAppCheck');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txAftAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppCheck;

FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txPreAppUpdate');
    plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_feeamt number;
    v_feeamtorder number;
    v_feecalc varchar2(1);
    v_AUTOID number;
    v_ccycd varchar2(10);
    v_feecd varchar2(10);
    v_feerate number;
    v_getcurrent date;
    v_result number;
    v_deltd varchar2(1);
br_bankcitad varchar2(100);
v_feedaily varchar2(10);
v_trfcode varchar2(100);

count_is_shinhan number;
v_banknostro varchar2(100);
v_banknostro_trans varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    select NVL(feedaily,'N') into v_feedaily  from cfmast where custodycd = p_txmsg.txfields('88').value;

    SELECT count(bankcitadcode) into count_is_shinhan
            FROM FAMEMBERS
            WHERE   autoid   in (select od.member
                                        from odmast od
                                            where od.orderid = p_txmsg.txfields('99').value)
        ;

        --GOI API TRA PHI CHO BROKER SANG BANK
    --if v_feedaily = 'N' then
        if count_is_shinhan > 0 then
            begin
                select bankacctno,banktrans into v_banknostro,v_banknostro_trans from banknostro where banktype = '002' and banktrans = 'OUTTRFFEETRER';
            exception when NO_DATA_FOUND
                THEN
                p_err_code := '-930017';
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end;
            SELECT trfcode into v_trfcode FROM CRBTRFCODE WHERE OBJNAME = '8865' AND TRFCODE = 'PAYMENTFEEBROKER';
            

            BEGIN
                        PCK_BANKAPI.Bank_NostroWtransfer(
                                           p_txmsg.txfields('05').value,  --- tk ddmast tk doi ung (ca nhan)
                                           v_banknostro, --- so tk nostro (tu doanh )
                                           v_banknostro_trans, ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
                                           'C',  -- Debit or credit
                                           p_txmsg.txfields('12').value,  --- so tien
                                           v_trfcode, --request code cua nghiep vu trong allcode
                                           p_txmsg.txnum,  --requestkey duy nhat de truy lai giao dich goc
                                           p_txmsg.txfields('30').value,  -- dien giai
                                           p_txmsg.tlid, -- nguoi tao giao dich
                                           P_ERR_CODE)
                        ;
                        if P_ERR_CODE = systemnums.C_SUCCESS then
                            INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields('05').value,'0009',ROUND(p_txmsg.txfields('12').value,0),NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

                            update ddmast
                                set receiving = receiving - p_txmsg.txfields('12').value,
                                    LAST_CHANGE = SYSTIMESTAMP
                                where acctno = p_txmsg.txfields('05').value;
                        end if;
                        EXCEPTION WHEN OTHERS THEN
                            
                            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                            RETURN errnums.C_BIZ_RULE_INVALID;
             END;
            else
                begin
                    PCK_BANKAPI.Bank_Internal_Tranfer(
                                      v_banknostro,  --- tk ddmast tk chuyen
                                      p_txmsg.txfields('06').value, ---ten tk nhan
                                      p_txmsg.txfields('05').value, --- so tk nhan
                                      p_txmsg.txfields('12').value,  --- so tien
                                      v_trfcode, --request code cua nghiep vu trong allcode
                                      p_txmsg.txnum,  --requestkey duy nhat de truy lai giao dich goc
                                      p_txmsg.txfields('30').value,  -- dien giai
                                      p_txmsg.tlid, -- nguoi tao giao dich
                                      P_ERR_CODE)
                    ;
                    if P_ERR_CODE <> systemnums.C_SUCCESS then
                        
                        plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    end if;
                    EXCEPTION WHEN OTHERS THEN
                            
                            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                            RETURN errnums.C_BIZ_RULE_INVALID;
                end;
            end if;
        --end if;
    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppUpdate;

BEGIN
      FOR i IN (SELECT *
                FROM tlogdebug)
      LOOP
         logrow.loglevel    := i.loglevel;
         logrow.log4table   := i.log4table;
         logrow.log4alert   := i.log4alert;
         logrow.log4trace   := i.log4trace;
      END LOOP;
      pkgctx    :=
         plog.init ('TXPKS_#8874EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8874EX;
/
