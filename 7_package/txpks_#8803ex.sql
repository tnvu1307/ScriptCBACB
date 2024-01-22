SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8803ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8803EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      02/03/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#8803ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_codeid           CONSTANT CHAR(2) := '01';
   c_orderid          CONSTANT CHAR(2) := '06';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_custid           CONSTANT CHAR(2) := '04';
   c_ddacctno         CONSTANT CHAR(2) := '12';
   c_seacctno         CONSTANT CHAR(2) := '13';
   c_txnum            CONSTANT CHAR(2) := '14';
   c_tradedate        CONSTANT CHAR(2) := '15';
   c_price            CONSTANT CHAR(2) := '10';
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
    v_orstatus varchar2(10);
    v_ispayment varchar2(10);
    v_odtype varchar2(10);
    n_qtty number;
    n_gross number;
    n_net number;
    v_custodycd varchar(100);
    v_ddacctno varchar(100);
    v_seacctno varchar(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        --lay thong tin lenh
        begin
            select od.exectype, od.orderqtty, od.EXECAMT, od.netamount, od.custodycd, od.ddacctno, od.seacctno, od.orstatus, od.ispayment
            into v_odtype, n_qtty, n_gross, n_net, v_custodycd, v_ddacctno, v_seacctno, v_orstatus, v_ispayment
            from odmast od
            where od.orderid = p_txmsg.txfields('06').VALUE;
        exception when NO_DATA_FOUND then
            v_seacctno:='';
            v_custodycd:='';
            v_ddacctno:='';
            v_odtype:='';
            n_qtty:=0;
            n_gross:=0;
            n_net:=0;
            v_orstatus := '';
            v_ispayment :='';
        end;

        
        if v_ispayment <> 'Y' and v_orstatus not in ('3', '5', '7') then

            UPDATE TLLOG SET reftxnum = p_txmsg.txfields('14').VALUE
            WHERE TXNUM = p_txmsg.TXNUM AND TXDATE = TO_DATE(p_txmsg.TXDATE, systemnums.C_DATE_FORMAT);
            /*
            UPDATE TLLOG
                SET DELTD = 'Y'
                    WHERE TXNUM = p_txmsg.txfields('14').VALUE AND TXDATE = TO_DATE(p_txmsg.txfields('15').VALUE, systemnums.C_DATE_FORMAT);
            UPDATE TLLOGALL
                SET DELTD = 'Y'
                    WHERE TXNUM = p_txmsg.txfields('14').VALUE AND TXDATE = TO_DATE(p_txmsg.txfields('15').VALUE, systemnums.C_DATE_FORMAT);
            */
            -- Xu ly doi voi tien
            FOR REC IN (
                SELECT DISTINCT TRIM(CF.FEEDAILY) FEEDAILY
                FROM ODMAST OD, SBSECURITIES SB, CFMAST CF
                WHERE OD.CODEID = SB.CODEID
                AND OD.CUSTID = CF.CUSTID
                --AND SB.TRADEPLACE = '099'
                AND OD.ORDERID = P_TXMSG.TXFIELDS('06').VALUE
            )
            LOOP
                if REC.FEEDAILY = 'Y' then -- v_feedaily = 'Y' => hold theo tien net => revert tien net
                    if v_odtype = 'NB' then
                        INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                        VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_ddacctno,'0010',n_net,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(p_txmsg.TXDATE,'dd/MM/RRRR'),'' || '' || '');

                        update ddmast set netting = netting - n_net where acctno = v_ddacctno;
                    else
                        INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                        VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_ddacctno,'0008',n_net,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(p_txmsg.TXDATE,'dd/MM/RRRR'),'' || '' || '');

                        update ddmast set receiving = receiving - n_net where acctno = v_ddacctno;
                    end if;
                else
                    if v_odtype = 'NB' then
                        INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                        VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_ddacctno,'0010',n_gross,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(p_txmsg.TXDATE,'dd/MM/RRRR'),'' || '' || '');

                        update ddmast set netting = netting - n_gross where acctno = v_ddacctno;
                    else
                        INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                        VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_ddacctno,'0008',n_net,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(p_txmsg.TXDATE,'dd/MM/RRRR'),'' || '' || '');

                        update ddmast set receiving = receiving - n_gross where acctno = v_ddacctno;
                    end if;
                end if;
                 -- Xu ly doi voi CK
                if v_odtype = 'NB' then
                    INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_seacctno,'0015',n_qtty,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(p_txmsg.TXDATE,'dd/MM/RRRR'),'' || '' || '');

                    update semast set receiving = receiving - n_qtty where acctno = v_seacctno;
                else
                    INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_seacctno,'0012',n_qtty,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(p_txmsg.TXDATE,'dd/MM/RRRR'),'' || '' || '');

                    INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_seacctno,'0020',n_qtty,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(p_txmsg.TXDATE,'dd/MM/RRRR'),'' || '' || '');

                    update semast set trade = trade + n_qtty where acctno = v_seacctno;
                    update semast set netting = netting - n_qtty where acctno = v_seacctno;
                end if;
            END LOOP;
             -- Xu ly doi voi odmast

            update odmast
            set orstatus = '3', deltd = 'Y'
            where orderid = p_txmsg.txfields('06').VALUE;

            update stschd
            set status = 'C', deltd = 'Y'
            where orderid = p_txmsg.txfields('06').VALUE;

            update stschdhist
            set status = 'C', deltd = 'Y'
            where orderid = p_txmsg.txfields('06').VALUE;

            update iod
            set orstatus = 'C', deltd = 'Y'
            where orderid = p_txmsg.txfields('06').VALUE;

            update iodhist
            set orstatus = 'C', deltd = 'Y'
            where orderid = p_txmsg.txfields('06').VALUE;

            Update tblconfirm_compare_import set deltd ='Y' where orderid = p_txmsg.txfields('06').VALUE;
            Update tblcompare_trading_result set deltd ='Y' where orderid = p_txmsg.txfields('06').VALUE;
            update odmastcmp set ISODMAST = 'N' where orderid = p_txmsg.txfields('06').VALUE;
            update odmastcust set ISODMAST = 'N' where orderid = p_txmsg.txfields('06').VALUE;
            update odmastvsd set ISODMAST = 'N' where orderid = p_txmsg.txfields('06').VALUE;
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
         plog.init ('TXPKS_#8803EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8803EX;
/
