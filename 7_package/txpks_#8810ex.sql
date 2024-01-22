SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8810ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8810EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      28/09/2021     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#8810ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_txdate           CONSTANT CHAR(2) := '20';
   c_txtype           CONSTANT CHAR(2) := '01';
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
    L_TXMSG       TX.MSG_RECTYPE;
    L_ERR_PARAM   VARCHAR2(1000);
    L_ERR_CODE   NUMBER;
    L_STRDESC     VARCHAR2(400);
    L_CUSTYPE VARCHAR2(10);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    IF p_txmsg.deltd <> 'Y' THEN
        SELECT CASE WHEN P_TXMSG.TXFIELDS('01').VALUE = 'FA' THEN 'Y'
                    WHEN P_TXMSG.TXFIELDS('01').VALUE = 'CB' THEN 'N'
                    ELSE '%%'
               END
        INTO L_CUSTYPE
        FROM DUAL;

        SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = '2216';

        L_TXMSG.TLTXCD      := '2216';
        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := P_TXMSG.TLID;
        L_TXMSG.BRID        := P_TXMSG.BRID;
        L_TXMSG.WSNAME      := P_TXMSG.WSNAME;
        L_TXMSG.IPADDRESS   := P_TXMSG.IPADDRESS;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := P_TXMSG.BUSDATE;
        L_TXMSG.TXDATE      := P_TXMSG.TXDATE;
        L_TXMSG.REFTXNUM    := P_TXMSG.TXNUM;

        FOR rec IN
        (
            SELECT SE.CODEID, CF.CUSTODYCD, CF.FULLNAME, SE.ACCTNO, SB.SYMBOL, SE.HOLD QUANTITY
            FROM SEMAST SE, CFMAST CF, SBSECURITIES SB
            WHERE SE.HOLD > 0
            AND SE.CODEID = SB.CODEID
            AND SE.AFACCTNO = CF.CUSTID
            AND SUPEBANK LIKE L_CUSTYPE
        )
        LOOP
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            --03    Ti?u kho?n CK ghi có   C
                 l_txmsg.txfields ('03').defname   := 'ACCTNO';
                 l_txmsg.txfields ('03').TYPE      := 'C';
                 l_txmsg.txfields ('03').value      := rec.ACCTNO;
            --04    Mã ch?ng khoán   C
                 l_txmsg.txfields ('04').defname   := 'CODEID';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.CODEID;
            --05    Công ty ch?ng khoán   C
                 l_txmsg.txfields ('05').defname   := 'MEMBERID';
                 l_txmsg.txfields ('05').TYPE      := 'C';
                 l_txmsg.txfields ('05').value      := '';
            --06    Tên nhân viên   C
                 l_txmsg.txfields ('06').defname   := 'BRNAME';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := '';
            --07    S? di?n tho?i   C
                 l_txmsg.txfields ('07').defname   := 'BRPHONE';
                 l_txmsg.txfields ('07').TYPE      := 'C';
                 l_txmsg.txfields ('07').value      := '';
            --10    S? lu?ng   N
                 l_txmsg.txfields ('10').defname   := 'QUANTITY';
                 l_txmsg.txfields ('10').TYPE      := 'N';
                 l_txmsg.txfields ('10').value      := rec.QUANTITY;
            --14    Mã ch?ng khoán   C
                 l_txmsg.txfields ('14').defname   := 'SYMBOL';
                 l_txmsg.txfields ('14').TYPE      := 'C';
                 l_txmsg.txfields ('14').value      := rec.SYMBOL;
            --15    Mã giao d?ch   C
                 l_txmsg.txfields ('15').defname   := 'TXNUM';
                 l_txmsg.txfields ('15').TYPE      := 'C';
                 l_txmsg.txfields ('15').value      := '';
            --30    Di?n gi?i   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := L_STRDESC;
            --88    S? TK luu ký   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
            --90    H? tên   C
                 l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                 l_txmsg.txfields ('90').TYPE      := 'C';
                 l_txmsg.txfields ('90').value      := rec.FULLNAME;

            --L_ERR_CODE := TXPKS_#2216.FN_BATCHTXPROCESS(L_TXMSG, L_ERR_CODE, L_ERR_PARAM);
            BEGIN
                IF TXPKS_#2216.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
					plog.error (pkgctx, 'got error 2216: ' || p_err_code);
                    ROLLBACK;
                    RETURN ERRNUMS.C_BIZ_RULE_INVALID;
                END IF;
            END;
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
         plog.init ('TXPKS_#8810EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8810EX;
/
