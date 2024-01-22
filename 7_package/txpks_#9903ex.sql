SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#9903ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#9903EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      17/04/2023     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#9903ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_gl               CONSTANT CHAR(2) := '07';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_cifid            CONSTANT CHAR(2) := '89';
   c_codeid           CONSTANT CHAR(2) := '04';
   c_qttytype         CONSTANT CHAR(2) := '14';
   c_qtty             CONSTANT CHAR(2) := '10';
   c_parvalue         CONSTANT CHAR(2) := '15';
   c_trantype         CONSTANT CHAR(2) := '16';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    L_DEALINGCUSTODYCD VARCHAR2(10);
    L_TRADEPLACE VARCHAR2(50);
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
    IF p_txmsg.deltd <> 'Y' THEN
        BEGIN
              SELECT VARVALUE INTO L_DEALINGCUSTODYCD
              FROM SYSVAR WHERE VARNAME = 'DEALINGCUSTODYCD';
        EXCEPTION WHEN OTHERS THEN
            L_DEALINGCUSTODYCD := 'SHVE';
        END;

        FOR REC IN (
            SELECT P.*, SB.SHORTCD
            FROM POSTMAPEXT P, SBCURRENCY SB
            WHERE P.STATUS = 'A'
            AND P.DORC = P_TXMSG.TXFIELDS('14').VALUE
            AND (P.DEBITACCOUNT = P_TXMSG.TXFIELDS('07').VALUE OR P.CREBITACCOUNT = P_TXMSG.TXFIELDS('07').VALUE)
            AND P.CCYCD = SB.CCYCD
        )LOOP
            IF REC.CFTYPE = '001' AND SUBSTR(P_TXMSG.TXFIELDS('88').VALUE, 1, 4) <> L_DEALINGCUSTODYCD THEN
                P_ERR_CODE := '-9';
                RETURN ERRNUMS.C_BIZ_RULE_INVALID;
            END IF;
            SELECT TRADEPLACE INTO L_TRADEPLACE FROM SBSECURITIES WHERE CODEID = P_TXMSG.TXFIELDS('04').VALUE;
            IF (REC.TRADEPLACE = '000' AND L_TRADEPLACE NOT IN ('001','002','005','010')) OR (REC.TRADEPLACE <> '000' AND L_TRADEPLACE IN ('001','002','005','010')) THEN
                P_ERR_CODE := '-9';
                RETURN ERRNUMS.C_BIZ_RULE_INVALID;
            END IF;
        END LOOP;
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
    L_SYMBOL VARCHAR2(100);
    L_QTTY NUMBER;
    L_PARVALUE NUMBER;
    L_BANKREQID VARCHAR2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN
        SELECT SYMBOL INTO L_SYMBOL FROM SBSECURITIES WHERE CODEID = P_TXMSG.TXFIELDS('04').VALUE;
        L_QTTY := P_TXMSG.TXFIELDS('10').VALUE;
        L_PARVALUE := P_TXMSG.TXFIELDS('15').VALUE;
        L_BANKREQID := TO_CHAR(P_TXMSG.TXDATE,'RRRRMMDD') || LPAD(SEQ_GL_EXP_RESULTS.NEXTVAL, 4, '0');

        FOR REC IN (
            SELECT P.*, SB.SHORTCD CURRENCY
            FROM POSTMAPEXT P, SBCURRENCY SB
            WHERE P.STATUS = 'A'
            AND P.DORC = P_TXMSG.TXFIELDS('14').VALUE
            AND (P.DEBITACCOUNT = P_TXMSG.TXFIELDS('07').VALUE OR P.CREBITACCOUNT = P_TXMSG.TXFIELDS('07').VALUE)
            AND P.CCYCD = SB.CCYCD
        )LOOP
            FOR REC2 IN (
                SELECT CF.CUSTID, CF.CUSTODYCD, CF.CIFID, NVL(CF.MCIFID, CF.CIFID) MCIFID, VW.CUSTODYCD MCUSTODYCD
                FROM CFMAST CF, VW_CFMAST_M VW
                WHERE CF.CUSTODYCD = P_TXMSG.TXFIELDS('88').VALUE
                AND CF.CUSTODYCD = VW.CUSTODYCD_ORG
            ) LOOP
                IF P_TXMSG.TXFIELDS('16').VALUE = '1' THEN --Aither
                    INSERT INTO CRBTXREQ (REQID, OBJTYPE, OBJNAME, TRFCODE, REQCODE, REQTXNUM, OBJKEY, TXDATE, AFFECTDATE, BANKCODE,
                        BANKACCT, AFACCTNO, TXAMT, STATUS, REFTXNUM, REFTXDATE, REFVAL, NOTES, RBANKACCOUNT, RBANKCITAD,
                        CURRENCY, RBANKNAME)
                    VALUES (SEQ_CRBTXREQ.NEXTVAL, 'T', 'SCOA', 'SCOA', 'SCOA', L_BANKREQID, NULL, P_TXMSG.TXDATE, P_TXMSG.BUSDATE, 'SHV',
                        REC.CREBITACCOUNT, REC2.CIFID, L_QTTY * L_PARVALUE, 'P', NULL, NULL, NULL, REC.ACNAME, REC.DEBITACCOUNT, NULL,
                        REC.CURRENCY, TO_CHAR(P_TXMSG.BUSDATE,'RRRRMMDD'));
                ELSIF P_TXMSG.TXFIELDS('16').VALUE = '2' THEN -- CB
                    INSERT INTO GL_EXP_TRAN (REF, REFAUTOID, TLTXCD, TXNUM, TXDATE, BUSDATE, CUSTID, CUSTODYCD, CIFID, SYMBOL, QTTY, AMOUNT, CCYCD, DORC, DEBITACCT, CREDITACCT, DELTD, MCUSTODYCD, MCIFID)
                    SELECT TO_CHAR(P_TXMSG.TXDATE, 'YYYYMMDD'), REC.AUTOID, P_TXMSG.TLTXCD, P_TXMSG.TXNUM, P_TXMSG.TXDATE, P_TXMSG.BUSDATE, REC2.CUSTID, REC2.CUSTODYCD, REC2.CIFID, L_SYMBOL,
                        L_QTTY, L_PARVALUE, REC.CURRENCY, REC.DORC, REC.DEBITACCOUNT, REC.CREBITACCOUNT, 'N', REC2.MCUSTODYCD, REC2.MCIFID
                    FROM DUAL;

                    INSERT INTO GL_EXP_RESULTS (TXDATE, BUSDATE, CUSTODYCD, CIFID, DEBITACCT, CREDITACCT, AMOUNT, STATUS, DELTD, CCYCD, NOTE, MCUSTODYCD, MCIFID, BANKREQID)
                    SELECT P_TXMSG.TXDATE, P_TXMSG.BUSDATE, REC2.CUSTODYCD, REC2.CIFID, REC.DEBITACCOUNT, REC.CREBITACCOUNT, L_QTTY * L_PARVALUE AMOUNT, 'A', 'N', REC.CURRENCY, REC.ACNAME, REC2.MCUSTODYCD, REC2.MCIFID, L_BANKREQID
                    FROM DUAL;
                ELSE
                    INSERT INTO GL_EXP_TRAN (REF, REFAUTOID, TLTXCD, TXNUM, TXDATE, BUSDATE, CUSTID, CUSTODYCD, CIFID, SYMBOL, QTTY, AMOUNT, CCYCD, DORC, DEBITACCT, CREDITACCT, DELTD, MCUSTODYCD, MCIFID)
                    SELECT TO_CHAR(P_TXMSG.TXDATE, 'YYYYMMDD'), REC.AUTOID, P_TXMSG.TLTXCD, P_TXMSG.TXNUM, P_TXMSG.TXDATE, P_TXMSG.BUSDATE, REC2.CUSTID, REC2.CUSTODYCD, REC2.CIFID, L_SYMBOL,
                        L_QTTY, L_PARVALUE, REC.CURRENCY, REC.DORC, REC.DEBITACCOUNT, REC.CREBITACCOUNT, 'N', REC2.MCUSTODYCD, REC2.MCIFID
                    FROM DUAL;

                    INSERT INTO GL_EXP_RESULTS (TXDATE, BUSDATE, CUSTODYCD, CIFID, DEBITACCT, CREDITACCT, AMOUNT, STATUS, DELTD, CCYCD, NOTE, MCUSTODYCD, MCIFID, BANKREQID)
                    SELECT P_TXMSG.TXDATE, P_TXMSG.BUSDATE, REC2.CUSTODYCD, REC2.CIFID, REC.DEBITACCOUNT, REC.CREBITACCOUNT, L_QTTY * L_PARVALUE AMOUNT, 'A', 'N', REC.CURRENCY, REC.ACNAME, REC2.MCUSTODYCD, REC2.MCIFID, L_BANKREQID
                    FROM DUAL;

                    INSERT INTO CRBTXREQ (REQID, OBJTYPE, OBJNAME, TRFCODE, REQCODE, REQTXNUM, OBJKEY, TXDATE, AFFECTDATE, BANKCODE,
                        BANKACCT, AFACCTNO, TXAMT, STATUS, REFTXNUM, REFTXDATE, REFVAL, NOTES, RBANKACCOUNT, RBANKCITAD,
                        CURRENCY, RBANKNAME)
                    VALUES (SEQ_CRBTXREQ.NEXTVAL, 'T', 'SCOA', 'SCOA', 'SCOA', L_BANKREQID, NULL, P_TXMSG.TXDATE, P_TXMSG.BUSDATE, 'SHV',
                        REC.CREBITACCOUNT, REC2.CIFID, L_QTTY * L_PARVALUE, 'P', NULL, NULL, NULL, REC.ACNAME, REC.DEBITACCOUNT, NULL,
                        REC.CURRENCY, TO_CHAR(P_TXMSG.BUSDATE,'RRRRMMDD'));
                END IF;
            END LOOP;
        END LOOP;
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
         plog.init ('TXPKS_#9903EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#9903EX;
/
