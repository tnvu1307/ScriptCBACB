SET DEFINE OFF;
CREATE OR REPLACE PACKAGE TXPKS_#1901EX
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1901EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      14/11/2019     Created
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


CREATE OR REPLACE PACKAGE BODY TXPKS_#1901EX
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '44';
   c_codeid           CONSTANT CHAR(2) := '01';
   c_custodycd        CONSTANT CHAR(2) := '88';
   --NAM.LY: bo Bondcode thay bang IssueCode (bang ISSUES) -SHBVNEX-167
   --c_bondcode         CONSTANT CHAR(2) := '09';
   c_issuesid         CONSTANT CHAR(2) := '08';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_plamt            CONSTANT CHAR(2) := '20';
   c_amt              CONSTANT CHAR(2) := '10';
   c_custatcom        CONSTANT CHAR(2) := '11';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
V_QTT_REMAIN NUMBER;
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txPreAppCheck');
   plog.debug(pkgctx,'BEGIN OF fn_txPreAppCheck');
   --*************************************TRIBUI**************************************************************
    BEGIN
        SELECT  MT.QTTY INTO V_QTT_REMAIN
        FROM (
             SELECT SE.ACCTNO, SE.AFACCTNO, SE.ISSUESID,
             SUM(CASE WHEN SE.TLTXCD IN ('1900') THEN SE.QTTY
                      WHEN SE.TLTXCD IN ('1901') THEN -SE.QTTY ELSE 0 END) QTTY
             FROM SEMORTAGE SE
             WHERE SE.STATUS IN ('C')
                   AND SE.ISSUESID IS NOT NULL
             GROUP BY SE.ACCTNO, SE.AFACCTNO,SE.ISSUESID
        )MT, SEMAST SE, SBSECURITIES SB, AFMAST AF, CFMAST CF, ISSUERS ISS, ISSUES I1
        WHERE MT.ACCTNO = SE.ACCTNO 
              --AND SE.MORTAGE > 0 
              AND SE.CODEID = SB.CODEID
              AND SE.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID AND MT.QTTY > 0
              AND I1.AUTOID = MT.ISSUESID
              AND ISS.ISSUERID = I1.ISSUERID
              --AND CF.CUSTATCOM = 'N' 
              AND CF.CUSTODYCD= p_txmsg.txfields('88').value
              AND SB.SYMBOL = p_txmsg.txfields('04').value
              AND SE.AFACCTNO= p_txmsg.txfields('02').value
              AND I1.ISSUECODE= p_txmsg.txfields('08').value;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_QTT_REMAIN:=0 ;  
    END;
    -------------------------------
    IF V_QTT_REMAIN < p_txmsg.txfields('10').value THEN
       P_ERR_CODE := '-100551';
       PLOG.SETENDSECTION (PKGCTX, 'FN_TXPREAPPCHECK');
       RETURN ERRNUMS.C_BIZ_RULE_INVALID;
    END IF;
   --***************************************************************************************************
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
  v_issuesid varchar2(50);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    BEGIN
        SELECT AUTOID INTO v_issuesid FROM ISSUES WHERE ISSUECODE = p_txmsg.txfields('08').value;
        EXCEPTION
            WHEN OTHERS THEN v_issuesid := '';
    END;

    IF p_txmsg.deltd <> 'Y' THEN
        INSERT INTO semortage (AUTOID,ACCTNO,AFACCTNO,TLTXCD,TXNUM,TXDATE,QTTY,STATUS,DELTD,PSTATUS,TXNUM_MTG,TXDATE_MTG,DESCRIPTION, ISSUESID)
            VALUES(seq_semortage.nextval, p_txmsg.txfields(c_acctno).value, p_txmsg.txfields(c_afacctno).value, p_txmsg.tltxcd
                 , p_txmsg.txnum, p_txmsg.txdate, p_txmsg.txfields(c_amt).value, 'C', 'N', 'N',NULL,NULL
                 , p_txmsg.txfields(c_desc).value, v_issuesid);
    ELSE
        DELETE FROM SEMORTAGE WHERE TXDATE = p_txmsg.txdate AND TXNUM = p_txmsg.txnum;
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
         plog.init ('TXPKS_#1901EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1901EX;
/
