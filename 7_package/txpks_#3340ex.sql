SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3340ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3340EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      11/10/2011     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3340ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '03';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_catype           CONSTANT CHAR(2) := '05';
   c_actiondate       CONSTANT CHAR(2) := '07';
   c_contents         CONSTANT CHAR(2) := '13';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
l_count NUMBER;
l_catype VARCHAR2(4);
l_status varchar2(1);
l_afacctno varchar2(50);
l_count2 number;
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
        SELECT catype INTO l_catype FROM camast
        WHERE camastid=p_txmsg.txfields ('03').VALUE;
        --Ngay 10/02/2020 NamTv check them tai khoan chua khai bao tieu khoan tien
        for rec in (
            select count(*) lcount--into l_count
            from caschd
            where camastid= trim(p_txmsg.txfields('03').value)
            and deltd<>'Y'
            and afacctno not in (select afacctno from ddmast where  status <> 'C')
        )loop
            IF ( rec.lcount > 0 )  THEN
                p_err_code := '-330004';
                plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        end loop;

        FOR REC IN (
            SELECT DD.AFACCTNO L_DDMAST
            FROM CASCHD CAS,
            (
                SELECT AFACCTNO FROM DDMAST WHERE ISDEFAULT='Y' AND STATUS <> 'C'
            ) DD
            WHERE CAS.AFACCTNO = DD.AFACCTNO(+)
            AND CAS.DELTD <> 'Y'
            AND CAS.CAMASTID = P_TXMSG.TXFIELDS('03').VALUE
        )LOOP
            IF REC.L_DDMAST IS NULL THEN
                P_ERR_CODE := '-330004';
                PLOG.SETENDSECTION (PKGCTX, 'FN_TXAPPAUTOCHECK');
                RETURN ERRNUMS.C_BIZ_RULE_INVALID;
            END IF;
        END LOOP;

        --Ngay 10/02/2020 NamTv End
    IF (l_catype='014') THEN
       SELECT COUNT(*) INTO l_count from CASCHD
       WHERE CAMASTID= p_txmsg.txfields ('03').VALUE
       AND tqtty <> qtty AND status <> 'O' and deltd <> 'Y';
             IF l_count >0 THEN
                 p_err_code:= '-300047';
                 RETURN errnums.C_BIZ_RULE_INVALID; -- Van con sot tieu khoan
             END IF;
    END IF;
    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
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
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
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
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_err_param varchar2(500);
    l_camastid varchar2(50);
    l_CATYPE varchar2(10);
    l_codeid varchar2(50);
    l_count number;
    l_data_source clob;
    l_email varchar2(100);
    l_desc varchar2(1000);
    l_countmail number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    if p_txmsg.deltd<>'Y' then
        cspks_caproc.pr_3380_send_cop_action(p_txmsg,p_err_code);
        if p_err_code <> systemnums.C_SUCCESS THEN
            
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
        --TruongLD commnent. Logic nghiep vu, tai buoc nay khong gui duoc mail nay.
        --> Comment lai
        /*
        nmpks_ems.pr_GenTemplateE281(p_txmsg.txfields(c_camastid).value);
        */
    ELSE
        for rec in
        (
            select * from tllog where reftxnum =p_txmsg.txnum
        )
        loop
            if rec.tltxcd = '3380' then
                if txpks_#3380.fn_txrevert(rec.txnum,to_char(rec.txdate,'dd/mm/rrrr'),p_err_code,l_err_param) <> 0 then
                    plog.error (pkgctx, 'Loi khi thuc hien xoa giao dich');
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    return errnums.C_SYSTEM_ERROR;
                end if;
            end if;

        end loop;
    end if;

    select camastid,catype, codeid into l_camastid, l_CATYPE, l_codeid from camast where camastid =p_txmsg.txfields('03').value;
    if p_txmsg.deltd <>'Y' then

        UPDATE CAMAST SET STATUS='S' WHERE CAMASTID=p_txmsg.txfields('03').value;

        if l_CATYPE= '002' then --Halt chung khoan
           UPDATE SBSECURITIES SET HALT ='Y'
            WHERE CODEID=l_codeid;
        end if;

    -----------------------------------SEND MAIL---------------------------------------------
    select count(*) into l_countmail
    from camast ca,caschd cas
        where ca.camastid=cas.camastid and ca.camastid like p_txmsg.txfields('03').value and ca.catype not in ('014','003','029','031','032');
    if l_countmail <> 0
        then
            sendmailall(p_txmsg.txfields('03').value,'3340');
    end if;

    ----------------------------------------------------------------------------------------
    ELSE
        if l_catype = '023' then
            UPDATE CAMAST SET STATUS='V' WHERE CAMASTID=p_txmsg.txfields('03').value;
        ELSIF l_catype <> '014' then
            UPDATE CAMAST SET STATUS='A' WHERE CAMASTID=p_txmsg.txfields('03').value;

        else
            select count(1) into l_count from caschd where camastid =p_txmsg.txfields('03').value and deltd <> 'Y' and status ='M';
            if l_count=0 then
                UPDATE CAMAST SET STATUS='V' WHERE CAMASTID=p_txmsg.txfields('03').value;
            else
                UPDATE CAMAST SET STATUS='M' WHERE CAMASTID=p_txmsg.txfields('03').value;
            end if;
        end if;
        if l_CATYPE= '002' then --Halt chung khoan
             UPDATE SBSECURITIES SET HALT ='N'
             WHERE CODEID=l_codeid;
        end if;

    end if;

    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
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
         plog.init ('TXPKS_#3340EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3340EX;
/
