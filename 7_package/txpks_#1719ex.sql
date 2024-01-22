SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1719ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1719EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      29/01/2021     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1719ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_txdate           CONSTANT CHAR(2) := '14';
   c_txnum            CONSTANT CHAR(2) := '15';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_txnum varchar(100);
    l_txdate date;
    l_count number;
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
    l_txnum := p_txmsg.txfields('15').value;
    l_txdate := TO_DATE(p_txmsg.txfields('14').value,systemnums.C_DATE_FORMAT);
    select count(1) into l_count from vw_tllog_all where txnum = l_txnum and txdate = l_txdate;
    if l_count <= 0 then
        p_err_code := '-100078';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;

    select count(1) into l_count from vw_tllogfld_all where txnum = l_txnum and txdate = l_txdate;
    if l_count <= 0 then
        p_err_code := '-100078';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;

    select count(1) into l_count from SWIFT_OUT where txnum = l_txnum and txdate = l_txdate and iscancel = 'N';
    if l_count <= 0 then
        p_err_code := '-100078';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;
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
    l_txnum varchar(100);
    l_txdate date;
    l_txmsg tx.msg_rectype;
    l_fldname varchar2(100);
    l_defname varchar2(100);
    l_fldtype varchar(10);
    l_sqlcommand VARCHAR2(4000);
    l_err_param VARCHAR2(4000);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_txnum := p_txmsg.txfields('15').value;
    l_txdate := TO_DATE(p_txmsg.txfields('14').value,systemnums.C_DATE_FORMAT);
    IF p_txmsg.deltd <> 'Y' THEN
        BEGIN
            FOR REC in
            (
                SELECT * FROM SWIFT_OUT WHERE TXNUM = l_txnum AND TXDATE= l_txdate AND iscancel = 'N'
            )
            LOOP
                l_txmsg.msgtype     := 'T';
                l_txmsg.local       := 'N';
                l_txmsg.tlid        := systemnums.c_system_userid;
                l_txmsg.off_line    := 'N';
                select sys_context('USERENV', 'HOST'), sys_context('USERENV', 'IP_ADDRESS', 15)
                into l_txmsg.wsname, l_txmsg.ipaddress
                from dual;
                l_txmsg.txstatus    := txstatusnums.c_txcompleted;
                l_txmsg.deltd       := txnums.c_deltd_txnormal;
                l_txmsg.msgsts      := '0';
                l_txmsg.ovrsts      := '0';
                l_txmsg.batchname   := 'DAY';
                l_txmsg.txdate      := p_txmsg.txdate;
                l_txmsg.busdate     := p_txmsg.busdate;
                select systemnums.c_batch_prefixed || lpad(seq_batchtxnum.nextval, 8, '0')
                into l_txmsg.txnum
                from dual;
                l_txmsg.tltxcd      := REC.tltxcd;
                l_txmsg.brid        := systemnums.c_ho_hoid;
                l_txmsg.reftxnum    := p_txmsg.txnum;
                for recfld in
                (
                    select * from vw_tllogfld_all where txnum=l_txnum and txdate= l_txdate
                )
                LOOP
                    begin
                        select fldname, defname, fldtype
                        into l_fldname, l_defname, l_fldtype
                        from fldmaster
                        where objname=REC.tltxcd and FLDNAME=recfld.FLDCD;

                        l_txmsg.txfields (l_fldname).defname   := l_defname;
                        l_txmsg.txfields (l_fldname).TYPE      := l_fldtype;
                        if l_fldtype = 'C' then
                            l_txmsg.txfields (l_fldname).VALUE     := recfld.CVALUE;
                        elsif l_fldtype = 'N' then
                            l_txmsg.txfields (l_fldname).VALUE     := recfld.NVALUE;
                        else
                            l_txmsg.txfields (l_fldname).VALUE     := recfld.CVALUE;
                        end if;
                    exception when others then
                       l_txmsg.txfields (l_fldname).VALUE := 'ERROR';
                    end;
                END LOOP;

                l_sqlcommand := '
                BEGIN
                    IF txpks_#'|| REC.tltxcd ||'.fn_AutoTxProcess(:l_txmsg, :p_err_code, :p_err_param) <> systemnums.c_success THEN
                        ROLLBACK;
                    END IF;
                END;
                ';
                EXECUTE IMMEDIATE l_sqlcommand USING IN OUT l_txmsg, IN OUT p_err_code, OUT l_err_param;

                IF p_err_code = TO_CHAR(systemnums.c_success) or p_err_code is null THEN
                    p_err_code := systemnums.c_success;
                ELSE
                    
                    Raise errnums.E_BIZ_RULE_INVALID;
                END IF;
            END LOOP;
        EXCEPTION when others THEN
            plog.error (pkgctx, SQLERRM ||  dbms_utility.format_error_backtrace);
            p_err_code := errnums.C_SYSTEM_ERROR;
            Raise errnums.E_BIZ_RULE_INVALID;
        END;
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
         plog.init ('TXPKS_#1719EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1719EX;
/
