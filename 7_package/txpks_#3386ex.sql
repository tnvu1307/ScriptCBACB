SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3386ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3386EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      04/01/2012     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/


CREATE OR REPLACE PACKAGE BODY txpks_#3386ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '02';
   c_afacctno         CONSTANT CHAR(2) := '03';
   c_custodycd        CONSTANT CHAR(2) := '96';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_fullname         CONSTANT CHAR(2) := '08';
   c_seacctno         CONSTANT CHAR(2) := '06';
   c_exprice          CONSTANT CHAR(2) := '05';
   c_parvalue         CONSTANT CHAR(2) := '22';
   c_maxqtty          CONSTANT CHAR(2) := '20';
   c_balance          CONSTANT CHAR(2) := '07';
   c_qtty             CONSTANT CHAR(2) := '21';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_optseacctno      CONSTANT CHAR(2) := '09';
   c_license          CONSTANT CHAR(2) := '92';
   c_iddate           CONSTANT CHAR(2) := '93';
   c_reportdate       CONSTANT CHAR(2) := '23';
   c_idplace          CONSTANT CHAR(2) := '94';
   c_iscorebank       CONSTANT CHAR(2) := '60';
   c_desc             CONSTANT CHAR(2) := '30';
   c_taskcd           CONSTANT CHAR(2) := '16';
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_leader_license varchar2(100);
    l_leader_idexpired date;
    l_idexpdays apprules.field%TYPE;
    l_afmastcheck_arr txpks_check.afmastcheck_arrtype;
        l_leader_expired boolean;
    l_qtty  number;
    l_count number;
    l_maxqtty number;

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
    l_leader_expired:= false;


 --T07/2017 STP
    --check luong dien
    --neu la luong co ket noi stp thi k cho thay doi sl
    if p_txmsg.txfields('98').value = 'Y' then
       select count(1) into l_qtty from caregister where autoid = p_txmsg.txfields('97').value and deltd <> 'Y';
       if l_qtty > 0 then
            select sum(qtty) into l_qtty from caregister where autoid = p_txmsg.txfields('97').value and deltd <> 'Y';
            if l_qtty <> TO_NUMBER(p_txmsg.txfields('21').value) then
                p_err_code := '-269010'; -- Pre-defined in DEFERROR table
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
       ELSE
            p_err_code := '-100777'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
       end if;
    end if;
    --End T07/2017 STP

    --28/08/2017 DieuNDA: Them check chong double giao dich
    if p_txmsg.deltd <> 'Y' then
        select sum(qtty - cancelqtty) into l_maxqtty from caregister where autoid = p_txmsg.txfields('97').value and deltd <> 'Y';
        if nvl(l_maxqtty,0) < TO_NUMBER(p_txmsg.txfields('21').value) then
                p_err_code := '-269010'; -- Pre-defined in DEFERROR table
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
    end if;
    --End 28/08/2017 DieuNDA: Them check chong double giao dich

    select idcode, idexpired into l_leader_license, l_leader_idexpired
    from cfmast cf, afmast af
    where cf.custid = af.custid
    and af.acctno = p_txmsg.txfields(c_afacctno).value;

    IF l_leader_idexpired < p_txmsg.txdate THEN --leader expired
        l_leader_expired:=true;
    END IF;


    if l_leader_expired = true then
            p_txmsg.txWarningException('-2002081').value:= cspks_system.fn_get_errmsg('-200208');
            p_txmsg.txWarningException('-2002081').errlev:= '1';
    end if;

    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
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
      plog.error (pkgctx, SQLERRM);
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
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_qtty number(20,4);
    l_balance number(20,4);
    l_left_rightoffrate varchar2(30);
    l_right_rightoffrate varchar2(30);
    l_roundtype number(20,4);
    l_exprice number(20,4);
    l_transfertimes number(20,4);
    l_retailbal number(20,4);
    l_optcodeid varchar2(100);
    l_count number;
    l_autoid NUMBER;
    l_vsdstocktype VARCHAR2(3);
    l_newqtty number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_qtty:= to_number(p_txmsg.txfields(c_qtty).value);
    l_balance:= to_number(p_txmsg.txfields('81').value);
    l_autoid:= to_number(p_txmsg.txfields('01').value);
    SELECT      substr(rightoffrate,1,instr(rightoffrate,'/')-1),
           substr(rightoffrate,instr(rightoffrate,'/') + 1,length(rightoffrate)),
           roundtype, TRANSFERTIMES, OPTCODEID, exprice
    INTO    l_left_rightoffrate, l_right_rightoffrate, l_roundtype, l_transfertimes, l_optcodeid, l_exprice
    from camast where camastid = p_txmsg.txfields(c_camastid).value and deltd <> 'Y';

    if p_txmsg.deltd <> 'Y' then
        UPDATE CASCHD
        SET BALANCE = BALANCE - l_balance,
            AAMT= FN_GET_AMT_3384(camastid, BALANCE - l_balance, l_exprice),
            QTTY= FN_GET_QTTY_3386(camastid, BALANCE - l_balance),
            PAAMT= FN_GET_AMT_3384(camastid, PBALANCE + l_balance, l_exprice),
            PQTTY= FN_GET_QTTY_3386(camastid, PBALANCE + l_balance),
            PBALANCE = PBALANCE + l_balance
        WHERE AFACCTNO =p_txmsg.txfields(c_afacctno).value AND camastid = p_txmsg.txfields(c_camastid).value and  deltd <> 'Y'
        AND autoid=l_autoid;

		
         --T07/2017 STP
        --update CASCHD_log
        if p_txmsg.txfields('98').value = 'Y' then

            select vsdstocktype into l_vsdstocktype from caregister where autoid = p_txmsg.txfields('97').value and deltd = 'N';
            
            if l_vsdstocktype is not null then
            --update CASCHD_log
                if l_vsdstocktype = '1' THEN
                    update caschd_log
                    set trade = trade + l_qtty,
                    ptrade = ptrade + l_balance,
                    outtrade = outtrade - l_qtty,
                    outptrade = outptrade - l_balance
                    where AFACCTNO =p_txmsg.txfields(c_afacctno).value
                    and camastid =  p_txmsg.txfields(c_camastid).value
                    and codeid = p_txmsg.txfields('24').VALUE and deltd <> 'Y';
                else
                    update caschd_log
                    set blocked = blocked + l_qtty,
                    pblocked = pblocked + l_balance,
                    outblocked = outblocked - l_qtty,
                    outpblocked = outpblocked - l_balance
                    where AFACCTNO =p_txmsg.txfields(c_afacctno).value
                    and camastid =  p_txmsg.txfields(c_camastid).value
                    and codeid = p_txmsg.txfields('24').VALUE and deltd <> 'Y';
                end if;
                --update caregister set deltd = 'Y' where autoid = p_txmsg.txfields('97').value;
            end if;
        end if;

        --END T07/2017 STP
        --28/08/2017 DieuNDA: Them log Dang ky SKQ mua
        update caregister
        set cancelqtty = cancelqtty + l_qtty,
            qtty = FN_GET_QTTY_3386(camastid, BALANCE - l_balance),
            last_change = SYSTIMESTAMP,
            BALANCE = BALANCE - l_balance,
            amt = FN_GET_AMT_3384(camastid, balance - l_balance, exprice)
        where autoid = p_txmsg.txfields('97').value;
        --End 28/08/2017 DieuNDA: Them log Dang ky SKQ mua
        --begin
        --chap nhan bi hut do lam tron 2020/11/12
        SELECT SUM(QTTY) INTO L_NEWQTTY
        FROM CAREGISTER
        WHERE AFACCTNO = P_TXMSG.TXFIELDS(C_AFACCTNO).VALUE
        AND CAMASTID = P_TXMSG.TXFIELDS(C_CAMASTID).VALUE
        AND DELTD <> 'Y'
        GROUP BY AFACCTNO, CAMASTID;

        UPDATE CASCHD
        SET AAMT = L_NEWQTTY * L_EXPRICE,
            QTTY = L_NEWQTTY
        WHERE AFACCTNO = P_TXMSG.TXFIELDS(C_AFACCTNO).VALUE
        AND CAMASTID = P_TXMSG.TXFIELDS(C_CAMASTID).VALUE
        AND DELTD <> 'Y'
        AND AUTOID = L_AUTOID;
        --end
    end if;
    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN

      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
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
         plog.init ('TXPKS_#3386EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3386EX;
/
