SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1711ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1711EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      16/09/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1711ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_mttype           CONSTANT CHAR(2) := '06';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_camastid         CONSTANT CHAR(2) := '03';
   c_refnum           CONSTANT CHAR(2) := '04';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_sendswift varchar2(4);
l_rowcount  number;
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
 IF p_txmsg.deltd <> 'Y' THEN
    if UPPER(p_txmsg.txfields('88').value) <> 'ALL' then
        select trim(nvl(cf.sendswift,'N')) into v_sendswift
        from cfmast cf
        where custodycd = p_txmsg.txfields('88').value ;
             IF NOT v_sendswift='Y' THEN
                p_err_code := '-199222';
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
             END IF;

        l_rowcount := REGEXP_COUNT(p_txmsg.txfields('31').value, chr(10), 1, 'i') + 1;
        if p_txmsg.txfields('06').value = '568' and l_rowcount > 10 then
            p_err_code := '-199223';
            
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        elsif p_txmsg.txfields('06').value = '599' and l_rowcount > 35 then
            p_err_code := '-199224';
            
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
    end if;
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
v_sendswift varchar2(4);
v_camastid varchar2(100);
v_txnum varchar2(10);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
 IF p_txmsg.deltd <> 'Y' THEN
    v_camastid := replace(p_txmsg.txfields('03').value,'.','');
    
    if UPPER(p_txmsg.txfields('88').value) = 'ALL' then
        if p_txmsg.txfields('06').value = '599' then
            for r in
                ( SELECT cf.custodycd FROM cfmast cf WHERE cf.status <> 'C' and cf.sendswift ='Y')
            loop
                FOR REC IN (
                          SELECT TRFCODE, BANKCODE FROM VSDTRFCODE WHERE TLTXCD='1711'  AND STATUS='Y' and vsdmt=p_txmsg.txfields('06').value AND (TYPE = 'REQ'
                           AND BANKCODE ='CBP')
                           )
                LOOP
                  SELECT systemnums.C_BATCH_PREFIXED
                             || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                      INTO v_txnum
                      FROM DUAL;
                  INSERT INTO tllogfld(AUTOID, TXNUM, TXDATE, FLDCD, NVALUE, CVALUE, TXDESC)
                  VALUES( seq_tllogfld.NEXTVAL, v_txnum, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),'06',0,p_txmsg.txfields('06').value,'MT type');
                  INSERT INTO tllogfld(AUTOID, TXNUM, TXDATE, FLDCD, NVALUE, CVALUE, TXDESC)
                  VALUES( seq_tllogfld.NEXTVAL, v_txnum, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),'88',0,r.custodycd,'Custody code');
                  INSERT INTO tllogfld(AUTOID, TXNUM, TXDATE, FLDCD, NVALUE, CVALUE, TXDESC)
                  VALUES( seq_tllogfld.NEXTVAL,v_txnum, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),'03',0,p_txmsg.txfields('03').value,'CA Code');
                  INSERT INTO tllogfld(AUTOID, TXNUM, TXDATE, FLDCD, NVALUE, CVALUE, TXDESC)
                  VALUES( seq_tllogfld.NEXTVAL, v_txnum, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),'04',0,p_txmsg.txfields('04').value,'Related Reference');
                  INSERT INTO tllogfld(AUTOID, TXNUM, TXDATE, FLDCD, NVALUE, CVALUE, TXDESC)
                  VALUES( seq_tllogfld.NEXTVAL, v_txnum, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),'30',0,p_txmsg.txfields('30').value,'Message content');
                  INSERT INTO tllogfld(AUTOID, TXNUM, TXDATE, FLDCD, NVALUE, CVALUE, TXDESC)
                  VALUES( seq_tllogfld.NEXTVAL, v_txnum, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),'31',0,p_txmsg.txfields('31').value,'Convert message content');
                  Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE)
                  values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE,'1711' ,v_txnum,p_txmsg.txdate,'N',r.custodycd,'0001','0001', REC.BANKCODE);
                END LOOP;
            end loop;
        else
            for r in
                ( SELECT cf.custodycd FROM caschd_list ca,cfmast cf WHERE  ca.CAMASTID = v_camastid and ca.afacctno  = cf.custid and cf.status <> 'C' and cf.sendswift ='Y')
            loop
                FOR REC IN (
                          SELECT TRFCODE, BANKCODE FROM VSDTRFCODE WHERE TLTXCD='1711'  AND STATUS='Y' and vsdmt=p_txmsg.txfields('06').value AND (TYPE = 'REQ'
                           AND BANKCODE ='CBP')
                           )
                LOOP
                  SELECT systemnums.C_BATCH_PREFIXED
                                 || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                          INTO v_txnum
                          FROM DUAL;
                  INSERT INTO tllogfld(AUTOID, TXNUM, TXDATE, FLDCD, NVALUE, CVALUE, TXDESC)
                  VALUES( seq_tllogfld.NEXTVAL, v_txnum, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),'06',0,p_txmsg.txfields('06').value,'MT type');
                  INSERT INTO tllogfld(AUTOID, TXNUM, TXDATE, FLDCD, NVALUE, CVALUE, TXDESC)
                  VALUES( seq_tllogfld.NEXTVAL, v_txnum, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),'88',0,r.custodycd,'Custody code');
                  INSERT INTO tllogfld(AUTOID, TXNUM, TXDATE, FLDCD, NVALUE, CVALUE, TXDESC)
                  VALUES( seq_tllogfld.NEXTVAL,v_txnum, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),'03',0,p_txmsg.txfields('03').value,'CA Code');
                  INSERT INTO tllogfld(AUTOID, TXNUM, TXDATE, FLDCD, NVALUE, CVALUE, TXDESC)
                  VALUES( seq_tllogfld.NEXTVAL, v_txnum, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),'04',0,p_txmsg.txfields('04').value,'Related Reference');
                  INSERT INTO tllogfld(AUTOID, TXNUM, TXDATE, FLDCD, NVALUE, CVALUE, TXDESC)
                  VALUES( seq_tllogfld.NEXTVAL, v_txnum, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),'30',0,p_txmsg.txfields('30').value,'Message content');
                  INSERT INTO tllogfld(AUTOID, TXNUM, TXDATE, FLDCD, NVALUE, CVALUE, TXDESC)
                  VALUES( seq_tllogfld.NEXTVAL, v_txnum, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),'31',0,p_txmsg.txfields('31').value,'Convert message content');
                  Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE)
                  values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE,'1711' ,v_txnum,p_txmsg.txdate,'N',r.custodycd,'0001','0001', REC.BANKCODE);
                END LOOP;
            end loop;
        end if;
    else
        select nvl(cf.sendswift,'N') into v_sendswift
        from cfmast cf
        where   cf.custodycd = p_txmsg.txfields('88').value ;
        if  trim(v_sendswift)= 'Y' then
            FOR REC IN (
                      SELECT TRFCODE, BANKCODE FROM VSDTRFCODE WHERE TLTXCD='1711'  AND STATUS='Y' and vsdmt=p_txmsg.txfields('06').value AND (TYPE = 'REQ'
                       AND BANKCODE ='CBP') )
            LOOP
               Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,MSGACCT,BRID,TLID,BANKCODE)
               values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE,'1711' ,p_txmsg.txnum,p_txmsg.txdate,'N',p_txmsg.txfields('88').value,'0001','0001', REC.BANKCODE);
            END LOOP;
        end if;
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
         plog.init ('TXPKS_#1711EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1711EX;
/
