SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3403ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3403EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      04/12/2023     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3403ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '99';
   c_camastid         CONSTANT CHAR(2) := '02';
   c_mcustodycd       CONSTANT CHAR(2) := '88';
   c_custodycd        CONSTANT CHAR(2) := '96';
   c_cifid            CONSTANT CHAR(2) := '97';
   c_afacctno         CONSTANT CHAR(2) := '03';
   c_fullname         CONSTANT CHAR(2) := '90';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_codeid           CONSTANT CHAR(2) := '01';
   c_trade            CONSTANT CHAR(2) := '13';
   c_qtty             CONSTANT CHAR(2) := '10';
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
        SELECT COUNT(1) INTO L_COUNT FROM CA040REGISTER WHERE AUTOID = TO_NUMBER(P_TXMSG.TXFIELDS('99').VALUE) AND MSGSTATUS IN ('P', 'R') AND DELTD = 'N';
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
    L_AUTOID NUMBER;
    L_CBREF VARCHAR2(50);
    L_DATA VARCHAR2(4000);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF P_TXMSG.DELTD <> 'Y' THEN
        L_AUTOID := TO_NUMBER(P_TXMSG.TXFIELDS('99').VALUE);

        L_CBREF := 'CB.' || P_TXMSG.TXFIELDS('99').VALUE;
        FOR REC IN (
            SELECT CA.VSDID VSDCAID, SB.SYMBOL, NVL(CF.MCUSTODYCD, CF.CUSTODYCD) CUSTODYCD, CF.FULLNAME, CF.IDCODE, CF.IDDATE, CF.ALTERNATEID, REG.QTTY
            FROM CA040REGISTER REG, VW_CFMAST_VSTP CF, CAMAST CA, SBSECURITIES SB
            WHERE REG.CUSTODYCD = CF.CUSTODYCD
            AND REG.CAMASTID = CA.CAMASTID
            AND CA.CODEID = SB.CODEID
            AND REG.AUTOID = L_AUTOID
        )
        LOOP
            L_DATA := '{';
            L_DATA := L_DATA || '"VSDCAID":"' || TRANSFORM_PARAMETER_JSON(REC.VSDCAID) || '",';
            L_DATA := L_DATA || '"SYMBOL":"' || TRANSFORM_PARAMETER_JSON(REC.SYMBOL) || '",';
            L_DATA := L_DATA || '"CUSTODYCD":"' || TRANSFORM_PARAMETER_JSON(REC.CUSTODYCD) || '",';
            L_DATA := L_DATA || '"FULLNAME":"' || TRANSFORM_PARAMETER_JSON(REC.FULLNAME) || '",';
            L_DATA := L_DATA || '"IDCODE":"' || TRANSFORM_PARAMETER_JSON(REC.IDCODE) || '",';
            L_DATA := L_DATA || '"IDDATE":"' || TRANSFORM_PARAMETER_JSON(TO_CHAR(REC.IDDATE, 'DD/MM/RRRR')) || '",';
            L_DATA := L_DATA || '"ALTERNATEID":"' || TRANSFORM_PARAMETER_JSON(REC.ALTERNATEID) || '",';
            L_DATA := L_DATA || '"QTTY":"' || TRANSFORM_PARAMETER_JSON(REC.QTTY) || '",';
            L_DATA := L_DATA || '"CBREF":"' || TRANSFORM_PARAMETER_JSON(L_CBREF) || '"';
            L_DATA := L_DATA || '}';

            L_DATA := TRANSFORM_JSON(L_DATA);

            CBBONDACB.CSPKS_VSTP.PRC_CALL_1705(L_DATA, p_err_code);
            IF P_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN
                
                
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        END LOOP;

        UPDATE CA040REGISTER SET MSGSTATUS = 'S' WHERE AUTOID = L_AUTOID;
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
         plog.init ('TXPKS_#3403EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3403EX;
/
