SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8825ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8825EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      07/11/2023     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#8825ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '01';
   c_orgorderid       CONSTANT CHAR(2) := '06';
   c_afacctno         CONSTANT CHAR(2) := '03';
   c_ddacctno         CONSTANT CHAR(2) := '04';
   c_codeid           CONSTANT CHAR(2) := '02';
   c_seacctno         CONSTANT CHAR(2) := '05';
   c_postdate         CONSTANT CHAR(2) := '23';
   c_broker           CONSTANT CHAR(2) := '24';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_fullname         CONSTANT CHAR(2) := '90';
   c_cifid            CONSTANT CHAR(2) := '91';
   c_refacctno        CONSTANT CHAR(2) := '25';
   c_typeorder        CONSTANT CHAR(2) := '26';
   c_typeorder        CONSTANT CHAR(2) := '28';
   c_isunhold         CONSTANT CHAR(2) := '33';
   c_symbol           CONSTANT CHAR(2) := '07';
   c_qtty             CONSTANT CHAR(2) := '09';
   c_amt              CONSTANT CHAR(2) := '10';
   c_fee              CONSTANT CHAR(2) := '11';
   c_tax              CONSTANT CHAR(2) := '27';
   c_des              CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    L_COUNT NUMBER;
    L_HOLDBALACE NUMBER;
    L_NETTING NUMBER;
    L_FEEDAILY VARCHAR2(10);
    L_CUSTODYCD VARCHAR2(20);
    L_DDACCTNO VARCHAR2(50);
    L_MEMBERID VARCHAR2(20);
    L_REFCASAACCT VARCHAR2(50);
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
    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        L_MEMBERID := P_TXMSG.TXFIELDS('24').VALUE;
        L_CUSTODYCD := P_TXMSG.TXFIELDS('88').VALUE;
        L_DDACCTNO := P_TXMSG.TXFIELDS('04').VALUE;

        SELECT TRIM(CF.FEEDAILY) INTO L_FEEDAILY
        FROM CFMAST CF
        WHERE CF.CUSTODYCD = P_TXMSG.TXFIELDS('88').VALUE
        AND STATUS NOT IN ('C');

        SELECT REFCASAACCT INTO L_REFCASAACCT FROM DDMAST WHERE ACCTNO = L_DDACCTNO;

        SELECT SUM(R.TXAMT) INTO L_HOLDBALACE
        FROM
        (SELECT * FROM CRBTXREQ WHERE TRFCODE = 'HOLD' AND REQCODE = 'BANKHOLDEDBYBROKERTPRL' AND STATUS = 'C' AND UNHOLD = 'N') R,
        (SELECT * FROM TLLOG WHERE TLTXCD = '6690') L,
        (
            SELECT TXNUM, TXDATE,
            MAX (CASE WHEN F.FLDCD = '05' THEN F.CVALUE ELSE '' END) MEMBERID,
            MAX (CASE WHEN F.FLDCD = '88' THEN F.CVALUE ELSE '' END) CUSTODYCD,
            MAX (CASE WHEN F.FLDCD = '93' THEN F.CVALUE ELSE '' END) BANKACCTNO,
            MAX (CASE WHEN F.FLDCD = '30' THEN F.CVALUE ELSE '' END) NOTE
            FROM TLLOGFLD F
            WHERE FLDCD IN ('05', '88', '93', '30')
            GROUP BY TXNUM, TXDATE
        ) F
        WHERE L.TXNUM = F.TXNUM AND L.TXDATE = F.TXDATE
        AND R.OBJNAME = L.TLTXCD
        AND R.OBJKEY = L.TXNUM
        AND R.TXDATE = L.TXDATE
        AND F.MEMBERID = L_MEMBERID
        AND F.CUSTODYCD = L_CUSTODYCD
        AND F.BANKACCTNO = L_REFCASAACCT;

        IF L_FEEDAILY = 'Y' THEN
            L_NETTING := NVL(p_txmsg.txfields('10').value + p_txmsg.txfields('11').value + p_txmsg.txfields('27').value, 0);
        ELSE
            L_NETTING := NVL(p_txmsg.txfields('10').value, 0);
        END IF;

        IF NVL(L_HOLDBALACE, 0) < L_NETTING THEN
            p_err_code := '-400504';
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
    L_HOLDBALACE NUMBER;
    L_NETTING NUMBER;
    L_FEEDAILY VARCHAR2(10);
    L_VERSION VARCHAR2(30);
    L_ATUOID NUMBER;
    L_ORDERID VARCHAR2(20);
    L_CUSTODYCD VARCHAR2(20);
    L_DDACCTNO VARCHAR2(50);
    L_MEMBERID VARCHAR2(20);
    L_ORDERAMT NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        L_MEMBERID := P_TXMSG.TXFIELDS('24').VALUE;
        L_CUSTODYCD := P_TXMSG.TXFIELDS('88').VALUE;
        L_DDACCTNO := P_TXMSG.TXFIELDS('04').VALUE;
        L_ORDERID := P_TXMSG.TXFIELDS('06').VALUE;
        L_ORDERAMT := P_TXMSG.TXFIELDS('10').VALUE;
        L_ATUOID := SEQ_VSTP_SETTLE_LOG.NEXTVAL;
        L_VERSION := TO_CHAR(p_txmsg.txdate, 'RRMMDD') || P_TXMSG.TXNUM || '.' || TO_CHAR(L_ATUOID);

        SELECT TRIM(CF.FEEDAILY) INTO L_FEEDAILY
        FROM CFMAST CF
        WHERE CF.CUSTODYCD = L_CUSTODYCD
        AND STATUS NOT IN ('C');

        IF L_FEEDAILY = 'Y' THEN
            L_NETTING := NVL(P_TXMSG.TXFIELDS('10').VALUE + P_TXMSG.TXFIELDS('11').VALUE + P_TXMSG.TXFIELDS('27').VALUE, 0);
        ELSE
            L_NETTING := NVL(P_TXMSG.TXFIELDS('10').VALUE, 0);
        END IF;

        INSERT INTO VSTP_SETTLE_LOG(AUTOID, TXNUM, TXDATE, CUSTODYCD, DDACCTNO, ORDERID, MEMBERID, AMT, ODAMT, VERSION, STATUS, DESCRIPTION)
        VALUES (L_ATUOID, P_TXMSG.TXNUM, P_TXMSG.TXDATE, L_CUSTODYCD, L_DDACCTNO, L_ORDERID, L_MEMBERID, L_NETTING, L_ORDERAMT, L_VERSION, '0', P_TXMSG.TXFIELDS('30').VALUE);

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
         plog.init ('TXPKS_#8825EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8825EX;
/
