SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3334EX
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3334EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      23/10/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3334EX
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '01';
   c_notransct        CONSTANT CHAR(2) := '71';
   c_camastid         CONSTANT CHAR(2) := '02';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_optsymbol        CONSTANT CHAR(2) := '24';
   c_custodycd        CONSTANT CHAR(2) := '81';
   c_fullname         CONSTANT CHAR(2) := '08';
   c_iddate           CONSTANT CHAR(2) := '33';
   c_tocustodycd      CONSTANT CHAR(2) := '82';
   c_remoaccount      CONSTANT CHAR(2) := '31';
   c_citad            CONSTANT CHAR(2) := '32';
   c_tomemcus         CONSTANT CHAR(2) := '34';
   c_qtty             CONSTANT CHAR(2) := '10';
   c_exprice          CONSTANT CHAR(2) := '05';
   c_amount           CONSTANT CHAR(2) := '11';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
l_balance number;
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
    begin
        select balance into l_balance
        from ddmast
        where refcasaacct = p_txmsg.txfields('31').value and status <> 'C';
    exception
    when others then
        l_balance:=0;
    end;
    if l_balance < to_number(p_txmsg.txfields('11').value) then
        p_err_code := '-400101';
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
l_refcasaacctdr varchar2(50);
l_refcasaacctcr varchar2(50);
l_custnamecr varchar2(500);
l_custnamedr varchar2(500);
l_trfacctnodr varchar2(50);
l_trfacctnocr varchar2(50);
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

    select remoaccount,ddacctno,custname,custname2 into l_refcasaacctdr,l_refcasaacctcr,l_custnamecr,l_custnamedr
        from catransfer where autoid=p_txmsg.txfields('01').value;
    BEGIN
        SELECT ACCTNO INTO L_TRFACCTNODR FROM DDMAST WHERE REFCASAACCT=L_REFCASAACCTDR AND STATUS <> 'C';
    EXCEPTION
    WHEN OTHERS
       THEN
       L_TRFACCTNODR:='';
    END;

    BEGIN
        SELECT ACCTNO INTO L_TRFACCTNOCR FROM DDMAST WHERE REFCASAACCT=L_REFCASAACCTCR AND STATUS <> 'C';
    EXCEPTION
    WHEN OTHERS
       THEN
       L_TRFACCTNOCR:='';
    END;

    IF L_TRFACCTNODR is not null and L_TRFACCTNOCR is null THEN
        if p_txmsg.txstatus = 0  and p_txmsg.deltd <> 'Y' then --cho duyet
           pck_bankapi.Checkblacklist(l_custnamecr,p_txmsg.txnum,p_txmsg.txdate,p_txmsg.tlid,'',p_err_code);
        end if;
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
l_nostroacct varchar2(50);
l_trftype varchar2(50);
l_trfacctnodr varchar2(50);
l_trfacctnocr varchar2(50);
l_refcasaacctdr varchar2(50);
l_refcasaacctcr varchar2(50);
l_custnamecr varchar2(500);
l_custnamedr varchar2(500);
l_RBANKCITAD varchar2(50);
v_custodycd  varchar2(50);
v_sb varchar2(1);
v_fundcode varchar2(50);
l_txtype    varchar2(20);
v_globalid  varchar2(50);
v_refbankacct varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    if p_txmsg.deltd <> 'Y' then
        Begin
            select bankacctno into l_nostroacct
            from banknostro where banktrans='OUTTRFODSELL';
        EXCEPTION
        WHEN OTHERS
           THEN
           l_nostroacct:='';
        end;

        --Lay thong tin tai khoan tien nguoi nhan
        select remoaccount,ddacctno,custname,custname2,citad into l_refcasaacctdr,l_refcasaacctcr,l_custnamecr,l_custnamedr,l_RBANKCITAD
        from catransfer where autoid=p_txmsg.txfields('01').value;

        --Lay tai khoan di tien
        BEGIN
            SELECT ACCTNO INTO L_TRFACCTNODR FROM DDMAST WHERE REFCASAACCT=L_REFCASAACCTDR AND STATUS <> 'C';
        EXCEPTION
        WHEN OTHERS
           THEN
           L_TRFACCTNODR:='';
        END;

        BEGIN
            SELECT ACCTNO INTO L_TRFACCTNOCR FROM DDMAST WHERE REFCASAACCT=L_REFCASAACCTCR AND STATUS <> 'C';
        EXCEPTION
        WHEN OTHERS
           THEN
           L_TRFACCTNOCR:='';
        END;

        v_custodycd := p_txmsg.txfields(c_tocustodycd).value;
        select NVL(SUPEBANK,'N'), NVL(FUNDCODE,'') into v_sb,v_fundcode from CFMAST where CUSTODYCD = v_custodycd;
        l_txtype := 'CABUYR';

        v_globalid := 'CB.'||TO_CHAR(p_txmsg.txdate,'YYYYMMDD')||'.'||p_txmsg.txnum;

        select d.refcasaacct into v_refbankacct from ddmast d where d.acctno = L_TRFACCTNODR;

        INSERT INTO CBFA_BANKPAYMENT(AUTOID,GLOBALID,CUSTODYCD,ACCTNO,TXTYPE,TRANSTYPE,TXNUM,TXDATE,
                                  CITAD,BANKNAME,BANKBRACH,BENEFICIARYACCOUNT,CUSTNAME,CREATETIME,TXAMT,
                                  REFCONTRACT,FEETYPE,SUPERBANK,ISAPPRSB,BANKSTATUS,SYNSTATUS,VALUEDATE,
                                  REFBANKACCT,TLTXCD)
        SELECT SEQ_CBFABANKPAYMENT.NEXTVAL,v_globalid,v_custodycd,L_TRFACCTNODR,l_txtype,null,p_txmsg.txnum,
            p_txmsg.txdate,l_RBANKCITAD,null,null,L_REFCASAACCTCR,null, systimestamp,p_txmsg.txfields(c_amount).value,
            p_txmsg.txfields('71').value,'1',v_sb,CASE WHEN v_sb = 'N' THEN 'Y' ELSE 'N' END,
            'P','P',null,v_refbankacct, p_txmsg.tltxcd
        FROM DUAL;

        IF v_sb = 'Y' OR (v_fundcode is not null and length(trim(v_fundcode)) >0) THEN -- SB duyet
          insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values
             ('CB.'||TO_CHAR(p_txmsg.txdate,'YYYYMMDD')||'.'||p_txmsg.txnum,seq_log_notify_cbfa.nextval,
             'CBFABANKPAYMENT','GLOBALID',v_globalid,p_txmsg.txdesc,p_txmsg.txnum,p_txmsg.txdate,p_txmsg.tltxcd,SYSDATE,p_txmsg.busdate);
        ELSE
        IF L_TRFACCTNODR IS NOT NULL AND L_TRFACCTNOCR IS NOT NULL THEN
            pck_bankapi.Bank_Internal_Tranfer(
                  L_TRFACCTNODR,  --- tk ddmast tk chuyen
                  l_custnamecr, ---ten tk nhan
                  L_TRFACCTNOCR, --- so tk nhan
                  to_number(p_txmsg.txfields('11').value),  --- so tien
                  'OUTTRFODSELL', --request code cua nghiep vu trong allcode
                  v_globalid,  --requestkey duy nhat de truy lai giao dich goc
                  'List of customers on money right issue transfer',  -- dien giai
                  '0000', -- nguoi tao giao dich
                  P_ERR_CODE);

                 IF p_err_code <> systemnums.c_success THEN
                    RETURN errnums.C_BIZ_RULE_INVALID;
/*                     update catransfer set status='B', errcode=p_err_code, reqtxnum=to_char(p_txmsg.txdate,systemnums.C_DATE_FORMAT)||p_txmsg.txnum
                     where autoid=p_txmsg.txfields('01').value and status='H';*/
                 ELSE
                     update catransfer set status='P', errcode=p_err_code, reqtxnum=to_char(p_txmsg.txdate,systemnums.C_DATE_FORMAT)||p_txmsg.txnum
                     where autoid=p_txmsg.txfields('01').value and status='H';
                 END IF;
        ELSIF L_TRFACCTNODR is not null and L_TRFACCTNOCR is null THEN
            pck_bankapi.Bank_Tranfer_Out(
                  L_TRFACCTNODR,  --- tk ddmast tk chuyen
                  l_custnamecr, ---ten tk nhan
                  L_TRFACCTNOCR, --- so tk nhan
                  l_RBANKCITAD, --- so citad ngan hang nhan
                  to_number(p_txmsg.txfields('11').value),  --- so tien
                  'OUTTRFODSELL', --request code cua nghiep vu trong allcode
                  v_globalid,  --requestkey duy nhat de truy lai giao dich goc
                  'List of customers on money right issue transfer',  -- dien giai
                  '0000', -- nguoi tao giao dich
                  P_ERR_CODE)  ;

                 IF p_err_code <> systemnums.c_success THEN
                     RETURN errnums.C_BIZ_RULE_INVALID;
/*                     update catransfer set status='B', errcode=p_err_code, reqtxnum=to_char(p_txmsg.txdate,systemnums.C_DATE_FORMAT)||p_txmsg.txnum
                     where autoid=p_txmsg.txfields('01').value and status='H';
*/               ELSE
                     update catransfer set status='P', errcode=p_err_code, reqtxnum=to_char(p_txmsg.txdate,systemnums.C_DATE_FORMAT)||p_txmsg.txnum
                     where autoid=p_txmsg.txfields('01').value and status='H';
                 END IF;
        END IF;
        END IF;

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
         plog.init ('TXPKS_#3334EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3334EX;
/
