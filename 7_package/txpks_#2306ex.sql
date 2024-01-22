SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#2306ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2306EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      18/11/2023     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#2306ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_mcustodycd       CONSTANT CHAR(2) := '94';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_custname         CONSTANT CHAR(2) := '90';
   c_dobdate          CONSTANT CHAR(2) := '34';
   c_idcode           CONSTANT CHAR(2) := '31';
   c_iddate           CONSTANT CHAR(2) := '95';
   c_idplace          CONSTANT CHAR(2) := '37';
   c_address          CONSTANT CHAR(2) := '91';
   c_country          CONSTANT CHAR(2) := '96';
   c_alternateid      CONSTANT CHAR(2) := '38';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_codeid           CONSTANT CHAR(2) := '01';
   c_stocktype        CONSTANT CHAR(2) := '33';
   c_qtty             CONSTANT CHAR(2) := '10';
   c_referenceid      CONSTANT CHAR(2) := '77';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_symbol varchar2(50);
    l_status apprules.field%TYPE;
    l_trade apprules.field%TYPE;
    l_blocked apprules.field%TYPE;
    l_semastcheck_arr txpks_check.semastcheck_arrtype;
    l_stocktype VARCHAR2(20);
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
    IF p_txmsg.deltd <> 'Y' THEN
        SELECT SYMBOL INTO L_SYMBOL FROM SBSECURITIES WHERE CODEID = P_TXMSG.TXFIELDS('01').VALUE;

        IF INSTR(L_SYMBOL,'_WFT') > 0 AND NVL(P_TXMSG.TXFIELDS('77').VALUE, '---') = '---' THEN
            P_ERR_CODE := '-150016';
            RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        END IF;

        l_STOCKTYPE := p_txmsg.txfields('33').value;

        l_SEMASTcheck_arr := txpks_check.fn_SEMASTcheck(p_txmsg.txfields('03').value, 'SEMAST', 'ACCTNO');

        l_STATUS := l_SEMASTcheck_arr(0).STATUS;
        l_TRADE := l_SEMASTcheck_arr(0).TRADE;
        l_BLOCKED := l_SEMASTcheck_arr(0).BLOCKED;

        IF l_STOCKTYPE = '2' THEN
            IF NOT (to_number(l_BLOCKED) >= to_number(p_txmsg.txfields('10').value)) THEN
                p_err_code := '-900040';
                plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        ELSE
            IF NOT (to_number(l_TRADE) >= to_number(p_txmsg.txfields('10').value)) THEN
                p_err_code := '-900017';
                plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        END IF;
        IF NOT (INSTR('A',l_STATUS) > 0) THEN
            p_err_code := '-900019';
            plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
    END IF;
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
    L_CODEID VARCHAR2(20);
    L_AFACCTNO VARCHAR2(20);
    L_ACCTNO VARCHAR2(20);
    L_CUSTODYCD VARCHAR2(20);
    L_MCUSTODYCD VARCHAR2(20);
    L_QTTY NUMBER;
    L_QTTYTYPE VARCHAR2(20);
    L_REFERENCEID VARCHAR2(50);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN
        L_CODEID := P_TXMSG.TXFIELDS('01').VALUE;
        L_AFACCTNO := P_TXMSG.TXFIELDS('02').VALUE;
        L_ACCTNO := P_TXMSG.TXFIELDS('03').VALUE;
        L_CUSTODYCD := P_TXMSG.TXFIELDS('88').VALUE;
        L_MCUSTODYCD := P_TXMSG.TXFIELDS('94').VALUE;
        L_QTTY := P_TXMSG.TXFIELDS('10').VALUE;
        L_QTTYTYPE := P_TXMSG.TXFIELDS('33').VALUE;
        L_REFERENCEID := P_TXMSG.TXFIELDS('77').VALUE;

        INSERT INTO SEWITHDRAWDTL_TPRL(AUTOID, TXDATE, TXNUM, BUSDATE, CODEID, AFACCTNO, ACCTNO, CUSTODYCD, MCUSTODYCD, QTTY, QTTYTYPE, REFERENCEID)
        VALUES (SEQ_SEWITHDRAWDTL_TPRL.NEXTVAL, p_txmsg.txdate, p_txmsg.txnum, p_txmsg.busdate, L_CODEID, L_AFACCTNO, L_ACCTNO, L_CUSTODYCD, L_MCUSTODYCD, L_QTTY, L_QTTYTYPE, L_REFERENCEID);

        IF L_QTTYTYPE = '2' THEN
            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields('03').value,'0044',p_txmsg.txfields('10').value,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'');

            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields('03').value,'0089',p_txmsg.txfields('10').value,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'');

            UPDATE SEMAST
            SET
            BLOCKWITHDRAW = BLOCKWITHDRAW + p_txmsg.txfields('10').value,
            BLOCKED = BLOCKED - p_txmsg.txfields('10').value,
            LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=p_txmsg.txfields('03').value;
        ELSE
            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields('03').value,'0040',p_txmsg.txfields('10').value,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'');

            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields('03').value,'0041',p_txmsg.txfields('10').value,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'');

            UPDATE SEMAST
            SET
            WITHDRAW = WITHDRAW + p_txmsg.txfields('10').value,
            TRADE = TRADE - p_txmsg.txfields('10').value,
            LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=p_txmsg.txfields('03').value;
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
         plog.init ('TXPKS_#2306EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2306EX;
/
