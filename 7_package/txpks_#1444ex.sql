SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1444ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1444EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      17/03/2021     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1444ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_crphysagreeid    CONSTANT CHAR(2) := '05';
   c_crphysagreeno    CONSTANT CHAR(2) := '06';
   c_txdate           CONSTANT CHAR(2) := '20';
   c_txnum            CONSTANT CHAR(2) := '07';
   c_appendixid       CONSTANT CHAR(2) := '08';
   c_appendixname     CONSTANT CHAR(2) := '09';
   c_effdate          CONSTANT CHAR(2) := '11';
   c_symbol           CONSTANT CHAR(2) := '12';
   c_cifid            CONSTANT CHAR(2) := '13';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_custodycdbuy     CONSTANT CHAR(2) := '89';
   c_fullname         CONSTANT CHAR(2) := '90';
   c_avqtty           CONSTANT CHAR(2) := '14';
   c_sellqtty         CONSTANT CHAR(2) := '15';
   c_amtsell          CONSTANT CHAR(2) := '16';
   c_tax              CONSTANT CHAR(2) := '17';
   c_taxableparty     CONSTANT CHAR(2) := '18';
   c_netamt           CONSTANT CHAR(2) := '19';
   c_settledate       CONSTANT CHAR(2) := '21';
   c_paystatus        CONSTANT CHAR(2) := '22';
   c_paystatusval     CONSTANT CHAR(2) := '25';
   c_balancestatusval   CONSTANT CHAR(2) := '26';
   c_balancestatus    CONSTANT CHAR(2) := '23';
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
    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
         IF p_txmsg.txfields('25').value ='Y' OR p_txmsg.txfields('26').value = 'Y' THEN
            p_err_code := '-930104';
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
V_AQTTY NUMBER;
l_sellseacctno VARCHAR2(100);
v_check_custody  VARCHAR2(10);
l_buyseacctno    SEMAST.AFACCTNO%TYPE;
L_BUYCODEID VARCHAR2(100);
v_custid        varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    BEGIN
        SELECT CF.CUSTID
        INTO V_CUSTID
        FROM CFMAST CF
        WHERE CF.CUSTODYCD = p_txmsg.txfields(c_custodycd).value;
    END;
    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction


       SELECT AQTTY INTO V_AQTTY FROM APPENDIX WHERE AUTOID  =p_txmsg.txfields('08').value;
       SELECT acctno || codeid INTO l_sellseacctno FROM crphysagree WHERE  crphysagreeid = p_txmsg.txfields('05').value;
       --trung.luu: 02-07-2020 log lai de len view physical
       --bao.nguyen: 25-07-2022 SHBVNEX-2730
       insert into CRPHYSAGREE_LOG_ALL (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC,CITAD,TLTXCD, custid)
       values (p_txmsg.txdate, p_txmsg.txnum,'CP',p_txmsg.txfields('08').value , p_txmsg.txfields('05').value , NULL, NULL, NULL, V_AQTTY, 'A', 'N',p_txmsg.txfields(c_desc).value,null,p_txmsg.tltxcd, v_custid);


        UPDATE semast se
        SET se.trade = se.trade + V_AQTTY,
            se.netting = se.netting - V_AQTTY
        WHERE se.acctno = l_sellseacctno;
        --
        INSERT INTO SETRAN (TXNUM, TXDATE, ACCTNO, TXCD, NAMT, CAMT, REF, DELTD, AUTOID, ACCTREF, TLTXCD, BKDATE, TRDESC)
        VALUES (p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT), l_sellseacctno, '0012', V_AQTTY, null, null, 'N', seq_setran.nextval, null, p_txmsg.tltxcd, to_date(p_txmsg.busdate, systemnums.C_DATE_FORMAT), null);
        --
        INSERT INTO SETRAN (TXNUM, TXDATE, ACCTNO, TXCD, NAMT, CAMT, REF, DELTD, AUTOID, ACCTREF, TLTXCD, BKDATE, TRDESC)
        VALUES (p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT), l_sellseacctno, '0020', V_AQTTY, null, null, 'N', seq_setran.nextval, null, p_txmsg.tltxcd, to_date(p_txmsg.busdate, systemnums.C_DATE_FORMAT), null);


        SELECT CODEID INTO L_BUYCODEID  FROM sbsecurities WHERE SYMBOL = p_txmsg.txfields('12').value;
        BEGIN
            SELECT CF.CUSTID || L_BUYCODEID
                INTO l_buyseacctno
            FROM cfmast cf
            WHERE cf.custodycd = p_txmsg.txfields('89').value;
            SELECT buymember  INTO v_check_custody  FROM crphysagree_sell_log WHERE appendixid = p_txmsg.txfields('08').value;
        EXCEPTION
            WHEN OTHERS
               THEN
                l_buyseacctno :='';
                v_check_custody := '';
        END;
        IF v_check_custody = 'SHV' THEN
            BEGIN
                UPDATE SEMAST SE
                    SET
                        SE.RECEIVING = SE.RECEIVING - V_AQTTY
                WHERE SE.ACCTNO = l_buyseacctno;
                --
                INSERT INTO SETRAN (TXNUM, TXDATE, ACCTNO, TXCD, NAMT, CAMT, REF, DELTD, AUTOID, ACCTREF, TLTXCD, BKDATE, TRDESC)
                VALUES (p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT), l_buyseacctno, '0015', V_AQTTY, null, null, 'N', seq_setran.nextval, null, p_txmsg.tltxcd, to_date(p_txmsg.busdate, systemnums.C_DATE_FORMAT), null);
            END;
        END IF;

        UPDATE crphysagree cr
            set cr.reqtty = cr.reqtty - V_AQTTY
        WHERE cr.crphysagreeid = p_txmsg.txfields('05').value;



        UPDATE APPENDIX SET DELTD = 'Y' WHERE AUTOID  =p_txmsg.txfields('08').value;
        UPDATE crphysagree_sell_log SET DELTD = 'I' WHERE appendixid = p_txmsg.txfields('08').value;
         update CRPHYSAGREE_LOG_ALL set deltd = 'I' where CRPHYSAGREEID = p_txmsg.txfields('05').value;


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
         plog.init ('TXPKS_#1444EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1444EX;
/
