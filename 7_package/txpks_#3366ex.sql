SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3366ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3366EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      06/09/2021     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3366ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '02';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_codeid           CONSTANT CHAR(2) := '22';
   c_codeid           CONSTANT CHAR(2) := '71';
   c_glmast           CONSTANT CHAR(2) := '15';
   c_bankid           CONSTANT CHAR(2) := '05';
   c_bankacc          CONSTANT CHAR(2) := '08';
   c_bankname         CONSTANT CHAR(2) := '85';
   c_bankaccname      CONSTANT CHAR(2) := '86';
   c_qtty             CONSTANT CHAR(2) := '21';
   c_balance          CONSTANT CHAR(2) := '07';
   c_aamt             CONSTANT CHAR(2) := '10';
   c_benefcustname    CONSTANT CHAR(2) := '82';
   c_benefacct        CONSTANT CHAR(2) := '81';
   c_benefname        CONSTANT CHAR(2) := '80';
   c_potxdate         CONSTANT CHAR(2) := '98';
   c_potxnum          CONSTANT CHAR(2) := '99';
   c_podesc           CONSTANT CHAR(2) := '31';
   c_desc             CONSTANT CHAR(2) := '30';
   c_potype           CONSTANT CHAR(2) := '17';
   c_ioro             CONSTANT CHAR(2) := '32';
   c_citad            CONSTANT CHAR(2) := '27';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_count number;
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

    IF P_TXMSG.DELTD <> 'Y' THEN
        SELECT COUNT(1) INTO l_count
        FROM  SBSECURITIES SYM, CAMAST, CASCHD  CA, SBSECURITIES SYM_ORG,
        (
            SELECT CAMASTID, AFACCTNO, MSGSTATUS
            FROM CAREGISTER
            WHERE MSGSTATUS IN ('S','C')
            GROUP BY CAMASTID,AFACCTNO,MSGSTATUS
        ) RIS
        WHERE CAMAST.TOCODEID = SYM.CODEID
        AND CAMAST.CODEID = SYM_ORG.CODEID
        AND CAMAST.CAMASTID  = CA.CAMASTID
        AND CA.CAMASTID = RIS.CAMASTID
        AND CA.AFACCTNO = RIS.AFACCTNO
        AND CA.STATUS IN('M','O')
        AND CA.STATUS <>'Y'
        AND CA.DELTD <> 'Y'
        AND CA.BALANCE > 0
        AND (CA.QTTY + CA.SENDQTTY + CA.CUTQTTY - CA.TQTTY) > 0
        AND CAMAST.CATYPE = '014'
        AND CAMAST.CAMASTID = P_TXMSG.TXFIELDS('02').VALUE;

        IF l_count = 0 THEN
            p_err_code := '-100777';
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
    L_TXMSG       TX.MSG_RECTYPE;
    L_ERR_PARAM   VARCHAR2(1000);
    V_TLTXCD      VARCHAR2(10);
    V_STRDESC     VARCHAR2(1000);
    V_STREN_DESC  VARCHAR2(1000);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF P_TXMSG.DELTD <> 'Y' THEN
        V_TLTXCD := '3387';
        ------------------------
        BEGIN
            SELECT TXDESC, EN_TXDESC
            INTO V_STRDESC, V_STREN_DESC
            FROM TLTX
            WHERE TLTXCD = V_TLTXCD;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            V_STRDESC:= null;
            V_STREN_DESC:= null;
        END;
        ------------------------
        L_TXMSG.MSGTYPE     :='T';
        L_TXMSG.LOCAL       :='N';
        L_TXMSG.TLID        := P_TXMSG.TLID;
        ------------------------
        SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                 SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
        INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
        FROM DUAL;
        ------------------------
        BEGIN
            SELECT BRID
            INTO L_TXMSG.BRID
            FROM TLPROFILES WHERE TLID=L_TXMSG.TLID;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            L_TXMSG.BRID:= null;
        END;
        ------------------------
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.REFTXNUM    := P_TXMSG.TXNUM;
        L_TXMSG.TXDATE      := TO_DATE(P_TXMSG.TXDATE,SYSTEMNUMS.C_DATE_FORMAT);
        L_TXMSG.BUSDATE     := TO_DATE(P_TXMSG.TXDATE,SYSTEMNUMS.C_DATE_FORMAT);
        L_TXMSG.TLTXCD      := V_TLTXCD;
        L_TXMSG.CCYUSAGE    := P_TXMSG.CCYUSAGE;

        FOR REC IN (
            SELECT  CA.AUTOID, CF.CUSTODYCD, CF.CIFID , CAMAST.CAMASTID,
            CA.AFACCTNO, CAMAST.CODEID CODEID_ORG, CAMAST.TOCODEID CODEID, CA.BALANCE  BALANCE, (CA.QTTY+ CA.SENDQTTY+CA.CUTQTTY - CA.TQTTY )  QTTY,
            CA.NMQTTY, (CA.QTTY + CA.SENDQTTY + CA.CUTQTTY - CA.TQTTY - CA.NMQTTY ) MQTTY, (CA.QTTY + CA.SENDQTTY + CA.CUTQTTY - CA.TQTTY) * CAMAST.EXPRICE AMT,
            SYM.SYMBOL, CA.AFACCTNO ||(CASE WHEN CAMAST.ISWFT='Y' THEN (SELECT CODEID FROM SBSECURITIES WHERE REFCODEID =SYM.CODEID ) ELSE CAMAST.TOCODEID END) SEACCTNO,
            CA.AFACCTNO||CAMAST.OPTCODEID OPTSEACCTNO, SYM.PARVALUE PARVALUE, CAMAST.REPORTDATE REPORTDATE, CAMAST.ACTIONDATE,CAMAST.EXPRICE,
            SYM_ORG.SYMBOL SYMBOL_ORG, CAMAST.ISINCODE, CF.MCUSTODYCD
            FROM  SBSECURITIES SYM, CAMAST, CASCHD  CA, AFMAST AF , CFMAST CF, SBSECURITIES SYM_ORG,
            (SELECT CAMASTID,AFACCTNO,MSGSTATUS
                FROM CAREGISTER
                WHERE MSGSTATUS IN ('S','C')
                GROUP BY CAMASTID,AFACCTNO,MSGSTATUS
            ) RIS
            WHERE CAMAST.TOCODEID = SYM.CODEID
            AND CAMAST.CAMASTID  = CA.CAMASTID
            AND CA.AFACCTNO = AF.ACCTNO
            AND AF.CUSTID = CF.CUSTID
            AND SYM_ORG.CODEID=CAMAST.CODEID
            AND CA.CAMASTID=RIS.CAMASTID
            AND CA.AFACCTNO=RIS.AFACCTNO
            AND CAMAST.CATYPE ='014'
            AND CA.STATUS IN('M','O')
            AND CA.STATUS <>'Y'
            AND CA.DELTD <> 'Y'
            AND CA.BALANCE > 0
            AND (CA.QTTY + CA.SENDQTTY + CA.CUTQTTY - CA.TQTTY) > 0
            AND CAMAST.CAMASTID = P_TXMSG.TXFIELDS('02').VALUE
        )
        LOOP
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD (SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            --01    Mã l?ch CA   C
                 l_txmsg.txfields ('01').defname   := 'AUTOID';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := rec.AUTOID;
            --02    Mã CA   C
                 l_txmsg.txfields ('02').defname   := 'CAMASTID';
                 l_txmsg.txfields ('02').TYPE      := 'C';
                 l_txmsg.txfields ('02').value      := rec.CAMASTID;
            --03    S? Ti?u kho?n   C
                 l_txmsg.txfields ('03').defname   := 'AFACCTNO';
                 l_txmsg.txfields ('03').TYPE      := 'C';
                 l_txmsg.txfields ('03').value      := rec.AFACCTNO;
            --04    Mã ch?ng khoán   C
                 l_txmsg.txfields ('04').defname   := 'SYMBOL';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.SYMBOL;
            --05    Mã ngân hàng chuy?n   C
                 l_txmsg.txfields ('05').defname   := 'BANKID';
                 l_txmsg.txfields ('05').TYPE      := 'C';
                 l_txmsg.txfields ('05').value      := P_TXMSG.TXFIELDS('05').VALUE;
            --06    S? tài kho?n SE   C
                 l_txmsg.txfields ('06').defname   := 'SEACCTNO';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.SEACCTNO;
            --07    Quy?n   N
                 l_txmsg.txfields ('07').defname   := 'BALANCE';
                 l_txmsg.txfields ('07').TYPE      := 'N';
                 l_txmsg.txfields ('07').value      := rec.BALANCE;
            --08    S? tài kho?n   C
                 l_txmsg.txfields ('08').defname   := 'BANKACC';
                 l_txmsg.txfields ('08').TYPE      := 'C';
                 l_txmsg.txfields ('08').value      := P_TXMSG.TXFIELDS('08').VALUE;
            --09    S? tài kho?n  SE   C
                 l_txmsg.txfields ('09').defname   := 'OPTSEACCTNO';
                 l_txmsg.txfields ('09').TYPE      := 'C';
                 l_txmsg.txfields ('09').value      := rec.OPTSEACCTNO;
            --10    S? ti?n dang ký mua    N
                 l_txmsg.txfields ('10').defname   := 'AAMT';
                 l_txmsg.txfields ('10').TYPE      := 'N';
                 l_txmsg.txfields ('10').value      := rec.AMT;
            --15    Tài kho?n GL   C
                 l_txmsg.txfields ('15').defname   := 'GLMAST';
                 l_txmsg.txfields ('15').TYPE      := 'C';
                 l_txmsg.txfields ('15').value      := P_TXMSG.TXFIELDS('15').VALUE;
            --17    Lo?i UNC   C
                 l_txmsg.txfields ('17').defname   := 'POTYPE';
                 l_txmsg.txfields ('17').TYPE      := 'C';
                 l_txmsg.txfields ('17').value      := P_TXMSG.TXFIELDS('17').VALUE;
            --21    S? lu?ng dang ký mua    N
                 l_txmsg.txfields ('21').defname   := 'QTTY';
                 l_txmsg.txfields ('21').TYPE      := 'N';
                 l_txmsg.txfields ('21').value      := rec.QTTY;
            --22    Mã ch?ng khoán   C
                 l_txmsg.txfields ('22').defname   := 'CODEID';
                 l_txmsg.txfields ('22').TYPE      := 'C';
                 l_txmsg.txfields ('22').value      := rec.CODEID;
            --27    Mã CITAD   C
                 l_txmsg.txfields ('27').defname   := 'CITAD';
                 l_txmsg.txfields ('27').TYPE      := 'C';
                 l_txmsg.txfields ('27').value      := P_TXMSG.TXFIELDS('27').VALUE;
            --30    Di?n gi?i   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := P_TXMSG.TXFIELDS('30').VALUE;
            --31    Di?n gi?i UNC   C
                 l_txmsg.txfields ('31').defname   := 'PODESC';
                 l_txmsg.txfields ('31').TYPE      := 'C';
                 l_txmsg.txfields ('31').value      := P_TXMSG.TXFIELDS('31').VALUE;
            --32    Ki?u phí   C
                 l_txmsg.txfields ('32').defname   := 'IORO';
                 l_txmsg.txfields ('32').TYPE      := 'C';
                 l_txmsg.txfields ('32').value      := P_TXMSG.TXFIELDS('32').VALUE;
            --71    Mã ch?ng khoán ch?t   C
                 l_txmsg.txfields ('71').defname   := 'CODEID';
                 l_txmsg.txfields ('71').TYPE      := 'C';
                 l_txmsg.txfields ('71').value      := rec.CODEID;
            --77    S? TK luu ký   C
                 l_txmsg.txfields ('77').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('77').TYPE      := 'C';
                 l_txmsg.txfields ('77').value      := rec.CUSTODYCD;
            --80    Tên ngân hàng nh?n   C
                 l_txmsg.txfields ('80').defname   := 'BENEFNAME';
                 l_txmsg.txfields ('80').TYPE      := 'C';
                 l_txmsg.txfields ('80').value      := P_TXMSG.TXFIELDS('80').VALUE;
            --81    S? tài kho?n nh?n   C
                 l_txmsg.txfields ('81').defname   := 'BENEFACCT';
                 l_txmsg.txfields ('81').TYPE      := 'C';
                 l_txmsg.txfields ('81').value      := P_TXMSG.TXFIELDS('81').VALUE;
            --82    Tên khách hàng nh?n   C
                 l_txmsg.txfields ('82').defname   := 'BENEFCUSTNAME';
                 l_txmsg.txfields ('82').TYPE      := 'C';
                 l_txmsg.txfields ('82').value      := P_TXMSG.TXFIELDS('82').VALUE;
            --85    T?i ngân hàng   C
                 l_txmsg.txfields ('85').defname   := 'BANKNAME';
                 l_txmsg.txfields ('85').TYPE      := 'C';
                 l_txmsg.txfields ('85').value      := P_TXMSG.TXFIELDS('85').VALUE;
            --86    Tên TK ngân hàng   C
                 l_txmsg.txfields ('86').defname   := 'BANKACCNAME';
                 l_txmsg.txfields ('86').TYPE      := 'C';
                 l_txmsg.txfields ('86').value      := P_TXMSG.TXFIELDS('86').VALUE;
            --88    Sô´ TKLK me?   C
                 l_txmsg.txfields ('88').defname   := 'MCUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.MCUSTODYCD;
            --98    Ngày b?ng kê   D
                 l_txmsg.txfields ('98').defname   := 'POTXDATE';
                 l_txmsg.txfields ('98').TYPE      := 'D';
                 l_txmsg.txfields ('98').value      := P_TXMSG.TXFIELDS('98').VALUE;
            --99    S? b?ng kê   C
                 l_txmsg.txfields ('99').defname   := 'POTXNUM';
                 l_txmsg.txfields ('99').TYPE      := 'C';
                 l_txmsg.txfields ('99').value      := P_TXMSG.TXFIELDS('99').VALUE;

            IF TXPKS_#3387.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        END LOOP;

        INSERT INTO CA3387_CITAD_RESULT(AUTOID, TXNUM, TXDATE, BANKACCT, TXAMT,
                                        NOTES, STATUS, CREATEDATE, RBANKACCOUNT,RBANKCITAD,
                                        RBANKACCNAME, CURRENCY)
        VALUES(SEQ_CA3387_CITAD_RESULT.NEXTVAL, P_TXMSG.TXNUM, TO_DATE(P_TXMSG.TXDATE,SYSTEMNUMS.C_DATE_FORMAT), P_TXMSG.TXFIELDS('08').VALUE, TO_NUMBER(P_TXMSG.TXFIELDS('10').VALUE),
               P_TXMSG.TXFIELDS('31').VALUE, 'N', TO_DATE(P_TXMSG.BUSDATE,SYSTEMNUMS.C_DATE_FORMAT), TRIM(P_TXMSG.TXFIELDS('81').VALUE), TRIM(P_TXMSG.TXFIELDS('27').VALUE),
               TRIM(P_TXMSG.TXFIELDS('82').VALUE), 'VND');
        PCK_BANKFLMS.SP_AUTO_GEN_CA3387_CITAD_RESULT();
    ELSE
        FOR REC IN
        (
            SELECT * FROM TLLOG WHERE REFTXNUM = P_TXMSG.TXNUM AND TLTXCD = '3387' AND DELTD = 'N'
        )
        LOOP
            IF TXPKS_#3387.FN_TXREVERT(REC.TXNUM, TO_CHAR(REC.TXDATE,'DD/MM/RRRR'), P_ERR_CODE, L_ERR_PARAM) <> 0 THEN
                PLOG.ERROR (PKGCTX, 'LOI KHI THUC HIEN XOA GIAO DICH');
                plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
                RETURN ERRNUMS.C_SYSTEM_ERROR;
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
         plog.init ('TXPKS_#3366EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3366EX;
/
