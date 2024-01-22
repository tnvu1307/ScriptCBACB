SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3384ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3384EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      15/11/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3384ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '01';
   c_camastid         CONSTANT CHAR(2) := '02';
   c_custodycd        CONSTANT CHAR(2) := '96';
   c_afacctno         CONSTANT CHAR(2) := '03';
   c_ddacctno         CONSTANT CHAR(2) := '31';
   c_fullname         CONSTANT CHAR(2) := '08';
   c_codeid           CONSTANT CHAR(2) := '24';
   c_symbol_org       CONSTANT CHAR(2) := '71';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_exprice          CONSTANT CHAR(2) := '05';
   c_balance          CONSTANT CHAR(2) := '07';
   c_buyqtty          CONSTANT CHAR(2) := '26';
   c_maxqtty          CONSTANT CHAR(2) := '20';
   c_qtty             CONSTANT CHAR(2) := '21';
   c_avlqtty          CONSTANT CHAR(2) := '25';
   c_amt              CONSTANT CHAR(2) := '10';
   c_parvalue         CONSTANT CHAR(2) := '22';
   c_seacctno         CONSTANT CHAR(2) := '06';
   c_optseacctno      CONSTANT CHAR(2) := '09';
   c_phone            CONSTANT CHAR(2) := '70';
   c_address          CONSTANT CHAR(2) := '91';
   c_custname         CONSTANT CHAR(2) := '90';
   c_iddate           CONSTANT CHAR(2) := '93';
   c_license          CONSTANT CHAR(2) := '92';
   c_reportdate       CONSTANT CHAR(2) := '23';
   c_status           CONSTANT CHAR(2) := '40';
   c_issname          CONSTANT CHAR(2) := '95';
   c_idplace          CONSTANT CHAR(2) := '94';
   c_iscorebank       CONSTANT CHAR(2) := '60';
   c_description      CONSTANT CHAR(2) := '30';
   c_taskcd           CONSTANT CHAR(2) := '16';
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
    l_count NUMBER;
    l_availqtty FLOAT;
    l_baldefovd number;
    l_mrtype char(1);
    l_outstanding number;
    l_navaccount number;
    l_mrirate number;
    l_mrmrate number;
    l_mrlrate number;
    l_marginrate number;
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
    if p_txmsg.deltd <> 'Y' then
    BEGIN
    select PQTTY INTO l_availqtty from CASCHD WHERE CAMASTID= p_txmsg.txfields ('02').VALUE AND AFACCTNO = p_txmsg.txfields ('03').VALUE
                                              AND deltd='N' AND autoid=p_txmsg.txfields ('01').VALUE;
    IF l_availqtty < p_txmsg.txfields ('21').VALUE THEN
        p_err_code:= '-300026';
        RETURN errnums.C_BIZ_RULE_INVALID; -- Chua het ngay cho phep dang ki chuyen nhuong.
    END IF;
    EXCEPTION
    WHEN no_data_found THEN
        p_err_code:= '-300013';
        RETURN errnums.C_BIZ_RULE_INVALID; -- Chua het ngay cho phep dang ki chuyen nhuong.
    END;

    SELECT COUNT(1)
        INTO l_count
    FROM CAMAST CA, SYSVAR SYS
    WHERE SYS.VARNAME = 'CURRDATE'
        AND SYS.GRNAME = 'SYSTEM'
        AND CATYPE = '014'
        AND TO_DATE (VARVALUE,'DD/MM/RRRR') >= BEGINDATE
        AND camastid = p_txmsg.txfields ('02').VALUE;

    IF l_count = 0 THEN
        p_err_code:= '-300046';
        RETURN errnums.C_BIZ_RULE_INVALID; -- Chua het ngay cho phep dang ki chuyen nhuong.
    END IF;
    end if;
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
    l_camastid varchar2(30); --02   CAMASTID      C
    l_afacctno varchar2(30); --03   AFACCTNO      C
    l_symbol varchar2(30); --04   SYMBOL        C
    l_exprice number(20,0); --05   EXPRICE       N
    l_qtty number(20,0); --21   QTTY          N
    l_balance number(20,0); --21   QTTY          N
    l_status varchar2(1); --40   STATUS        C
    -- TRANSACTION
    l_left_rightoffrate varchar2(30);
    l_right_rightoffrate varchar2(30);
    l_VSDSTOCKTYPE varchar2(3);
    l_maxTrade      number;
    l_Trade         number;
    l_maxBlocked    number;
    l_Blocked       number;
    l_codeid varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
        --Get cac field giao dich
        --02   CAMASTID      C
        l_camastid:= p_txmsg.txfields ('02').VALUE;
        --03   AFACCTNO      C
        l_afacctno:= p_txmsg.txfields ('03').VALUE;
        --04   SYMBOL        C
        l_symbol:= p_txmsg.txfields ('04').VALUE;
        --05   EXPRICE       N
        l_exprice:= p_txmsg.txfields ('05').VALUE;
        --21   QTTY          N
        l_qtty:=p_txmsg.txfields ('21').VALUE;
        --81   BALANCE          N
        l_balance:=p_txmsg.txfields ('81').VALUE;
        --40   STATUS        C
        l_status:=p_txmsg.txfields ('40').VALUE;
  --T07/2017 STP
        --l_maxTrade      := to_number(p_txmsg.txfields ('50').VALUE); 02##24##03
        --l_Trade         := to_number(p_txmsg.txfields ('51').VALUE);
        --l_maxBlocked    := to_number(p_txmsg.txfields ('52').VALUE);
        --l_Blocked       := to_number(p_txmsg.txfields ('53').VALUE);

        /*select codeid into l_codeid from camast where camastid=l_camastid;
        l_maxTrade      := FN_GET_PTRADE(l_camastid,l_codeid,l_afacctno);
        l_Trade         :=0;
        l_maxBlocked    := FN_GET_PBLOCKED(l_camastid,l_codeid,l_afacctno);
        l_Blocked       :=0;
        if l_Trade=0 and l_Blocked = 0 and l_qtty > 0 THEN
            l_Blocked := LEAST(l_maxBlocked,l_qtty);
            l_Trade := GREATEST(LEAST(l_maxTrade,l_qtty-l_Blocked),0);
        end if;
        --End T07/2017 STP */
        FOR REC IN
        (
        SELECT rightoffrate, excodeid, optcodeid FROM CAMAST WHERE CAMASTID= l_camastid AND deltd='N'
        )
        LOOP

           SELECT      substr(REC.rightoffrate,1,instr(REC.rightoffrate,'/')-1),
                           substr(REC.rightoffrate,instr(REC.rightoffrate,'/') + 1,length(REC.rightoffrate))
               INTO    l_left_rightoffrate, l_right_rightoffrate
           from dual;
        if p_txmsg.deltd <> 'Y' then
                   Update semast
                    set trade = trade - l_balance
                   where acctno = l_afacctno || REC.optcodeid;

                   INSERT INTO SETRAN (ACCTNO, TXNUM, TXDATE, TXCD, NAMT, CAMT, REF, DELTD,AUTOID,acctref,Tltxcd)
                   VALUES (l_afacctno || REC.optcodeid,p_txmsg.txnum,p_txmsg.txdate,'0011', l_balance,'',p_txmsg.txfields ('01').VALUE,'N',SEQ_SETRAN.NEXTVAL,p_txmsg.txfields ('01').VALUE,'3384');

                   UPDATE CASCHD
                    SET STATUS= l_status
                   WHERE AFACCTNO= l_afacctno
                       AND CAMASTID= l_camastid
                       AND DELTD = 'N'
                       AND autoid=p_txmsg.txfields ('01').VALUE;

                   UPDATE CAMAST
                   SET STATUS= l_status
                   WHERE CAMASTID= l_camastid;

                   -- Cap nhat giam so tien nop cho quyen mua
                   UPDATE CASCHD
                   SET     BALANCE = BALANCE + l_balance ,
                           AAMT= AAMT + (l_exprice * l_qtty),
                           QTTY = QTTY + l_qtty,
                           PAAMT= PAAMT - (l_exprice * l_qtty),
                           PQTTY= PQTTY - l_qtty,
                           PBALANCE = PBALANCE - l_balance
                   WHERE AFACCTNO= l_afacctno AND CAMASTID= l_camastid AND DELTD = 'N'
                         AND autoid=p_txmsg.txfields ('01').VALUE;


                               --T07/2017 STP:  cap nhat log caschd tung loai CK
            UPDATE CASCHD_LOG
            SET TRADE =  TRADE - L_BALANCE,
                PTRADE = PTRADE - L_QTTY,
                OUTTRADE = OUTTRADE + L_BALANCE,
                OUTPTRADE = OUTPTRADE + L_QTTY
            WHERE CAMASTID= L_CAMASTID
            AND AFACCTNO= L_AFACCTNO
            AND DELTD = 'N';

            if l_balance > 0  then
                insert into caregister (AUTOID,TXDATE, TXNUM, CAMASTID, CUSTODYCD, AFACCTNO, SEACCTNO, OPTSEACCTNO,
                CODEID, QTTY, EXPRICE, PARVALUE, deltd, VSDSTOCKTYPE, MSGSTATUS,TRFACCTNO, LAST_CHANGE, BALANCE, AMT)
                values(seq_caregister.nextval, p_txmsg.txdate, p_txmsg.txnum,l_camastid,p_txmsg.txfields ('96').VALUE,l_afacctno,p_txmsg.txfields ('06').VALUE,p_txmsg.txfields ('09').VALUE,
                p_txmsg.txfields ('24').VALUE, L_QTTY, l_exprice, p_txmsg.txfields ('22').VALUE,'N','1','H',p_txmsg.txfields ('31').VALUE,SYSTIMESTAMP, l_balance, FN_GET_AMT_3384(l_camastid, l_balance, l_exprice));
            end if;

            /*if l_Blocked > 0  then
                insert into caregister (AUTOID,TXDATE, TXNUM, CAMASTID, CUSTODYCD, AFACCTNO, SEACCTNO, OPTSEACCTNO,
                CODEID, QTTY, AMT, EXPRICE, PARVALUE, deltd, VSDSTOCKTYPE, MSGSTATUS,TRFACCTNO, LAST_CHANGE)
                values(seq_caregister.nextval,p_txmsg.txdate, p_txmsg.txnum,l_camastid,p_txmsg.txfields ('96').VALUE,l_afacctno,p_txmsg.txfields ('06').VALUE,p_txmsg.txfields ('09').VALUE,
                p_txmsg.txfields ('24').VALUE, l_Blocked,l_Blocked * l_exprice, l_exprice, p_txmsg.txfields ('22').VALUE,'N','2','H',p_txmsg.txfields ('31').VALUE,SYSTIMESTAMP);
            end if;*/


           --End T07/2017 STP
        --THUNT-17/02/2020: CAP NHAT TRANG THAI KH DA DANG KY --Thoai.tran sua lai lay C la da DK
          UPDATE CASCHD
             SET ISREGIS ='C'
          WHERE AUTOID = p_txmsg.txfields ('01').VALUE and AFACCTNO = l_afacctno and camastid =l_camastid;

   else

                Update semast set trade = trade - l_balance
                where acctno = l_afacctno || REC.optcodeid;

                update SETRAN set DELTD = 'Y' where txnum = p_txmsg.txnum and txdate = p_txmsg.txdate;

                UPDATE CASCHD
                SET STATUS='V'
                WHERE AFACCTNO=p_txmsg.txfields(c_afacctno).value
                AND CAMASTID=p_txmsg.txfields(c_camastid).value
                AND DELTD = 'N'
                AND autoid=p_txmsg.txfields ('01').VALUE;

                UPDATE CAMAST
                SET STATUS='V'
                WHERE  CAMASTID=p_txmsg.txfields(c_camastid).value;

                UPDATE CASCHD
                SET BALANCE = BALANCE - l_balance ,
                    AAMT= AAMT - (l_exprice * l_qtty) ,
                    QTTY= QTTY - l_qtty,
                    PAAMT= PAAMT + (l_exprice * l_qtty) ,
                    PQTTY= PQTTY + l_qtty,
                    PBALANCE = PBALANCE + l_balance
                WHERE AFACCTNO= p_txmsg.txfields(c_afacctno).value  AND CAMASTID=p_txmsg.txfields(c_camastid).value
                AND DELTD = 'N'
                AND autoid=p_txmsg.txfields ('01').VALUE;

        UPDATE CASCHD_LOG
        SET TRADE =  TRADE + L_BALANCE,
            PTRADE = PTRADE + L_QTTY,
            OUTTRADE = OUTTRADE - L_BALANCE,
            OUTPTRADE = OUTPTRADE - L_QTTY
        WHERE CAMASTID= L_CAMASTID
        AND AFACCTNO= L_AFACCTNO
        AND DELTD = 'N';

        update caregister set deltd = 'Y' where txdate = p_txmsg.txdate and txnum = p_txmsg.txnum;
        --End T07/2017 STP
        --THUNT-17/02/2020: CAP NHAT TRANG THAI KH KHONG DANG KY
        UPDATE CASCHD
        SET ISREGIS ='A'
        WHERE AUTOID = p_txmsg.txfields ('01').VALUE and AFACCTNO = l_afacctno and camastid =l_camastid;
  end if;

  END LOOP;
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
         plog.init ('TXPKS_#3384EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3384EX;
/
