SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8869ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8869EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      18/10/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#8869ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_ddacctno         CONSTANT CHAR(2) := '04';
   c_fullname         CONSTANT CHAR(2) := '90';
   c_amount           CONSTANT CHAR(2) := '10';
   c_ddacctno_1       CONSTANT CHAR(2) := '06';
   c_statebank        CONSTANT CHAR(2) := '07';
   c_bankreci         CONSTANT CHAR(2) := '08';
   c_reciname         CONSTANT CHAR(2) := '09';
   c_identity         CONSTANT CHAR(2) := '12';
   c_desc             CONSTANT CHAR(2) := '30';
   c_citad            CONSTANT CHAR(2) := '15';
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_ishold varchar2(2);
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
    select ishold into v_ishold from odmast where orderid  =p_txmsg.txfields('25').value;
    if trim(v_ishold) = 'Y' then
        p_err_code := '-911008';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;

    if length(p_txmsg.txfields('12').value) <> 10 then
        p_txmsg.txWarningException('-930103').value:= cspks_system.fn_get_errmsg('-930103');
        p_txmsg.txWarningException('-930103').errlev:= '1';
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
v_trfcode varchar(100);
globalid_bank varchar2(250);
is_hold_odmast varchar2(10);
v_banknostro varchar2(250);
v_banknostro_trans varchar2(250);
v_feedaily varchar(3);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    /*
    select trfcode into v_trfcode from CRBTRFCODE where objname = '8869' and trfcode = 'BANKTRANSFEROUT8869';
    --gen request key qua bank
    select fn_getglobalid(p_txmsg.txdate, p_txmsg.txnum) into globalid_bank from dual;
    
    IF p_txmsg.deltd <> 'Y' THEN -- Normal TRANSACTION
        IF p_txmsg.txfields ('31').value = 'DD' THEN
             --giam netting = tien mua vi khi dat lenh da tang netting ma trong api cung tang netting
            INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('04').value,'0010',NVL(p_txmsg.txfields('10').value ,0),NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            update ddmast
                set netting = netting - NVL(p_txmsg.txfields('10').value ,0),
                    LAST_CHANGE = SYSTIMESTAMP
                where acctno = p_txmsg.txfields('04').value;
             pck_bankapi.Bank_Tranfer_Out_gbond(p_txmsg.txfields('04').value,
                                          p_txmsg.txfields('08').value,
                                          p_txmsg.txfields('06').value,
                                          p_txmsg.txfields('15').value,
                                          '2', --wave
                                          p_txmsg.txfields('10').value,
                                          v_trfcode,
                                          globalid_bank,
                                          p_txmsg.txfields('30').value,
                                          p_txmsg.tlid,
                                          p_txmsg.txfields('12').value,
                                          p_err_code);
             if P_ERR_CODE <> systemnums.C_SUCCESS then
                
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            --
            select cf.feedaily into v_feedaily from cfmast cf, odmast od where cf.custid = od.custid and od.orderid = p_txmsg.txfields('25').value;
            begin
                select bankacctno,banktrans into v_banknostro,v_banknostro_trans from banknostro where banktype = '001' and banktrans = 'INTRFRESELL';
            exception when NO_DATA_FOUND
                THEN
                p_err_code := '-930017';
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end;
            select trfcode into v_trfcode from CRBTRFCODE where objname = '8869' and trfcode = 'PAYMENTFEE';
            --goi api chuyen phi khi feedaily = y
            if trim(v_feedaily) = 'Y' then
                INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('04').value,'0010',p_txmsg.txfields('34').value + p_txmsg.txfields('35').value,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

                update ddmast
                    set netting = netting - p_txmsg.txfields('34').value + p_txmsg.txfields('35').value,
                        LAST_CHANGE = SYSTIMESTAMP
                    where acctno = p_txmsg.txfields('04').value;
                BEGIN
                    PCK_BANKAPI.Bank_NostroWtransfer(
                                  p_txmsg.txfields('04').value,  --- tk ddmast tk doi ung (ca nhan)
                                  v_banknostro, --- so tk nostro (tu doanh )
                                  v_banknostro_trans, ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
                                  'D',  -- Debit or credit
                                  p_txmsg.txfields('34').value + p_txmsg.txfields('35').value,  --- so tien
                                  v_trfcode, --request code cua nghiep vu trong allcode
                                  globalid_bank,  --requestkey duy nhat de truy lai giao dich goc
                                  p_txmsg.txfields('30').value,  -- dien giai
                                  p_txmsg.tlid, -- nguoi tao giao dich
                                  P_ERR_CODE)
                    ;
                if P_ERR_CODE <> systemnums.C_SUCCESS then
                    
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
                EXCEPTION WHEN OTHERS THEN
                    
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                 END;
             end if;
            --cap nhat lai trang thai odmast
            --if P_ERR_CODE = systemnums.c_success then
                UPDATE ODMAST
                 SET
                   ISPAYMENT='Y', LASTCHANGE = SYSTIMESTAMP
                WHERE ORDERID=p_txmsg.txfields('25').value;
                update stschd
                    set status = 'C',
                    lastchange = SYSTIMESTAMP
                    where orderid = p_txmsg.txfields('25').value and duetype = 'SM';
            --END IF;
        else

            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('32').value,'0015',ROUND(p_txmsg.txfields('13').value,0),NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
              INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('32').value,'0012',ROUND(p_txmsg.txfields('13').value,0),NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
              UPDATE ODMAST
                 SET
                   ORSTATUS='7', LASTCHANGE = SYSTIMESTAMP
                WHERE ORDERID=p_txmsg.txfields('25').value;
            update stschd
                    set status = 'C',
                    lastchange = SYSTIMESTAMP
                    where orderid = p_txmsg.txfields('25').value and duetype = 'SM';
              UPDATE SEMAST
                 SET
                   TRADE = TRADE + (ROUND(p_txmsg.txfields('13').value,0)),
                   RECEIVING = RECEIVING - (ROUND(p_txmsg.txfields('13').value,0)),
                    LAST_CHANGE = SYSTIMESTAMP
                WHERE ACCTNO=p_txmsg.txfields('32').value;
        END IF;
    END IF;
    */
    IF p_txmsg.deltd <> 'Y' THEN -- Normal TRANSACTION
        select trfcode into v_trfcode from CRBTRFCODE where objname = '8869' and trfcode = 'BANKTRANSFEROUT8869';
        select fn_getglobalid(p_txmsg.txdate, p_txmsg.txnum) into globalid_bank from dual;
        select cf.feedaily into v_feedaily from cfmast cf, odmast od where cf.custid = od.custid and od.orderid = p_txmsg.txfields('25').value;
        begin
            select bankacctno,banktrans into v_banknostro,v_banknostro_trans from banknostro where banktype = '001' and banktrans = 'INTRFRESELL';
        exception when NO_DATA_FOUND THEN
            p_err_code := '-930017';
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end;
        select trfcode into v_trfcode from CRBTRFCODE where objname = '8869' and trfcode = 'PAYMENTFEE';

        pck_bankapi.Bank_Internal_Tranfer_fa(
            p_txmsg.txfields('04').value,  --- tk ddmast tk chuyen
            p_txmsg.txfields('08').value, ---ten tk nhan
            p_txmsg.txfields('06').value, --- so tk nhan
            to_number(p_txmsg.txfields('10').value),  --- so tien
            v_trfcode, --request code cua nghiep vu trong allcode
            globalid_bank,  --requestkey duy nhat de truy lai giao dich goc
            p_txmsg.txfields('30').value,  -- dien giai
            p_txmsg.tlid, -- nguoi tao giao dich
            P_ERR_CODE);
        if P_ERR_CODE <> systemnums.C_SUCCESS then
            
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
        --goi api chuyen phi khi feedaily = y
        if trim(v_feedaily) = 'Y' then
            INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('04').value,'0010',p_txmsg.txfields('34').value + p_txmsg.txfields('35').value,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            update ddmast
            set netting = netting - p_txmsg.txfields('34').value + p_txmsg.txfields('35').value,
            LAST_CHANGE = SYSTIMESTAMP
            where acctno = p_txmsg.txfields('04').value;

            BEGIN
                PCK_BANKAPI.Bank_NostroWtransfer(
                              p_txmsg.txfields('04').value,  --- tk ddmast tk doi ung (ca nhan)
                              v_banknostro, --- so tk nostro (tu doanh )
                              v_banknostro_trans, ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
                              'D',  -- Debit or credit
                              p_txmsg.txfields('34').value + p_txmsg.txfields('35').value,  --- so tien
                              v_trfcode, --request code cua nghiep vu trong allcode
                              globalid_bank,  --requestkey duy nhat de truy lai giao dich goc
                              p_txmsg.txfields('30').value,  -- dien giai
                              p_txmsg.tlid, -- nguoi tao giao dich
                              P_ERR_CODE)
                ;
                if P_ERR_CODE <> systemnums.C_SUCCESS then
                    
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            EXCEPTION WHEN OTHERS THEN
                
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END;
        end if;
        --cap nhat lai trang thai odmast
        UPDATE ODMAST
        SET
        ISPAYMENT='Y', LASTCHANGE = SYSTIMESTAMP
        WHERE ORDERID=p_txmsg.txfields('25').value;

        update stschd
        set status = 'C',
        lastchange = SYSTIMESTAMP
        where orderid = p_txmsg.txfields('25').value and duetype = 'SM';
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
         plog.init ('TXPKS_#8869EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8869EX;
/
