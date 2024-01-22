SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1408ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1408EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      07/04/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1408ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_type             CONSTANT CHAR(2) := '03';
   c_crphysagreeid    CONSTANT CHAR(2) := '88';
   c_custodycd        CONSTANT CHAR(2) := '18';
   c_fullname         CONSTANT CHAR(2) := '90';
   c_symbol           CONSTANT CHAR(2) := '33';
   c_codeid           CONSTANT CHAR(2) := '01';
   c_citad            CONSTANT CHAR(2) := '06';
   c_bankcode         CONSTANT CHAR(2) := '32';
   c_bankacctno       CONSTANT CHAR(2) := '02';
   c_clvalue          CONSTANT CHAR(2) := '55';
   c_tax              CONSTANT CHAR(2) := '19';
   c_remamt           CONSTANT CHAR(2) := '09';
   c_ccyname          CONSTANT CHAR(2) := '35';
   c_faceamt          CONSTANT CHAR(2) := '12';
   c_amt              CONSTANT CHAR(2) := '10';
   c_feetype          CONSTANT CHAR(2) := '16';
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
   L_SUMAMT           NUMBER(20,4);
   L_CLVALUE          NUMBER(20,4);
   L_TLTXCD           VARCHAR2(10);
   L_APPENDIXID       VARCHAR2(20);
   L_CRPHYSAGREEID    VARCHAR2(20);
   v_custid           varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
    --
    BEGIN
        SELECT CF.CUSTID
        INTO V_CUSTID
        FROM CFMAST CF
        WHERE CF.CUSTODYCD = p_txmsg.txfields(c_custodycd).value;
    END;
    L_TLTXCD        := p_txmsg.txfields('03').value;
    --NAM.LY: 1400,1407 dung chung giao dich 1401
    L_APPENDIXID    := p_txmsg.txfields('88').value;
    L_CRPHYSAGREEID := p_txmsg.txfields('88').value;
    IF p_txmsg.deltd <> 'Y' THEN
        IF (L_TLTXCD = '1400') THEN
            BEGIN

                --trung.luu: 02-07-2020 log lai de len view physical
                --bao.nguyen: 25-07-2022 SHBVNEX-2730
               insert into CRPHYSAGREE_LOG_ALL (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC,CITAD,TLTXCD,FEETYPE,SYMBOL,CUSTODYCD,typedoc, custid)
               values (p_txmsg.txdate, p_txmsg.txnum,'CTS',p_txmsg.txfields(c_crphysagreeid).value ,null, P_TXMSG.TXFIELDS(C_FACEAMT).VALUE, P_TXMSG.TXFIELDS(C_AMT).VALUE, null,null, 'A', 'N',p_txmsg.txfields(c_desc).value,p_txmsg.txfields('06').value,p_txmsg.tltxcd,p_txmsg.txfields('16').value,p_txmsg.txfields('33').value,p_txmsg.txfields('18').value,L_TLTXCD, v_custid);


                INSERT INTO CRPHYSAGREE_LOG (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC)
                VALUES (P_TXMSG.TXDATE, P_TXMSG.TXNUM, 'T', P_TXMSG.TXFIELDS(C_CRPHYSAGREEID).VALUE, NULL, P_TXMSG.TXFIELDS(C_FACEAMT).VALUE, P_TXMSG.TXFIELDS(C_AMT).VALUE, NULL, NULL, 'A', 'N',  P_TXMSG.TXFIELDS(C_DESC).VALUE);
                --
                BEGIN
                     SELECT SUM(CR.AMT) INTO L_SUMAMT FROM CRPHYSAGREE_LOG CR WHERE CR.APPENDIXID = L_APPENDIXID AND CR.TYPE = 'T' AND CR.DELTD <> 'Y';
                     EXCEPTION WHEN OTHERS THEN L_SUMAMT := 0;
                END;
                --
                BEGIN
                     SELECT AP.CLVALUE INTO L_CLVALUE FROM APPENDIX AP WHERE AP.AUTOID = L_APPENDIXID;
                     EXCEPTION WHEN OTHERS THEN L_CLVALUE := 0;
                END;
                --
                IF L_SUMAMT >= L_CLVALUE THEN
                    UPDATE APPENDIX AP SET AP.PAYSTATUS = 'T' WHERE AP.AUTOID = L_APPENDIXID;
                END IF;
            END;
        ELSIF (L_TLTXCD = '1407') THEN
            BEGIN

                 --trung.luu: 02-07-2020 log lai de len view physical
                 --bao.nguyen: 25-07-2022 SHBVNEX-2730
               insert into CRPHYSAGREE_LOG_ALL (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC,CITAD,TLTXCD,FEETYPE,SYMBOL,CUSTODYCD,typedoc, custid)
               values (p_txmsg.txdate, p_txmsg.txnum,'CTS',null,p_txmsg.txfields(c_crphysagreeid).value , P_TXMSG.TXFIELDS(C_FACEAMT).VALUE, P_TXMSG.TXFIELDS(C_AMT).VALUE, null,null, 'A', 'N',p_txmsg.txfields(c_desc).value,p_txmsg.txfields('06').value,p_txmsg.tltxcd,p_txmsg.txfields('16').value,p_txmsg.txfields('33').value,p_txmsg.txfields('18').value,L_TLTXCD, v_custid);


                INSERT INTO CRPHYSAGREE_LOG (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC)
                VALUES (P_TXMSG.TXDATE, P_TXMSG.TXNUM, 'T', NULL, P_TXMSG.TXFIELDS(C_CRPHYSAGREEID).VALUE, P_TXMSG.TXFIELDS(C_FACEAMT).VALUE, P_TXMSG.TXFIELDS(C_AMT).VALUE, NULL, NULL, 'A', 'N',  P_TXMSG.TXFIELDS(C_DESC).VALUE);
                --
                BEGIN
                     SELECT SUM(CR.AMT) INTO L_SUMAMT FROM CRPHYSAGREE_LOG CR WHERE CR.CRPHYSAGREEID = L_CRPHYSAGREEID AND CR.TYPE = 'T' AND CR.DELTD <> 'Y';
                     EXCEPTION WHEN OTHERS THEN L_SUMAMT := 0;
                END;
                --
                BEGIN
                     SELECT CR.CLVALUE INTO L_CLVALUE FROM CRPHYSAGREE CR WHERE CR.CRPHYSAGREEID = L_CRPHYSAGREEID;
                     EXCEPTION WHEN OTHERS THEN L_CLVALUE := 0;
                END;
                --
                IF L_SUMAMT >= L_CLVALUE THEN
                    UPDATE CRPHYSAGREE CR SET CR.PAYSTATUS = 'T' WHERE CR.CRPHYSAGREEID = L_CRPHYSAGREEID;
                END IF;
            END;
        END IF;
    ELSE --Revert trans
        UPDATE TLLOG
        SET DELTD = 'Y'
        WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
        --
        UPDATE CRPHYSAGREE_LOG CR SET CR.DELTD = 'Y' WHERE CR.TXDATE = p_txmsg.txdate AND CR.TXNUM = p_txmsg.txnum;
        --
        IF (L_TLTXCD = '1400') THEN
           UPDATE APPENDIX AP SET AP.PAYSTATUS = 'P' WHERE AP.AUTOID = L_APPENDIXID AND AP.PAYSTATUS = 'T';
        ELSIF (L_TLTXCD = '1407') THEN
           UPDATE CRPHYSAGREE CR SET CR.PAYSTATUS = 'A' WHERE CR.CRPHYSAGREEID = L_CRPHYSAGREEID AND CR.PAYSTATUS = 'T';
        END IF;
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
         plog.init ('TXPKS_#1408EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1408EX;
/
