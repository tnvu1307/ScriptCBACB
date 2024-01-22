SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#2217ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2217EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      31/07/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#2217ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_custname         CONSTANT CHAR(2) := '90';
   c_profoliocd       CONSTANT CHAR(2) := '91';
   c_escrowid         CONSTANT CHAR(2) := '92';
   c_symbol           CONSTANT CHAR(2) := '14';
   c_escrowqtty       CONSTANT CHAR(2) := '09';
   c_quantity         CONSTANT CHAR(2) := '10';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_holdtemp number;
v_qtty number;
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

        SELECT HOLD_SE_TEMP, QTTY INTO V_HOLDTEMP, V_QTTY
        FROM ESCROW
        WHERE ESCROWID = P_TXMSG.TXFIELDS('92').VALUE
        AND NVL(DELTD, 'N') = 'N';

        if p_txmsg.txfields('10').value > v_qtty - v_holdtemp then
            p_err_code := '-930108';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
        if p_txmsg.txfields('10').value <= 0 THEN
            p_err_code := '-930108';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
    end if;
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
v_seacctno varchar2(100);
v_custid varchar2(100);
v_codeid varchar2(100);
v_reqid     varchar2(200);
v_hold number;
v_amt number;
v_bcustodycd varchar2(250);
v_bcustid varchar2(250);
v_symbol varchar2(250);
v_escrowid varchar2(250);
v_count number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        v_reqid := fn_getglobalid(p_txmsg.txdate, p_txmsg.txnum);
        begin
            select custid into v_custid from cfmast where custodycd =p_txmsg.txfields('88').value ;
            select codeid into v_codeid from sbsecurities where symbol =p_txmsg.txfields('14').value ;
            v_seacctno := v_custid||v_codeid;
        exception when NO_DATA_FOUND
            then
            v_codeid := '';
            v_custid := '';
        end;
        
        SELECT COUNT(*) INTO v_count FROM SEMAST WHERE ACCTNO = v_seacctno;
        if v_count = 0 then
             INSERT INTO semast
                      (actype, custid, acctno,
                       codeid,
                       afacctno, opndate, lastdate,
                       costdt, tbaldt, status, irtied, ircd, costprice, trade,
                       mortage, margin, receiving, standing, withdraw, deposit, loan,temp
                      )
               VALUES ('0000', v_custid, v_seacctno,
                       v_codeid,
                       v_custid, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                       TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), 'A', 'Y', '000', 0, 0,
                       0, 0, 0, 0, 0, 0,0,p_txmsg.txfields('10').value
                      );
             INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
             VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_seacctno,'0106',p_txmsg.txfields('10').value,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(p_txmsg.txdate,'dd/MM/RRRR'),'' || '' || '');
        else
             INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                 VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_seacctno,'0106',p_txmsg.txfields('10').value,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(p_txmsg.txdate,'dd/MM/RRRR'),'' || '' || '');
             Update semast
                 set temp = temp + p_txmsg.txfields('10').value
                 where acctno = v_seacctno;

        end if;

        UPDATE ESCROW
        SET HOLD_SE_TEMP = HOLD_SE_TEMP + P_TXMSG.TXFIELDS('10').VALUE
        WHERE ESCROWID = P_TXMSG.TXFIELDS('92').VALUE
        AND NVL(DELTD, 'N') = 'N';


        --trung.luu: 15-10-2020 insert detail
        --ESCROW_HOLD_TEMP.hold_type = 'SE': chung khoan
        SELECT BCUSTID,BCUSTODYCD
        INTO V_BCUSTID,V_BCUSTODYCD
        FROM ESCROW
        WHERE ESCROWID = P_TXMSG.TXFIELDS('92').VALUE
        AND NVL(DELTD, 'N') = 'N';
        -- Thoai.tran 17/08/2021
        -- SHBVNEX-1310 Check xem da co hold escrow chua?
        select count(*) into v_count from ESCROW_HOLD_TEMP where escrowid = p_txmsg.txfields('92').value AND NVL(DELTD, 'N') = 'N';
        if v_count = 0 then
            insert into ESCROW_HOLD_TEMP ( autoid, escrowid, hold_type, scustid, scustodycd,--
                                           sseacctno, sbankaccount, bcustid, bcustodycd,
                                           bddacctno, codeid, symbol, hold_se, hold_dd, unhold,
                                           holdreqid, unholdreqid,deltd)
            values  (SEQ_ESCROW_HOLD_TEMP.nextval,p_txmsg.txfields('92').value,'SE',v_custid,p_txmsg.txfields('88').value,--
                                           v_seacctno,'',v_bcustid,v_bcustodycd,--
                                           '', v_codeid,p_txmsg.txfields('14').value,TO_NUMBER(p_txmsg.txfields('10').value),0,'N',--
                                           v_reqid,'','N');
       else
            update ESCROW_HOLD_TEMP set hold_se = hold_se + p_txmsg.txfields('10').value
            where escrowid = p_txmsg.txfields('92').value
            AND NVL(DELTD, 'N') = 'N';
       end if;

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
         plog.init ('TXPKS_#2217EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2217EX;
/
