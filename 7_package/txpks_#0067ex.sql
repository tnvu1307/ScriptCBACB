SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#0067ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0067EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      16/04/2012     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#0067ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_custid           CONSTANT CHAR(2) := '03';
   c_acctno           CONSTANT CHAR(2) := '05';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_count number;
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


     select count(1) into l_count
        from (select actype from afmast
                where custid = p_txmsg.txfields('03').value
                and (p_txmsg.txfields('05').value = 'ALL'
                    or (p_txmsg.txfields('05').value <> 'ALL' and (acctno = p_txmsg.txfields('05').value or status <> 'C')))
                group by actype
                having count(1) > 1);
    if l_count > 0 then
        p_txmsg.txWarningException('-1001401').value:= cspks_system.fn_get_errmsg('-100140');
        p_txmsg.txWarningException('-1001401').errlev:= '1';
    end if;

    select count(1) into l_count
        from (select bankname, bankacctno
                from afmast
                where p_txmsg.txfields('05').value = decode(p_txmsg.txfields('05').value,'ALL',p_txmsg.txfields('05').value, acctno)
                    and custid = p_txmsg.txfields('03').value and status = 'C'
                    and bankname is not null and bankacctno is not null
             ) mst
        where exists (select 1 from afmast af where af.bankname is not null and af.bankacctno is not null
                        and mst.bankname = af.bankname and mst.bankacctno = af.bankacctno
                        and status <> 'C');

    if l_count > 0 then
        p_txmsg.txWarningException('-1001471').value:= cspks_system.fn_get_errmsg('-100147');
        p_txmsg.txWarningException('-1001471').errlev:= '1';
    end if;

    select count(1) into l_count from afmast af, cfmast cf where af.custid = cf.custid and cf.status = 'C' and af.status <> 'C' and af.custid = p_txmsg.txfields('03').value;
    if l_count > 0 then
        p_err_code := '-200010'; -- Pre-defined in DEFERROR table
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;

    --Kiem tra neu All tieu khoan thi phai co it nhat mot tai khoan dang dong
    --Neu 1 tieu khoan thi tieu khoan do phai la dang dong
    select count(1) into l_count from afmast af where af.status = 'C'
        and custid = p_txmsg.txfields('03').value
        and p_txmsg.txfields('05').value = decode(p_txmsg.txfields('05').value,'ALL',p_txmsg.txfields('05').value, af.acctno);
    if l_count <= 0 then
        p_err_code := '-200010'; -- Pre-defined in DEFERROR table
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
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
v_count number;
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
    v_count:=0;
    SELECT count(1) into v_count
    FROM CFMAST CF1,
    (
        SELECT IDCODE,CUSTTYPE FROM CFMAST WHERE CUSTID = p_txmsg.txfields('03').value AND IDTYPE <> '009'
    ) CF2
    WHERE CF1.STATUS <> 'C'
    AND CF1.IDCODE = CF2.IDCODE
    AND CF1.CUSTTYPE = CF2.CUSTTYPE;

    if v_count > 0 then
        p_err_code:='-200020';
        plog.setendsection(pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
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
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    if p_txmsg.deltd <> 'Y' then
        update cfmast
        set activests = 'Y', nsdstatus= 'C'
        where custid = p_txmsg.txfields('03').value;


            if p_txmsg.txfields('05').value='ALL' then
                --Cap nhat cho toan bo tieu khoan
                for rec in
                    (select acctno from afmast where custid = p_txmsg.txfields('03').value and status ='C')
                loop
                    update afmast set status ='A' where acctno = rec.acctno and status <> 'A';
                    update semast set status ='A' where afacctno = rec.acctno and status <> 'A';
                    --update ddmast set status ='A' where afacctno = rec.acctno and status <> 'A';
                end loop;
            else
                --Cap nhat cho tieu khoan da chon
                update afmast set status ='A' where acctno = p_txmsg.txfields('05').value and status <> 'A';
                update semast set status ='A' where afacctno = p_txmsg.txfields('05').value and status <> 'A';
                --update ddmast set status ='A' where afacctno = p_txmsg.txfields('05').value and status <> 'A';
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
         plog.init ('TXPKS_#0067EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#0067EX;
/
