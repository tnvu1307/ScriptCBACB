SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#2208ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2208EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      31/10/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#2208ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_otcodid          CONSTANT CHAR(2) := '03';
   c_exectype         CONSTANT CHAR(2) := '02';
   c_crttxdate        CONSTANT CHAR(2) := '04';
   c_effdate          CONSTANT CHAR(2) := '05';
   c_bcustodycd       CONSTANT CHAR(2) := '88';
   c_bfullname        CONSTANT CHAR(2) := '89';
   c_bbankaccount     CONSTANT CHAR(2) := '82';
   c_scustid          CONSTANT CHAR(2) := '71';
   c_scustodycd       CONSTANT CHAR(2) := '78';
   c_sfullname        CONSTANT CHAR(2) := '79';
   c_sbankaccount     CONSTANT CHAR(2) := '72';
   c_sbankid          CONSTANT CHAR(2) := '73';
   c_codeid           CONSTANT CHAR(2) := '06';
   c_symbol           CONSTANT CHAR(2) := '07';
   c_qtty             CONSTANT CHAR(2) := '10';
   c_price            CONSTANT CHAR(2) := '11';
   c_amt              CONSTANT CHAR(2) := '12';
   c_fee              CONSTANT CHAR(2) := '13';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_count number;
    l_seacctno  varchar2(60);
    l_NETTING   number;
    l_status    varchar2(3);
    l_semastcheck_arr txpks_check.semastcheck_arrtype;
    l_sewithdrawcheck_arr txpks_check.sewithdrawcheck_arrtype;
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
    IF p_txmsg.deltd <> 'Y' THEN
        --Khong tim thay so hop dong
        select count(*) into l_count
        from OTCODMAST es
        where AUTOID = p_txmsg.txfields('01').value
            and DELTD <> 'Y';
        if l_count = 0 then
            p_err_code := '-180023';
            
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

        --Khong tim thay so hop dong
        select count(*) into l_count
        from OTCODMAST es
        where AUTOID = p_txmsg.txfields('01').value and es.sestatus in ('PC','BC') and ((es.ddstatus = 'P' AND es.istrfcash='Y') or (es.ddstatus = 'C' AND es.istrfcash='N'))
            and DELTD <> 'Y';
        if l_count = 0 then
            p_err_code := '-180022';
            
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

        select max(se.acctno), count(*) into  l_seacctno, l_count
        from OTCODMAST ot, AFMAST AF, SEMAST SE
        WHERE OT.scustid = AF.CUSTID
            AND AF.ACCTNO = SE.AFACCTNO
            AND SE.CODEID = OT.CODEID
            AND OT.autoid = p_txmsg.txfields('01').value;
        if l_count > 0 then
            l_SEMASTcheck_arr := txpks_check.fn_SEMASTcheck(l_seacctno,'SEMAST','ACCTNO');
            l_STATUS := l_SEMASTcheck_arr(0).STATUS;
            l_NETTING := l_SEMASTcheck_arr(0).NETTING;

            IF NOT ( INSTR('A',l_STATUS) > 0) THEN
                p_err_code := '-900019';
                
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
            IF NOT (to_number(l_NETTING) >= to_number(p_txmsg.txfields('10').value)) THEN
                p_err_code := '-200403';
                
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;

        end if;

    ELSE -- Revert GD
        --Khong tim thay so hop dong
        select count(*) into l_count
        from OTCODMAST es
        where AUTOID = p_txmsg.txfields('01').value
            and DELTD = 'Y';
        if l_count = 0 then
            p_err_code := '-180022';
            
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
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
    l_seacctno  varchar2(60);
    l_count     number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN
        select max(se.acctno), count(*) into  l_seacctno, l_count
        from OTCODMAST ot, AFMAST AF, SEMAST SE
        WHERE OT.scustid = AF.CUSTID
            AND AF.ACCTNO = SE.AFACCTNO
            AND SE.CODEID = OT.CODEID
            AND OT.autoid = p_txmsg.txfields('01').value;

        if l_count > 0 then
            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_seacctno,'0020',ROUND(to_number(p_txmsg.txfields('10').value),0),NULL,p_txmsg.txfields ('88').value,p_txmsg.deltd,null,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_seacctno,'0045',ROUND(to_number(p_txmsg.txfields('10').value),0),NULL,p_txmsg.txfields ('88').value,p_txmsg.deltd,null,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            UPDATE SEMAST
             SET
               NETTING = NETTING - (ROUND(p_txmsg.txfields('10').value,0)),
               TRADE = TRADE + (ROUND(p_txmsg.txfields('10').value,0)), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO = l_seacctno;
        end if;

        update OTCODMAST
        set deltd = 'Y'
        where autoid = p_txmsg.txfields('01').value and deltd = 'N';
    ELSE
        update OTCODMAST
        set deltd = 'N'
        where autoid = p_txmsg.txfields('01').value and deltd = 'Y';

        select max(se.acctno), count(*) into  l_seacctno, l_count
        from OTCODMAST ot, AFMAST AF, SEMAST SE
        WHERE OT.scustid = AF.CUSTID
            AND AF.ACCTNO = SE.AFACCTNO
            AND SE.CODEID = OT.CODEID
            AND OT.autoid = p_txmsg.txfields('01').value;

        if l_count > 0 then
            UPDATE SETRAN        SET DELTD = 'Y'
            WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);

            UPDATE SEMAST
             SET
               NETTING = NETTING + (ROUND(p_txmsg.txfields('10').value,0)),
               TRADE = TRADE - (ROUND(p_txmsg.txfields('10').value,0)), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO = l_seacctno;
        end if;

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
         plog.init ('TXPKS_#2208EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2208EX;
/
