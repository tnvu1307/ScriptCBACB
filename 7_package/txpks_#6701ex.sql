SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#6701ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#6701EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      26/08/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#6701ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_trx_d            CONSTANT CHAR(2) := '01';
   c_txdate           CONSTANT CHAR(2) := '02';
   c_screen           CONSTANT CHAR(2) := '04';
   c_cifid            CONSTANT CHAR(2) := '05';
   c_waccount         CONSTANT CHAR(2) := '06';
   c_wccycd           CONSTANT CHAR(2) := '07';
   c_raccount         CONSTANT CHAR(2) := '08';
   c_rccycd           CONSTANT CHAR(2) := '09';
   c_amount           CONSTANT CHAR(2) := '10';
   c_exchangerate     CONSTANT CHAR(2) := '11';
   c_ramount          CONSTANT CHAR(2) := '12';
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
v_fr_custodycd varchar2(100);
v_to_custodycd varchar2(100);
v_fr_accounttype varchar2(100);
v_to_accounttype varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN
        --trung.luu : 11-05-2021 log lai de lay bao cao cho de
        begin
            select custodycd,accounttype into v_fr_custodycd,v_fr_accounttype from ddmast where refcasaacct = p_txmsg.txfields('06').value and status <> 'C';

            --tk nhan
            select custodycd,accounttype into v_to_custodycd,v_to_accounttype from ddmast where refcasaacct = p_txmsg.txfields('08').value and status <> 'C';
        exception when NO_DATA_FOUND
            then
            v_fr_custodycd :='';
            v_to_custodycd:='';
            v_fr_accounttype:= '';
            v_to_accounttype:='';
        end;
        if v_to_accounttype = 'IICA' and p_txmsg.txfields('07').value = 'USD' then  --Cash amount(After exchange)
            insert into log_od6004
            (autoid, txnum, txdate, tltxcd, fccycd, tccycd,
            custodycd, fraccount, toaccount, amount, deltd,lastchange)
            values
            (seq_log_od6004.nextval,p_txmsg.txnum,to_date(p_txmsg.txdate,'dd/MM/RRRR'),p_txmsg.tltxcd,p_txmsg.txfields('07').value,p_txmsg.txfields('09').value,
            v_to_custodycd,p_txmsg.txfields('06').value,p_txmsg.txfields('08').value,to_number(p_txmsg.txfields('12').value),'N',SYSTIMESTAMP);
        elsif v_fr_accounttype = 'IICA' and p_txmsg.txfields('09').value = 'USD' then --Credit Amount
            insert into log_od6004
            (autoid, txnum, txdate, tltxcd, fccycd, tccycd,
            custodycd, fraccount, toaccount, amount, deltd,lastchange)
            values
            (seq_log_od6004.nextval,p_txmsg.txnum,to_date(p_txmsg.txdate,'dd/MM/RRRR'),p_txmsg.tltxcd,p_txmsg.txfields('07').value,p_txmsg.txfields('09').value,
            v_fr_custodycd,p_txmsg.txfields('06').value,p_txmsg.txfields('08').value,to_number(p_txmsg.txfields('10').value),'N',SYSTIMESTAMP);
        end if;


        -- Thoai.tran 04-Sep-2020
        -- Send mail FX
        sendmailfx(p_txmsg.txnum,'6701');
    end if;
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
         plog.init ('TXPKS_#6701EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#6701EX;
/
