SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#6609ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#6609EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      08/07/2020     Created
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
FUNCTION fn_txAftAppUpdate(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/


CREATE OR REPLACE PACKAGE BODY txpks_#6609ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_id               CONSTANT CHAR(2) := '01';
   c_type             CONSTANT CHAR(2) := '02';
   c_ddaccount        CONSTANT CHAR(2) := '06';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_name             CONSTANT CHAR(2) := '90';
   c_bankaccount      CONSTANT CHAR(2) := '05';
   c_cfnstatus        CONSTANT CHAR(2) := '04';
   c_newstatus        CONSTANT CHAR(2) := '10';
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

FUNCTION fn_txAftAppUpdate(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_type varchar2(10);
v_accountstatus  varchar2(10);
v_bankaccount  varchar2(50);
v_ccycd  varchar2(5);
v_cifid  varchar2(20);
v_custodycd  varchar2(20);
v_seqddmast varchar2(40);
v_afacctno varchar2(40);
v_ddmast_autoid number;
v_count number;
v_record_key varchar2(250);
v_custid varchar2(50);
v_modnum number;
v_autoid_ddmast number;
v_child_record_key varchar2(250);
v_status varchar2(1);
v_newstatus varchar2(1);
v_accounttype varchar2(250);
v_opendate date;
v_branddate date;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/


 IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
    select type,accountstatus,bankaccount,ccycd,cifid,custodycd,accounttype,opendate,branchdate
    into v_type,v_accountstatus,v_bankaccount,v_ccycd,v_cifid,v_custodycd,v_accounttype,v_opendate,v_branddate
    from CASH_ACCOUNT_AITHER
    where autoid = p_txmsg.txfields('01').value;



    select custid into v_custid from cfmast where custodycd = p_txmsg.txfields('88').value;
    v_count:= 0;
    v_record_key := 'CUSTID = ' || ''''||v_custid ||'''';
    
    if v_type= '01'  then  --addnew
        select count(*) into v_count from ddmast where refcasaacct = v_bankaccount and custodycd = p_txmsg.txfields('88').value and accounttype = v_accounttype and status <> 'C';
        if v_count >0 then
            p_err_code := '-130011';
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
        select   to_char(getcurrdate(),'DDMMRRRR') || to_char(LPAD (SEQ_DDMAST_ACCTNO.NEXTVAL, 6,'0'  )),seq_ddmast.NEXTVAL, cf.custid
        into v_seqddmast,v_ddmast_autoid, v_afacctno
        from afmast af, cfmast cf  where cf.custodycd = p_txmsg.txfields('88').value and af.custid = cf.custid and af.status = 'A' and rownum=1;

        v_autoid_ddmast :=seq_ddmast.nextval;
        v_child_record_key := 'AUTOID = '|| ''''||v_autoid_ddmast ||'''';
        

        select max(mod_num)+1 into v_modnum from maintain_log where table_name = 'CFMAST' and CHILD_TABLE_NAME ='DDMAST' and action_flag ='ADD';

        insert into maintain_log (TABLE_NAME, RECORD_KEY, MAKER_ID, MAKER_DT, APPROVE_RQD, APPROVE_ID, APPROVE_DT, MOD_NUM, COLUMN_NAME, FROM_VALUE, TO_VALUE, ACTION_FLAG, CHILD_TABLE_NAME, CHILD_RECORD_KEY, MAKER_TIME, APPROVE_TIME)
        values ('CFMAST', v_record_key, p_txmsg.tlid, to_date( p_txmsg.txdate, 'dd/MM/RRRR'), 'Y', null, null, v_modnum, 'AUTOID', null, v_autoid_ddmast, 'ADD', 'DDMAST',v_child_record_key, p_txmsg.txtime, null);

        insert into maintain_log (TABLE_NAME, RECORD_KEY, MAKER_ID, MAKER_DT, APPROVE_RQD, APPROVE_ID, APPROVE_DT, MOD_NUM, COLUMN_NAME, FROM_VALUE, TO_VALUE, ACTION_FLAG, CHILD_TABLE_NAME, CHILD_RECORD_KEY, MAKER_TIME, APPROVE_TIME)
        values ('CFMAST', v_record_key, p_txmsg.tlid, to_date( p_txmsg.txdate, 'dd/MM/RRRR'), 'Y', null, null, v_modnum, 'CUSTID', null, v_afacctno, 'ADD', 'DDMAST', v_child_record_key, p_txmsg.txtime, null);

        insert into maintain_log (TABLE_NAME, RECORD_KEY, MAKER_ID, MAKER_DT, APPROVE_RQD, APPROVE_ID, APPROVE_DT, MOD_NUM, COLUMN_NAME, FROM_VALUE, TO_VALUE, ACTION_FLAG, CHILD_TABLE_NAME, CHILD_RECORD_KEY, MAKER_TIME, APPROVE_TIME)
        values ('CFMAST', v_record_key, p_txmsg.tlid, to_date( p_txmsg.txdate, 'dd/MM/RRRR'), 'Y', null, null, v_modnum, 'CCYCD', null, v_ccycd, 'ADD', 'DDMAST', v_child_record_key, p_txmsg.txtime, null);

        insert into maintain_log (TABLE_NAME, RECORD_KEY, MAKER_ID, MAKER_DT, APPROVE_RQD, APPROVE_ID, APPROVE_DT, MOD_NUM, COLUMN_NAME, FROM_VALUE, TO_VALUE, ACTION_FLAG, CHILD_TABLE_NAME, CHILD_RECORD_KEY, MAKER_TIME, APPROVE_TIME)
        values ('CFMAST', v_record_key, p_txmsg.tlid, to_date( p_txmsg.txdate, 'dd/MM/RRRR'), 'Y', null, null, v_modnum, 'CUSTODYCD', null, p_txmsg.txfields('88').value, 'ADD', 'DDMAST', v_child_record_key, p_txmsg.txtime, null);

        insert into maintain_log (TABLE_NAME, RECORD_KEY, MAKER_ID, MAKER_DT, APPROVE_RQD, APPROVE_ID, APPROVE_DT, MOD_NUM, COLUMN_NAME, FROM_VALUE, TO_VALUE, ACTION_FLAG, CHILD_TABLE_NAME, CHILD_RECORD_KEY, MAKER_TIME, APPROVE_TIME)
        values ('CFMAST', v_record_key, p_txmsg.tlid, to_date( p_txmsg.txdate, 'dd/MM/RRRR'), 'Y', null, null, v_modnum, 'AFACCTNO', null, v_afacctno, 'ADD', 'DDMAST', v_child_record_key, p_txmsg.txtime, null);

        insert into maintain_log (TABLE_NAME, RECORD_KEY, MAKER_ID, MAKER_DT, APPROVE_RQD, APPROVE_ID, APPROVE_DT, MOD_NUM, COLUMN_NAME, FROM_VALUE, TO_VALUE, ACTION_FLAG, CHILD_TABLE_NAME, CHILD_RECORD_KEY, MAKER_TIME, APPROVE_TIME)
        values ('CFMAST', v_record_key, p_txmsg.tlid, to_date( p_txmsg.txdate, 'dd/MM/RRRR'), 'Y', null, null, v_modnum, 'OPNDATE', null, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT), 'ADD', 'DDMAST', v_child_record_key, p_txmsg.txtime, null);

        insert into maintain_log (TABLE_NAME, RECORD_KEY, MAKER_ID, MAKER_DT, APPROVE_RQD, APPROVE_ID, APPROVE_DT, MOD_NUM, COLUMN_NAME, FROM_VALUE, TO_VALUE, ACTION_FLAG, CHILD_TABLE_NAME, CHILD_RECORD_KEY, MAKER_TIME, APPROVE_TIME)
        values ('CFMAST',v_record_key, p_txmsg.tlid, to_date( p_txmsg.txdate, 'dd/MM/RRRR'), 'Y', null, null, v_modnum, 'ISDEFAULT', null, 'N', 'ADD', 'DDMAST', v_child_record_key, p_txmsg.txtime, null);

        insert into maintain_log (TABLE_NAME, RECORD_KEY, MAKER_ID, MAKER_DT, APPROVE_RQD, APPROVE_ID, APPROVE_DT, MOD_NUM, COLUMN_NAME, FROM_VALUE, TO_VALUE, ACTION_FLAG, CHILD_TABLE_NAME, CHILD_RECORD_KEY, MAKER_TIME, APPROVE_TIME)
        values ('CFMAST', v_record_key, p_txmsg.tlid, to_date( p_txmsg.txdate, 'dd/MM/RRRR'), 'Y', null, null, v_modnum, 'ACCOUNTTYPE', null, v_accounttype, 'ADD', 'DDMAST', v_child_record_key, p_txmsg.txtime, null);

        insert into maintain_log (TABLE_NAME, RECORD_KEY, MAKER_ID, MAKER_DT, APPROVE_RQD, APPROVE_ID, APPROVE_DT, MOD_NUM, COLUMN_NAME, FROM_VALUE, TO_VALUE, ACTION_FLAG, CHILD_TABLE_NAME, CHILD_RECORD_KEY, MAKER_TIME, APPROVE_TIME)
        values ('CFMAST', v_record_key, p_txmsg.tlid, to_date( p_txmsg.txdate, 'dd/MM/RRRR'), 'Y', null, null, v_modnum, 'REFCASAACCT', null, v_bankaccount, 'ADD', 'DDMAST', v_child_record_key, p_txmsg.txtime, null);

        insert into maintain_log (TABLE_NAME, RECORD_KEY, MAKER_ID, MAKER_DT, APPROVE_RQD, APPROVE_ID, APPROVE_DT, MOD_NUM, COLUMN_NAME, FROM_VALUE, TO_VALUE, ACTION_FLAG, CHILD_TABLE_NAME, CHILD_RECORD_KEY, MAKER_TIME, APPROVE_TIME)
        values ('CFMAST',v_record_key, p_txmsg.tlid, to_date( p_txmsg.txdate, 'dd/MM/RRRR'), 'Y', null, null, v_modnum, 'STATUS', null, decode(v_accountstatus,'10','A','C'), 'ADD', 'DDMAST', v_child_record_key, p_txmsg.txtime, null);

        insert into maintain_log (TABLE_NAME, RECORD_KEY, MAKER_ID, MAKER_DT, APPROVE_RQD, APPROVE_ID, APPROVE_DT, MOD_NUM, COLUMN_NAME, FROM_VALUE, TO_VALUE, ACTION_FLAG, CHILD_TABLE_NAME, CHILD_RECORD_KEY, MAKER_TIME, APPROVE_TIME)
        values ('CFMAST', v_record_key, p_txmsg.tlid, to_date( p_txmsg.txdate, 'dd/MM/RRRR'), 'Y', null, null, v_modnum, 'AUTOTRANSFER', null, 'N', 'ADD', 'DDMAST', v_child_record_key, p_txmsg.txtime, null);

        insert into maintain_log (TABLE_NAME, RECORD_KEY, MAKER_ID, MAKER_DT, APPROVE_RQD, APPROVE_ID, APPROVE_DT, MOD_NUM, COLUMN_NAME, FROM_VALUE, TO_VALUE, ACTION_FLAG, CHILD_TABLE_NAME, CHILD_RECORD_KEY, MAKER_TIME, APPROVE_TIME)
        values ('CFMAST', v_record_key, p_txmsg.tlid, to_date( p_txmsg.txdate, 'dd/MM/RRRR'), 'Y', null, null, v_modnum, 'ACCTNO', null, v_seqddmast, 'ADD', 'DDMAST', v_child_record_key, p_txmsg.txtime, null);


       INSERT INTO ddmast ( autoid, actype, custid, afacctno, custodycd, acctno, ccycd, refcasaacct, balance, acramt, adramt, mcramt, mdramt, holdbalance, blockamt, receiving, netting,
                             status, pstatus, opndate, clsdate, lastchange, last_change, pendinghold, pendingunhold, bankbalance, bankholdbalance, isdefault, depofeeacr, depofeeamt,
                             depolastdt, corebank, accounttype, inqbankreqid,autotransfer,branchdate)
       VALUES(v_ddmast_autoid,'0000',v_afacctno,v_afacctno, p_txmsg.txfields('88').value,v_seqddmast,v_ccycd,v_bankaccount,0,0,0,0,0,0,0,0,0,
                              decode(v_accountstatus,'10','A','C'),NULL,v_opendate,NULL,systimestamp,NULL,0,0,0,0,'N',0,0,
                              NULL,NULL,v_accounttype,NULL,'N',v_branddate);

       -- TRUNG.LUU: 24-02-2021 SHBVNEX-2078 KHONG UP THEO CIFID VI CIFID CUA TAI KHOAN ME
       update cfmast set status = 'P',last_change =systimestamp  where   custodycd = p_txmsg.txfields('88').value ;-- AND cifid = v_cifid;
    else  -- edit
      select status  into v_status
      from ddmast where refcasaacct= v_bankaccount;

      if v_accountstatus = '10' then
         v_newstatus:='A';
      else
         v_newstatus:='C';
      end if;
      if v_newstatus = v_status then
         p_txmsg.txWarningException('-400100').value:= cspks_system.fn_get_errmsg('-400100');
         p_txmsg.txWarningException('-400100').errlev:= '1';
      end if;
      if v_accountstatus = '10' then
        update ddmast set status = decode(v_accountstatus,'10','A','C'),opndate = v_opendate,branchdate = v_branddate where refcasaacct = v_bankaccount;
      else
        update ddmast set status = decode(v_accountstatus,'10','A','C'),clsdate = v_branddate,branchdate = v_branddate where refcasaacct = v_bankaccount;
      end if;
    end if;


    update CASH_ACCOUNT_AITHER set status = 'C', tlid = p_txmsg.tlid, lastchange= systimestamp   where autoid = p_txmsg.txfields('01').value;
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
         plog.init ('TXPKS_#6609EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#6609EX;
/
