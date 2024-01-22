SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3348ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3348EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      04/09/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3348ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '03';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_fullname         CONSTANT CHAR(2) := '90';
   c_votecode         CONSTANT CHAR(2) := '06';
   c_opinion          CONSTANT CHAR(2) := '07';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_camastid   varchar2(20);
v_count     varchar2(20);
v_custodycd varchar2(20);
v_votecode  varchar2(20);
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
     v_camastid := p_txmsg.txfields('03').value;
     v_custodycd := p_txmsg.txfields('88').value;
     v_votecode := p_txmsg.txfields('06').value;
    IF p_txmsg.deltd <> 'Y' THEN
      --Loai SKQ khong dung
         select count(1) into v_count
         from CAMAST
         WHERE CAMASTID = v_CAMASTID and CATYPE IN ('006','028','005') and DELTD <> 'Y';
         IF v_count = 0 THEN
             BEGIN
               p_err_code := '-300020';
               plog.setendsection (pkgctx, 'fn_txPreAppCheck');
               RETURN errnums.C_BIZ_RULE_INVALID;
             END;
         END IF;
      --Trang thai SKQ khong dung
         select count(1) into v_count
         from vw_tllog_all
         WHERE MSGACCT = v_CAMASTID and TLTXCD='3340' and DELTD <> 'Y';
         IF v_count = 0 THEN
             BEGIN
               p_err_code := '-300013';
               plog.setendsection (pkgctx, 'fn_txPreAppCheck');
               RETURN errnums.C_BIZ_RULE_INVALID;
             END;
         END IF;
         --So TKLK khong duoc huong SKQ
        select count(1) into v_count
        from CASCHD
        WHERE CAMASTID = v_CAMASTID
        and AFACCTNO IN (select ACCTNO from AFMAST AF, CFMAST CF where AF.CUSTID=CF.CUSTID AND CF.CUSTODYCD=v_CUSTODYCD) and DELTD <> 'Y';
        IF v_count = 0 THEN
             BEGIN
               p_err_code := '-300055';
               plog.setendsection (pkgctx, 'fn_txPreAppCheck');
               RETURN errnums.C_BIZ_RULE_INVALID;
             END;
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
v_camastid varchar2(20);
v_custodycd varchar2(20);
v_votecode varchar2(20);
v_afacctno varchar2(20);
v_opinion varchar2(20);
v_count number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_camastid := p_txmsg.txfields('03').value;
    v_custodycd := p_txmsg.txfields('88').value;
    v_votecode := p_txmsg.txfields('06').value;
    v_opinion := p_txmsg.txfields('07').value;
    select ACCTNO into v_afacctno from AFMAST where CUSTID IN (select CUSTID from CFMAST where CUSTODYCD = v_custodycd);
    --Ghi nhan vao bang VOTINGDETAIL
    select count(*) into v_count from VOTINGDETAIL where CAMASTID=v_camastid and CUSTODYCD = v_custodycd and VOTECODE = v_votecode;
    if v_count = 0 then
        INSERT INTO VOTINGDETAIL(AUTOID, CAMASTID, CUSTODYCD, AFACCTNO, VOTECODE, OPINION, DESCRIPTION)
        VALUES (SEQ_VOTINGDETAIL.Nextval, v_camastid, v_custodycd, v_afacctno, v_votecode, v_opinion, p_txmsg.txfields('30').value);
    else
        UPDATE VOTINGDETAIL SET OPINION = v_opinion where CAMASTID=v_camastid and CUSTODYCD = v_custodycd and VOTECODE = v_votecode;
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
         plog.init ('TXPKS_#3348EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3348EX;
/
