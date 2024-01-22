SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#2323ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2323EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      20/11/2023     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#2323ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_mcustodycd       CONSTANT CHAR(2) := '94';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_autoid           CONSTANT CHAR(2) := '99';
   c_custname         CONSTANT CHAR(2) := '90';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_codeid           CONSTANT CHAR(2) := '01';
   c_stocktype        CONSTANT CHAR(2) := '33';
   c_qtty             CONSTANT CHAR(2) := '10';
   c_placeid          CONSTANT CHAR(2) := '04';
   c_contractno       CONSTANT CHAR(2) := '05';
   c_contractdate     CONSTANT CHAR(2) := '07';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    L_COUNT NUMBER;
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
    IF P_TXMSG.DELTD <> 'Y' THEN
        SELECT COUNT(1) INTO L_COUNT FROM SEMORTAGE_TPRL WHERE AUTOID = TO_NUMBER(P_TXMSG.TXFIELDS('99').VALUE) AND STATUS IN ('P','R') AND DELTD = 'N';
        IF L_COUNT = 0 THEN
            p_err_code := '-100165';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
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
    L_DATA VARCHAR2(4000);
    L_AUTOID NUMBER;
    L_CODEID VARCHAR2(20);
    L_AFACCTNO VARCHAR2(20);
    L_ACCTNO VARCHAR2(20);
    L_CUSTODYCD VARCHAR2(20);
    L_MCUSTODYCD VARCHAR2(20);
    L_QTTY NUMBER;
    L_QTTYTYPE VARCHAR2(20);
    L_CBREF VARCHAR2(50);
    L_CUSTNAME VARCHAR2(500);
    L_PLACEID VARCHAR2(50);
    L_CONTRACTNO VARCHAR2(100);
    L_CONTRACTDATE VARCHAR2(50);
    L_REFVSDID VARCHAR2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF P_TXMSG.DELTD <> 'Y' THEN
        L_AUTOID := TO_NUMBER(P_TXMSG.TXFIELDS('99').VALUE);
        L_CODEID := P_TXMSG.TXFIELDS('01').VALUE;
        L_AFACCTNO := P_TXMSG.TXFIELDS('02').VALUE;
        L_ACCTNO := P_TXMSG.TXFIELDS('03').VALUE;
        L_CUSTODYCD := P_TXMSG.TXFIELDS('88').VALUE;
        L_MCUSTODYCD := P_TXMSG.TXFIELDS('94').VALUE;
        L_QTTY := P_TXMSG.TXFIELDS('10').VALUE;
        L_QTTYTYPE := P_TXMSG.TXFIELDS('33').VALUE;
        L_CUSTNAME := P_TXMSG.TXFIELDS('90').VALUE;
        L_PLACEID := P_TXMSG.TXFIELDS('04').VALUE;
        L_CONTRACTNO := P_TXMSG.TXFIELDS('05').VALUE;
        L_CONTRACTDATE := P_TXMSG.TXFIELDS('07').VALUE;

        L_CBREF := 'CB.' || P_TXMSG.TXFIELDS('99').VALUE;
        BEGIN
            SELECT SE2316.REFVSDID INTO L_REFVSDID
            FROM SEMORTAGE_TPRL SE2321, SEMORTAGE_TPRL SE2316
            WHERE SE2321.REFID = SE2316.AUTOID
            AND SE2321.AUTOID = L_AUTOID;
        EXCEPTION WHEN OTHERS THEN
            L_REFVSDID := '';
        END;
        L_DATA := '{';
        L_DATA := L_DATA || '"CODEID":"' || TRANSFORM_PARAMETER_JSON(L_CODEID) || '",';
        L_DATA := L_DATA || '"AFACCTNO":"' || TRANSFORM_PARAMETER_JSON(L_AFACCTNO) || '",';
        L_DATA := L_DATA || '"SETTLEMENTDATE":"' || TRANSFORM_PARAMETER_JSON(TO_CHAR(P_TXMSG.TXDATE, 'DD/MM/RRRR')) || '",';
        L_DATA := L_DATA || '"STOCKTYPE":"' || TRANSFORM_PARAMETER_JSON(L_QTTYTYPE) || '",';
        L_DATA := L_DATA || '"CUSTODYCD":"' || TRANSFORM_PARAMETER_JSON(NVL(L_MCUSTODYCD, L_CUSTODYCD)) || '",';
        L_DATA := L_DATA || '"CUSTNAME":"' || TRANSFORM_PARAMETER_JSON(L_CUSTNAME) || '",';
        L_DATA := L_DATA || '"QTTY":"' || TRANSFORM_PARAMETER_JSON(L_QTTY) || '",';
        L_DATA := L_DATA || '"PLACEID":"' || TRANSFORM_PARAMETER_JSON(L_PLACEID) || '",';
        L_DATA := L_DATA || '"CONTRACTNO":"' || TRANSFORM_PARAMETER_JSON(L_CONTRACTNO) || '",';
        L_DATA := L_DATA || '"BPLOCKREQID":"' || TRANSFORM_PARAMETER_JSON(L_REFVSDID) || '",';
        L_DATA := L_DATA || '"CONTRACTDATE":"' || TRANSFORM_PARAMETER_JSON(L_CONTRACTDATE) || '",';
        L_DATA := L_DATA || '"CBREF":"' || TRANSFORM_PARAMETER_JSON(L_CBREF) || '"';
        L_DATA := L_DATA || '}';

        L_DATA := TRANSFORM_JSON(L_DATA);

        CBBONDACB.CSPKS_VSTP.PRC_CALL_1512(L_DATA, p_err_code);
        IF P_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN
            
            
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

        UPDATE SEMORTAGE_TPRL SET STATUS = 'S' WHERE AUTOID = L_AUTOID;
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
         plog.init ('TXPKS_#2323EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2323EX;
/
