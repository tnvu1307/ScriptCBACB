SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#6691ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#6691EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      14/10/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#6691ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;
   c_reqtxnum         CONSTANT CHAR(2) := '95';
   c_reqcode          CONSTANT CHAR(2) := '94';
   c_refholdtxnum     CONSTANT CHAR(2) := '91';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_secaccount       CONSTANT CHAR(2) := '03';
   c_ddacctno         CONSTANT CHAR(2) := '04';
   c_custname         CONSTANT CHAR(2) := '90';
   c_refcasaacct      CONSTANT CHAR(2) := '93';
   c_bankbalance      CONSTANT CHAR(2) := '13';
   c_bankholded       CONSTANT CHAR(2) := '12';
   c_memberid         CONSTANT CHAR(2) := '05';
   c_brname           CONSTANT CHAR(2) := '06';
   c_brphone          CONSTANT CHAR(2) := '07';
   c_bankholdedbybroker   CONSTANT CHAR(2) := '11';
   c_ccycd            CONSTANT CHAR(2) := '20';
   c_exchangerate     CONSTANT CHAR(2) := '21';
   c_amount           CONSTANT CHAR(2) := '10';
   c_value            CONSTANT CHAR(2) := '22';
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
    v_refglobalid varchar2(50);
    L_COUNT NUMBER;
    L_REQTXNUM VARCHAR2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

     IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        --locpt 20190819 add phan sinh request qua bank
        --Sinh bankrequest,banklog
        begin
            select repval  into v_refglobalid
            from crbtxreq
            where  objkey = p_txmsg.txfields ('91').VALUE and TO_DATE (txdate, systemnums.c_date_format) = TO_DATE (p_txmsg.BUSDATE, systemnums.c_date_format) and unhold = 'N' and rownum = 1;
        EXCEPTION WHEN OTHERS THEN
            v_refglobalid := p_txmsg.txfields ('91').VALUE;
        end;
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
                              refval,
                              notes,unhold,trnref)
          VALUES   (seq_crbtxreq.NEXTVAL,
                    'T',
                    '6691',
                    'UNHOLD',
                    p_txmsg.txfields ('94').VALUE,
                    p_txmsg.txfields ('95').VALUE,
                    p_txmsg.txnum,
                    TO_DATE (p_txmsg.txdate, systemnums.c_date_format),
                    TO_DATE (p_txmsg.txdate, systemnums.c_date_format),
                    'SHV',
                    p_txmsg.txfields ('93').VALUE,
                    p_txmsg.txfields ('04').VALUE,
                    p_txmsg.txfields ('10').VALUE,
                    'P',
                    p_txmsg.txfields ('91').VALUE,
                    NULL,
                    NULL,
                    p_txmsg.txfields ('30').VALUE,'N',v_refglobalid);

        --update trang thai de user khong hold dc nua
        update crbtxreq set unhold = 'Y' where objkey = p_txmsg.txfields ('91').VALUE and unhold = 'N' and txdate = p_txmsg.busdate and rownum = 1;
        --update trang thai da unhold trong odmast
        --update odmast set ishold = 'N' where orderid in(select reqtxnum from crbtxreq where objkey = p_txmsg.txfields ('91').VALUE);
        --- gen buff

        if not p_txmsg.txfields('05').value is null then
            pr_gen_buf_dd_member(p_txmsg.txfields('04').value ,p_txmsg.txfields(c_memberid).value,-(ROUND(p_txmsg.txfields('10').value,0)),0,(ROUND(p_txmsg.txfields('10').value,0)),0,0,0) ;
        end if;

        /*
        SELECT REQTXNUM INTO L_REQTXNUM FROM CRBTXREQ WHERE OBJKEY = P_TXMSG.TXFIELDS ('91').VALUE;

        SELECT COUNT(1) INTO L_COUNT
        FROM STSCHD_NETOFF
        WHERE TO_CHAR(AUTOID) = L_REQTXNUM;
        IF L_COUNT > 0 THEN
            FOR REC IN (
                SELECT * FROM STSCHD_NETOFF WHERE TO_CHAR(AUTOID) = L_REQTXNUM
            )LOOP
                UPDATE STSCHD_NETOFF SET ISHOLD = 'N' WHERE AUTOID = REC.AUTOID;
                UPDATE ODMAST SET ISHOLD = 'N', LASTCHANGE = SYSTIMESTAMP WHERE NETOFFID = REC.AUTOID AND EXECTYPE = 'NB';
            END LOOP;
        ELSE
         */
            SELECT COUNT(1) INTO L_COUNT
            FROM ODMAST
            WHERE ORDERID = L_REQTXNUM;
            IF L_COUNT > 0 THEN
                UPDATE ODMAST SET ISHOLD = 'N', LASTCHANGE = SYSTIMESTAMP WHERE ORDERID = L_REQTXNUM;
            END IF;
        /*END IF;*/
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
         plog.init ('TXPKS_#6691EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#6691EX;
/
