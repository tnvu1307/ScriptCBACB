SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3333ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3333EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      07/11/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3333ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '02';
   c_symbol_org       CONSTANT CHAR(2) := '71';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_optsymbol        CONSTANT CHAR(2) := '24';
   c_custodycd        CONSTANT CHAR(2) := '96';
   c_cifid            CONSTANT CHAR(2) := '03';
   c_fullname         CONSTANT CHAR(2) := '08';
   c_trade            CONSTANT CHAR(2) := '11';
   c_maxqtty          CONSTANT CHAR(2) := '20';
   c_qttycancel       CONSTANT CHAR(2) := '12';
   c_qtty             CONSTANT CHAR(2) := '10';
   c_exprice          CONSTANT CHAR(2) := '05';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_afacctno varchar2(20);
    v_caqtty number;
    v_camastid varchar2(20);
    v_pbalance number;
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

    v_camastid := p_txmsg.txfields('02').VALUE;
    v_caqtty:= to_number(p_txmsg.txfields ('10').VALUE);

    BEGIN
        SELECT AF.ACCTNO INTO l_afacctno FROM CFMAST CF, AFMAST AF WHERE CF.CUSTID = AF.CUSTID AND CF.CUSTODYCD = P_TXMSG.TXFIELDS ('96').VALUE;

        SELECT PBALANCE - QTTYCANCEL INTO v_pbalance FROM CASCHD WHERE CAMASTID = v_camastid AND AFACCTNO = l_afacctno AND DELTD <> 'Y';

        IF v_pbalance < v_caqtty THEN
            p_err_code := '-300056';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        p_err_code := '-200012';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END;
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
l_seacctno varchar2(50);
l_afacctno varchar2(20);
l_optcodeid varchar2(20);
v_caqtty number;
v_qtty number;
v_camastid varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    select codeid into l_optcodeid
    from sbsecurities
    where symbol=p_txmsg.txfields ('24').VALUE;

    SELECT AF.ACCTNO INTO l_afacctno FROM CFMAST CF, AFMAST AF WHERE CF.CUSTID = AF.CUSTID AND CF.CUSTODYCD = P_TXMSG.TXFIELDS ('96').VALUE;

    l_seacctno:=l_afacctno||l_optcodeid;

    v_camastid := p_txmsg.txfields('02').VALUE;
    v_caqtty:= to_number(p_txmsg.txfields ('10').VALUE);
    v_qtty:= to_number(p_txmsg.txfields ('21').VALUE);

    if p_txmsg.deltd <> 'Y' then
        Update semast
        set trade = trade - v_caqtty
        where acctno = l_seacctno;

        INSERT INTO SETRAN (ACCTNO, TXNUM, TXDATE, TXCD, NAMT, CAMT, REF, DELTD,AUTOID,acctref,Tltxcd)
        VALUES (l_seacctno,p_txmsg.txnum,p_txmsg.txdate,'0011', v_caqtty,'',p_txmsg.txfields ('03').VALUE,'N',SEQ_SETRAN.NEXTVAL,p_txmsg.txfields ('03').VALUE,'3333');


        UPDATE CASCHD SET PQTTY = PQTTY - v_qtty, QTTYCANCEL = QTTYCANCEL + v_caqtty
        WHERE CAMASTID = v_camastid
        AND AFACCTNO = l_afacctno
        AND DELTD <> 'Y';

        /*for rec in (
            SELECT * FROM CASCHD
            WHERE AFACCTNO = l_afacctno
                AND CAMASTID= p_txmsg.txfields('02').VALUE
                AND PQTTY-QTTYCANCEL > 0
                AND DELTD <> 'Y'
            ORDER BY AUTOID
        )
        loop
            if v_caqtty > rec.PBALANCE then
                UPDATE CASCHD SET PQTTY = PQTTY - REC.PQTTY, QTTYCANCEL = QTTYCANCEL + REC.PBALANCE
                WHERE AUTOID = REC.AUTOID;
                v_caqtty := v_caqtty - REC.PBALANCE;
                v_qtty := v_qtty - REC.PQTTY;
            else
                update CASCHD set
                        PQTTY=PQTTY-v_caqtty,
                        QTTYCANCEL = QTTYCANCEL + v_caqtty
                    where autoid = rec.autoid;
                v_caqtty:=0;
            end if;
            exit when v_caqtty<=0;
        end loop;*/
    else
        Update semast
        set trade = trade + v_qtty
        where acctno = l_seacctno;

        UPDATE SETRAN SET DELTD='Y' WHERE txnum=p_txmsg.txnum and txdate=p_txmsg.txdate;

        UPDATE CASCHD SET PQTTY = PQTTY + v_qtty, QTTYCANCEL = QTTYCANCEL - v_caqtty
        WHERE CAMASTID = v_camastid
        AND AFACCTNO = l_afacctno
        AND DELTD <> 'Y';

        /*for rec in (
            SELECT * FROM CASCHD
            WHERE AFACCTNO = l_afacctno
                AND CAMASTID= p_txmsg.txfields('02').VALUE
                AND DELTD <> 'Y'
            ORDER BY AUTOID
        )
        loop
            if v_caqtty > rec.QTTYCANCEL then
                update CASCHD set
                        PQTTY=PQTTY+rec.QTTYCANCEL,
                        QTTYCANCEL = QTTYCANCEL - rec.QTTYCANCEL
                where autoid = rec.autoid;
                v_caqtty:=v_caqtty-rec.QTTYCANCEL;
            else
                update CASCHD set
                        PQTTY=PQTTY+v_caqtty,
                        QTTYCANCEL = QTTYCANCEL - v_caqtty
                where autoid = rec.autoid;
                v_caqtty:=0;
            end if;
            exit when v_caqtty<=0;
        end loop;*/
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
         plog.init ('TXPKS_#3333EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3333EX;
/
