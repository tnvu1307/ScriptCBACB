SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#6638ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#6638EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      21/07/2021     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#6638ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '21';
   c_postingdate      CONSTANT CHAR(2) := '01';
   c_tradingacct      CONSTANT CHAR(2) := '02';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_porfolio         CONSTANT CHAR(2) := '04';
   c_balance          CONSTANT CHAR(2) := '05';
   c_available        CONSTANT CHAR(2) := '06';
   c_instruction      CONSTANT CHAR(2) := '07';
   c_transfer         CONSTANT CHAR(2) := '08';
   c_citad            CONSTANT CHAR(2) := '09';
   c_bank             CONSTANT CHAR(2) := '11';
   c_bankbranch       CONSTANT CHAR(2) := '12';
   c_bankacctno       CONSTANT CHAR(2) := '13';
   c_name             CONSTANT CHAR(2) := '14';
   c_amt              CONSTANT CHAR(2) := '10';
   c_refcontract      CONSTANT CHAR(2) := '15';
   c_feetype          CONSTANT CHAR(2) := '16';
   c_fee              CONSTANT CHAR(2) := '19';
   c_netamt           CONSTANT CHAR(2) := '20';
   c_valuedate        CONSTANT CHAR(2) := '17';
   c_descs            CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    v_citad varchar2(50);
    v_transfer varchar2(50);
    v_count number;
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

    IF p_txmsg.deltd <> 'Y'  THEN
        v_citad := p_txmsg.txfields(c_citad).value;
        v_transfer := p_txmsg.txfields(c_transfer).value;

        --trung.luu sua theo yeu cau anh Hac 13-03-2020 : neu la gd online  voi 3 type kia thi cho phep null citad
        if p_txmsg.tlid <> '6868' or p_txmsg.txfields(c_instruction).value not in('ETFEX','TAEX','TARD') then
           IF (length(v_citad) = 0 OR v_citad IS NULL) AND v_transfer = 'D' THEN
              p_err_code := '-670413';
              RETURN errnums.C_BIZ_RULE_INVALID;
           END IF;
        END IF;
        --trung.luu: SHBVNEX-2345
        SELECT COUNT(1) INTO v_count FROM LOG_FUTURE6639 WHERE AUTOID = p_txmsg.txfields(c_autoid).value AND STATUS = 'C';
        IF v_count > 0 THEN
            p_err_code := '-670060';
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
    l_autoid number;
    l_custodycd varchar2(20);
    l_ddacctno varchar2(40);
    l_bankacc varchar2(30);
    l_bankname varchar(500);
    l_porfolio varchar(500);
    l_feetype varchar(1);
    l_txamt number;
    l_balance number;
    l_available number;
    l_fee number;
    l_netamt number;
    l_citad varchar2(20);
    l_instruction varchar2(20);
    l_transtype varchar(1);
    l_bankbranch varchar(100);
    l_custname varchar(100);
    l_valuedate date;
    l_postingdate date;
    l_refcontract varchar2(500);
    l_desc varchar2(2000);
    l_currdate date;
    v_globalid varchar(100);
    v_count number;
    v_toacctno varchar2(50);
    v_txdate date;
    v_txnum varchar2(50);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF P_TXMSG.DELTD <> 'Y' THEN
        l_autoid := p_txmsg.txfields(c_autoid).value;
        l_custodycd := p_txmsg.txfields(c_tradingacct).value;
        l_bankacc := p_txmsg.txfields(c_bankacctno).value;
        l_bankname := p_txmsg.txfields(c_bank).value;
        l_citad := p_txmsg.txfields(c_citad).value;
        l_ddacctno := p_txmsg.txfields(c_acctno).value;
        l_feetype := p_txmsg.txfields(c_feetype).value;
        l_instruction := p_txmsg.txfields(c_instruction).value;
        l_transtype := p_txmsg.txfields(c_transfer).value;
        l_bankbranch := p_txmsg.txfields(c_bankbranch).value;
        l_custname := p_txmsg.txfields(c_name).value;
        l_txamt := p_txmsg.txfields(c_amt).value;
        l_valuedate := to_date(p_txmsg.txfields(c_valuedate).value,'dd/mm/rrrr');
        l_postingdate := to_date(p_txmsg.txfields(c_postingdate).value,'dd/mm/rrrr');
        l_porfolio := p_txmsg.txfields(c_porfolio).value;
        l_balance := p_txmsg.txfields(c_balance).value;
        l_available := p_txmsg.txfields(c_available).value;
        l_refcontract := p_txmsg.txfields(c_refcontract).value;
        l_desc := p_txmsg.txfields(c_descs).value;
        l_fee := p_txmsg.txfields(c_fee).value;
        l_netamt := p_txmsg.txfields(c_netamt).value;

        l_currdate := getcurrdate();

        BEGIN
            SELECT TXDATE, TXNUM INTO V_TXDATE, V_TXNUM FROM LOG_FUTURE6639 WHERE AUTOID = L_AUTOID;
            SELECT GLOBALID INTO v_globalid FROM CBFA_BANKPAYMENT WHERE TXNUM = V_TXNUM AND TXDATE = V_TXDATE;

            IF L_TRANSTYPE = 'D'  THEN--CHUYEN TIEN RA NGOAI
                PCK_BANKAPI.BANK_TRANFER_OUT_FA(L_DDACCTNO, L_CUSTNAME, L_BANKACC, L_CITAD, L_FEETYPE, L_TXAMT, L_INSTRUCTION, V_GLOBALID, L_DESC, P_TXMSG.TLID, P_ERR_CODE);
                IF P_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN
                    RAISE ERRNUMS.E_SYSTEM_ERROR;
                END IF;
            ELSE
                SELECT COUNT(*) INTO V_COUNT FROM DDMAST D WHERE D.REFCASAACCT = L_BANKACC;
                IF V_COUNT = 0 THEN
                    PCK_BANKAPI.BANK_INTERNAL_TRANFER_FA(L_DDACCTNO, L_CUSTNAME, L_BANKACC, L_TXAMT,  L_INSTRUCTION,  V_GLOBALID,  L_DESC,  P_TXMSG.TLID,  P_ERR_CODE);
                    IF P_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN
                        RAISE ERRNUMS.E_SYSTEM_ERROR;
                    END IF;
                ELSE
                    SELECT ACCTNO INTO V_TOACCTNO FROM DDMAST  WHERE REFCASAACCT = L_BANKACC;
                    PCK_BANKAPI.BANK_INTERNAL_TRANFER(L_DDACCTNO, L_CUSTNAME, V_TOACCTNO, L_TXAMT, L_INSTRUCTION, V_GLOBALID, L_DESC, P_TXMSG.TLID, P_ERR_CODE);
                    IF P_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN
                        RAISE ERRNUMS.E_SYSTEM_ERROR;
                    END IF;
               END IF;
            END IF;
            UPDATE LOG_FUTURE6639 SET STATUS = 'C' WHERE AUTOID = L_AUTOID;
            UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S' WHERE TXNUM = V_TXNUM AND TXDATE = V_TXDATE;
        EXCEPTION WHEN OTHERS THEN
            UPDATE LOG_FUTURE6639 SET STATUS = 'E', ERRMSG = P_ERR_CODE WHERE AUTOID = L_AUTOID;
            RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        END;
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
         plog.init ('TXPKS_#6638EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#6638EX;
/
