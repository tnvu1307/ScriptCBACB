SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1217ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1217EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      23/08/2022     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1217ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_valdate          CONSTANT CHAR(2) := '08';
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
    V_CVALDATE VARCHAR2(20);
    V_TLTX VARCHAR2(20);
    V_DESC VARCHAR2(500);
    L_TXMSG TX.MSG_RECTYPE;
    L_ERR_PARAM VARCHAR2(300);
    L_ERR_CODE VARCHAR2(300);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF P_TXMSG.DELTD <> 'Y' THEN
        V_CVALDATE := P_TXMSG.TXFIELDS(C_VALDATE).VALUE;
        V_TLTX := '1207';

        SELECT EN_TXDESC INTO V_DESC FROM TLTX WHERE TLTXCD = V_TLTX;

        L_TXMSG.TLTXCD      := V_TLTX;
        l_txmsg.msgtype     := 'T';
        l_txmsg.local       := 'N';
        l_txmsg.tlid        := p_txmsg.TLID;
        l_txmsg.wsname      := p_txmsg.wsname;
        l_txmsg.ipaddress   := p_txmsg.ipaddress;
        l_txmsg.offid       := p_txmsg.offid;
        l_txmsg.off_line    := 'N';
        l_txmsg.deltd       := txnums.c_deltd_txnormal;
        l_txmsg.txstatus    := txstatusnums.c_txcompleted;
        l_txmsg.msgsts      := '0';
        l_txmsg.ovrsts      := '0';
        l_txmsg.batchname   := 'DAY';
        l_txmsg.busdate     := p_txmsg.busdate;
        l_txmsg.txdate      := p_txmsg.txdate;
        l_txmsg.reftxnum    := p_txmsg.txnum;
        l_txmsg.brid        := p_txmsg.BRID;

        select to_char(sysdate,'hh24:mi:ss') into l_txmsg.txtime from dual;

        FOR REC IN (
            SELECT FEE.AUTOID, FEE.FEECODE, CF.CUSTODYCD, FEE.SPRACNO,
                FEE.FEEAMOUNT, NVL(FEE.TAXAMOUNT,0) TAXAMOUNT, ROUND((NVL(FEE.FEEAMOUNT,0) + NVL(FEE.TAXAMOUNT,0)),2) FEEAMTVAT,
                FEE.CURRENCY CCYCD, 'Settle ' || FEE.REMARK SETTREMARK,
                NVL(CF.SETTLETYPE, '60') SETTLETYPE,
                (CASE WHEN NVL(CF.SETTLETYPE, '60') = '60' THEN NOSTRO.BANKACCTNO ELSE DD.REFCASAACCT END) BANKACCTNO
            FROM
            (
                SELECT * FROM FEE_BOOKING_RESULT
                UNION ALL
                SELECT*FROM FEE_BOOKING_RESULTHIST
            ) FEE,
            (
                SELECT CF.* FROM CFMAST CF WHERE CF.SUPEBANK = 'N' AND CF.STATUS NOT IN ('C') AND NVL(CF.AUTOSETTLEFEE, 'Y') = 'Y'
            ) CF,
            (
                SELECT * FROM DDMAST WHERE PAYMENTFEE = 'Y' AND STATUS <> 'C'
            ) DD,
            (
                SELECT BANKACCTNO, 'VND' CCYCD FROM BANKNOSTRO WHERE BANKTRANS = 'OUTTRFMONFEESETTVND' AND ROWNUM = 1
                UNION ALL
                SELECT BANKACCTNO, 'USD' CCYCD FROM BANKNOSTRO WHERE BANKTRANS = 'OUTTRFMONFEESETTUSD' AND ROWNUM = 1
            ) NOSTRO,
            (SELECT * FROM ALLCODE WHERE CDTYPE = 'DD' AND CDNAME = 'FSTATUS') AL,
            (SELECT * FROM ALLCODE WHERE CDTYPE = 'DD' AND CDNAME = 'DELTDTEXT') A2,
            (SELECT * FROM FAMEMBERS WHERE ROLES = 'AMC') AMC,
            (SELECT * FROM FAMEMBERS WHERE ROLES = 'GCB') GCB
            WHERE FEE.CIFID = CF.CIFID
            AND FEE.STATUS = AL.CDVAL(+)
            AND FEE.DELTD = A2.CDVAL(+)
            AND CF.AMCID = AMC.AUTOID(+)
            AND CF.GCBID = GCB.AUTOID(+)
            AND NVL(FEE.DELTD,'N') NOT IN ('Y')
            AND FEE.STATUS = 'C'
            AND FEE.AUTOID NOT IN (SELECT FEEBOOKINGAUOID FROM SETTLE_FEE_LOG WHERE STATUS IN ('P','C'))
            AND CF.CUSTID = DD.CUSTID(+)
            AND FEE.CURRENCY = NOSTRO.CCYCD(+)
            AND TO_CHAR(FEE.TRANSDATE,'MMRRRR') = V_CVALDATE
            ORDER BY CF.CUSTODYCD
        ) LOOP
            SELECT systemnums.C_BATCH_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO l_txmsg.txnum
            FROM DUAL;

            --02    AUTOID   C
                 l_txmsg.txfields ('02').defname   := 'AUTOID';
                 l_txmsg.txfields ('02').TYPE      := 'C';
                 l_txmsg.txfields ('02').value      := rec.AUTOID;
            --08    Ngày tính phí   C
                 l_txmsg.txfields ('08').defname   := 'VALDATE';
                 l_txmsg.txfields ('08').TYPE      := 'C';
                 l_txmsg.txfields ('08').value      := V_CVALDATE;
            --22    Mã phí   C
                 l_txmsg.txfields ('22').defname   := 'FEECODE';
                 l_txmsg.txfields ('22').TYPE      := 'C';
                 l_txmsg.txfields ('22').value      := rec.FEECODE;
            --88    S? TK luu ký   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
            --23    Lo?i thanh toán   C
                 l_txmsg.txfields ('23').defname   := 'SETTLETYPE';
                 l_txmsg.txfields ('23').TYPE      := 'C';
                 l_txmsg.txfields ('23').value      := rec.SETTLETYPE;
            --05    S? tài kho?n ti?n   C
                 l_txmsg.txfields ('05').defname   := 'REFCASAACCT';
                 l_txmsg.txfields ('05').TYPE      := 'C';
                 l_txmsg.txfields ('05').value      := rec.BANKACCTNO;
            --06    S? TK suspense   C
                 l_txmsg.txfields ('06').defname   := 'SPRACNO';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.SPRACNO;
            --10    S? phí (tru?c thu?)   N
                 l_txmsg.txfields ('10').defname   := 'FEEAMT';
                 l_txmsg.txfields ('10').TYPE      := 'N';
                 l_txmsg.txfields ('10').value      := rec.FEEAMOUNT;
            --26    Thu?   N
                 l_txmsg.txfields ('26').defname   := 'VATAMT';
                 l_txmsg.txfields ('26').TYPE      := 'N';
                 l_txmsg.txfields ('26').value      := rec.TAXAMOUNT;
            --27    S? phí (sau thu?)   N
                 l_txmsg.txfields ('27').defname   := 'FEEAMTVAT';
                 l_txmsg.txfields ('27').TYPE      := 'N';
                 l_txmsg.txfields ('27').value      := rec.FEEAMTVAT;
            --15    Ðon v? ti?n t?   C
                 l_txmsg.txfields ('15').defname   := 'TAXCCY';
                 l_txmsg.txfields ('15').TYPE      := 'C';
                 l_txmsg.txfields ('15').value      := rec.CCYCD;
            --16    ISMANUAL   C
                 l_txmsg.txfields ('16').defname   := 'ISMANUAL';
                 l_txmsg.txfields ('16').TYPE      := 'C';
                 l_txmsg.txfields ('16').value      := 'N';
            --30    Di?n gi?i   C
                 l_txmsg.txfields ('30').defname   := 'DESCRIPTION';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := rec.SETTREMARK;

            IF TXPKS_#1207.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                CONTINUE;
            END IF;
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
         plog.init ('TXPKS_#1217EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1217EX;
/
