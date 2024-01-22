SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3339ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3339EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      12/02/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3339ex
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
L_txnum varchar2(50);
v_camastid varchar2(50);
v_custodcyd varchar2(20);
v_trfacctno varchar2(50);
l_reqtxnum varchar2(20);
l_refcasaacct varchar2(50);
l_bankacctno varchar2(50);
l_txtype varchar2(50);
v_sb     varchar2(1);
v_fundcode  varchar2(50);
v_tradeplace varchar2(20);
v_batchname varchar2(50);
l_bankname varchar2(1000);
v_afacctno varchar2(20);
l_codeid varchar2(10);
l_symbol varchar(50);
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
    select acctno,afacctno into v_trfacctno, v_afacctno
        from ddmast
        where refcasaacct=l_refcasaacct and status <> 'C';
    --thunt-04/05/2020: lay thong tin ma ck chot
    select codeid into l_codeid
        from caschd
        where camastid=v_camastid and afacctno=v_afacctno and deltd ='N';

    select symbol into l_symbol from sbsecurities where codeid=l_codeid;
    begin
        select  BANKACCTNO,OWNERNAME INTO l_bankacctno, l_bankname
        from BANKNOSTRO where BANKTRANS='INTRFCARIGHT' AND BANKTYPE='001';
    EXCEPTION
      WHEN others THEN -- caution handles all exceptions
       l_bankacctno:='';
    end;

    select tradeplace INTO v_tradeplace from sbsecurities where symbol = p_txmsg.txfields('04').value;
    select NVL(SUPEBANK,'N'), NVL(FUNDCODE,'') into v_sb,v_fundcode from CFMAST where CUSTODYCD = v_custodcyd;

    INSERT INTO CBFA_BANKPAYMENT(AUTOID,GLOBALID,CUSTODYCD,ACCTNO,TXTYPE,TRANSTYPE,TXNUM,TXDATE,
                                  CITAD,BANKNAME,BANKBRACH,BENEFICIARYACCOUNT,CUSTNAME,CREATETIME,TXAMT,
                                  REFCONTRACT,FEETYPE,SUPERBANK,ISAPPRSB,BANKSTATUS,SYNSTATUS,VALUEDATE,
                                  REFBANKACCT,TLTXCD)
     SELECT SEQ_CBFABANKPAYMENT.NEXTVAL,L_txnum,v_custodcyd,v_trfacctno,l_txtype,'I',p_txmsg.txnum,
            p_txmsg.txdate,null,null,null,l_bankacctno,null, systimestamp,p_txmsg.txfields(c_amount).value,
             null,'1',v_sb,CASE WHEN v_sb = 'N' THEN 'Y' ELSE 'N' END,
            'P','P',null,l_refcasaacct,p_txmsg.tltxcd
     FROM DUAL;

    IF (v_sb = 'Y' OR (v_fundcode is not null and length(trim(v_fundcode)) >0)) AND v_tradeplace = 'OTC' THEN--Sb duyet
      insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
      values
             ('CB.'||TO_CHAR(p_txmsg.txdate,'YYYYMMDD')||'.'||p_txmsg.txnum,seq_log_notify_cbfa.nextval,
             'CBFABANKPAYMENT','GLOBALID',L_txnum,p_txmsg.txdesc,p_txmsg.txnum,p_txmsg.txdate,p_txmsg.tltxcd,SYSDATE,p_txmsg.busdate);
    ELSE

    pck_bankapi.Bank_Internal_Tranfer_fa(v_trfacctno,  --- tk ddmast tk chuyen
                                      l_bankname, ---ten tk nhan
                                      l_bankacctno, --- so tk nhan
                                      to_number(p_txmsg.txfields('11').value),  --- so tien
                                      'INTRFCARIGHT', --request code cua nghiep vu trong allcode
                                      L_txnum,  --requestkey duy nhat de truy lai giao dich goc
                                      'Debit account for '||l_symbol||' right subscription',  -- dien giai
                                      '0000', -- nguoi tao giao dich
                                      P_ERR_CODE);

    IF p_err_code <> systemnums.c_success THEN
       update caregister set msgstatus='B', errcode=p_err_code, banktxnum=L_txnum, banktxdate=TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)
            where camastid=v_camastid
            and custodycd=v_custodcyd
            and trfacctno=v_trfacctno
            and msgstatus in ('U', 'H');
    ELSE
        --Ngay 14/02/2020 NamTv goi them Api confirmation_swift566 sau khi nhan ket qua thanh cong
        gen_confirmation_swift566_014(v_camastid,v_afacctno);
        --Cap nhat trang thai sau khi nhan ket qua tu api
       update caregister set msgstatus='P', errcode=p_err_code, banktxnum=L_txnum, banktxdate=TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)
            where camastid=v_camastid
            and custodycd=v_custodcyd
            and trfacctno=v_trfacctno
            and msgstatus in ('U', 'H');
    END IF;
    END IF;
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
         plog.init ('TXPKS_#3339EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3339EX;
/
