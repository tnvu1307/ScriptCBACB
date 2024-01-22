SET DEFINE OFF;
CREATE OR REPLACE PACKAGE TXPKS_#8887EX
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8887EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      27/11/2019     Created
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


CREATE OR REPLACE PACKAGE BODY TXPKS_#8887EX
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '01';
   c_orgorderid       CONSTANT CHAR(2) := '06';
   c_afacctno         CONSTANT CHAR(2) := '03';
   c_ddacctno         CONSTANT CHAR(2) := '04';
   c_codeid           CONSTANT CHAR(2) := '02';
   c_seacctno         CONSTANT CHAR(2) := '05';
   c_postdate         CONSTANT CHAR(2) := '23';
   c_broker           CONSTANT CHAR(2) := '24';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_refacctno        CONSTANT CHAR(2) := '25';
   c_typeorder        CONSTANT CHAR(2) := '28';
   c_typeorder        CONSTANT CHAR(2) := '26';
   c_symbol           CONSTANT CHAR(2) := '07';
   c_qtty             CONSTANT CHAR(2) := '09';
   c_amt              CONSTANT CHAR(2) := '10';
   c_fee              CONSTANT CHAR(2) := '11';
   c_tax              CONSTANT CHAR(2) := '27';
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
b_trfcode varchar2(100);
NOSTRO_bankacctno_NHAN VARCHAR2(100);
NOSTRO_banktrans_NHAN VARCHAR2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    --unhold lai tien da hold theo lenh de di thanh toan
            --orderid (06)
            begin
                PCK_BANKAPI.Bank_UNholdbalance(
                          p_txmsg.txfields('06').value,  ---txnum cua giao dich hold
                          p_txmsg.txfields('04').value,  --- tk ddmast
                          p_txmsg.txfields('10').value,  -- so tien
                          'UNHOLDOD', --request code cua nghiep vu trong allcode
                          p_txmsg.txnum ,  --requestkey duy nhat de truy lai giao dich goc
                          p_txmsg.txfields('30').value,  -- dien giai
                          p_txmsg.tlid , -- nguoi tao giao dich
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

            -- LAY TK TONG DE NHAN TIEN MUA
            SELECT bankacctno,banktrans INTO NOSTRO_bankacctno_NHAN,NOSTRO_banktrans_NHAN FROM BANKNOSTRO WHERE banktype = '001' AND BANKTRANS = 'INTRFRESELL';
            BEGIN
                PCK_BANKAPI.Bank_NostroWtransfer(
                              p_txmsg.txfields('04').value,  --- tk ddmast tk doi ung (ca nhan)
                              NOSTRO_bankacctno_NHAN , --- so tk nostro (tu doanh )
                              NOSTRO_banktrans_NHAN, ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
                              'D',  -- Debit or credit
                              NVL(p_txmsg.txfields('10').value + p_txmsg.txfields('11').value + p_txmsg.txfields('27').value,0),  --- so tien
                              b_trfcode, --request code cua nghiep vu trong allcode
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
            END;
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
         plog.init ('TXPKS_#8887EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8887EX;
/
