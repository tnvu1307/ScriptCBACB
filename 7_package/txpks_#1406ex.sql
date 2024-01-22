SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1406ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1406EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      29/11/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1406ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_receiveddate     CONSTANT CHAR(2) := '17';
   c_autoid           CONSTANT CHAR(2) := '09';
   c_crphysagreeid    CONSTANT CHAR(2) := '01';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_symbol           CONSTANT CHAR(2) := '03';
   c_crqtty           CONSTANT CHAR(2) := '10';
   c_refno            CONSTANT CHAR(2) := '02';
   c_postingdate      CONSTANT CHAR(2) := '18';
   c_sender           CONSTANT CHAR(2) := '31';
   c_receiver         CONSTANT CHAR(2) := '32';
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
v_count number;
V_CUSTID   VARCHAR2(20);
V_AFACCTNO VARCHAR2(20);
V_FEEAMT     NUMBER(20,4);
V_TAXAMT     NUMBER(20,4);
V_TAXRATE    NUMBER(20,4);
V_CCYCD      VARCHAR2(20);
V_FAUTOID    NUMBER;
V_TAUTOID    NUMBER;
V_SUPEBANK   VARCHAR2(1);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    --
    BEGIN
        SELECT CF.CUSTID, AF.ACCTNO, CF.SUPEBANK
        INTO V_CUSTID, V_AFACCTNO, V_SUPEBANK
        FROM CFMAST CF, AFMAST AF
        WHERE CF.CUSTID = AF.CUSTID AND
              CF.CUSTODYCD = p_txmsg.txfields(c_custodycd).value;
        EXCEPTION WHEN OTHERS THEN V_CUSTID   := NULL;
                                   V_AFACCTNO := NULL;
                                   V_SUPEBANK := NULL;
    END;
    IF p_txmsg.deltd <> 'Y' THEN

        --trung.luu: 02-07-2020 log lai de len view physical
        --bao.nguyen: 25-07-2022 SHBVNEX-2730
       insert into CRPHYSAGREE_LOG_ALL (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC,CITAD,TLTXCD,FEETYPE,SYMBOL,CUSTODYCD,REFNO,SENDER,RECEIVER,receiverdate,typedoc, custid)
       values (p_txmsg.txdate, p_txmsg.txnum,'NK',null,p_txmsg.txfields(c_crphysagreeid).value ,NULL, NULL, null, p_txmsg.txfields('11').value, 'A', 'N',p_txmsg.txfields(c_desc).value,null,p_txmsg.tltxcd,null,p_txmsg.txfields('03').value,
                p_txmsg.txfields('88').value,p_txmsg.txfields('02').value,p_txmsg.txfields(c_sender).value,p_txmsg.txfields(c_receiver).value, p_txmsg.txfields(c_receiveddate).value,'1407', v_custid);


        update docstransfer sr
        set
            sr.clsdate = TO_DATE(p_txmsg.txfields(c_postingdate).value, systemnums.C_DATE_FORMAT),
            sr.clstxdate = p_txmsg.txdate,
            sr.clstxnum = p_txmsg.txnum,
            sr.clssender = p_txmsg.txfields(c_sender).value,
            sr.clsreceiver = p_txmsg.txfields(c_receiveddate).value,
            sr.wrqtty = p_txmsg.txfields('11').value,
            sr.status = 'CLS'
        where sr.autoid = p_txmsg.txfields(c_autoid).value;
        select nvl(count(*), 0) into v_count from crphysagree cr where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
        if v_count > 0 then
            update crphysagree cr
            set
                cr.reposstatus = 'W'
            where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
         end if;
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
         plog.init ('TXPKS_#1406EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1406EX;
/
