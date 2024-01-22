SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#6673ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#6673EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      18/10/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#6673ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_reqtxnum         CONSTANT CHAR(2) := '95';
   c_reqcode          CONSTANT CHAR(2) := '94';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_desacctno        CONSTANT CHAR(2) := '06';
   c_dorc             CONSTANT CHAR(2) := '91';
   c_ccycd            CONSTANT CHAR(2) := '92';
   c_refcasaacct      CONSTANT CHAR(2) := '93';
   c_nostroacct       CONSTANT CHAR(2) := '90';
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
    l_balance apprules.field%TYPE;
    l_status apprules.field%TYPE;
    l_ddmastcheck_arr txpks_check.ddmastcheck_arrtype;
    l_dorc varchar2(20);
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
    IF p_txmsg.deltd = 'N' THEN
        l_dorc := p_txmsg.txfields('91').value;
        IF l_dorc IN ('C', 'D') THEN
            l_DDMASTcheck_arr := txpks_check.fn_DDMASTcheck(p_txmsg.txfields('06').value,'DDMAST','ACCTNO');
            l_BALANCE := l_DDMASTcheck_arr(0).BALANCE;
            l_STATUS := l_DDMASTcheck_arr(0).STATUS;

            IF NOT (to_number(l_BALANCE) >= to_number(p_txmsg.txfields('10').value)) and l_dorc =  'D' THEN
                p_err_code := '-400101';
                plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
            IF NOT ( INSTR('A',l_STATUS) > 0) THEN
                p_err_code := '-400100';
                plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        END IF;
    END IF;


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
    l_dorc varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        l_dorc := p_txmsg.txfields('91').value;

        IF l_dorc =  'D' THEN
            INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('06').value,'0011',ROUND(p_txmsg.txfields('10').value,0),NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('06').value,'0003',ROUND(p_txmsg.txfields('10').value,0),NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            UPDATE DDMAST
            SET
            NETTING = NETTING + (ROUND(p_txmsg.txfields('10').value,0)),
            BALANCE = BALANCE - (ROUND(p_txmsg.txfields('10').value,0)),
            LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=p_txmsg.txfields('06').value;
        end if;

        SELECT DECODE(l_dorc, 'A', 'D', 'B', 'C', l_dorc) INTO l_dorc FROM DUAL;

        --locpt 20190819 add phan sinh request qua bank
        --Sinh bankrequest,banklog
        /* Formatted on 8/19/2019 3:43:04 PM (QP5 v5.126) */
        INSERT INTO crbtxreq (reqid,
                              objtype,
                              objname,
                              trfcode,
                              reqcode,
                              reqtxnum,
                              objkey,
                              txdate,
                              affectdate,
                              bankcode,
                              bankacct,
                              afacctno,
                              txamt,
                              status,
                              reftxnum,
                              reftxdate,
                              rbankaccount,
                              notes,unhold,dorc,busdate)
          VALUES   (seq_crbtxreq.NEXTVAL,
                    'T',
                    '6673',
                    'WTRANSFER',
                    p_txmsg.txfields ('94').VALUE,
                    p_txmsg.txfields ('95').VALUE,
                    p_txmsg.txnum,
                    TO_DATE (p_txmsg.txdate, systemnums.c_date_format),
                    TO_DATE (p_txmsg.txdate, systemnums.c_date_format),
                    'SHV',
                    p_txmsg.txfields ('93').VALUE,
                    p_txmsg.txfields ('06').VALUE,
                    p_txmsg.txfields ('10').VALUE,
                    'P',
                    NULL,
                    NULL,
                    p_txmsg.txfields ('90').VALUE,
                    p_txmsg.txfields ('30').VALUE,'N',l_dorc,TO_DATE (p_txmsg.busdate, systemnums.c_date_format));

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
         plog.init ('TXPKS_#6673EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#6673EX;
/
