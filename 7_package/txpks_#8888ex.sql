SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8888ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8888EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      27/11/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#8888ex
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
v_sysvar             varchar2(100);
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
    select varvalue into v_sysvar  from sysvar where varname = 'DEALINGCUSTODYCD';
    IF P_TXMSG.TXFIELDS('15').VALUE = 'TPRL' THEN
        SELECT COUNT(1) INTO V_COUNT
        FROM FAMEMBERS FA, CFMAST CF, SBSECURITIES SB,
        (SELECT * FROM VW_STSCHD_ALL WHERE DUETYPE IN ('SM','RM') AND DELTD = 'N' AND FVSTATUS = 'A') FE,
        (SELECT * FROM ODMAST WHERE ODTYPE IN ('ODT','ODG')) OD
        WHERE OD.ORDERID = FE.ORDERID
        AND OD.CODEID = SB.CODEID
        AND FE.CUSTODYCD = CF.CUSTODYCD
        AND OD.MEMBER = FA.AUTOID
        AND FA.SHORTNAME = P_TXMSG.TXFIELDS('02').VALUE
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
        FROM FAMEMBERS FA, CFMAST CF, SBSECURITIES SB,
        (SELECT * FROM VW_STSCHD_ALL WHERE DUETYPE IN ('SM','RM') AND DELTD = 'N' AND FVSTATUS = 'A') FE,
        (SELECT * FROM ODMAST WHERE ODTYPE IN ('ODT','ODG')) OD
        WHERE OD.ORDERID = FE.ORDERID
        AND OD.CODEID = SB.CODEID
        AND FE.CUSTODYCD = CF.CUSTODYCD
        AND OD.MEMBER = FA.AUTOID
        AND FA.SHORTNAME = P_TXMSG.TXFIELDS('02').VALUE
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
    v_feeamt number;
    v_feeamtorder number;
    v_feecalc varchar2(1);
    v_AUTOID number;
    v_ccycd varchar2(10);
    v_feecd varchar2(10);
    v_feerate number;
    v_getcurrent date;
    v_result number;
    v_deltd varchar2(1);
    br_bankcitad varchar2(100);
    v_feedaily varchar2(10);
    v_trfcode varchar2(100);

    count_is_shinhan number;
    v_banknostro varchar2(100);
    v_banknostro_trans varchar2(100);

    v_citad varchar2(100);
    l_amt number;
    l_fee number;
    l_vat number;
    reqestkey varchar2(250);
    l_bankcitadcode varchar2(250);
    l_bankfeeBRaccount  varchar2(250);
    memberid varchar2(100);
    l_currency varchar2(100);
    v_sysvar             varchar2(100);
    v_seq number;
    v_amount number;
    v_count number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        V_SEQ := SEQ_FEE_BROKER_RESULT.NEXTVAL;
        SELECT VARVALUE INTO V_SYSVAR FROM SYSVAR WHERE VARNAME = 'DEALINGCUSTODYCD';
        SELECT FN_GETGLOBALID(P_TXMSG.TXDATE, P_TXMSG.TXNUM) INTO REQESTKEY FROM DUAL;
        SELECT BANKCITADCODE INTO L_BANKCITADCODE FROM FAMEMBERS WHERE BANKACCTNO = P_TXMSG.TXFIELDS('05').VALUE;

        L_AMT := P_TXMSG.TXFIELDS('12').VALUE;
        IF P_TXMSG.TXFIELDS('15').VALUE = 'TPRL' THEN
            BEGIN
                SELECT BANKACCTNO INTO L_BANKFEEBRACCOUNT FROM BANKNOSTRO WHERE BANKTYPE = '002' AND BANKTRANS = 'OUTTRFFEETRERTPRL';
            EXCEPTION WHEN NO_DATA_FOUND THEN
                P_ERR_CODE := '-930017';
                PLOG.SETENDSECTION (PKGCTX, 'FN_TXAFTAPPUPDATE');
                RETURN ERRNUMS.C_BIZ_RULE_INVALID;
            END;

            FOR REC IN
            (
                SELECT FE.CLEARDATE, FE.ORDERID,NVL(FE.FEEAMT,0) FEEAMT,NVL(FE.VAT,0) VAT,NVL(FE.PAIDFEEAMT,0) PAIDFEEAMT,NVL(FE.PAIDVAT,0) PAIDVAT,FE.DUETYPE,FE.CUSTODYCD
                FROM FAMEMBERS FA, CFMAST CF, SBSECURITIES SB,
                (SELECT * FROM VW_STSCHD_ALL WHERE DUETYPE IN ('SM','RM') AND DELTD = 'N' AND FVSTATUS = 'A') FE,
                (SELECT * FROM ODMAST WHERE ODTYPE IN ('ODT','ODG')) OD
                WHERE OD.ORDERID = FE.ORDERID
                AND OD.CODEID = SB.CODEID
                AND FE.CUSTODYCD = CF.CUSTODYCD
                AND OD.MEMBER = FA.AUTOID
                AND FA.SHORTNAME = P_TXMSG.TXFIELDS('02').VALUE
                AND CF.FEEDAILY <> 'N'
                AND SB.TRADEPLACE IN ('099')
                AND SUBSTR(CF.CUSTODYCD,0,4) NOT LIKE V_SYSVAR
                AND GREATEST(NVL(FE.FEEAMT,0) - NVL(FE.PAIDFEEAMT,0),0) + GREATEST(NVL(FE.VAT,0) - NVL(FE.PAIDVAT,0),0) <> 0
                AND TO_CHAR(FE.CLEARDATE,'DD/MM/RRRR') = TO_CHAR(GETCURRDATE,'DD/MM/RRRR')
            )
            LOOP
                UPDATE STSCHD FE
                SET FVSTATUS = 'C', REF8888 = V_SEQ, LASTCHANGE = SYSTIMESTAMP
                WHERE FE.ORDERID = REC.ORDERID
                AND FE.DUETYPE = REC.DUETYPE
                AND FE.CUSTODYCD = REC.CUSTODYCD;

                IF L_AMT > (GREATEST(NVL(REC.FEEAMT,0)-NVL(REC.PAIDFEEAMT,0),0) + GREATEST(NVL(REC.VAT,0)-NVL(REC.PAIDVAT,0),0)) THEN
                    L_AMT := L_AMT - REC.FEEAMT - REC.VAT;

                    UPDATE STSCHD FE
                    SET FE.PAIDFEEAMT = FEEAMT, FE.PAIDVAT=VAT
                    WHERE FE.ORDERID =REC.ORDERID
                    AND FE.DUETYPE=REC.DUETYPE
                    AND FE.CUSTODYCD=REC.CUSTODYCD;

                ELSIF L_AMT > 0 THEN
                    L_FEE := GREATEST(LEAST(L_AMT,GREATEST(REC.FEEAMT-NVL(REC.PAIDFEEAMT,0),0)),0);
                    L_AMT:=L_AMT - L_FEE;
                    L_VAT := GREATEST(LEAST(L_AMT, GREATEST(REC.VAT-NVL(REC.PAIDVAT,0),0)),0);

                    UPDATE STSCHD FE
                    SET FE.PAIDFEEAMT = REC.PAIDFEEAMT + L_FEE, FE.PAIDVAT = REC.PAIDVAT + L_VAT
                    WHERE  FE.ORDERID =REC.ORDERID
                    AND FE.DUETYPE=REC.DUETYPE
                    AND FE.CUSTODYCD=REC.CUSTODYCD
                    AND SUBSTR(FE.CUSTODYCD,0,4) NOT LIKE V_SYSVAR;
                END IF;
            END LOOP;
        ELSE
            BEGIN
                SELECT BANKACCTNO INTO L_BANKFEEBRACCOUNT FROM BANKNOSTRO WHERE BANKTYPE = '002' AND BANKTRANS = 'OUTTRFFEETRER';
            EXCEPTION WHEN NO_DATA_FOUND THEN
                P_ERR_CODE := '-930017';
                PLOG.SETENDSECTION (PKGCTX, 'FN_TXAFTAPPUPDATE');
                RETURN ERRNUMS.C_BIZ_RULE_INVALID;
            END;

            FOR REC IN
            (
                SELECT FE.CLEARDATE, FE.ORDERID,NVL(FE.FEEAMT,0) FEEAMT,NVL(FE.VAT,0) VAT,NVL(FE.PAIDFEEAMT,0) PAIDFEEAMT,NVL(FE.PAIDVAT,0) PAIDVAT,FE.DUETYPE,FE.CUSTODYCD
                FROM FAMEMBERS FA, CFMAST CF, SBSECURITIES SB,
                (SELECT * FROM VW_STSCHD_ALL WHERE DUETYPE IN ('SM','RM') AND DELTD = 'N' AND FVSTATUS = 'A') FE,
                (SELECT * FROM ODMAST WHERE ODTYPE IN ('ODT','ODG')) OD
                WHERE OD.ORDERID = FE.ORDERID
                AND OD.CODEID = SB.CODEID
                AND FE.CUSTODYCD = CF.CUSTODYCD
                AND OD.MEMBER = FA.AUTOID
                AND FA.SHORTNAME = P_TXMSG.TXFIELDS('02').VALUE
                AND CF.FEEDAILY <> 'N'
                AND SB.TRADEPLACE NOT IN ('099')
                AND SUBSTR(CF.CUSTODYCD,0,4) NOT LIKE V_SYSVAR
                AND GREATEST(NVL(FE.FEEAMT,0) - NVL(FE.PAIDFEEAMT,0),0) + GREATEST(NVL(FE.VAT,0) - NVL(FE.PAIDVAT,0),0) <> 0
                AND TO_CHAR(FE.CLEARDATE,'DD/MM/RRRR') = TO_CHAR(GETCURRDATE,'DD/MM/RRRR')
            )
            LOOP
                UPDATE STSCHD FE
                SET FVSTATUS = 'C', REF8888 = V_SEQ, LASTCHANGE = SYSTIMESTAMP
                WHERE FE.ORDERID = REC.ORDERID
                AND FE.DUETYPE = REC.DUETYPE
                AND FE.CUSTODYCD = REC.CUSTODYCD;

                IF L_AMT > (GREATEST(NVL(REC.FEEAMT,0)-NVL(REC.PAIDFEEAMT,0),0) + GREATEST(NVL(REC.VAT,0)-NVL(REC.PAIDVAT,0),0)) THEN
                    L_AMT := L_AMT - REC.FEEAMT - REC.VAT;

                    UPDATE STSCHD FE
                    SET FE.PAIDFEEAMT = FEEAMT, FE.PAIDVAT=VAT
                    WHERE FE.ORDERID =REC.ORDERID
                    AND FE.DUETYPE=REC.DUETYPE
                    AND FE.CUSTODYCD=REC.CUSTODYCD;

                ELSIF L_AMT > 0 THEN
                    L_FEE := GREATEST(LEAST(L_AMT,GREATEST(REC.FEEAMT-NVL(REC.PAIDFEEAMT,0),0)),0);
                    L_AMT:=L_AMT - L_FEE;
                    L_VAT := GREATEST(LEAST(L_AMT, GREATEST(REC.VAT-NVL(REC.PAIDVAT,0),0)),0);

                    UPDATE STSCHD FE
                    SET FE.PAIDFEEAMT = REC.PAIDFEEAMT + L_FEE, FE.PAIDVAT = REC.PAIDVAT + L_VAT
                    WHERE  FE.ORDERID =REC.ORDERID
                    AND FE.DUETYPE=REC.DUETYPE
                    AND FE.CUSTODYCD=REC.CUSTODYCD
                    AND SUBSTR(FE.CUSTODYCD,0,4) NOT LIKE V_SYSVAR;
                END IF;
            END LOOP;
        END IF;


        SELECT COUNT(*)INTO V_COUNT FROM CRBBANKLIST WHERE CITAD = L_BANKCITADCODE AND BANKNAME LIKE '%SHINHANBANK%';
        --SINH REQUEST QUA BANK
        IF V_COUNT >0  THEN
            SELECT FA.AUTOID,TAXCCY INTO MEMBERID,L_CURRENCY FROM FAMEMBERS FA WHERE FA.SHORTNAME LIKE P_TXMSG.TXFIELDS('02').VALUE AND ROLES = 'BRK';

            INSERT INTO FEE_BROKER_RESULT(AUTOID, BANKACCOUNT, REMARK, FEEAMOUNT, NOSTROACCOUNT,
                STATUS, BANKGLOBALID, TRANSDATE, SETTLEDATE, MEMBERID,
                CURRENCY, REFCODE, CITAD)
            VALUES(V_SEQ, P_TXMSG.TXFIELDS('05').VALUE, P_TXMSG.TXFIELDS('30').VALUE, P_TXMSG.TXFIELDS('12').VALUE, L_BANKFEEBRACCOUNT,
                'N', NULL, TO_CHAR(TO_DATE(P_TXMSG.TXDATE,'DD/MM/RRRR'),'RRRRMMDD'), TO_CHAR(GETCURRDATE,'RRRRMMDD'), MEMBERID,
                'VND', 'FEEBROKERIP', NULL)
            ;
            PCK_BANKFLMS.SP_AUTO_GEN_FEE_BROKER_IP();
        ELSE
            SELECT FA.AUTOID,FA.TAXCCY,FA.BANKCITADCODE INTO MEMBERID,L_CURRENCY,V_CITAD FROM FAMEMBERS FA WHERE FA.BANKACCTNO = P_TXMSG.TXFIELDS('05').VALUE;

            INSERT INTO FEE_BROKER_RESULT(AUTOID, BANKACCOUNT, REMARK, FEEAMOUNT, NOSTROACCOUNT,
                STATUS, BANKGLOBALID, TRANSDATE, SETTLEDATE, MEMBERID,
                CURRENCY, REFCODE, CITAD)
            VALUES(V_SEQ, P_TXMSG.TXFIELDS('05').VALUE, P_TXMSG.TXFIELDS('30').VALUE, P_TXMSG.TXFIELDS('12').VALUE, L_BANKFEEBRACCOUNT,
                'N', NULL, TO_CHAR(TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT),'RRRRMMDD'), TO_CHAR(TO_DATE(GETCURRDATE, SYSTEMNUMS.C_DATE_FORMAT),'RRRRMMDD'), MEMBERID,
                    'VND', 'FEEBROKEROP',L_BANKCITADCODE)
            ;
            PCK_BANKFLMS.SP_AUTO_GEN_FEE_BROKER_OP();
        end if;
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
         plog.init ('TXPKS_#8888EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8888EX;
/
