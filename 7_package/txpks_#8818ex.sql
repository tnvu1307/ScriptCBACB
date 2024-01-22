SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8818ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8818EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      30/11/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#8818ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '01';
   c_orgorderid       CONSTANT CHAR(2) := '06';
   c_afacctno         CONSTANT CHAR(2) := '03';
   c_ddacctno         CONSTANT CHAR(2) := '04';
   c_codeid           CONSTANT CHAR(2) := '02';
   c_seacctno         CONSTANT CHAR(2) := '05';
   c_postdate         CONSTANT CHAR(2) := '23';
   c_broker           CONSTANT CHAR(2) := '24';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_refacctno        CONSTANT CHAR(2) := '25';
   c_typeorder        CONSTANT CHAR(2) := '28';
   c_typeorder        CONSTANT CHAR(2) := '26';
   c_symbol           CONSTANT CHAR(2) := '07';
   c_qtty             CONSTANT CHAR(2) := '09';
   c_amt              CONSTANT CHAR(2) := '10';
   c_fee              CONSTANT CHAR(2) := '11';
   c_tax              CONSTANT CHAR(2) := '27';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
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
    /*select ishold into v_ishold from odmast where orderid  =p_txmsg.txfields('06').value;
    
    if trim(v_ishold) = 'Y' then
        p_err_code := '-911008';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;*/
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
    NOSTRO_bankacctno_NHAN VARCHAR2(100);
    NOSTRO_banktrans_NHAN VARCHAR2(100);
    v_feedaily varchar2(10);
    globalid_bank VARCHAR2(250);
    v_country varchar2(20);
    L_COUNT NUMBER;
    L_netting NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        SELECT COUNT(1) INTO L_COUNT FROM ODMAST WHERE ORDERID = P_TXMSG.TXFIELDS('06').VALUE;
        IF L_COUNT >0 THEN
            select fn_getglobalid(p_txmsg.txdate, p_txmsg.txnum) into globalid_bank from dual;
            select cf.feedaily,CF.COUNTRY into v_feedaily,v_country from cfmast cf,ddmast dd where cf.custodycd = dd.custodycd and dd.acctno = p_txmsg.txfields('04').value and dd.status <> 'C';
            -- LAY TK TONG DE NHAN TIEN MUA
            begin
                if v_country <> '234' then
                    SELECT bankacctno,banktrans INTO NOSTRO_bankacctno_NHAN,NOSTRO_banktrans_NHAN FROM BANKNOSTRO WHERE banktype = '001' AND BANKTRANS = 'INTRFRESELL';
                else
                    SELECT bankacctno,banktrans INTO NOSTRO_bankacctno_NHAN,NOSTRO_banktrans_NHAN FROM BANKNOSTRO WHERE banktype = '001' AND BANKTRANS = 'INTRFRESELLVN';
                end if;
            exception when NO_DATA_FOUND
                THEN
                p_err_code := '-930017';
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end;

            --tra phi ngay = netamount
            if trim(v_feedaily) = 'Y' then
                --giam netting = tien mua vi khi dat lenh da tang netting ma trong api cung tang netting
                INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('04').value,'0010',NVL(p_txmsg.txfields('10').value +p_txmsg.txfields('11').value+p_txmsg.txfields('27').value,0),NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

                update ddmast
                set netting = netting - NVL(p_txmsg.txfields('10').value +p_txmsg.txfields('11').value+p_txmsg.txfields('27').value ,0),
                LAST_CHANGE = SYSTIMESTAMP
                where acctno = p_txmsg.txfields('04').value;
                --di tien mua
                BEGIN
                    PCK_BANKAPI.Bank_NostroWtransfer(
                                  p_txmsg.txfields('04').value,  --- tk ddmast tk doi ung (ca nhan)
                                  NOSTRO_bankacctno_NHAN , --- so tk nostro (tu doanh )
                                  NOSTRO_banktrans_NHAN, ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
                                  'D',  -- Debit or credit
                                  p_txmsg.txfields('10').value +p_txmsg.txfields('11').value+p_txmsg.txfields('27').value,  --- so tien
                                  'PAYMENTBUYORDER', --request code cua nghiep vu trong allcode
                                  globalid_bank,  --requestkey duy nhat de truy lai giao dich goc
                                  p_txmsg.txfields('30').value,  -- dien giai
                                  p_txmsg.tlid, -- nguoi tao giao dich
                                  P_ERR_CODE)
                    ;
                    if P_ERR_CODE <> systemnums.C_SUCCESS then
                        
                        plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    end if;
                        --cap nhat lai trang thai odmast
                        update odmast
                        set ispayment = 'Y', LASTCHANGE = SYSTIMESTAMP
                        where orderid =p_txmsg.txfields('06').value;

                        update stschd
                        set status = 'C', lastchange = SYSTIMESTAMP
                        where orderid = p_txmsg.txfields('06').value and duetype = 'SM';
                EXCEPTION WHEN OTHERS THEN
                    
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                END;
            else
                --trung.luu: khong can unhold(tach unhold ra buoc rieng)
                --giam netting = tien mua vi khi dat lenh da tang netting ma trong api cung tang netting
                INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('04').value,'0010',NVL(p_txmsg.txfields('10').value,0),NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

                update ddmast
                set netting = netting - NVL(p_txmsg.txfields('10').value,0),
                LAST_CHANGE = SYSTIMESTAMP
                where acctno = p_txmsg.txfields('04').value;
                --di tien mua
                BEGIN
                    PCK_BANKAPI.Bank_NostroWtransfer(
                                  p_txmsg.txfields('04').value,  --- tk ddmast tk doi ung (ca nhan)
                                  NOSTRO_bankacctno_NHAN , --- so tk nostro (tu doanh )
                                  NOSTRO_banktrans_NHAN, ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
                                  'D',  -- Debit or credit
                                  NVL(p_txmsg.txfields('10').value ,0),  --- so tien
                                  'PAYMENTBUYORDER', --request code cua nghiep vu trong allcode
                                  globalid_bank,  --requestkey duy nhat de truy lai giao dich goc
                                  p_txmsg.txfields('30').value,  -- dien giai
                                  p_txmsg.tlid, -- nguoi tao giao dich
                                  P_ERR_CODE)
                    ;
                    if P_ERR_CODE <> systemnums.C_SUCCESS then
                        
                        plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    end if;
                    --cap nhat lai trang thai odmast
                    update odmast
                    set ispayment = 'Y', LASTCHANGE = SYSTIMESTAMP
                    where orderid = p_txmsg.txfields('06').value;

                    update stschd
                    set status = 'C', lastchange = SYSTIMESTAMP
                    where orderid = p_txmsg.txfields('06').value and duetype = 'SM';

                EXCEPTION WHEN OTHERS THEN
                    
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                END;
            end if;
        /*
        ELSE
            FOR REC IN (
                SELECT * FROM STSCHD_NETOFF WHERE TO_CHAR(AUTOID) = p_txmsg.txfields('01').VALUE
            )LOOP
                select fn_getglobalid(p_txmsg.txdate, p_txmsg.txnum) into globalid_bank from dual;
                -- LAY TK TONG DE NHAN TIEN MUA
                begin
                    select CF.COUNTRY into v_country from cfmast cf where cf.custodycd = p_txmsg.txfields('88').value ;
                    if v_country <> '234' then
                        SELECT bankacctno,banktrans INTO NOSTRO_bankacctno_NHAN,NOSTRO_banktrans_NHAN FROM BANKNOSTRO WHERE banktype = '001' AND BANKTRANS = 'INTRFRESELL';
                    else
                        SELECT bankacctno,banktrans INTO NOSTRO_bankacctno_NHAN,NOSTRO_banktrans_NHAN FROM BANKNOSTRO WHERE banktype = '001' AND BANKTRANS = 'INTRFRESELLVN';
                    end if;
                exception when NO_DATA_FOUND THEN
                    p_err_code := '-930017';
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end;

                L_netting := (CASE WHEN REC.FEEDAILY = 'Y' THEN NVL(P_TXMSG.TXFIELDS('10').VALUE + P_TXMSG.TXFIELDS('11').VALUE + P_TXMSG.TXFIELDS('27').VALUE,0) ELSE NVL(P_TXMSG.TXFIELDS('10').VALUE,0) END);

                BEGIN
                    PCK_BANKAPI.Bank_NostroWtransfer(
                                  p_txmsg.txfields('04').value,  --- tk ddmast tk doi ung (ca nhan)
                                  NOSTRO_bankacctno_NHAN , --- so tk nostro (tu doanh )
                                  NOSTRO_banktrans_NHAN, ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
                                  'D',  -- Debit or credit
                                  L_netting,  --- so tien
                                  'PAYMENTBUYORDER', --request code cua nghiep vu trong allcode
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

                INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('04').value,'0010', L_netting, NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

                UPDATE DDMAST
                SET NETTING = NETTING - L_NETTING,
                LAST_CHANGE = SYSTIMESTAMP
                WHERE ACCTNO = P_TXMSG.TXFIELDS('04').VALUE;

                UPDATE STSCHD_NETOFF
                SET ISPAYMENT = 'Y'
                WHERE AUTOID = REC.AUTOID;

                UPDATE ODMAST
                SET ISPAYMENT = 'Y', LASTCHANGE = SYSTIMESTAMP
                WHERE NETOFFID = REC.AUTOID;

                UPDATE STSCHD
                SET STATUS = 'C', LASTCHANGE = SYSTIMESTAMP
                WHERE DUETYPE = 'SM'
                AND ORDERID IN (SELECT ORDERID FROM ODMAST WHERE NETOFFID = REC.AUTOID);

            END LOOP;
         */
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
         plog.init ('TXPKS_#8818EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8818EX;
/
