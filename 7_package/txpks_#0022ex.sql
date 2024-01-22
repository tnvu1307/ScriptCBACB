SET DEFINE OFF;
CREATE OR REPLACE PACKAGE TXPKS_#0022EX
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0022EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      02/06/2017     Created
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


CREATE OR REPLACE PACKAGE BODY TXPKS_#0022EX
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_oldaftype        CONSTANT CHAR(2) := '05';
   c_newaftype        CONSTANT CHAR(2) := '04';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    v_afacctno varchar2(20);
    v_newAFtype varchar2(20);
    v_oldAFtype varchar2(20);
    v_count number;
    v_ncitype varchar2(20);
    v_nsetype varchar2(20);

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

    v_afacctno := p_txmsg.txfields(c_acctno).value;
    v_newAFtype := p_txmsg.txfields(c_newaftype).value;
    v_oldAFtype := p_txmsg.txfields(c_oldaftype).value;

    SELECT count(1) into v_count FROM AFMAST WHERE ACCTNO = v_afacctno AND STATUS IN ('B','C');
    if v_count <> 1 then
        p_err_code := '-200010'; --Trang thai tieu khoan khong hop le
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;

    cspks_cfproc.pr_AFMAST_ChangeTypeCheck(v_afacctno,v_newAFtype,p_err_code);
    IF p_err_code <> systemnums.C_SUCCESS THEN
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    select citype ncitype, setype into v_ncitype, v_nsetype
    from aftype naf
    where actype = v_newAFtype;

    if v_ncitype is null or v_nsetype is null then
        p_err_code := '-200097'; --Loai hinh tieu khoan moi chua khai bao loai hinh CI, SE!.
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
    v_currdate date;
    v_afacctno varchar2(20);
    v_newAFtype varchar2(20);
    v_oldAFtype varchar2(20);
    v_maxModNum number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_currdate := to_char(getcurrdate,'DD/MM/RRRR');
    v_afacctno := p_txmsg.txfields(c_acctno).value;
    v_newAFtype := p_txmsg.txfields(c_newaftype).value;
    v_oldAFtype := p_txmsg.txfields(c_oldaftype).value;


    for rec in (
        select * from aftype where actype = v_newAFtype
    )loop
        begin
            select max(mod_num) into v_maxModNum
            from maintain_log mt, afmast af
            where af.acctno = v_afacctno
                and mt.table_name = 'CFMAST' and mt.record_key like '%' || af.custid ||'%';
            exception when others then
                v_maxModNum := 0;
        end;

        --THem thong tin vao trong Maintain_log trang thai da duyet de ghi nhan la Co thay doi loai hinh hop dong
        INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,
              MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME,APPROVE_TIME)
        SELECT 'CFMAST' TABLE_NAME, 'CUSTID = ''' || af.custid  || '''' RECORD_KEY, p_txmsg.tlid MAKER_ID, p_txmsg.txdate MAKER_DT, 'Y' APPROVE_RQD,
            p_txmsg.tlid APPROVE_ID, p_txmsg.txdate APPROVE_DT, nvl(v_maxModNum,0) + 1  MOD_NUM, 'ACTYPE' COLUMN_NAME, af.actype FROM_VALUE, rec.actype TO_VALUE,
            'EDIT' ACTION_FLAG, 'AFMAST' CHILD_TABLE_NAME, 'ACCTNO = ''' || v_afacctno || '''' CHILD_RECORD_KEY,
            to_char(sysdate,'hh24:mi:ss') MAKER_TIME, to_char(sysdate,'hh24:mi:ss') APPROVE_TIME
        FROM AFMAST AF
        WHERE AF.ACCTNO = v_afacctno;

        --if v_strOldcorebank <> v_strCoreBank
        INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,
               MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME,APPROVE_TIME)
        SELECT 'CFMAST' TABLE_NAME, 'CUSTID = ''' || af.custid  || '''' RECORD_KEY, p_txmsg.tlid MAKER_ID, p_txmsg.txdate MAKER_DT, 'Y' APPROVE_RQD,
            p_txmsg.tlid APPROVE_ID, p_txmsg.txdate APPROVE_DT, nvl(v_maxModNum,0) + 1  MOD_NUM, 'COREBANK' COLUMN_NAME, af.COREBANK FROM_VALUE, rec.COREBANK TO_VALUE,
            'EDIT' ACTION_FLAG, 'AFMAST' CHILD_TABLE_NAME, 'ACCTNO = ''' || v_afacctno || '''' CHILD_RECORD_KEY,
            to_char(sysdate,'hh24:mi:ss') MAKER_TIME, to_char(sysdate,'hh24:mi:ss') APPROVE_TIME
        FROM AFMAST AF
        WHERE AF.ACCTNO = v_afacctno
            and af.COREBANK <> rec.COREBANK;

        update afmast
         set actype = rec.actype,
             corebank = rec.corebank
        where acctno = v_afacctno;

        UPDATE DDMAST SET ACTYPE = rec.citype WHERE AFACCTNO = v_afacctno;
        UPDATE SEMAST SET ACTYPE = rec.setype WHERE AFACCTNO = v_afacctno;

    end loop;


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
         plog.init ('TXPKS_#0022EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#0022EX;
/
