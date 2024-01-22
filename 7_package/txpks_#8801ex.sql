SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8801ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8801EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      16/02/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#8801ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_orderid          CONSTANT CHAR(2) := '99';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_feenum           CONSTANT CHAR(2) := '04';
   c_broker           CONSTANT CHAR(2) := '02';
   c_brokername       CONSTANT CHAR(2) := '03';
   c_bankaccbroker    CONSTANT CHAR(2) := '05';
   c_banknamebroker   CONSTANT CHAR(2) := '06';
   c_brankbank        CONSTANT CHAR(2) := '07';
   c_amt              CONSTANT CHAR(2) := '10';
   c_amt_1            CONSTANT CHAR(2) := '11';
   c_amt_2            CONSTANT CHAR(2) := '12';
   c_desc             CONSTANT CHAR(2) := '30';

FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    v_count number;
    v_sysvar varchar2(100);
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
    SELECT VARVALUE INTO V_SYSVAR  FROM SYSVAR WHERE VARNAME = 'DEALINGCUSTODYCD';
    IF P_TXMSG.TXFIELDS('15').VALUE = 'TPRL' THEN
        SELECT COUNT(1) INTO V_COUNT
        FROM CFMAST CF, SBSECURITIES SB,
        (SELECT * FROM VW_STSCHD_ALL WHERE DUETYPE IN ('SM','RM') AND DELTD = 'N' AND FVSTATUS = 'P') FE,
        (SELECT * FROM ODMAST WHERE ODTYPE IN ('ODT','ODG')) OD
        WHERE OD.ORDERID = FE.ORDERID
        AND OD.CODEID = SB.CODEID
        AND FE.CUSTODYCD = CF.CUSTODYCD
        AND CF.FEEDAILY <> 'N'
        AND SB.TRADEPLACE IN ('099')
        AND SUBSTR(CF.CUSTODYCD,0,4) NOT LIKE V_SYSVAR
        AND GREATEST(NVL(FE.FEEAMT,0) - NVL(FE.PAIDFEEAMT,0),0) + GREATEST(NVL(FE.VAT,0) - NVL(FE.PAIDVAT,0),0) <> 0
        AND TO_CHAR(FE.CLEARDATE,'DD/MM/RRRR') = TO_CHAR(GETCURRDATE,'DD/MM/RRRR');

        IF V_COUNT = 0 THEN
            P_ERR_CODE := '-660004';
            PLOG.SETENDSECTION (PKGCTX, 'FN_TXPREAPPCHECK');
            RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        END IF;
    ELSE
        SELECT COUNT(1) INTO V_COUNT
        FROM CFMAST CF, SBSECURITIES SB,
        (SELECT * FROM VW_STSCHD_ALL WHERE DUETYPE IN ('SM','RM') AND DELTD = 'N' AND FVSTATUS = 'P') FE,
        (SELECT * FROM ODMAST WHERE ODTYPE IN ('ODT','ODG')) OD
        WHERE OD.ORDERID = FE.ORDERID
        AND OD.CODEID = SB.CODEID
        AND FE.CUSTODYCD = CF.CUSTODYCD
        AND CF.FEEDAILY <> 'N'
        AND SB.TRADEPLACE NOT IN ('099')
        AND SUBSTR(CF.CUSTODYCD,0,4) NOT LIKE V_SYSVAR
        AND GREATEST(NVL(FE.FEEAMT,0) - NVL(FE.PAIDFEEAMT,0),0) + GREATEST(NVL(FE.VAT,0) - NVL(FE.PAIDVAT,0),0) <> 0
        AND TO_CHAR(FE.CLEARDATE,'DD/MM/RRRR') = TO_CHAR(GETCURRDATE,'DD/MM/RRRR');

        IF V_COUNT = 0 THEN
            P_ERR_CODE := '-660004';
            PLOG.SETENDSECTION (PKGCTX, 'FN_TXPREAPPCHECK');
            RETURN ERRNUMS.C_BIZ_RULE_INVALID;
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
    l_bankaccount varchar2(100);
    l_bankaccount_vn varchar2(100);
    l_bankfeeBRaccount varchar2(100);
    memberid varchar2(100);
    l_currency varchar2(100);
    v_sysvar varchar2(100);
    v_seq number;
    v_amount number;
    v_amount_VN number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        V_SEQ := SEQ_FEE_BROKER_RESULT.NEXTVAL;
        SELECT VARVALUE INTO V_SYSVAR FROM SYSVAR WHERE VARNAME = 'DEALINGCUSTODYCD';
        SELECT FA.AUTOID INTO MEMBERID FROM FAMEMBERS FA WHERE FA.SHORTNAME LIKE P_TXMSG.TXFIELDS('02').VALUE AND ROLES = 'BRK';

        v_amount:= 0;
        v_amount_VN := 0;

        IF P_TXMSG.TXFIELDS('15').VALUE = 'TPRL' THEN
            BEGIN
                SELECT BANKACCTNO, CCYCD INTO L_BANKACCOUNT, L_CURRENCY FROM BANKNOSTRO WHERE BANKTYPE = '001' AND BANKTRANS = 'INTRFRESELLTPRL';
                SELECT BANKACCTNO, CCYCD INTO L_BANKACCOUNT_VN, L_CURRENCY FROM BANKNOSTRO WHERE BANKTYPE = '001' AND BANKTRANS = 'INTRFRESELLVNTPRL';
                SELECT BANKACCTNO INTO L_BANKFEEBRACCOUNT FROM BANKNOSTRO WHERE BANKTYPE='002' AND BANKTRANS = 'OUTTRFFEETRERTPRL';
            EXCEPTION WHEN NO_DATA_FOUND THEN
                P_ERR_CODE := '-930017';
                PLOG.SETENDSECTION (PKGCTX, 'FN_TXAFTAPPUPDATE');
                RETURN ERRNUMS.C_BIZ_RULE_INVALID;
            END;

            --update fvstatus = A -> da qua tai khoan trung gian
            FOR REC IN
            (
                SELECT FE.CLEARDATE, FE.ORDERID, NVL(FE.FEEAMT,0) FEEAMT, NVL(FE.VAT,0) VAT, NVL(FE.PAIDFEEAMT,0) PAIDFEEAMT, NVL(FE.PAIDVAT,0) PAIDVAT, FE.DUETYPE, FE.CUSTODYCD, CF.COUNTRY, OD.ODTYPE
                FROM CFMAST CF, SBSECURITIES SB,
                (SELECT * FROM VW_STSCHD_ALL WHERE DUETYPE IN ('SM','RM') AND DELTD = 'N' AND FVSTATUS = 'P') FE,
                (SELECT * FROM ODMAST WHERE ODTYPE IN ('ODT','ODG')) OD
                WHERE OD.ORDERID = FE.ORDERID
                AND OD.CODEID = SB.CODEID
                AND FE.CUSTODYCD = CF.CUSTODYCD
                AND CF.FEEDAILY <> 'N'
                AND SB.TRADEPLACE IN ('099')
                AND SUBSTR(CF.CUSTODYCD,0,4) NOT LIKE V_SYSVAR
                AND GREATEST(NVL(FE.FEEAMT,0) - NVL(FE.PAIDFEEAMT,0),0) + GREATEST(NVL(FE.VAT,0) - NVL(FE.PAIDVAT,0),0) <> 0
                AND TO_CHAR(FE.CLEARDATE,'DD/MM/RRRR') = TO_CHAR(GETCURRDATE,'DD/MM/RRRR')
            )
            LOOP
                IF REC.ODTYPE <> 'ODG' THEN
                     IF REC.COUNTRY <> '234' THEN
                        V_AMOUNT:= V_AMOUNT + REC.FEEAMT +REC.VAT;
                     ELSE
                        V_AMOUNT_VN:= V_AMOUNT_VN + REC.FEEAMT +REC.VAT;
                     END IF;
                ELSE
                    V_AMOUNT:= V_AMOUNT + REC.FEEAMT +REC.VAT;
                END IF;

                UPDATE STSCHD
                SET FVSTATUS = 'A', REF8801 = V_SEQ, LASTCHANGE = SYSTIMESTAMP
                WHERE ORDERID = REC.ORDERID
                AND ORDERID =REC.ORDERID
                AND DUETYPE = REC.DUETYPE
                AND CUSTODYCD = REC.CUSTODYCD;
            END LOOP;
        ELSE
            BEGIN
                SELECT BANKACCTNO, CCYCD INTO L_BANKACCOUNT, L_CURRENCY FROM BANKNOSTRO WHERE BANKTYPE = '001' AND BANKTRANS = 'INTRFRESELL';
                SELECT BANKACCTNO, CCYCD INTO L_BANKACCOUNT_VN, L_CURRENCY FROM BANKNOSTRO WHERE BANKTYPE = '001' AND BANKTRANS = 'INTRFRESELLVN';
                SELECT BANKACCTNO INTO L_BANKFEEBRACCOUNT FROM BANKNOSTRO WHERE BANKTYPE='002' AND BANKTRANS = 'OUTTRFFEETRER';
            EXCEPTION WHEN NO_DATA_FOUND THEN
                P_ERR_CODE := '-930017';
                PLOG.SETENDSECTION (PKGCTX, 'FN_TXAFTAPPUPDATE');
                RETURN ERRNUMS.C_BIZ_RULE_INVALID;
            END;

            --update fvstatus = A -> da qua tai khoan trung gian
            FOR REC IN
            (
                SELECT FE.CLEARDATE, FE.ORDERID, NVL(FE.FEEAMT,0) FEEAMT, NVL(FE.VAT,0) VAT, NVL(FE.PAIDFEEAMT,0) PAIDFEEAMT, NVL(FE.PAIDVAT,0) PAIDVAT, FE.DUETYPE, FE.CUSTODYCD, CF.COUNTRY, OD.ODTYPE
                FROM CFMAST CF, SBSECURITIES SB,
                (SELECT * FROM VW_STSCHD_ALL WHERE DUETYPE IN ('SM','RM') AND DELTD = 'N' AND FVSTATUS = 'P') FE,
                (SELECT * FROM ODMAST WHERE ODTYPE IN ('ODT','ODG')) OD
                WHERE OD.ORDERID = FE.ORDERID
                AND OD.CODEID = SB.CODEID
                AND FE.CUSTODYCD = CF.CUSTODYCD
                AND CF.FEEDAILY <> 'N'
                AND SB.TRADEPLACE NOT IN ('099')
                AND SUBSTR(CF.CUSTODYCD,0,4) NOT LIKE V_SYSVAR
                AND GREATEST(NVL(FE.FEEAMT,0) - NVL(FE.PAIDFEEAMT,0),0) + GREATEST(NVL(FE.VAT,0) - NVL(FE.PAIDVAT,0),0) <> 0
                AND TO_CHAR(FE.CLEARDATE,'DD/MM/RRRR') = TO_CHAR(GETCURRDATE,'DD/MM/RRRR')
            )
            LOOP
                IF REC.ODTYPE <> 'ODG' THEN
                     IF REC.COUNTRY <> '234' THEN
                        V_AMOUNT:= V_AMOUNT + REC.FEEAMT +REC.VAT;
                     ELSE
                        V_AMOUNT_VN:= V_AMOUNT_VN + REC.FEEAMT +REC.VAT;
                     END IF;
                ELSE
                    V_AMOUNT:= V_AMOUNT + REC.FEEAMT +REC.VAT;
                END IF;

                UPDATE STSCHD
                SET FVSTATUS = 'A', REF8801 = V_SEQ, LASTCHANGE = SYSTIMESTAMP
                WHERE ORDERID = REC.ORDERID
                AND ORDERID =REC.ORDERID
                AND DUETYPE = REC.DUETYPE
                AND CUSTODYCD = REC.CUSTODYCD;
            END LOOP;
        END IF;

        --sinh request qua bank
        IF V_AMOUNT <> 0 THEN
            INSERT INTO FEE_BROKER_RESULT(AUTOID, BANKACCOUNT, REMARK, FEEAMOUNT, NOSTROACCOUNT, STATUS,
                BANKGLOBALID, TRANSDATE, SETTLEDATE, MEMBERID, CURRENCY,
                REFCODE)
            VALUES(V_SEQ, L_BANKFEEBRACCOUNT, P_TXMSG.TXFIELDS('30').VALUE, V_AMOUNT, L_BANKACCOUNT, 'N',
                NULL, TO_CHAR(TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),'RRRRMMDD'), TO_CHAR(TO_DATE(GETCURRDATE, SYSTEMNUMS.C_DATE_FORMAT),'RRRRMMDD'), MEMBERID, L_CURRENCY,
                'FEEBROKER')
            ;
        END IF;

        --SINH REQUEST QUA BANK
        IF V_AMOUNT_VN <> 0 THEN
            INSERT INTO FEE_BROKER_RESULT(AUTOID, BANKACCOUNT, REMARK, FEEAMOUNT, NOSTROACCOUNT, STATUS,
                BANKGLOBALID, TRANSDATE, SETTLEDATE, MEMBERID, CURRENCY,
                REFCODE)
            VALUES(V_SEQ, L_BANKFEEBRACCOUNT, P_TXMSG.TXFIELDS('30').VALUE, V_AMOUNT_VN, L_BANKACCOUNT_VN,
                'N', NULL, TO_CHAR(TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),'RRRRMMDD'), TO_CHAR(TO_DATE(GETCURRDATE, SYSTEMNUMS.C_DATE_FORMAT),'RRRRMMDD'), MEMBERID, L_CURRENCY,
                'FEEBROKER')
            ;
        END IF;
        PCK_BANKFLMS.SP_AUTO_GEN_FEE_BROKER();

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
         plog.init ('TXPKS_#8801EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8801EX;
/
