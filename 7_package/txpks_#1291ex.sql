SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1291ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1291EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      30/08/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1291ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_date             CONSTANT CHAR(2) := '93';
   c_currency         CONSTANT CHAR(2) := '33';
   c_vnd              CONSTANT CHAR(2) := '44';
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
v_checkExist number;
v_currdate varchar2(20);
l_autoid number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.txfields ('35').VALUE = 'SHV' AND p_txmsg.txfields ('34').VALUE = 'REP' THEN
        SELECT NVL(MAX(autoid), 0) INTO l_autoid
        FROM exchangerate_orther
        WHERE CURRENCY = p_txmsg.txfields('33').value
        AND RTYPE = p_txmsg.txfields ('34').VALUE
        AND ITYPE = p_txmsg.txfields ('35').VALUE
        AND TRADEDATE = TO_DATE(p_txmsg.txfields ('93').VALUE, systemnums.C_DATE_FORMAT);

        IF(l_autoid <> 0) THEN
            UPDATE exchangerate_orther SET VND = to_number(p_txmsg.txfields ('44').VALUE), NOTE = p_txmsg.txfields ('30').VALUE, LASTCHANGE = SYSTIMESTAMP WHERE AUTOID = l_autoid;
        ELSE
            INSERT INTO EXCHANGERATE_ORTHER (AUTOID, TRADEDATE, LASTCHANGE, CURRENCY, VND, NOTE, RTYPE, ITYPE)
            VALUES (seq_exchangerate.nextval,
                    TO_DATE(p_txmsg.txfields ('93').VALUE, systemnums.C_DATE_FORMAT),
                    SYSTIMESTAMP,
                    p_txmsg.txfields ('33').VALUE,
                    to_number(p_txmsg.txfields ('44').VALUE),
                    p_txmsg.txfields ('30').VALUE,
                    p_txmsg.txfields ('34').VALUE,
                    p_txmsg.txfields ('35').VALUE);
        END IF;
    ELSE
        select varvalue  into v_currdate from sysvar where varname = 'CURRDATE';
        IF to_date(v_currdate,'DD/MM/RRRR') = TO_DATE(p_txmsg.txfields ('93').VALUE, 'DD/MM/RRRR') then --- ngay hien tai
            SELECT COUNT(*) INTO v_checkExist
            FROM exchangerate WHERE CURRENCY = p_txmsg.txfields(c_currency).value and RTYPE =p_txmsg.txfields ('34').VALUE and ITYPE =p_txmsg.txfields ('35').VALUE ;

            /* Formatted on 23/08/2019 11:31:49 (QP5 v5.126) */
            IF(v_checkExist > 0) THEN
                -- day du lieu ve bang hist
                INSERT INTO exchangerate_hist (autoid, tradedate, lastchange, currency, vnd, note, RTYPE, ITYPE)
                                        SELECT autoid, tradedate, lastchange, currency, vnd, note, RTYPE, ITYPE
                                        FROM   exchangerate
                                        WHERE  currency = p_txmsg.txfields (c_currency).VALUE and RTYPE =p_txmsg.txfields ('34').VALUE and ITYPE =p_txmsg.txfields ('35').VALUE;

                DELETE FROM exchangerate WHERE currency = p_txmsg.txfields (c_currency).VALUE and RTYPE =p_txmsg.txfields ('34').VALUE and ITYPE =p_txmsg.txfields ('35').VALUE;
                --- insert record moi
                INSERT INTO exchangerate (autoid,
                                        tradedate,
                                        lastchange,
                                        currency,
                                        vnd,
                                        note,
                                        RTYPE,ITYPE)
                              VALUES   (seq_exchangerate.nextval,
                                        TO_DATE(p_txmsg.txfields ('93').VALUE, systemnums.C_DATE_FORMAT),
                                        SYSTIMESTAMP,
                                        p_txmsg.txfields ('33').VALUE,
                                        to_number(p_txmsg.txfields ('44').VALUE),
                                        p_txmsg.txfields ('30').VALUE,
                                        p_txmsg.txfields ('34').VALUE,
                                        p_txmsg.txfields ('35').VALUE)
                                       ;

            ELSE
                --- case moi chua co thi insert luon
                INSERT INTO EXCHANGERATE (AUTOID, TRADEDATE, LASTCHANGE, CURRENCY, VND, NOTE, RTYPE, ITYPE)
                VALUES (seq_exchangerate.nextval,
                        TO_DATE(p_txmsg.txfields ('93').VALUE, systemnums.C_DATE_FORMAT),
                        SYSTIMESTAMP,
                        p_txmsg.txfields ('33').VALUE,
                        to_number(p_txmsg.txfields ('44').VALUE),
                        p_txmsg.txfields ('30').VALUE,
                        p_txmsg.txfields ('34').VALUE,
                        p_txmsg.txfields ('35').VALUE);
            END IF;
        ELSE  --- cap nhat du lieu qua khu
            INSERT INTO EXCHANGERATE_HIST (AUTOID, TRADEDATE, LASTCHANGE, CURRENCY, VND, NOTE, RTYPE, ITYPE)
            VALUES (seq_exchangerate.nextval,
                    TO_DATE(p_txmsg.txfields ('93').VALUE, systemnums.C_DATE_FORMAT),
                    SYSTIMESTAMP,
                    p_txmsg.txfields ('33').VALUE,
                    to_number(p_txmsg.txfields ('44').VALUE),
                    p_txmsg.txfields ('30').VALUE,
                    p_txmsg.txfields ('34').VALUE,
                    p_txmsg.txfields ('35').VALUE);
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
         plog.init ('TXPKS_#1291EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1291EX;
/
