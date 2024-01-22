SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8880ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8880EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      12/11/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#8880ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_type             CONSTANT CHAR(2) := '06';
   c_txnum            CONSTANT CHAR(2) := '13';
   c_tpcp             CONSTANT CHAR(2) := '07';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_ddacctno         CONSTANT CHAR(2) := '04';
   c_seacctno         CONSTANT CHAR(2) := '33';
   c_acctno           CONSTANT CHAR(2) := '32';
   c_identity         CONSTANT CHAR(2) := '12';
   c_citad            CONSTANT CHAR(2) := '15';
   c_qtty             CONSTANT CHAR(2) := '05';
   c_price            CONSTANT CHAR(2) := '08';
   c_value            CONSTANT CHAR(2) := '09';
   c_desc             CONSTANT CHAR(2) := '30';
   c_des              CONSTANT CHAR(2) := '31';
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
NOSTRO_bankacctno_CHUYEN  VARCHAR2(100);
NOSTRO_banktrans_CHUYEN VARCHAR2(100);
globalid_bank varchar2(250);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
     --gen request key qua bank
    select fn_getglobalid(p_txmsg.txdate, p_txmsg.txnum) into globalid_bank from dual;
    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
         if p_txmsg.txfields ('31').value = 'SE' then
            --LENH BAN
            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('32').value,'0020',ROUND(p_txmsg.txfields('05').value,0),NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
             UPDATE SEMAST
                 SET
                   NETTING  = NETTING - (ROUND(p_txmsg.txfields('05').value,0)), LAST_CHANGE = SYSTIMESTAMP
                WHERE ACCTNO=p_txmsg.txfields('32').value;
            UPDATE ODMAST
                 SET
                   ORSTATUS='7', LASTCHANGE = SYSTIMESTAMP
                WHERE   TXNUM=p_txmsg.txfields('13').value
                    and orderid = p_txmsg.txfields('35').value
            ;
            update stschd
                set status = 'C',
                LASTCHANGE = SYSTIMESTAMP
                where orderid = p_txmsg.txfields('35').value and duetype = 'RM';
         else
            -- LAY TK TONG DE DI TIEN BAN
                begin
                    SELECT bankacctno,banktrans INTO NOSTRO_bankacctno_CHUYEN,NOSTRO_banktrans_CHUYEN FROM BANKNOSTRO WHERE banktype = '002' AND BANKTRANS = 'OUTTRFODSELL';
                exception when NO_DATA_FOUND
                    THEN
                    p_err_code := '-930017';
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end;
                BEGIN
                    PCK_BANKAPI.Bank_NostroWtransfer(
                                  p_txmsg.txfields('04').value,  --- tk ddmast tk doi ung (ca nhan)
                                  NOSTRO_bankacctno_CHUYEN , --- so tk nostro (tu doanh )
                                  NOSTRO_banktrans_CHUYEN, ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
                                  'C',  -- Debit or credit
                                  NVL(p_txmsg.txfields('09').value,0),  --- so tien
                                  'PAYMENT_NOSTROWTRANFER', --request code cua nghiep vu trong allcode
                                  globalid_bank,  --requestkey duy nhat de truy lai giao dich goc
                                  p_txmsg.txfields('30').value,  -- dien giai
                                  p_txmsg.tlid, -- nguoi tao giao dich
                                  P_ERR_CODE)
                    ;

                    INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields('04').value,'0008',ROUND((p_txmsg.txfields('09').value),0),NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

                    update ddmast
                    set receiving = receiving - (p_txmsg.txfields('09').value),
                    LAST_CHANGE = SYSTIMESTAMP
                    where acctno = p_txmsg.txfields('04').value;

                    EXCEPTION WHEN OTHERS THEN
                        
                        plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                END;
                --cap nhat trang thai odmast
                    --if P_ERR_CODE = systemnums.c_success then
                        update odmast
                            set ispayment = 'Y',
                            LASTCHANGE = SYSTIMESTAMP
                            where   TXNUM=p_txmsg.txfields('13').value
                                and orderid = p_txmsg.txfields('35').value
                        ;
                        update stschd
                        set status = 'C',
                        LASTCHANGE = SYSTIMESTAMP
                        where orderid = p_txmsg.txfields('35').value and duetype = 'RM';
                    --end if;
           END IF;
    END IF;
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
         plog.init ('TXPKS_#8880EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8880EX;
/
