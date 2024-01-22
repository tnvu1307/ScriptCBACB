SET DEFINE OFF;
CREATE OR REPLACE PACKAGE TXPKS_#1911EX
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1911EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      14/02/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1911ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_actiondate       CONSTANT CHAR(2) := '01';
   c_agreementno      CONSTANT CHAR(2) := '04';
   c_agreementdate    CONSTANT CHAR(2) := '05';
   c_sectype          CONSTANT CHAR(2) := '08';
   c_symbol           CONSTANT CHAR(2) := '02';
   c_codeid           CONSTANT CHAR(2) := '03';
   c_scustodycd       CONSTANT CHAR(2) := '88';
   c_sfullname        CONSTANT CHAR(2) := '90';
   c_rcustodycd       CONSTANT CHAR(2) := '89';
   c_rfullname        CONSTANT CHAR(2) := '91';
   c_mqtty            CONSTANT CHAR(2) := '06';
   c_tqtty            CONSTANT CHAR(2) := '07';
   c_desc             CONSTANT CHAR(2) := '30';
   c_acctno           CONSTANT CHAR(2) := '09';
   c_rcustid          CONSTANT CHAR(2) := '10';
   c_racctno          CONSTANT CHAR(2) := '11';
   c_afcctno          CONSTANT CHAR(2) := '12';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_allow         boolean;
    l_blocked apprules.field%TYPE;
    l_status apprules.field%TYPE;
    l_custodiantyp apprules.field%TYPE;
    l_trade apprules.field%TYPE;
    l_avlsewithdraw apprules.field%TYPE;
    l_semastcheck_arr txpks_check.semastcheck_arrtype;
    l_sewithdrawcheck_arr txpks_check.sewithdrawcheck_arrtype;
    l_afmastcheck_arr txpks_check.afmastcheck_arrtype;
    l_bondsemast number;
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
     If txpks_check.fn_aftxmapcheck(p_txmsg.txfields('09').value,'SEMAST','','1911')<>'TRUE' then
         p_err_code := errnums.C_SA_TLTX_NOT_ALLOW_BY_ACCTNO;
         plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
         RETURN errnums.C_BIZ_RULE_INVALID;
     End if;
     --
     If txpks_check.fn_aftxmapcheck(p_txmsg.txfields('11').value,'SEMAST','','1911')<>'TRUE' then
         p_err_code := errnums.C_SA_TLTX_NOT_ALLOW_BY_ACCTNO;
         plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
         RETURN errnums.C_BIZ_RULE_INVALID;
     End if;
     --============KIEM TRA BEN NHAN CHUYEN NHUONG======================
     l_SEMASTcheck_arr := txpks_check.fn_SEMASTcheck(p_txmsg.txfields('11').value,'SEMAST','ACCTNO');
     l_STATUS := l_SEMASTcheck_arr(0).STATUS;
     IF NOT ( INSTR('AN',l_STATUS) > 0) THEN
        p_err_code := '-900019';
        plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
     END IF;
     ---------------------------------------
     --============KIEM TRA BEN CHUYEN NHUONG============================
     l_SEWITHDRAWcheck_arr := txpks_check.fn_SEWITHDRAWcheck(p_txmsg.txfields('09').value,'TRADE','');
     l_AFMASTcheck_arr := txpks_check.fn_AFMASTcheck(p_txmsg.txfields('12').value,'AFMAST','ACCTNO');
     l_SEMASTcheck_arr := txpks_check.fn_SEMASTcheck(p_txmsg.txfields('09').value,'SEMAST','ACCTNO');
     l_STATUS := l_SEMASTcheck_arr(0).STATUS;
     l_TRADE := l_SEMASTcheck_arr(0).TRADE;
     --
     IF NOT ( INSTR('ANC',l_STATUS) > 0) THEN
        p_err_code := '-900019';
        plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
     END IF;
     --
     --trung.luu: 25-08-2020 SHBVNEX-1458
     begin
        select trade into l_bondsemast from bondsemast where acctno = p_txmsg.txfields('09').value;
    exception when NO_DATA_FOUND
        then
        l_bondsemast := 0;
    end ;
     IF NOT (l_bondsemast >= to_number(p_txmsg.txfields('07').value)) THEN
        p_err_code := '-900017';
        plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
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
    v_strSCUSTODYCD  VARCHAR2(20); --so tklk chuyen
    v_strRCUSTODYCD  VARCHAR2(20); --so tklk nhan
    v_nTQTTY         NUMBER; --so luong chuyen nhuong
    v_strCODEID      VARCHAR2(30);
    v_strSYMBOL      VARCHAR2(30);
    v_strRACCTNO     VARCHAR2(30); --nhan
    v_strRAFACCTNO   VARCHAR2(20); --nhan
    v_strSACCTNO     VARCHAR2(30); --gui
    v_strSAFACCTNO   VARCHAR2(20); --gui
    v_strDESC        VARCHAR2(1000);
    v_count          NUMBER;
    v_txnum          VARCHAR2(30);
    v_txdate         DATE;
    v_busdate        DATE;
    v_scifid         VARCHAR2(20);
    v_rcifid         VARCHAR2(20);
    v_strade         NUMBER;
    v_rtrade         NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_strSCUSTODYCD := p_txmsg.txfields(c_scustodycd).value;
    v_strRCUSTODYCD := p_txmsg.txfields(c_rcustodycd).value;
    v_nTQTTY        := to_number(p_txmsg.txfields(c_tqtty).value);
    v_strCODEID     := p_txmsg.txfields(c_codeid).value;
    v_strSYMBOL     := p_txmsg.txfields(c_symbol).value;
    v_strDESC       := p_txmsg.txfields(c_desc).value;
    v_txnum         := p_txmsg.txnum;
    v_txdate        := TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
    v_busdate       := TO_DATE(p_txmsg.busdate, systemnums.C_DATE_FORMAT);
    v_strRACCTNO    := p_txmsg.txfields(c_racctno).value; --BEN NHAN CHUYEN NHUONG
    v_strSACCTNO    := p_txmsg.txfields(c_acctno).value; --BEN CHUYEN NHUONG  S:SEND-R:RECEIVE
    --
    IF p_txmsg.deltd <> 'Y' THEN
        -- AFACCTNO CUA BEN NHAN CHUYEN NHUONG
        SELECT max(af.acctno) INTO v_strRAFACCTNO FROM AFMAST af, CFMAST cf where af.custid = cf.custid AND cf.custodycd = v_strRCUSTODYCD;
        -- AFACCTNO CUA BEN CHUYEN NHUONG
        SELECT max(bo.afacctno) INTO v_strSAFACCTNO FROM BONDSEMAST bo where  bo.custodycd = v_strSCUSTODYCD;
        --==============================DOI VOI TAI KHOAN NHAN CHUYEN NHUONG================================================================
        SELECT NVL(COUNT(*), 0) INTO v_count FROM BONDSEMAST BO
        WHERE BO.ACCTNO = v_strRACCTNO;
        --

        --
        IF v_count = 0 THEN
            INSERT INTO BONDSEMAST (ACCTNO, AFACCTNO, CUSTODYCD, BONDCODE, BONDSYMBOL, TRADE, BLOCKED, STATUS)
                VALUES (v_strRACCTNO , v_strRAFACCTNO, v_strRCUSTODYCD, v_strCODEID , v_strSYMBOL, v_nTQTTY, 0.00, 'A');
        ELSE
            SELECT B.TRADE INTO v_rtrade FROM BONDSEMAST B WHERE B.ACCTNO = v_strRACCTNO;
            UPDATE BONDSEMAST SET TRADE = TRADE + ROUND(v_nTQTTY,0) WHERE ACCTNO = v_strRACCTNO;
        END IF;
        --
        INSERT INTO BONDSETRAN (TXNUM, TXDATE, ACCTNO, TXCD, NAMT, CAMT, REF, DELTD, AUTOID, ACCTREF, TLTXCD, BKDATE, TRDESC)
            VALUES (v_txnum, v_txdate, v_strRACCTNO, '1902', v_nTQTTY
                   , null, v_strRACCTNO, 'N', SEQ_BONDSETRAN.NEXTVAL, v_strSACCTNO, p_txmsg.tltxcd, v_busdate, v_strDESC);
        --==============================DOI VOI TAI KHOAN CHUYEN NHUONG================================================================

        --
        SELECT B.TRADE INTO v_strade FROM BONDSEMAST B WHERE B.ACCTNO = v_strSACCTNO;
        UPDATE BONDSEMAST SET TRADE = TRADE - ROUND(v_nTQTTY,0) WHERE ACCTNO = v_strSACCTNO;
        --
        INSERT INTO BONDSETRAN (TXNUM, TXDATE, ACCTNO, TXCD, NAMT, CAMT, REF, DELTD, AUTOID, ACCTREF, TLTXCD, BKDATE, TRDESC)
            VALUES (v_txnum, v_txdate, v_strSACCTNO, '1903', v_nTQTTY
                   , null, v_strSACCTNO, 'N', SEQ_BONDSETRAN.NEXTVAL, v_strRACCTNO, p_txmsg.tltxcd, v_busdate , v_strDESC);
       --gui email
       nmpks_ems.pr_GenTemplateEM33(P_CODEID     => v_strCODEID,
                                    P_SCUSTODYCD => v_strSCUSTODYCD,
                                    P_RCUSTODYCD => v_strRCUSTODYCD,
                                    P_QTTY       => v_nTQTTY);
       -- BAO.NGUYEN LOG DATA CUA GIAO DICH 1911
       SELECT CF.CIFID INTO v_scifid FROM CFMAST CF WHERE CF.CUSTODYCD = v_strSCUSTODYCD;
       SELECT CF.CIFID INTO v_rcifid FROM CFMAST CF WHERE CF.CUSTODYCD = v_strRCUSTODYCD;

       INSERT INTO DATALOG_1911(TXNUM, TXDATE, BUSDATE, SCIFID, SCUSTODYCD, SFULLNAME, SYMBOL, TQTTY, BALANCETRANS, BALANCERCV, RCIFID, RCUSTODYCD, RFULLNAME, SECTYPE, AGREEMENTNO, AGREEMENTDATE, ACCTNO, RACCTNO, MQTTY, DESCRIPTION)
       VALUES(V_TXNUM, V_TXDATE, V_BUSDATE, V_SCIFID, v_strSCUSTODYCD, p_txmsg.txfields('90').value, v_strSYMBOL, v_nTQTTY, v_strade, v_rtrade, V_RCIFID, v_strRCUSTODYCD, p_txmsg.txfields('91').value, p_txmsg.txfields('08').value, p_txmsg.txfields('04').value, p_txmsg.txfields('05').value, p_txmsg.txfields('09').value, p_txmsg.txfields('11').value, p_txmsg.txfields('06').value, v_strDESC);
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
         plog.init ('TXPKS_#1911EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1911EX;
/
