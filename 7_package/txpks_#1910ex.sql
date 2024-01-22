SET DEFINE OFF;
CREATE OR REPLACE PACKAGE TXPKS_#1910EX
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1910EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      12/02/2020     Created
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


CREATE OR REPLACE PACKAGE BODY TXPKS_#1910EX
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_refid            CONSTANT CHAR(2) := '00';
   c_actiondate       CONSTANT CHAR(2) := '01';
   c_symbol           CONSTANT CHAR(2) := '09';
   c_codeid           CONSTANT CHAR(2) := '08';
   c_contractdate     CONSTANT CHAR(2) := '03';
   c_contractno       CONSTANT CHAR(2) := '02';
   c_fullname         CONSTANT CHAR(2) := '90';
   c_issuecode        CONSTANT CHAR(2) := '04';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_ddacctno         CONSTANT CHAR(2) := '05';
   c_blockdate        CONSTANT CHAR(2) := '06';
   c_unblockamt       CONSTANT CHAR(2) := '07';
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
    l_reqid        varchar2(200);
    v_strCODEID    varchar2(10);
    v_strACCTNO    varchar2(20);
    v_strAFACCTNO  varchar2(20);
    v_strDDACCTNO  varchar2(20);
    v_strISSUESID  varchar2(20);
    v_strCUSTODYCD varchar2(20);
    v_strDESC      varchar2(2000);
    v_nUNBLOCKAMT  number;
    v_mACTIONDATE  date;
    v_txnum        varchar2(20);
    v_txdate       date;
    v_strREFID     number;
    v_txnumBLOCK   varchar2(50);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_strCODEID    := p_txmsg.txfields(c_codeid).value;
    v_strDDACCTNO  := p_txmsg.txfields(c_ddacctno).value;
    v_nUNBLOCKAMT  := TO_NUMBER(p_txmsg.txfields(c_unblockamt).value);
    v_strCUSTODYCD := p_txmsg.txfields(c_custodycd).value;
    v_strDESC      := p_txmsg.txfields(c_desc).value;
    v_mACTIONDATE  := TO_DATE(p_txmsg.txfields(c_actiondate).value,'DD/MM/RRRR');
    v_txnum        := p_txmsg.txnum;
    v_txdate       := TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
    v_strREFID     := p_txmsg.txfields(c_refid).value;
    --
    IF p_txmsg.deltd <> 'Y' THEN
        BEGIN
                SELECT ACCTNO, AFACCTNO, ISSUESID, REQTXNUM INTO v_strACCTNO, v_strAFACCTNO, v_strISSUESID, v_txnumBLOCK
                FROM BLOCKAGE
                WHERE AUTOID = v_strREFID AND TLTXCD ='1909';
        END;
        --
        UPDATE BLOCKAGE
        SET STATUS = 'Y'
        WHERE AUTOID = v_strREFID;
        --
        INSERT INTO BLOCKAGE (AUTOID, TLTXCD, CODEID, ACCTNO, DDACCTNO, AFACCTNO, CUSTODYCD, ISSUESID, TXNUM, TXDATE,
                              ACTIONDATE, AMT, STATUS, DELTD, DESCRIPTION, REFID)
        VALUES (SEQ_BLOCKAGE.NEXTVAL, '1910', v_strCODEID, v_strACCTNO, v_strDDACCTNO, v_strAFACCTNO, v_strCUSTODYCD, v_strISSUESID, v_txnum, v_txdate,
                v_mACTIONDATE ,v_nUNBLOCKAMT, 'N', 'N', v_strDESC, v_strREFID);
        ---
        l_reqid := fn_getglobalid(p_txmsg.txdate, p_txmsg.txnum);
        BEGIN
            PCK_BANKAPI.BANK_UNHOLDBALANCE(
                                          v_txnumBLOCK,  ---txnum cua giao dich hold
                                          v_strDDACCTNO,  --- tk ddmast
                                          v_nUNBLOCKAMT,  -- so tien
                                          'UNHOLD1910', --request code cua nghiep vu trong allcode
                                          l_reqid,  --requestkey duy nhat de truy lai giao dich goc
                                          v_strDESC,  -- dien giai
                                          systemnums.C_SYSTEM_USERID, -- nguoi tao giao dich
                                          P_ERR_CODE);
            IF P_ERR_CODE <> systemnums.C_SUCCESS THEN
                
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
            EXCEPTION WHEN OTHERS THEN
                plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
        END;
    ELSE --Revert trans
        UPDATE TLLOG
        SET DELTD = 'Y'
        WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
        --
        UPDATE BLOCKAGE
        SET DELTD = 'Y'
        WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
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
         plog.init ('TXPKS_#1910EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1910EX;
/
