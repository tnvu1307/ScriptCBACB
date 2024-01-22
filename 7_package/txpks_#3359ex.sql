SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3359ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3359EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      10/02/2022     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3359ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '01';
   c_camastid         CONSTANT CHAR(2) := '02';
   c_codeid           CONSTANT CHAR(2) := '24';
   c_custodycd        CONSTANT CHAR(2) := '19';
   c_afacctno         CONSTANT CHAR(2) := '03';
   c_ddacctno         CONSTANT CHAR(2) := '23';
   c_fullname         CONSTANT CHAR(2) := '17';
   c_idcode           CONSTANT CHAR(2) := '18';
   c_catype           CONSTANT CHAR(2) := '05';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_balance          CONSTANT CHAR(2) := '11';
   c_reportdate       CONSTANT CHAR(2) := '06';
   c_actiondate       CONSTANT CHAR(2) := '07';
   c_seacctno         CONSTANT CHAR(2) := '08';
   c_exseacctno       CONSTANT CHAR(2) := '09';
   c_amt              CONSTANT CHAR(2) := '10';
   c_dutyamt          CONSTANT CHAR(2) := '20';
   c_dfamt            CONSTANT CHAR(2) := '21';
   c_intamt           CONSTANT CHAR(2) := '13';
   c_aamt             CONSTANT CHAR(2) := '12';
   c_trfeeamt         CONSTANT CHAR(2) := '22';
   c_parvalue         CONSTANT CHAR(2) := '14';
   c_exparvalue       CONSTANT CHAR(2) := '15';
   c_desc             CONSTANT CHAR(2) := '30';
   c_iscorebank       CONSTANT CHAR(2) := '60';
   c_isdebitse        CONSTANT CHAR(2) := '61';
   c_taskcd           CONSTANT CHAR(2) := '16';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    V_COUNT NUMBER;
    V_MSGACCT VARCHAR2(100);
    V_AUTOID VARCHAR2(100);
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
    /*IF P_TXMSG.DELTD <> 'Y' THEN
        V_AUTOID := P_TXMSG.TXFIELDS('01').VALUE;

        SELECT COUNT(1) INTO V_COUNT
        FROM VW_TLLOG_ALL
        WHERE TLTXCD = '3359'
        AND MSGACCT = V_AUTOID
        AND TXSTATUS IN ('1','4')
        AND DELTD = 'N'
        AND TXNUM <> P_TXMSG.TXNUM
        AND TXDATE <> P_TXMSG.TXDATE;

        IF V_COUNT > 0 THEN
            P_ERR_CODE := '-100018';
            PLOG.SETENDSECTION (PKGCTX, 'fn_txPreAppCheck');
            RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        END IF;
    END IF;*/
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
    V_TLTX VARCHAR2(20);
    L_TXMSG TX.MSG_RECTYPE;
    L_ERR_PARAM VARCHAR2(300);
    L_err_code VARCHAR2(300);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF P_TXMSG.DELTD <> 'Y' THEN
        IF P_TXMSG.TXFIELDS('15').VALUE = 'IS' THEN
            --THU THUE TAI TCPH
            V_TLTX := '3354';
        ELSE
            --THU THUE TAI CONG TY
            V_TLTX := '3350';
        END IF;

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

        SELECT systemnums.C_BATCH_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
        INTO l_txmsg.txnum
        FROM DUAL;

        select to_char(sysdate,'hh24:mi:ss') into l_txmsg.txtime from dual;

        --01    Mã l?ch CA   C
             l_txmsg.txfields ('01').defname   := 'AUTOID';
             l_txmsg.txfields ('01').TYPE      := 'C';
             l_txmsg.txfields ('01').value      := P_TXMSG.TXFIELDS('01').VALUE;
        --02    Mã CA   C
             l_txmsg.txfields ('02').defname   := 'CAMASTID';
             l_txmsg.txfields ('02').TYPE      := 'C';
             l_txmsg.txfields ('02').value      := P_TXMSG.TXFIELDS('02').VALUE;
        --03    S? Ti?u kho?n   C
             l_txmsg.txfields ('03').defname   := 'AFACCTNO';
             l_txmsg.txfields ('03').TYPE      := 'C';
             l_txmsg.txfields ('03').value      := P_TXMSG.TXFIELDS('03').VALUE;
        --04    Mã ch?ng khoán   C
             l_txmsg.txfields ('04').defname   := 'SYMBOL';
             l_txmsg.txfields ('04').TYPE      := 'C';
             l_txmsg.txfields ('04').value      := P_TXMSG.TXFIELDS('04').VALUE;
        --05    Lo?i th?c hi?n quy?n   C
             l_txmsg.txfields ('05').defname   := 'CATYPE';
             l_txmsg.txfields ('05').TYPE      := 'C';
             l_txmsg.txfields ('05').value      := P_TXMSG.TXFIELDS('05').VALUE;
        --06    Ngày dang ký cu?i cùng   C
             l_txmsg.txfields ('06').defname   := 'REPORTDATE';
             l_txmsg.txfields ('06').TYPE      := 'C';
             l_txmsg.txfields ('06').value      := P_TXMSG.TXFIELDS('06').VALUE;
        --07    Ngày th?c hi?n quy?n   C
             l_txmsg.txfields ('07').defname   := 'ACTIONDATE';
             l_txmsg.txfields ('07').TYPE      := 'C';
             l_txmsg.txfields ('07').value      := P_TXMSG.TXFIELDS('07').VALUE;
        --08    S? TK SE   C
             l_txmsg.txfields ('08').defname   := 'SEACCTNO';
             l_txmsg.txfields ('08').TYPE      := 'C';
             l_txmsg.txfields ('08').value      := P_TXMSG.TXFIELDS('08').VALUE;
        --09    S? TK SE liên quan   C
             l_txmsg.txfields ('09').defname   := 'EXSEACCTNO';
             l_txmsg.txfields ('09').TYPE      := 'C';
             l_txmsg.txfields ('09').value      := P_TXMSG.TXFIELDS('09').VALUE;
        --10    S? ti?n   N
             l_txmsg.txfields ('10').defname   := 'AMT';
             l_txmsg.txfields ('10').TYPE      := 'N';
             l_txmsg.txfields ('10').value      := P_TXMSG.TXFIELDS('10').VALUE;
        --11    S? ch?ng khoán s? h?u   N
             l_txmsg.txfields ('11').defname   := 'BALANCE';
             l_txmsg.txfields ('11').TYPE      := 'N';
             l_txmsg.txfields ('11').value      := P_TXMSG.TXFIELDS('11').VALUE;
        --12    S? liên quan   N
             l_txmsg.txfields ('12').defname   := 'AAMT';
             l_txmsg.txfields ('12').TYPE      := 'N';
             l_txmsg.txfields ('12').value      := P_TXMSG.TXFIELDS('12').VALUE;
        --13    S? ti?n lãi du?c hu?ng   N
             l_txmsg.txfields ('13').defname   := 'INTAMT';
             l_txmsg.txfields ('13').TYPE      := 'N';
             l_txmsg.txfields ('13').value      := P_TXMSG.TXFIELDS('13').VALUE;
        --14    M?nh giá   N
             l_txmsg.txfields ('14').defname   := 'PARVALUE';
             l_txmsg.txfields ('14').TYPE      := 'N';
             l_txmsg.txfields ('14').value      := P_TXMSG.TXFIELDS('14').VALUE;
        --15    M?nh giá liên quan   N
             l_txmsg.txfields ('15').defname   := 'EXPARVALUE';
             l_txmsg.txfields ('15').TYPE      := 'N';
             l_txmsg.txfields ('15').value      := P_TXMSG.TXFIELDS('15').VALUE;
        --16    Mã v? vi?c   C
             l_txmsg.txfields ('16').defname   := 'TASKCD';
             l_txmsg.txfields ('16').TYPE      := 'C';
             l_txmsg.txfields ('16').value      := '';
        --17    Tên khách hàng   C
             l_txmsg.txfields ('17').defname   := 'FULLNAME';
             l_txmsg.txfields ('17').TYPE      := 'C';
             l_txmsg.txfields ('17').value      := P_TXMSG.TXFIELDS('17').VALUE;
        --18    CMND/GPKD   C
             l_txmsg.txfields ('18').defname   := 'IDCODE';
             l_txmsg.txfields ('18').TYPE      := 'C';
             l_txmsg.txfields ('18').value      := P_TXMSG.TXFIELDS('18').VALUE;
        --19    S? luu ký   C
             l_txmsg.txfields ('19').defname   := 'CUSTODYCD';
             l_txmsg.txfields ('19').TYPE      := 'C';
             l_txmsg.txfields ('19').value      := P_TXMSG.TXFIELDS('19').VALUE;
        --20    S? ti?n thu?   N
             l_txmsg.txfields ('20').defname   := 'DUTYAMT';
             l_txmsg.txfields ('20').TYPE      := 'N';
             l_txmsg.txfields ('20').value      := P_TXMSG.TXFIELDS('20').VALUE;
        --21    S? ti?n c?m c? DF   N
             l_txmsg.txfields ('21').defname   := 'DFAMT';
             l_txmsg.txfields ('21').TYPE      := 'N';
             l_txmsg.txfields ('21').value      := P_TXMSG.TXFIELDS('21').VALUE;
        --22    Phí chuy?n kho?n    N
             l_txmsg.txfields ('22').defname   := 'TRFEEAMT';
             l_txmsg.txfields ('22').TYPE      := 'N';
             l_txmsg.txfields ('22').value      := P_TXMSG.TXFIELDS('22').VALUE;
        --23    Tài kho?n ti?n t?   C
             l_txmsg.txfields ('23').defname   := 'DDACCTNO';
             l_txmsg.txfields ('23').TYPE      := 'C';
             l_txmsg.txfields ('23').value      := P_TXMSG.TXFIELDS('23').VALUE;
        --24    Mã ch?ng khoán   C
             l_txmsg.txfields ('24').defname   := 'CODEID';
             l_txmsg.txfields ('24').TYPE      := 'C';
             l_txmsg.txfields ('24').value      := P_TXMSG.TXFIELDS('24').VALUE;
        --30    Di?n gi?i   C
             l_txmsg.txfields ('30').defname   := 'DESC';
             l_txmsg.txfields ('30').TYPE      := 'C';
             l_txmsg.txfields ('30').value      := P_TXMSG.TXFIELDS('30').VALUE;
        --60    Là tk corebank?   N
             l_txmsg.txfields ('60').defname   := 'ISCOREBANK';
             l_txmsg.txfields ('60').TYPE      := 'N';
             l_txmsg.txfields ('60').value      := P_TXMSG.TXFIELDS('60').VALUE;
        --61    Gi?m ch?ng khoán s? h?u?   N
             l_txmsg.txfields ('61').defname   := 'ISDEBITSE';
             l_txmsg.txfields ('61').TYPE      := 'N';
             l_txmsg.txfields ('61').value      := P_TXMSG.TXFIELDS('61').VALUE;

        IF V_TLTX = '3350' THEN
            IF TXPKS_#3350.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
				plog.error (pkgctx, 'got error 3350: ' || p_err_code);
                ROLLBACK;
                RETURN ERRNUMS.C_BIZ_RULE_INVALID;
            END IF;
        ELSE
            IF TXPKS_#3354.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
				plog.error (pkgctx, 'got error 3354: ' || p_err_code);
                ROLLBACK;
                RETURN ERRNUMS.C_BIZ_RULE_INVALID;
            END IF;
        END IF;
    ELSE
        for rec in
        (
            select * from tllog where reftxnum = p_txmsg.txnum and tltxcd in ('3350', '3354') and deltd = 'N'
        )
        loop
            if rec.tltxcd = '3350' then
                if txpks_#3350.fn_txrevert(rec.txnum,to_char(rec.txdate,'dd/mm/rrrr'),p_err_code,l_err_param) <> 0 then
                    plog.error (pkgctx, 'Loi khi thuc hien xoa giao dich');
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    return errnums.C_SYSTEM_ERROR;
                end if;
            ELSIF rec.tltxcd = '3354' then
                if txpks_#3354.fn_txrevert(rec.txnum,to_char(rec.txdate,'dd/mm/rrrr'),p_err_code,l_err_param) <> 0 then
                    plog.error (pkgctx, 'Loi khi thuc hien xoa giao dich');
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    return errnums.C_SYSTEM_ERROR;
                end if;
            end if ;
        end loop;
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
         plog.init ('TXPKS_#3359EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3359EX;
/
