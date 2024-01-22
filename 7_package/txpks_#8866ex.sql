SET DEFINE OFF;
CREATE OR REPLACE PACKAGE TXPKS_#8866EX
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8866EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      11/10/2019     Created
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


CREATE OR REPLACE PACKAGE BODY TXPKS_#8866EX
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '01';
   c_orgorderid       CONSTANT CHAR(2) := '06';
   c_afacctno         CONSTANT CHAR(2) := '03';
   c_ddacctno         CONSTANT CHAR(2) := '04';
   c_seacctno         CONSTANT CHAR(2) := '05';
   c_symbol           CONSTANT CHAR(2) := '07';
   c_codeid           CONSTANT CHAR(2) := '02';
   c_amt              CONSTANT CHAR(2) := '10';
   c_qtty             CONSTANT CHAR(2) := '09';
   c_fee              CONSTANT CHAR(2) := '11';
   c_vat              CONSTANT CHAR(2) := '12';
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
v_amt number(20,4);
v_tax number(20,4);
v_autoid varchar2(10);
v_custodycd varchar2(30);
v_orderid varchar2(30);
v_stsautoid number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
     IF p_txmsg.deltd <> 'Y' THEN
        v_amt := p_txmsg.txfields('11').value;
        v_tax := p_txmsg.txfields(c_vat).value;
        v_autoid := seq_feetran.nextval;
        v_orderid := p_txmsg.txfields(c_orgorderid).value;
        v_stsautoid := p_txmsg.txfields(c_autoid).value;
        select st.custodycd into v_custodycd from STSCHD st where st.autoid = v_stsautoid;
        IF v_tax > 0 THEN

             insert into feetran (TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE
                 , VATAMT, AUTOID, TRDESC, CCYCD, ORDERID
                 , TYPE, DEDUCTEDPLACE, STATUS, PAIDDATE, PSTATUS, SUBTYPE, FEETYPES, CUSTODYCD)
               values (p_txmsg.txdate, p_txmsg.txnum, 'N', null, null ,v_amt, 0.0000, 0.0000, 0.0000
                   , v_tax, v_autoid,'Tax of '|| p_txmsg.txfields(c_desc).value, 'USD', v_orderid
                   , 'T', 'CTCK', 'N', null, null, null, null, v_custodycd);

             insert into feetrandetail (AUTOID, REFID, TXDATE, TXNUM, SUBTYPE, FEETYPES, TXAMT, FEEAMT, ORDERID, CUSTODYCD, CCYCD, RATEAMT, FORP, CODEID, SEBAL, ASSET)
                  values (seq_feetrandetail.nextval, v_autoid, p_txmsg.txdate, p_txmsg.txnum, null, null, v_amt, 0.0000, v_orderid, v_custodycd, 'USD', v_tax, 'T', p_txmsg.txfields(c_codeid).value, 0, 0);
        END IF;

        IF txpks_batch.fn_SettlementOrder(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
              RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
    ELSE
        IF v_tax > 0 THEN
            UPDATE FEETRAN fe
            SET
                fe.deltd = 'Y'
            WHERE fe.txdate = p_txmsg.txdate
            AND fe.txnum = p_txmsg.txnum
            AND TYPE = 'T';

            DELETE FEETRANDETAIL fe
            WHERE fe.txdate = p_txmsg.txdate
            AND fe.txnum = p_txmsg.txnum
            AND fe.forp = 'T';
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
         plog.init ('TXPKS_#8866EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8866EX;
/
