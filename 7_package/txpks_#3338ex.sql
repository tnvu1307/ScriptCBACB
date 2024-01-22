SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3338ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3338EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      18/12/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3338ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_isincode         CONSTANT CHAR(2) := '01';
   c_camastid         CONSTANT CHAR(2) := '02';
   c_custodycd        CONSTANT CHAR(2) := '08';
   c_ddacctno         CONSTANT CHAR(2) := '03';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_optsymbol        CONSTANT CHAR(2) := '24';
   c_qtty             CONSTANT CHAR(2) := '10';
   c_exprice          CONSTANT CHAR(2) := '05';
   c_balance          CONSTANT CHAR(2) := '15';
   c_amount           CONSTANT CHAR(2) := '11';
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
--pragma autonomous_transaction;
L_txnum varchar2(50);
v_camastid varchar2(50);
v_custodcyd varchar2(20);
v_trfacctno varchar2(50);
l_reqtxnum varchar2(20);
l_refcasaacct varchar2(50);
l_bankacctno varchar2(50);
l_txtype varchar2(50);
v_sb     varchar2(1);
v_tradeplace varchar2(20);
v_batchname varchar2(50);
v_status varchar2(3);
l_desc varchar2(2000);
l_count number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    L_txnum:=fn_getglobalid(p_txmsg.txdate, p_txmsg.txnum);
    v_camastid:=replace(p_txmsg.txfields('02').value,'.');
    v_custodcyd:=p_txmsg.txfields('08').value;
    l_refcasaacct:=p_txmsg.txfields('03').value;
    l_txtype := 'CARRI';
    select acctno into v_trfacctno
        from ddmast
        where refcasaacct=l_refcasaacct and status <> 'C' and isdefault='Y';

    --Ngay 13/02/2020 NamTv chinh sua tach cat tien ra giao dich rieng
    --Lay trang thai cua su kien
    select msgstatus into v_status
    from caregister
    where camastid=v_camastid
        and custodycd=v_custodcyd
        and trfacctno=v_trfacctno
        and rownum=1;

    IF v_status='B' THEN --Neu la B chi doi trang thai khong thuc hien UNHOLD cap nhat lai trang thai de di cat tien
        update caregister set msgstatus='U'
            where camastid=v_camastid
                and custodycd=v_custodcyd
                and trfacctno=v_trfacctno
                and msgstatus='B';
        RETURN systemnums.C_SUCCESS; --Tra ve thang cong luon
    END IF;

    --select tradeplace INTO v_tradeplace from sbsecurities where symbol = p_txmsg.txfields('04').value;

    --Lay thong tin unhole
    select reqtxnum into l_reqtxnum
        from caregister
        where camastid=v_camastid
            and custodycd=v_custodcyd
            and trfacctno=v_trfacctno
            and msgstatus in ('A','E')
            and rownum=1;

    begin
        select  BANKACCTNO INTO l_bankacctno
        from BANKNOSTRO where BANKTRANS='INTRFCAREG';
    EXCEPTION
      WHEN others THEN -- caution handles all exceptions
       l_bankacctno:='';
    end;
    /*select SUPEBANK into v_sb from CFMAST where CUSTODYCD = v_custodcyd;

    INSERT INTO CBFA_BANKPAYMENT(AUTOID,GLOBALID,CUSTODYCD,ACCTNO,TXTYPE,TRANSTYPE,TXNUM,TXDATE,
                                  CITAD,BANKNAME,BANKBRACH,BENEFICIARYACCOUNT,CUSTNAME,CREATETIME,TXAMT,
                                  REFCONTRACT,FEETYPE,SUPERBANK,ISAPPRSB,BANKSTATUS,SYNSTATUS,VALUEDATE,
                                  REFBANKACCT,TLTXCD)
     SELECT SEQ_CBFABANKPAYMENT.NEXTVAL,L_txnum,v_custodcyd,v_trfacctno,l_txtype,'I',p_txmsg.txnum,
            p_txmsg.txdate,null,null,null,l_bankacctno,null, systimestamp,p_txmsg.txfields(c_amount).value,
             null,'0',v_sb,CASE WHEN v_sb = 'N' THEN 'Y' ELSE 'N' END,
            'P','P',null,l_refcasaacct,p_txmsg.tltxcd
     FROM DUAL;*/

    /*IF v_sb = 'Y' AND v_tradeplace = 'OTC' THEN
      insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd)
      values
             ('CB.'||TO_CHAR(p_txmsg.txdate,'YYYYMMDD')||'.'||p_txmsg.txnum,seq_log_notify_cbfa.nextval,
             'CBFABANKPAYMENT','GLOBALID',L_txnum,p_txmsg.txdesc,p_txmsg.txnum,p_txmsg.txdate,p_txmsg.tltxcd);
    ELSE*/
    p_err_code:=0;

    select count(1) into l_count
    from crbtxreq
    where reqtxnum = l_reqtxnum and status = 'C' and trfcode = 'HOLD';

    IF l_count > 0 THEN
        pck_bankapi.Bank_UNholdbalance(
            l_reqtxnum,  ---txnum cua giao dich hold
            v_trfacctno,  --- tk ddmast
            to_number(p_txmsg.txfields('11').value),  -- so tien
            'INTRFCAREG', --request code cua nghiep vu trong allcode
            L_txnum,  --requestkey duy nhat de truy lai giao dich goc
            'Debit account for '||p_txmsg.txfields('04').value||' right subscription',
            '0000', -- nguoi tao giao dich
            P_ERR_CODE);
    END IF;

    IF v_batchname ='CASHDEBITDATE' THEN
        IF p_err_code <> systemnums.c_success THEN
            
            update caregister set msgstatus='E', errcode=p_err_code, UNREQTXNUM=L_txnum
                where camastid=v_camastid
                    and custodycd=v_custodcyd
                    and trfacctno=v_trfacctno
                    and msgstatus='A';
        ELSE
            update caregister set msgstatus='U', errcode=p_err_code, UNREQTXNUM=L_txnum
                where camastid=v_camastid
                    and custodycd=v_custodcyd
                    and trfacctno=v_trfacctno
                    and msgstatus='A';
        END IF;
    ELSE
        IF p_err_code <> systemnums.c_success THEN
            
            RETURN errnums.C_BIZ_RULE_INVALID;
        ELSE
            update caregister set msgstatus='U', errcode=p_err_code, UNREQTXNUM=L_txnum
                where camastid=v_camastid
                    and custodycd=v_custodcyd
                    and trfacctno=v_trfacctno
                    and msgstatus in ('A','E');
        END IF;
    END IF;

/*    IF p_err_code <> systemnums.c_success THEN
        
        rollback;
        RETURN errnums.C_BIZ_RULE_INVALID;
    ELSE
    commit;
        dbms_lock.sleep(10);
        pck_bankapi.Bank_NostroWtransfer( v_trfacctno,  --- tk ddmast tk doi ung (ca nhan)
                                          l_bankacctno, --- so tk nostro (tu doanh )
                                          'INTRFCAREG', ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
                                          'D',  -- Debit or credit
                                          to_number(p_txmsg.txfields('11').value),  --- so tien
                                          'INTRFCAREG', --request code cua nghiep vu trong allcode
                                          L_txnum,  --requestkey duy nhat de truy lai giao dich goc
                                          'Event registration customer purchase rights',  -- dien giai
                                          '0000', -- nguoi tao giao dich
                                          P_ERR_CODE);
        IF p_err_code <> systemnums.c_success THEN
        rollback;
            RETURN errnums.C_BIZ_RULE_INVALID;
        ELSE
           update caregister set msgstatus='P', errcode=p_err_code, banktxnum=L_txnum, banktxdate=TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)
                where camastid=v_camastid
                and custodycd=v_custodcyd
                and trfacctno=v_trfacctno
                and msgstatus='A';
                commit;
        END IF;
    END IF;*/
    --END IF;
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
         plog.init ('TXPKS_#3338EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3338EX;
/
