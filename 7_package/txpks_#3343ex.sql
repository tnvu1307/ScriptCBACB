SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3343ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3343EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      11/03/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3343ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '03';
   c_camastid         CONSTANT CHAR(2) := '01';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_catype           CONSTANT CHAR(2) := '05';
   c_codeid           CONSTANT CHAR(2) := '24';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_cifid            CONSTANT CHAR(2) := '89';
   c_amt              CONSTANT CHAR(2) := '10';
   c_newamt           CONSTANT CHAR(2) := '11';
   c_intamt           CONSTANT CHAR(2) := '12';
   c_newintamt        CONSTANT CHAR(2) := '13';
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
l_catype varchar2(20);
l_camastid varchar2(30);
l_afacctno varchar2(20);
l_ddacctno varchar2(20);
l_amount number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        select acctno into l_ddacctno
        from ddmast
        where custodycd=TRIM(P_TXMSG.TXFIELDS('88').VALUE)
        and status <> 'C' and isdefault='Y';

        l_amount:=(p_txmsg.txfields('10').value+p_txmsg.txfields('12').value-p_txmsg.txfields('11').value-p_txmsg.txfields('13').value);

        INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
        VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_ddacctno,'0008',l_amount,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

        UPDATE DDMAST
        SET LASTCHANGE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
        RECEIVING = RECEIVING - l_amount, LAST_CHANGE = SYSTIMESTAMP
        WHERE ACCTNO=l_ddacctno;

        --Ngay 11/03/2020 NamTv xu ly cap nhat lai gia tri cho CAMASTDTL cua CATYPE=010
        select camastid, afacctno into l_camastid,l_afacctno
        from caschd
        where autoid=p_txmsg.txfields('03').value;

        select catype into l_catype
        from camast
        where camastid=l_camastid;

        IF l_catype='010' THEN
            INSERT INTO CATRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('03').value,'0004',p_txmsg.txfields('11').value+p_txmsg.txfields('13').value-p_txmsg.txfields('10').value-p_txmsg.txfields('12').value,NULL,'',p_txmsg.deltd,'',seq_CATRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            UPDATE CASCHDDTL
            SET AMT = AMT + (p_txmsg.txfields('11').value+p_txmsg.txfields('13').value-p_txmsg.txfields('10').value-p_txmsg.txfields('12').value)
            WHERE AUTOID_CASCHD=p_txmsg.txfields('03').value
            AND DELTD <> 'Y' AND STATUS ='P'
            AND CAMASTID=l_camastid and afacctno=l_afacctno;
        ELSE
            INSERT INTO CATRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('03').value,'0004',p_txmsg.txfields('11').value+p_txmsg.txfields('13').value-p_txmsg.txfields('10').value-p_txmsg.txfields('12').value,NULL,'',p_txmsg.deltd,'',seq_CATRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            INSERT INTO CATRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('03').value,'0057',p_txmsg.txfields('13').value-p_txmsg.txfields('12').value,NULL,'',p_txmsg.deltd,'',seq_CATRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            UPDATE CASCHD
            SET AMT = AMT + (p_txmsg.txfields('11').value + p_txmsg.txfields('13').value - p_txmsg.txfields('10').value - p_txmsg.txfields('12').value),
            INTAMT = INTAMT + (p_txmsg.txfields('13').value - p_txmsg.txfields('12').value)
            WHERE AUTOID=p_txmsg.txfields('03').value;
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
         plog.init ('TXPKS_#3343EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3343EX;
/
