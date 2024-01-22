SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1207ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1207EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      11/08/2022     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1207ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '02';
   c_feecode          CONSTANT CHAR(2) := '22';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_settletype       CONSTANT CHAR(2) := '23';
   c_refcasaacct      CONSTANT CHAR(2) := '05';
   c_spracno          CONSTANT CHAR(2) := '06';
   c_chargedate       CONSTANT CHAR(2) := '08';
   c_feeamt           CONSTANT CHAR(2) := '10';
   c_vatamt           CONSTANT CHAR(2) := '26';
   c_feeamtvat        CONSTANT CHAR(2) := '27';
   c_taxccy           CONSTANT CHAR(2) := '15';
   c_ismanual         CONSTANT CHAR(2) := '16';
   c_description      CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    L_COUNT NUMBER;
    L_AUTOID VARCHAR2(50);
    L_CUSTODYCD VARCHAR2(50);
    L_REFCASAACCT VARCHAR2(50);
    L_ISMANUAL VARCHAR2(50);
    L_VALDATE VARCHAR2(50);
    L_TXAMT NUMBER;
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
        L_AUTOID := P_TXMSG.TXFIELDS(C_AUTOID).VALUE;
        L_CUSTODYCD := P_TXMSG.TXFIELDS(C_CUSTODYCD).VALUE;
        L_REFCASAACCT := P_TXMSG.TXFIELDS(C_REFCASAACCT).VALUE;
        L_ISMANUAL := P_TXMSG.TXFIELDS(C_ISMANUAL).VALUE;
        L_VALDATE := P_TXMSG.TXFIELDS(C_CHARGEDATE).VALUE;
        L_TXAMT := TO_NUMBER(P_TXMSG.TXFIELDS(C_FEEAMTVAT).VALUE);
        SELECT COUNT(1) INTO L_COUNT
        FROM
        (
            SELECT * FROM FEE_BOOKING_RESULT WHERE STATUS = 'C' AND DELTD = 'N'
            UNION ALL
            SELECT * FROM FEE_BOOKING_RESULTHIST WHERE STATUS = 'C' AND DELTD = 'N'
        ) DT
        WHERE TO_CHAR(DT.AUTOID) = L_AUTOID;

        IF L_COUNT = 0 THEN
            p_err_code := '-660004';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

        SELECT COUNT(1) INTO L_COUNT
        FROM SETTLE_FEE_LOG
        WHERE TO_CHAR(FEEBOOKINGAUOID) = L_AUTOID
        AND STATUS IN ('P','C');

        IF L_COUNT > 0 THEN
            p_err_code := '-660004';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
        /*
        IF L_ISMANUAL = 'Y' THEN
            SELECT COUNT(1) INTO L_COUNT
            FROM DDMAST
            WHERE PAYMENTFEE = 'Y'
            AND REFCASAACCT = L_REFCASAACCT
            AND STATUS NOT IN ('C')
            AND BALANCE < L_TXAMT;

            IF L_COUNT > 0 THEN
                p_err_code := '-400039';
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        ELSE
            SELECT COUNT(1) INTO L_COUNT
            FROM
            (
                SELECT DD.REFCASAACCT
                FROM
                (
                    SELECT * FROM FEE_BOOKING_RESULT WHERE STATUS = 'C' AND DELTD = 'N'
                    UNION ALL
                    SELECT * FROM FEE_BOOKING_RESULTHIST WHERE STATUS = 'C' AND DELTD = 'N'
                ) DT,
                (
                    SELECT * FROM CFMAST WHERE NVL(SETTLETYPE, '60') = '60' AND CUSTODYCD = L_CUSTODYCD AND STATUS NOT IN ('C')
                ) CF,
                (
                    SELECT * FROM DDMAST WHERE PAYMENTFEE = 'Y' AND REFCASAACCT = L_REFCASAACCT AND STATUS NOT IN ('C')
                ) DD
                WHERE DT.BANKACCOUNT = DD.REFCASAACCT
                AND DD.CUSTID = CF.CUSTID
                AND TO_CHAR(DT.SETTLEDATE, 'MMRRRR') = L_VALDATE
                GROUP BY DD.REFCASAACCT
                HAVING SUM(NVL(DT.FEEAMOUNT,0) + NVL(DT.TAXAMOUNT,0)) > MAX(DD.BALANCE)
            );

            IF L_COUNT > 0 THEN
                p_err_code := '-400039';
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        END IF;
        */
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
    L_DDACCTNO VARCHAR2(50);
    L_REFCASAACCT VARCHAR2(50);
    L_CUSTODYCD VARCHAR2(50);
    L_TXAMT NUMBER;
    L_NOTE VARCHAR2(4000);
    L_AUTOID VARCHAR2(50);
    L_CURRENCY VARCHAR2(50);
    L_SPRACNO VARCHAR(50);
    L_SETTLETYPE VARCHAR2(50);
    L_REQID NUMBER;
    L_COUNT NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN
        L_REFCASAACCT := P_TXMSG.TXFIELDS(C_REFCASAACCT).VALUE;
        L_CUSTODYCD := P_TXMSG.TXFIELDS(C_CUSTODYCD).VALUE;
        L_TXAMT := P_TXMSG.TXFIELDS(C_FEEAMTVAT).VALUE;
        L_NOTE := P_TXMSG.TXFIELDS(C_DESCRIPTION).VALUE;
        L_AUTOID := P_TXMSG.TXFIELDS(C_AUTOID).VALUE;
        L_SPRACNO := P_TXMSG.TXFIELDS(C_SPRACNO).VALUE;
        L_SETTLETYPE := P_TXMSG.TXFIELDS(C_SETTLETYPE).VALUE;
        L_CURRENCY := P_TXMSG.TXFIELDS(C_TAXCCY).VALUE;
        L_REQID := SEQ_CRBTXREQ.NEXTVAL;

        BEGIN
            SELECT ACCTNO INTO L_DDACCTNO
            FROM DDMAST
            WHERE REFCASAACCT = L_REFCASAACCT
            AND CUSTODYCD = L_CUSTODYCD
            AND STATUS NOT IN ('C')
            AND ROWNUM <= '1';
        EXCEPTION WHEN OTHERS THEN
            L_DDACCTNO := '';
        END;

        INSERT INTO CRBTXREQ (REQID, OBJTYPE, OBJNAME, TRFCODE, REQCODE,
                              REQTXNUM, OBJKEY, TXDATE, AFFECTDATE, BANKCODE,
                              BANKACCT, AFACCTNO, TXAMT, STATUS, NOTES,
                              CURRENCY, TOCURRENCY, FEETYPE, EXCHANGERATE,
                              DORC, DESBANKACCOUNT)
        VALUES (L_REQID, 'T', '1207', 'SETTLEFEE', 'SETTLEFEE',
                    p_txmsg.txnum, p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.c_date_format), TO_DATE (p_txmsg.txdate, systemnums.c_date_format), 'SHV',
                    L_REFCASAACCT, L_DDACCTNO, L_TXAMT, 'P', L_NOTE,
                    L_CURRENCY, L_CURRENCY, 'TTM', '1',
                    L_SETTLETYPE, L_SPRACNO);

        INSERT INTO SETTLE_FEE_LOG(TXDATE, TXNUM, REQID, FEEBOOKINGAUOID, TXAMT, GLOBALID, TRN_DT, DESBANKACCOUNT, STATUS)
        VALUES (TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT), P_TXMSG.TXNUM, L_REQID, TO_NUMBER(L_AUTOID), TO_NUMBER(L_TXAMT), NULL, NULL, L_SPRACNO, 'P');

        SELECT COUNT(1) INTO L_COUNT FROM FEE_BOOKING_RESULTHIST WHERE TO_CHAR(AUTOID) = L_AUTOID;
        IF L_COUNT > 0 THEN
            UPDATE FEE_BOOKING_RESULTHIST SET BANKACCOUNT = L_REFCASAACCT, SETTLETYPE = L_SETTLETYPE WHERE TO_CHAR(AUTOID) = L_AUTOID;
        ELSE
            UPDATE FEE_BOOKING_RESULT SET BANKACCOUNT = L_REFCASAACCT, SETTLETYPE = L_SETTLETYPE WHERE TO_CHAR(AUTOID) = L_AUTOID;
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
         plog.init ('TXPKS_#1207EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1207EX;
/
