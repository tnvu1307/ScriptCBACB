SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1404ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1404EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      29/11/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1404ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_crphysagreeid    CONSTANT CHAR(2) := '02';
   c_custodycd        CONSTANT CHAR(2) := '09';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_codeid           CONSTANT CHAR(2) := '01';
   c_setqtty          CONSTANT CHAR(2) := '55';
   c_qtty             CONSTANT CHAR(2) := '13';
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
v_receiving number;
v_acctno varchar2(30);
v_qtty number;
v_aqtty number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' then
        select cr.acctno||cr.codeid into v_acctno from crphysagree cr where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
        select se.receiving into v_receiving from semast se where se.acctno = v_acctno;
        ---
        select NVL(sum(crl.qtty),0) into v_qtty
        from CRPHYSAGREE_LOG crl
        where crl.type = 'R' and crl.deltd <> 'Y'
        and crl.crphysagreeid =  p_txmsg.txfields(c_crphysagreeid).value;
        select ap.qtty into v_aqtty from CRPHYSAGREE ap where ap.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
        if  p_txmsg.txfields(c_qtty).value > v_receiving or p_txmsg.txfields(c_qtty).value > (v_aqtty - v_qtty) then
            p_err_code:= -911005;
            
            plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
            Return errnums.C_BIZ_RULE_INVALID;
        end if;
    end if;
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
v_acctno varchar2(30);
v_sumqtty number;
v_qtty number;
v_tradeplace varchar2(5);
V_CUSTID VARCHAR2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    BEGIN
        SELECT CF.CUSTID INTO V_CUSTID FROM CFMAST CF WHERE CF.CUSTODYCD = p_txmsg.txfields(c_custodycd).value;
    END;
    select cr.acctno||cr.codeid into v_acctno from crphysagree cr where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
    -- Thoai.tran 14/04/2022
    -- Xu ly Ck listed/ unlisted
    BEGIN
        Select tradeplace into v_tradeplace from sbsecurities where codeid = p_txmsg.txfields(c_codeid).value;
        EXCEPTION WHEN OTHERS THEN v_tradeplace := '';
    END;
    if v_tradeplace <> '003' then
        IF p_txmsg.deltd <> 'Y' then

             update semast se
             set se.trade = trade + p_txmsg.txfields(c_qtty).value,
                 se.receiving = se.receiving - p_txmsg.txfields(c_qtty).value
             where se.acctno = v_acctno;

             INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                             VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_acctno,'0012',p_txmsg.txfields(c_qtty).value,NULL,'','N','',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
             INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                             VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_acctno,'0015',p_txmsg.txfields(c_qtty).value,NULL,'','N','',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

             --trung.luu: 02-07-2020 log lai de len view physical
             --bao.nguyen: 25-07-2022 SHBVNEX-2730
               insert into CRPHYSAGREE_LOG_ALL (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC,CITAD,TLTXCD,FEETYPE,CUSTODYCD,symbol,typedoc, CUSTID)
               values (p_txmsg.txdate, p_txmsg.txnum,'NP',null,p_txmsg.txfields(c_crphysagreeid).value ,NULL, NULL, p_txmsg.txfields(c_setqtty).value, p_txmsg.txfields(c_qtty).value, 'A', 'N',p_txmsg.txfields(c_desc).value,null,p_txmsg.tltxcd,null,p_txmsg.txfields('09').value,p_txmsg.txfields('04').value,'1407', V_CUSTID);

             insert into crphysagree_log (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC)
                 values (p_txmsg.txdate, p_txmsg.txnum, 'R', null, p_txmsg.txfields(c_crphysagreeid).value, null, null, p_txmsg.txfields(c_setqtty).value, p_txmsg.txfields(c_qtty).value, 'A', 'N', p_txmsg.txfields(c_desc).value);


             select sum(crl.qtty) into v_sumqtty from crphysagree_log crl where crl.type = 'R' and crl.deltd <> 'Y' and crl.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
             select cr.qtty into v_qtty from crphysagree cr where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
             if v_sumqtty = v_qtty then
                update crphysagree cr
                set
                    cr.balancestatus = 'R'
                where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
            end if;
        else
            UPDATE SETRAN SET DELTD = 'Y' WHERE TXNUM = P_TXMSG.TXNUM AND TXDATE = TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT);
            UPDATE CRPHYSAGREE_LOG_ALL SET DELTD = 'Y' WHERE TXNUM = P_TXMSG.TXNUM AND TXDATE = TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT);
            UPDATE CRPHYSAGREE_LOG SET DELTD = 'Y' WHERE TXNUM = P_TXMSG.TXNUM AND TXDATE = TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT);

            UPDATE SEMAST SE
            SET SE.TRADE = TRADE - P_TXMSG.TXFIELDS(C_QTTY).VALUE,
                SE.RECEIVING = SE.RECEIVING + P_TXMSG.TXFIELDS(C_QTTY).VALUE
            WHERE SE.ACCTNO = V_ACCTNO;

            SELECT SUM(CRL.QTTY) INTO V_SUMQTTY FROM CRPHYSAGREE_LOG CRL WHERE CRL.TYPE = 'R' AND CRL.DELTD <> 'Y' AND CRL.CRPHYSAGREEID = P_TXMSG.TXFIELDS(C_CRPHYSAGREEID).VALUE;
            SELECT CR.QTTY INTO V_QTTY FROM CRPHYSAGREE CR WHERE CR.CRPHYSAGREEID = P_TXMSG.TXFIELDS(C_CRPHYSAGREEID).VALUE;

            if v_sumqtty <> v_qtty then
                update crphysagree cr
                set cr.balancestatus = 'P'
                where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
            end if;
        END IF;
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
         plog.init ('TXPKS_#1404EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1404EX;
/
