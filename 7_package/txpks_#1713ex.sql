SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1713ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1713EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      04/12/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1713ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_mttype           CONSTANT CHAR(2) := '06';
   c_date             CONSTANT CHAR(2) := '20';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS

v_sendswift varchar2(4);
v_custodycd varchar2(50);
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
    v_custodycd := UPPER(NVL(p_txmsg.txfields('88').value,'ALL'));
    IF p_txmsg.deltd <> 'Y' THEN
        IF v_custodycd <> 'ALL' THEN
            SELECT trim(nvl(cf.sendswift,'N')) INTO v_sendswift
            FROM cfmast cf
            WHERE custodycd = p_txmsg.txfields('88').value;

            IF NOT v_sendswift='Y' THEN
                p_err_code := '-199222';
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
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
v_custodycd varchar2(50);
v_mttype varchar2(50);
v_trfcode varchar2(50);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_custodycd := UPPER(NVL(p_txmsg.txfields('88').value,'ALL'));
    v_mttype := p_txmsg.txfields('07').value;
    v_trfcode := p_txmsg.txfields('06').value;
    IF p_txmsg.deltd <> 'Y' THEN
        IF v_custodycd <> 'ALL' THEN
            FOR REC IN (
                SELECT TRFCODE, BANKCODE
                FROM VSDTRFCODE
                WHERE TLTXCD=P_TXMSG.TLTXCD
                AND STATUS='Y'
                AND TYPE = 'REQ'
                AND TRFCODE = v_trfcode
            )
            LOOP
                IF REC.TRFCODE IN ('950.STMT.MSG','940.CST.STMT.MSG') THEN --TRUNG.LUU:  11-01-2021  SHBVNEX-1889 MT940 MT950 SINH THEO DDMAST.ACCTNO
                    FOR REC2 IN (
                                SELECT ACCTNO FROM DDMAST WHERE CUSTODYCD = v_custodycd AND STATUS <> 'C'
                            )
                    LOOP
                        INSERT INTO VSD_PROCESS_LOG(AUTOID, TRFCODE, TLTXCD, TXNUM, TXDATE, PROCESS, MSGACCT, BRID, TLID, BANKCODE)
                        VALUES (SEQ_VSD_PROCESS_LOG.NEXTVAL, REC.TRFCODE, P_TXMSG.TLTXCD, P_TXMSG.TXNUM, P_TXMSG.TXDATE, 'N', REC2.ACCTNO, P_TXMSG.BRID, P_TXMSG.TLID, REC.BANKCODE);
                    END LOOP;
                ELSE
                    INSERT INTO VSD_PROCESS_LOG(AUTOID, TRFCODE, TLTXCD, TXNUM, TXDATE, PROCESS, MSGACCT, BRID, TLID, BANKCODE)
                    VALUES (SEQ_VSD_PROCESS_LOG.NEXTVAL, REC.TRFCODE, P_TXMSG.TLTXCD, P_TXMSG.TXNUM, P_TXMSG.TXDATE, 'N', V_CUSTODYCD, P_TXMSG.BRID, P_TXMSG.TLID, REC.BANKCODE);
                END IF;
            END LOOP;
        ELSE
            FOR RECCF IN (
                SELECT * FROM CFMAST WHERE STATUS <> 'C' AND NVL(SWIFTCODE,'X') <> 'X' AND TRIM(NVL(SENDSWIFT,'N')) = 'Y'
            )
            LOOP
                FOR REC IN (
                    SELECT TRFCODE, BANKCODE
                    FROM VSDTRFCODE
                    WHERE TLTXCD=P_TXMSG.TLTXCD
                    AND STATUS='Y'
                    AND TYPE = 'REQ'
                    AND TRFCODE = v_trfcode
                )
                LOOP
                    IF REC.TRFCODE IN ('950.STMT.MSG','940.CST.STMT.MSG') THEN --TRUNG.LUU:  11-01-2021  SHBVNEX-1889 MT940 MT950 SINH THEO DDMAST.ACCTNO
                        FOR REC2 IN (
                                    SELECT ACCTNO FROM DDMAST WHERE CUSTODYCD = RECCF.CUSTODYCD AND STATUS <> 'C'
                                )
                        LOOP
                            INSERT INTO VSD_PROCESS_LOG(AUTOID, TRFCODE, TLTXCD, TXNUM, TXDATE, PROCESS, MSGACCT, BRID, TLID, BANKCODE)
                            VALUES (SEQ_VSD_PROCESS_LOG.NEXTVAL, REC.TRFCODE, P_TXMSG.TLTXCD, P_TXMSG.TXNUM, P_TXMSG.TXDATE, 'N', REC2.ACCTNO, P_TXMSG.BRID, P_TXMSG.TLID, REC.BANKCODE);
                        END LOOP;
                    ELSE
                        INSERT INTO VSD_PROCESS_LOG(AUTOID, TRFCODE, TLTXCD, TXNUM, TXDATE, PROCESS, MSGACCT, BRID, TLID, BANKCODE)
                        VALUES (SEQ_VSD_PROCESS_LOG.NEXTVAL, REC.TRFCODE, P_TXMSG.TLTXCD, P_TXMSG.TXNUM, P_TXMSG.TXDATE, 'N', RECCF.CUSTODYCD, P_TXMSG.BRID, P_TXMSG.TLID, REC.BANKCODE);
                    END IF;
                END LOOP;
            END LOOP;
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
         plog.init ('TXPKS_#1713EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1713EX;
/
