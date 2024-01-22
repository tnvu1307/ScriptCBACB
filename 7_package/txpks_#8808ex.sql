SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8808ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8808EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      28/07/2021     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#8808ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_txdate           CONSTANT CHAR(2) := '20';
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
    l_count number;

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
    IF p_txmsg.deltd <> 'Y' THEN
        V_SEQ := SEQ_FEE_BROKER_RESULT.NEXTVAL;
        SELECT VARVALUE INTO V_SYSVAR  FROM SYSVAR WHERE VARNAME = 'DEALINGCUSTODYCD';

        BEGIN

            SELECT BANKACCTNO, CCYCD INTO L_BANKACCOUNT, L_CURRENCY FROM BANKNOSTRO WHERE BANKTYPE='001' AND BANKTRANS='INTRFRESELL';

            -- TK DUNG CHO KHACH VIET NAM
            SELECT BANKACCTNO, CCYCD INTO L_BANKACCOUNT_VN, L_CURRENCY FROM BANKNOSTRO WHERE BANKTYPE = '001' AND BANKTRANS = 'INTRFRESELLVN';
            --
            SELECT BANKACCTNO INTO L_BANKFEEBRACCOUNT FROM BANKNOSTRO WHERE BANKTYPE = '002' AND BANKTRANS = 'OUTTRFFEETRER';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            P_ERR_CODE := '-930017';
            PLOG.SETENDSECTION (PKGCTX, 'FN_TXAFTAPPUPDATE');
            RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        END;

        FOR V_REC1 IN
        (
            SELECT FA.AUTOID, FE.CLEARDATE
            FROM STSCHD FE, ODMAST OD, CFMAST CF, FAMEMBERS FA
            WHERE FA.AUTOID = OD.MEMBER
            AND OD.ORDERID = FE.ORDERID
            AND FE.CUSTODYCD = CF.CUSTODYCD
            AND FE.DUETYPE IN ('SM','RM')
            AND FE.DELTD = 'N'
            AND CF.FEEDAILY <> 'N'
            AND FE.FVSTATUS = 'P'
            AND SUBSTR(CF.CUSTODYCD,0,4) NOT LIKE V_SYSVAR
            AND GREATEST(NVL(FE.FEEAMT,0)-NVL(FE.PAIDFEEAMT,0),0) + GREATEST(NVL(FE.VAT,0)-NVL(FE.PAIDVAT,0),0) <> 0
            AND FE.VAT IS NULL
            GROUP BY FA.AUTOID, FE.CLEARDATE
        )
        LOOP
            V_AMOUNT := 0;
            V_AMOUNT_VN := 0;
            FOR V_REC2 IN
            (
                SELECT FE.CLEARDATE, FE.ORDERID, NVL(FE.FEEAMT,0) FEEAMT, NVL(FE.VAT,0) VAT, NVL(FE.PAIDFEEAMT,0) PAIDFEEAMT, NVL(FE.PAIDVAT,0) PAIDVAT, FE.DUETYPE, FE.CUSTODYCD, CF.COUNTRY, OD.ODTYPE
                FROM STSCHD FE, ODMAST OD, CFMAST CF
                WHERE OD.ORDERID = FE.ORDERID
                AND FE.CUSTODYCD = CF.CUSTODYCD
                AND FE.DUETYPE IN ('SM','RM')
                AND FE.DELTD = 'N'
                AND CF.FEEDAILY <> 'N'
                AND FE.FVSTATUS = 'P'
                AND SUBSTR(CF.CUSTODYCD,0,4) NOT LIKE V_SYSVAR
                AND GREATEST(NVL(FE.FEEAMT,0)-NVL(FE.PAIDFEEAMT,0),0) + GREATEST(NVL(FE.VAT,0)-NVL(FE.PAIDVAT,0),0) <> 0
                AND FE.VAT IS NULL
                AND OD.MEMBER = V_REC1.AUTOID
                AND FE.CLEARDATE = V_REC1.CLEARDATE
                ORDER BY FE.CLEARDATE
            )
            LOOP
                IF V_REC2.ODTYPE <> 'ODG' THEN
                    IF V_REC2.COUNTRY <> '234' THEN
                        V_AMOUNT:= V_AMOUNT + V_REC2.FEEAMT + V_REC2.VAT;
                    ELSE
                        V_AMOUNT_VN:= V_AMOUNT_VN + V_REC2.FEEAMT + V_REC2.VAT;
                    END IF;
                ELSE
                    V_AMOUNT:= V_AMOUNT + V_REC2.FEEAMT + V_REC2.VAT;
                END IF;

                UPDATE STSCHD SET FVSTATUS = 'A', REF8801 = V_SEQ, LASTCHANGE = SYSTIMESTAMP
                WHERE ORDERID = V_REC2.ORDERID
                AND ORDERID =V_REC2.ORDERID
                AND DUETYPE = V_REC2.DUETYPE
                AND CUSTODYCD = V_REC2.CUSTODYCD
                AND SUBSTR(CUSTODYCD,0,4) NOT LIKE V_SYSVAR;
            END LOOP;
            IF V_AMOUNT <> 0 THEN
                INSERT INTO FEE_BROKER_RESULT(AUTOID,BANKACCOUNT,REMARK,FEEAMOUNT,NOSTROACCOUNT,STATUS,BANKGLOBALID,TRANSDATE,SETTLEDATE,MEMBERID,CURRENCY,REFCODE)
                VALUES(V_SEQ,L_BANKFEEBRACCOUNT,UTF8NUMS.C_CONST_TLTX_TXDESC_8801,V_AMOUNT,L_BANKACCOUNT,'N',NULL,TO_CHAR(TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),'RRRRMMDD'),
                       TO_CHAR(TO_DATE(V_REC1.CLEARDATE, systemnums.C_DATE_FORMAT),'RRRRMMDD'),V_REC1.AUTOID,L_CURRENCY,'FEEBROKER');
            END IF;
            IF V_AMOUNT_VN <> 0 THEN
                INSERT INTO FEE_BROKER_RESULT(AUTOID,BANKACCOUNT,REMARK,FEEAMOUNT,NOSTROACCOUNT,STATUS,BANKGLOBALID,TRANSDATE,SETTLEDATE,MEMBERID,CURRENCY,REFCODE)
                VALUES(V_SEQ,L_BANKFEEBRACCOUNT,UTF8NUMS.C_CONST_TLTX_TXDESC_8801,V_AMOUNT_VN,L_BANKACCOUNT_VN ,'N',NULL,TO_CHAR(TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),'RRRRMMDD'),
                       TO_CHAR(TO_DATE(V_REC1.CLEARDATE, systemnums.C_DATE_FORMAT),'RRRRMMDD'),V_REC1.AUTOID ,L_CURRENCY,'FEEBROKER');
            END IF;
        END LOOP;

        FOR H_REC1 IN
        (
            SELECT FA.AUTOID, FE.CLEARDATE
            FROM STSCHDHIST FE, ODMASTHIST OD, CFMAST CF, FAMEMBERS FA
            WHERE FA.AUTOID = OD.MEMBER
            AND OD.ORDERID = FE.ORDERID
            AND FE.CUSTODYCD = CF.CUSTODYCD
            AND FE.DUETYPE IN ('SM','RM')
            AND FE.DELTD = 'N'
            AND CF.FEEDAILY <> 'N'
            AND FE.FVSTATUS = 'P'
            AND SUBSTR(CF.CUSTODYCD,0,4) NOT LIKE V_SYSVAR
            AND GREATEST(NVL(FE.FEEAMT,0)-NVL(FE.PAIDFEEAMT,0),0) + GREATEST(NVL(FE.VAT,0)-NVL(FE.PAIDVAT,0),0) <> 0
            AND FE.VAT IS NULL
            GROUP BY FA.AUTOID, FE.CLEARDATE
        )
        LOOP
            V_AMOUNT := 0;
            V_AMOUNT_VN := 0;
            FOR H_REC2 IN
            (
                SELECT FE.CLEARDATE, FE.ORDERID, NVL(FE.FEEAMT,0) FEEAMT, NVL(FE.VAT,0) VAT, NVL(FE.PAIDFEEAMT,0) PAIDFEEAMT, NVL(FE.PAIDVAT,0) PAIDVAT, FE.DUETYPE, FE.CUSTODYCD, CF.COUNTRY, OD.ODTYPE
                FROM STSCHDHIST FE, ODMASTHIST OD, CFMAST CF
                WHERE OD.ORDERID = FE.ORDERID
                AND FE.CUSTODYCD = CF.CUSTODYCD
                AND FE.DUETYPE IN ('SM','RM')
                AND FE.DELTD = 'N'
                AND CF.FEEDAILY <> 'N'
                AND FE.FVSTATUS = 'P'
                AND SUBSTR(CF.CUSTODYCD,0,4) NOT LIKE V_SYSVAR
                AND GREATEST(NVL(FE.FEEAMT,0)-NVL(FE.PAIDFEEAMT,0),0) + GREATEST(NVL(FE.VAT,0)-NVL(FE.PAIDVAT,0),0) <> 0
                AND FE.VAT IS NULL
                AND OD.MEMBER = H_REC1.AUTOID
                AND FE.CLEARDATE = H_REC1.CLEARDATE
                ORDER BY CLEARDATE
            )
            LOOP
                IF H_REC2.ODTYPE <> 'ODG' THEN
                    IF H_REC2.COUNTRY <> '234' THEN
                        V_AMOUNT:= V_AMOUNT + H_REC2.FEEAMT + H_REC2.VAT;
                    ELSE
                        V_AMOUNT_VN:= V_AMOUNT_VN + H_REC2.FEEAMT + H_REC2.VAT;
                    END IF;
                ELSE
                    V_AMOUNT:= V_AMOUNT + H_REC2.FEEAMT + H_REC2.VAT;
                END IF;

                UPDATE STSCHDHIST SET FVSTATUS = 'A', REF8801 = V_SEQ, LASTCHANGE = SYSTIMESTAMP
                WHERE ORDERID = H_REC2.ORDERID
                AND ORDERID =H_REC2.ORDERID
                AND DUETYPE = H_REC2.DUETYPE
                AND CUSTODYCD = H_REC2.CUSTODYCD
                AND SUBSTR(CUSTODYCD,0,4) NOT LIKE V_SYSVAR;
            END LOOP;
            IF V_AMOUNT <> 0 THEN
                INSERT INTO FEE_BROKER_RESULT(AUTOID,BANKACCOUNT,REMARK,FEEAMOUNT,NOSTROACCOUNT,STATUS,BANKGLOBALID,TRANSDATE,SETTLEDATE,MEMBERID,CURRENCY,REFCODE)
                VALUES(V_SEQ,L_BANKFEEBRACCOUNT,UTF8NUMS.C_CONST_TLTX_TXDESC_8801,V_AMOUNT,L_BANKACCOUNT,'N',NULL,TO_CHAR(TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),'RRRRMMDD'),
                       TO_CHAR(TO_DATE(H_REC1.CLEARDATE, systemnums.C_DATE_FORMAT),'RRRRMMDD'),H_REC1.AUTOID,L_CURRENCY,'FEEBROKER');
            END IF;
            IF V_AMOUNT_VN <> 0 THEN
                INSERT INTO FEE_BROKER_RESULT(AUTOID,BANKACCOUNT,REMARK,FEEAMOUNT,NOSTROACCOUNT,STATUS,BANKGLOBALID,TRANSDATE,SETTLEDATE,MEMBERID,CURRENCY,REFCODE)
                VALUES(V_SEQ,L_BANKFEEBRACCOUNT,UTF8NUMS.C_CONST_TLTX_TXDESC_8801,V_AMOUNT_VN,L_BANKACCOUNT_VN ,'N',NULL,TO_CHAR(TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),'RRRRMMDD'),
                       TO_CHAR(TO_DATE(H_REC1.CLEARDATE, systemnums.C_DATE_FORMAT),'RRRRMMDD'),H_REC1.AUTOID ,L_CURRENCY,'FEEBROKER');
            END IF;
        END LOOP;

        pck_bankflms.sp_auto_gen_fee_broker();
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
         plog.init ('TXPKS_#8808EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8808EX;
/
