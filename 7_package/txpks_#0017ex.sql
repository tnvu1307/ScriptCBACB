SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#0017ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0017EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      24/07/2013     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#0017ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custid           CONSTANT CHAR(2) := '03';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_nfullname        CONSTANT CHAR(2) := '38';
   c_fullname         CONSTANT CHAR(2) := '28';
   c_idcode           CONSTANT CHAR(2) := '21';
   c_nidcode          CONSTANT CHAR(2) := '31';
   c_iddate           CONSTANT CHAR(2) := '22';
   c_niddate          CONSTANT CHAR(2) := '32';
   c_idexpired        CONSTANT CHAR(2) := '23';
   c_nidexpired       CONSTANT CHAR(2) := '33';
   c_idplace          CONSTANT CHAR(2) := '24';
   c_nidplace         CONSTANT CHAR(2) := '34';
   c_tradingcode      CONSTANT CHAR(2) := '25';
   c_ntradingcode     CONSTANT CHAR(2) := '35';
   c_tradingcodedt    CONSTANT CHAR(2) := '26';
   c_ntradingcodedt   CONSTANT CHAR(2) := '36';
   c_address          CONSTANT CHAR(2) := '27';
   c_naddress         CONSTANT CHAR(2) := '37';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
l_custodycd varchar2(10);
l_idtype varchar2(10);
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
    if nvl(p_txmsg.txfields(c_fullname).value,'XYZ') = nvl(p_txmsg.txfields(c_nfullname).value,'XYZ')
            and nvl(p_txmsg.txfields(c_idcode).value,'XYZ') = nvl(p_txmsg.txfields(c_nidcode).value,'XYZ')
            and to_date(p_txmsg.txfields(c_iddate).value,'DD/MM/RRRR') = to_date(p_txmsg.txfields(c_niddate).value,'DD/MM/RRRR')
            and to_date(p_txmsg.txfields(c_idexpired).value,'DD/MM/RRRR') = to_date(p_txmsg.txfields(c_nidexpired).value,'DD/MM/RRRR')
            and nvl(p_txmsg.txfields(c_idplace).value,'XYZ') = nvl(p_txmsg.txfields(c_nidplace).value,'XYZ')
            and nvl(p_txmsg.txfields(c_tradingcode).value,'XYZ') = nvl(p_txmsg.txfields(c_ntradingcode).value,'XYZ')
            and p_txmsg.txfields(c_tradingcodedt).value = p_txmsg.txfields(c_ntradingcodedt).value
            and nvl(p_txmsg.txfields(c_address).value,'XYZ') = nvl(p_txmsg.txfields(c_naddress).value,'XYZ')
            and nvl(p_txmsg.txfields('45').value,'XYZ') = nvl(p_txmsg.txfields('46').value,'XYZ')
            and nvl(p_txmsg.txfields('47').value,'XYZ') = nvl(p_txmsg.txfields('48').value,'XYZ')
        then
        p_err_code := '-100145'; -- Pre-defined in DEFERROR table
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;

    if p_txmsg.txfields(c_tradingcodedt).value <> p_txmsg.txfields(c_ntradingcodedt).value
        then
        select idtype into l_idtype from cfmast where custid = p_txmsg.txfields(c_custid).value;
        if l_idtype = '009' and to_date(p_txmsg.txfields(c_ntradingcodedt).value,'DD/MM/RRRR') > p_txmsg.txdate then
            p_err_code := '-200415'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
    end if;

    select nvl(custodycd,'X') into l_custodycd from cfmast where custid = p_txmsg.txfields(c_custid).value;
    if l_custodycd is null or length(l_custodycd) <> 10 then
        p_err_code := '-200413'; -- Pre-defined in DEFERROR table
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
l_cutmark varchar2(1000);
l_modnum NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    -- Insert log
    insert into cfvsdlog(custid,ofullname,nfullname,oaddress,naddress,
            oidcode,nidcode,oiddate,niddate,oidexpired,nidexpired,
            oidplace,nidplace,otradingcode,
            ntradingcode,otradingcodedt,ntradingcodedt,
            TXdate,txnum,confirmtxdate,confirmtxnum,ocusttype,ncusttype,TYPEOFDOCUMENT,STATUS)
    values (p_txmsg.txfields(c_custid).value,
            p_txmsg.txfields(c_fullname).value,
            p_txmsg.txfields(c_nfullname).value,
            p_txmsg.txfields(c_address).value,
            p_txmsg.txfields(c_naddress).value,
            p_txmsg.txfields(c_idcode).value,
            p_txmsg.txfields(c_nidcode).value,
            to_date(p_txmsg.txfields(c_iddate).value,'DD/MM/RRRR'),
            to_date(p_txmsg.txfields(c_niddate).value,'DD/MM/RRRR'),
            to_date(p_txmsg.txfields(c_idexpired).value,'DD/MM/RRRR'),
            to_date(p_txmsg.txfields(c_nidexpired).value,'DD/MM/RRRR'),
            p_txmsg.txfields(c_idplace).value,
            p_txmsg.txfields(c_nidplace).value,
            p_txmsg.txfields(c_tradingcode).value,
            p_txmsg.txfields(c_ntradingcode).value,
            (case when replace(replace(p_txmsg.txfields(c_tradingcodedt).value,'/',''),' ','') is not null then to_date(p_txmsg.txfields(c_tradingcodedt).value,'DD/MM/RRRR') else null end),
            (case when replace(replace(p_txmsg.txfields(c_ntradingcodedt).value,'/',''),' ','') is not null then to_date(p_txmsg.txfields(c_ntradingcodedt).value,'DD/MM/RRRR') else null end),
            p_txmsg.txdate,
            p_txmsg.txnum,
            null,
            null, p_txmsg.txfields('45').value, p_txmsg.txfields('46').value,
            p_txmsg.txfields('83').value,
            p_txmsg.txfields('82').value
            )
           ;
    -- Cap nhat CFMAST
    l_cutmark:= p_txmsg.txfields(c_nfullname).value;
    FOR J In 1..length(p_txmsg.txfields(c_nfullname).value) LOOP
        if instr(UTF8NUMS.c_FindText,substr(p_txmsg.txfields(c_nfullname).value,J,1)) > 0 then
            l_cutmark:= replace(l_cutmark,substr(p_txmsg.txfields(c_nfullname).value,J,1),substr(UTF8NUMS.c_ReplText,instr(UTF8NUMS.c_FindText,substr(p_txmsg.txfields(c_nfullname).value,J,1)),1));
        end if;
    END LOOP;


    update cfmast
    set fullname = p_txmsg.txfields(c_nfullname).value,
        mnemonic = l_cutmark,
        address = p_txmsg.txfields(c_naddress).value,
        idcode = p_txmsg.txfields(c_nidcode).value,
        iddate = to_date(p_txmsg.txfields(c_niddate).value,'DD/MM/RRRR'),
        idexpired = to_date(p_txmsg.txfields(c_nidexpired).value,'DD/MM/RRRR'),
        idplace = p_txmsg.txfields(c_nidplace).value,
        tradingcode = p_txmsg.txfields(c_ntradingcode).value,
        tradingcodedt =(case when replace(replace(p_txmsg.txfields(c_ntradingcodedt).value,'/',''),' ','') is not null then to_date(p_txmsg.txfields(c_ntradingcodedt).value,'DD/MM/RRRR') else null end),
        custtype = p_txmsg.txfields('46').value,
        VAT = p_txmsg.txfields('48').value,
        last_mkid = p_txmsg.tlid,
        last_ofid = nvl(p_txmsg.offid,p_txmsg.tlid)
    where custid = p_txmsg.txfields(c_custid).value;
    select nvl(max(mod_num)+1,0) into l_modnum from maintain_log where substr(record_key,11,10)=p_txmsg.txfields(c_custid).value;
    if p_txmsg.txfields(c_fullname).value <> p_txmsg.txfields(c_nfullname).value
    then
        INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME)
        VALUES('CFMAST','CUSTID = ''' || p_txmsg.txfields(c_custid).value || '''',p_txmsg.tlid,p_txmsg.txdate,'Y',p_txmsg.offid,
            p_txmsg.txdate,l_modnum,'FULLNAME',p_txmsg.txfields(c_fullname).value,p_txmsg.txfields(c_nfullname).value,'EDIT',NULL,NULL,TO_CHAR(SYSDATE,'HH:MM:SS'));
    end if;

    if p_txmsg.txfields(c_idcode).value <> p_txmsg.txfields(c_nidcode).value
    then
        INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME)
        VALUES('CFMAST','CUSTID = ''' || p_txmsg.txfields(c_custid).value || '''',p_txmsg.tlid,p_txmsg.txdate,'Y',p_txmsg.offid,
            p_txmsg.txdate,l_modnum,'IDCODE',p_txmsg.txfields(c_idcode).value,p_txmsg.txfields(c_nidcode).value,'EDIT',NULL,NULL,TO_CHAR(SYSDATE,'HH:MM:SS'));
    end if;
    if to_date(p_txmsg.txfields(c_iddate).value,'DD/MM/RRRR') <> to_date(p_txmsg.txfields(c_niddate).value,'DD/MM/RRRR')
    then
        INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME)
        VALUES('CFMAST','CUSTID = ''' || p_txmsg.txfields(c_custid).value || '''',p_txmsg.tlid,p_txmsg.txdate,'Y',p_txmsg.offid,
            p_txmsg.txdate,l_modnum,'IDDATE',to_date(p_txmsg.txfields(c_iddate).value,'DD/MM/RRRR'),to_date(p_txmsg.txfields(c_niddate).value,'DD/MM/RRRR'),'EDIT',NULL,NULL,TO_CHAR(SYSDATE,'HH:MM:SS'));
    end if;
    if to_date(p_txmsg.txfields(c_idexpired).value,'DD/MM/RRRR') <> to_date(p_txmsg.txfields(c_nidexpired).value,'DD/MM/RRRR')
    then
        INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME)
        VALUES('CFMAST','CUSTID = ''' || p_txmsg.txfields(c_custid).value || '''',p_txmsg.tlid,p_txmsg.txdate,'Y',p_txmsg.offid,
            p_txmsg.txdate,l_modnum,'IDEXPIRED',to_date(p_txmsg.txfields(c_idexpired).value,'DD/MM/RRRR'),to_date(p_txmsg.txfields(c_nidexpired).value,'DD/MM/RRRR'),'EDIT',NULL,NULL,TO_CHAR(SYSDATE,'HH:MM:SS'));
    end if;
    if p_txmsg.txfields(c_idplace).value <> p_txmsg.txfields(c_nidplace).value
    then
        INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME)
        VALUES('CFMAST','CUSTID = ''' || p_txmsg.txfields(c_custid).value || '''',p_txmsg.tlid,p_txmsg.txdate,'Y',p_txmsg.offid,
            p_txmsg.txdate,l_modnum,'IDPLACE',p_txmsg.txfields(c_idplace).value,p_txmsg.txfields(c_nidplace).value,'EDIT',NULL,NULL,TO_CHAR(SYSDATE,'HH:MM:SS'));
    end if;
    if p_txmsg.txfields(c_tradingcode).value <> p_txmsg.txfields(c_ntradingcode).value
    then
        INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME)
        VALUES('CFMAST','CUSTID = ''' || p_txmsg.txfields(c_custid).value || '''',p_txmsg.tlid,p_txmsg.txdate,'Y',p_txmsg.offid,
            p_txmsg.txdate,l_modnum,'TRADINHCODE',p_txmsg.txfields(c_tradingcode).value,p_txmsg.txfields(c_ntradingcode).value,'EDIT',NULL,NULL,TO_CHAR(SYSDATE,'HH:MM:SS'));
    end if;
    if p_txmsg.txfields(c_tradingcodedt).value <> p_txmsg.txfields(c_ntradingcodedt).value
    then
        INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME)
        VALUES('CFMAST','CUSTID = ''' || p_txmsg.txfields(c_custid).value || '''',p_txmsg.tlid,p_txmsg.txdate,'Y',p_txmsg.offid,
            p_txmsg.txdate,l_modnum,'TRADINGCODEDT',p_txmsg.txfields(c_tradingcodedt).value,p_txmsg.txfields(c_ntradingcodedt).value,'EDIT',NULL,NULL,TO_CHAR(SYSDATE,'HH:MM:SS'));
    end if;

    if p_txmsg.txfields(c_address).value <> p_txmsg.txfields(c_naddress).value
    then
        INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME)
        VALUES('CFMAST','CUSTID = ''' || p_txmsg.txfields(c_custid).value || '''',p_txmsg.tlid,p_txmsg.txdate,'Y',p_txmsg.offid,
            p_txmsg.txdate,l_modnum,'ADDRESS',p_txmsg.txfields(c_address).value,p_txmsg.txfields(c_naddress).value,'EDIT',NULL,NULL,TO_CHAR(SYSDATE,'HH:MM:SS'));
    end if;

    if p_txmsg.txfields('45').value <> p_txmsg.txfields('46').value
    then
        INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME)
        VALUES('CFMAST','CUSTID = ''' || p_txmsg.txfields(c_custid).value || '''',p_txmsg.tlid,p_txmsg.txdate,'Y',p_txmsg.offid,
            p_txmsg.txdate,l_modnum,'CUSTTYPE',p_txmsg.txfields('45').value,p_txmsg.txfields('46').value,'EDIT',NULL,NULL,TO_CHAR(SYSDATE,'HH:MM:SS'));
    end if;

    if p_txmsg.txfields('47').value <> p_txmsg.txfields('48').value
    then
        INSERT INTO maintain_log (TABLE_NAME,RECORD_KEY,MAKER_ID,MAKER_DT,APPROVE_RQD,APPROVE_ID,APPROVE_DT,MOD_NUM,COLUMN_NAME,FROM_VALUE,TO_VALUE,ACTION_FLAG,CHILD_TABLE_NAME,CHILD_RECORD_KEY,MAKER_TIME)
        VALUES('CFMAST','CUSTID = ''' || p_txmsg.txfields(c_custid).value || '''',p_txmsg.tlid,p_txmsg.txdate,'Y',p_txmsg.offid,
            p_txmsg.txdate,l_modnum,'VAT',p_txmsg.txfields('47').value,p_txmsg.txfields('48').value,'EDIT',NULL,NULL,TO_CHAR(SYSDATE,'HH:MM:SS'));
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
         plog.init ('TXPKS_#0017EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#0017EX;
/
