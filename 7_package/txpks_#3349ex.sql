SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3349ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3349EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      04/11/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3349ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '03';
   c_votecode         CONSTANT CHAR(2) := '06';
   c_ratio            CONSTANT CHAR(2) := '31';
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
v_status varchar2(1);
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
        /*select status into v_status from camast where camastid=p_txmsg.txfields('03').value;
        if v_status <> 'S' then
         p_err_code  := -300014;
         return p_err_code;
        end if;*/
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

l_STRDT  varchar2(10000);
v_autoid varchar2(100);
v_votecode varchar2(100);
v_rate varchar2(100);
l_txmsg               tx.msg_rectype;
l_err_param   varchar2(1000);
l_tltxcd      varchar2(4);
v_camastid varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
if p_txmsg.deltd<>'Y' then

       /*for rec in
        (
            select * from tllog where reftxnum =p_txmsg.txnum
        )
        loop
            if rec.tltxcd = '3388' then
                if txpks_#3388.fn_txrevert(rec.txnum,to_char(rec.txdate,'dd/mm/rrrr'),p_err_code,l_err_param) <> 0 then
                    plog.error (pkgctx, 'Loi khi thuc hien xoa giao dich');
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    return errnums.C_SYSTEM_ERROR;
                end if;
            end if;

        end loop;
   update cavoting set rate=nvl(p_txmsg.txfields('31').value,0) where camastid=p_txmsg.txfields('03').value and votecode=v_votecode;

   UPDATE CAMAST SET STATUS='J' WHERE CAMASTID=p_txmsg.txfields('03').value;
*/


   l_STRDT:=   p_txmsg.txfields('31').VALUE;
   v_camastid := REPLACE(p_txmsg.txfields('03').VALUE,'.','');
       if l_STRDT is not null then
          FOR REC0 IN (
          SELECT REGEXP_SUBSTR(l_STRDT, '[^#,]+', 1, LEVEL) tmp
          FROM dual CONNECT BY REGEXP_SUBSTR(l_STRDT, '[^#,]+', 1, LEVEL) is NOT NULL
                  )
          LOOP
                
              /*SELECT SUBSTR( rec0.tmp,0,INSTR (rec0.tmp,'|') -1 ),
                    SUBSTR( rec0.tmp,INSTR (rec0.tmp,'|') +1,INSTR (rec0.tmp,'|',1,2) -  INSTR (rec0.tmp,'|',1,1)-1),
                    SUBSTR( rec0.tmp,INSTR (rec0.tmp,'|',1,2) +1,INSTR (rec0.tmp,'|',1,3) -  INSTR (rec0.tmp,'|',1,2)-1),
                    SUBSTR( rec0.tmp,INSTR (rec0.tmp,'|',1,3) +1)
                    */
              SELECT SUBSTR( rec0.tmp,0,INSTR (rec0.tmp,'|') -1 ) ,
                    SUBSTR( rec0.tmp,INSTR (rec0.tmp,'|') +1 ,INSTR (rec0.tmp,'|',1,2) -INSTR (rec0.tmp,'|',1,1)-1  ),
                    SUBSTR( rec0.tmp,INSTR (rec0.tmp,'|',1,2) +1)
              INTO v_autoid,v_votecode,v_rate
              FROM dual;

              
              --update rate vao voting
              update cavoting set rate=v_rate where autoid=v_autoid and votecode = votecode;
          END LOOP;
       END IF;
       /*l_tltxcd       := '3388';

            l_txmsg.tltxcd := l_tltxcd;

            l_txmsg.msgtype := 'T';
            l_txmsg.local   := 'N';
            l_txmsg.tlid    := p_txmsg.TLID;
            select sys_context('USERENV', 'HOST'),
                   sys_context('USERENV', 'IP_ADDRESS', 15)
              into l_txmsg.wsname, l_txmsg.ipaddress
              from dual;
            l_txmsg.off_line  := 'N';
            l_txmsg.deltd     := txnums.c_deltd_txnormal;
            l_txmsg.txstatus  := txstatusnums.c_txcompleted;
            l_txmsg.msgsts    := '0';
            l_txmsg.ovrsts    := '0';
            l_txmsg.batchname := 'DAY';
            l_txmsg.busdate   := p_txmsg.busdate;
            l_txmsg.txdate    := p_txmsg.txdate;
            l_txmsg.reftxnum  := p_txmsg.txnum;
            select systemnums.c_batch_prefixed ||
                    lpad(seq_batchtxnum.nextval, 8, '0')
              into l_txmsg.txnum
              from dual;
            select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
            l_txmsg.brid := p_txmsg.brid; -- can sua lai them brid trong vsdtxreq de fill lai gt vao day

            --03  CAMASTID        C
            l_txmsg.txfields ('03').defname   := 'CAMASTID    ';
            l_txmsg.txfields ('03').TYPE      := 'C';
            l_txmsg.txfields ('03').VALUE     := v_camastid;

            BEGIN
              IF TXPKS_#3388.FN_BATCHTXPROCESS(l_txmsg, p_err_code, l_err_param) <>  SYSTEMNUMS.C_SUCCESS THEN
				  PLOG.ERROR(PKGCTX,p_err_param || ' run ' || l_tltxcd || ' got ' || p_err_code || ':' ||p_err_param);
                  ROLLBACK;
                  RETURN p_err_code;
              END IF;
            END;*/
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
         plog.init ('TXPKS_#3349EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3349EX;
/
