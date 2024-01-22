SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1908ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1908EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      20/11/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1908ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_issuecode        CONSTANT CHAR(2) := '04';
   c_paymentdate      CONSTANT CHAR(2) := '01';
   c_templateid       CONSTANT CHAR(2) := '02';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
l_count     NUMBER;
V_ISSUECODE VARCHAR2(50);
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
    V_ISSUECODE := p_txmsg.txfields(c_issuecode).value;
    IF (UPPER(V_ISSUECODE) ='ALL' OR V_ISSUECODE IS NULL) THEN
       V_ISSUECODE := '%';
    END IF;
    SELECT COUNT(1) INTO l_count
    FROM BONDTYPEPAY BT, ISSUES ISS, BONDISSUE BI
    WHERE ISS.AUTOID = BI.ISSUESID AND
          BI.BONDCODE = BT.BONDCODE AND
          ISS.ISSUECODE LIKE V_ISSUECODE AND
          BT.PAYMENTDATE = TO_DATE(p_txmsg.txfields(c_paymentdate).value, systemnums.C_DATE_FORMAT);
    IF NOT l_count <> 0 THEN
      p_err_code := '-910003';
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RETURN errnums.C_BIZ_RULE_INVALID;
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
  V_ISSUECODE VARCHAR2(50);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    V_ISSUECODE := p_txmsg.txfields(c_issuecode).value;
    IF (UPPER(V_ISSUECODE) ='ALL' OR V_ISSUECODE IS NULL) THEN
       V_ISSUECODE := '%';
    END IF;
    FOR rec IN (
        SELECT DISTINCT BI.BONDCODE, BT.PAYMENTDATE, SB.SYMBOL
        FROM ISSUES ISS, BONDISSUE BI, BONDTYPEPAY BT, SBSECURITIES SB
        WHERE ISS.AUTOID = BI.ISSUESID AND
              BI.BONDCODE = BT.BONDCODE AND
              BI.BONDCODE = SB.CODEID AND
              ISS.ISSUECODE LIKE V_ISSUECODE AND
              BT.PAYMENTDATE = TO_DATE(p_txmsg.txfields(c_paymentdate).value, systemnums.C_DATE_FORMAT)
    ) LOOP
        IF p_txmsg.txfields(c_templateid).value = 'EM12' THEN
           nmpks_ems.pr_GenTemplateEM12(rec.SYMBOL, rec.PAYMENTDATE,'VIE');
        ELSIF p_txmsg.txfields(c_templateid).value = 'EM12EN' THEN
              nmpks_ems.pr_GenTemplateEM12(rec.SYMBOL, rec.PAYMENTDATE,'ENG');
        ELSIF p_txmsg.txfields(c_templateid).value = 'EM14' THEN
              nmpks_ems.pr_GenTemplateEM14(rec.SYMBOL, rec.PAYMENTDATE);
        ELSIF p_txmsg.txfields(c_templateid).value = 'EM20' THEN
              nmpks_ems.pr_GenTemplateEM20(rec.SYMBOL, rec.PAYMENTDATE);
        ELSIF p_txmsg.txfields(c_templateid).value = 'EM21' THEN
              nmpks_ems.pr_GenTemplateEM21(rec.SYMBOL, rec.PAYMENTDATE);
        END IF;
    END LOOP;
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
         plog.init ('TXPKS_#1908EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1908EX;
/
