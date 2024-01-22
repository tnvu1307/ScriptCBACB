SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8892ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8892EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      29/10/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#8892ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_txdate           CONSTANT CHAR(2) := '20';
   c_txnum            CONSTANT CHAR(2) := '21';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_fullname         CONSTANT CHAR(2) := '07';
   c_codeid           CONSTANT CHAR(2) := '23';
   c_qttyckcc         CONSTANT CHAR(2) := '24';
   c_etfid            CONSTANT CHAR(2) := '03';
   c_etfname          CONSTANT CHAR(2) := '82';
   c_type             CONSTANT CHAR(2) := '12';
   c_etfqtty          CONSTANT CHAR(2) := '06';
   c_nav              CONSTANT CHAR(2) := '08';
   c_amount           CONSTANT CHAR(2) := '09';
   c_desc             CONSTANT CHAR(2) := '30';
   c_acctno           CONSTANT CHAR(2) := '22';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
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
    select count(*) into l_count
        from etfwsap e
        where e.orderid = p_txmsg.txfields('22').value and status in ('A');
     if l_count > 0 then
         p_err_code := '-701416';

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
l_allow         boolean;

    l_status apprules.field%TYPE;
    l_semastcheck_arr txpks_check.semastcheck_arrtype;
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
        for r in (select (od.afacctno || et.codeid) ACCTNO from odmast od, etfwsap et where od.orderid = et.orderid and od.orderid = p_txmsg.txfields('22').value)
        loop
             If txpks_check.fn_aftxmapcheck(r.ACCTNO,'SEMAST','22','8899')<>'TRUE' then
                 p_err_code := errnums.C_SA_TLTX_NOT_ALLOW_BY_ACCTNO;
                 plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
                 RETURN errnums.C_BIZ_RULE_INVALID;
             End if;

             l_SEMASTcheck_arr := txpks_check.fn_SEMASTcheck(r.ACCTNO,'SEMAST','ACCTNO');

             l_STATUS := l_SEMASTcheck_arr(0).STATUS;

             IF NOT ( INSTR('A',l_STATUS) > 0) THEN
                p_err_code := '-900019';
                plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
             END IF;
        end loop;

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
v_QTTY number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    select sum(e.qtty) into v_QTTY from etfwsap e where orderid = p_txmsg.txfields('22').value;
    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        for r in (select (od.afacctno || et.codeid) ACCTNO, et.qtty from odmast od, etfwsap et where od.orderid = et.orderid and od.orderid = p_txmsg.txfields('22').value)
        loop
            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),r.ACCTNO,'0020',ROUND(r.qtty,0),NULL,r.ACCTNO,p_txmsg.deltd,r.ACCTNO,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),r.ACCTNO,'0010',ROUND(r.qtty,0),NULL,r.ACCTNO,p_txmsg.deltd,r.ACCTNO,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            UPDATE SEMAST
             SET
               TRADE =TRADE+ r.qtty,
               NETTING = NETTING - (ROUND(r.qtty,0)), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=r.ACCTNO;



             UPDATE ETFWSAP
             SET
               QTTY = QTTY - (r.qtty),
               PSTATUS=PSTATUS||STATUS,STATUS='A'
            WHERE TXNUM=p_txmsg.txfields('21').value;

        end loop;
   ELSE -- Reversal
UPDATE TLLOG
 SET DELTD = 'Y'
      WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
        UPDATE SETRAN        SET DELTD = 'Y'
        WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);

      for r in (select (od.afacctno || et.codeid) ACCTNO, et.qtty from odmast od, etfwsap et where od.orderid = et.orderid and od.orderid = p_txmsg.txfields('22').value)
        loop
            UPDATE SEMAST
             SET
               TRADE =TRADE - r.qtty,
               NETTING = NETTING + (ROUND(r.qtty,0)), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=r.ACCTNO;

             UPDATE ETFWSAP
             SET
               QTTY = QTTY + (r.qtty),
               PSTATUS=PSTATUS||STATUS,STATUS='P'
            WHERE TXNUM=p_txmsg.txfields('21').value;

        end loop;

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
         plog.init ('TXPKS_#8892EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8892EX;
/
