SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8819ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8819EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      14/01/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#8819ex
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
   c_typeorder        CONSTANT CHAR(2) := '26';
   c_typeorder        CONSTANT CHAR(2) := '28';
   c_symbol           CONSTANT CHAR(2) := '07';
   c_qtty             CONSTANT CHAR(2) := '09';
   c_amt              CONSTANT CHAR(2) := '10';
   c_fee              CONSTANT CHAR(2) := '11';
   c_tax              CONSTANT CHAR(2) := '27';
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
    l_txmsg               tx.msg_rectype;
    l_err_param   varchar2(1000);
    l_tltxcd      varchar2(4);
    L_COUNT NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        --8868 Nhan chung khoan mua
        l_tltxcd := '8868';
        l_txmsg.tltxcd := l_tltxcd;
        l_txmsg.msgtype := 'T';
        l_txmsg.local   := 'N';
        l_txmsg.tlid    := p_txmsg.TLID;
        l_txmsg.brid    := p_txmsg.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day
        l_txmsg.off_line  := 'N';
        l_txmsg.deltd     := txnums.c_deltd_txnormal;
        l_txmsg.txstatus  := txstatusnums.c_txcompleted;
        l_txmsg.msgsts    := '0';
        l_txmsg.ovrsts    := '0';
        l_txmsg.batchname := 'DAY';
        l_txmsg.busdate   := p_txmsg.busdate;
        l_txmsg.txdate    := p_txmsg.txdate;
        l_txmsg.reftxnum  := p_txmsg.txnum;

        select sys_context('USERENV', 'HOST'), sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;

        select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;

        ------AUTOID
        l_txmsg.txfields ('01').defname   := 'AUTOID';
        l_txmsg.txfields ('01').TYPE      := 'N';
        l_txmsg.txfields ('01').VALUE      := p_txmsg.txfields('01').value;
        ------CODEID
        l_txmsg.txfields ('02').defname   := 'CODEID';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').VALUE      := p_txmsg.txfields('02').value;
        ------AFACCTNO
        l_txmsg.txfields ('03').defname   := 'AFACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE      := p_txmsg.txfields('03').value;
        ------DDACCTNO
        l_txmsg.txfields ('04').defname   := 'DDACCTNO';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE      := p_txmsg.txfields('04').value;
        ------SEACCTNO
        l_txmsg.txfields ('05').defname   := 'SEACCTNO';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE      := p_txmsg.txfields('05').value;
        ------ORGORDERID
        l_txmsg.txfields ('06').defname   := 'ORGORDERID';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').VALUE      := '';
        ------SYMBOL
        l_txmsg.txfields ('07').defname   := 'SYMBOL';
        l_txmsg.txfields ('07').TYPE      := 'C';
        l_txmsg.txfields ('07').VALUE      := p_txmsg.txfields('07').value;
        ------QTTY
        l_txmsg.txfields ('09').defname   := 'QTTY';
        l_txmsg.txfields ('09').TYPE      := 'N';
        l_txmsg.txfields ('09').VALUE      := p_txmsg.txfields('09').value;
        ------AMT
        l_txmsg.txfields ('10').defname   := 'AMT';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').VALUE      := p_txmsg.txfields('10').value;
        ------FEE
        l_txmsg.txfields ('11').defname   := 'FEE';
        l_txmsg.txfields ('11').TYPE      := 'N';
        l_txmsg.txfields ('11').VALUE      := p_txmsg.txfields('11').value;
        ------DESC
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE      := p_txmsg.txfields('30').value;

        SELECT COUNT(1) INTO L_COUNT FROM ODMAST WHERE ORDERID = P_TXMSG.TXFIELDS('06').VALUE;
        IF L_COUNT > 0 THEN
            FOR REC IN (
                SELECT * FROM ODMAST WHERE ORDERID = p_txmsg.txfields('06').VALUE
            )LOOP
                select systemnums.c_batch_prefixed || lpad(seq_batchtxnum.nextval, 8, '0')
                into l_txmsg.txnum
                from dual;

                ------ORGORDERID
                l_txmsg.txfields ('06').defname   := 'ORGORDERID';
                l_txmsg.txfields ('06').TYPE      := 'C';
                l_txmsg.txfields ('06').VALUE      := p_txmsg.txfields('06').value;

                BEGIN
                    IF txpks_#8868.fn_batchtxprocess (l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
                        plog.debug (pkgctx, 'got error 8868: ' || p_err_code);
                        ROLLBACK;
                        RAISE errnums.E_SYSTEM_ERROR;
                    END IF;
                END;

                UPDATE ODMAST
                SET ORSTATUS = '7', LASTCHANGE = SYSTIMESTAMP
                WHERE ORDERID = P_TXMSG.TXFIELDS('06').VALUE;

                UPDATE STSCHD
                SET STATUS = 'C', LASTCHANGE = SYSTIMESTAMP
                WHERE ORDERID = P_TXMSG.TXFIELDS('06').VALUE
                AND DUETYPE = 'RS';
            END LOOP;
        /*
        ELSE
            FOR REC IN (
                SELECT * FROM STSCHD_NETOFF WHERE TO_CHAR(AUTOID) = p_txmsg.txfields('01').VALUE
            )LOOP
                select systemnums.c_batch_prefixed || lpad(seq_batchtxnum.nextval, 8, '0')
                into l_txmsg.txnum
                from dual;

                BEGIN
                    IF txpks_#8868.fn_batchtxprocess (l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
                        plog.debug (pkgctx, 'got error 8868: ' || p_err_code);
                        ROLLBACK;
                        RAISE errnums.E_SYSTEM_ERROR;
                    END IF;
                END;

                UPDATE STSCHD_NETOFF
                SET STATUS = 'C'
                WHERE AUTOID = REC.AUTOID;

                UPDATE ODMAST
                SET ORSTATUS = '7', LASTCHANGE = SYSTIMESTAMP
                WHERE NETOFFID = REC.AUTOID;

                UPDATE STSCHD
                SET STATUS = 'C', LASTCHANGE = SYSTIMESTAMP
                WHERE DUETYPE = 'RS'
                AND ORDERID IN (SELECT ORDERID FROM ODMAST WHERE NETOFFID = REC.AUTOID);
            END LOOP;
        */
        END IF;

    END IF;
    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;EXCEPTION

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
         plog.init ('TXPKS_#8819EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8819EX;
/
