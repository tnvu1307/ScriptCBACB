SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#6614ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#6614EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      27/02/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#6614ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_reqid            CONSTANT CHAR(2) := '00';
   c_rcustodycd       CONSTANT CHAR(2) := '88';
   c_bankacctno       CONSTANT CHAR(2) := '04';
   c_afacctno         CONSTANT CHAR(2) := '33';
   c_bankacct         CONSTANT CHAR(2) := '31';
   c_currency         CONSTANT CHAR(2) := '09';
   c_dorc             CONSTANT CHAR(2) := '05';
   c_rbankcitad       CONSTANT CHAR(2) := '06';
   c_rbankname        CONSTANT CHAR(2) := '11';
   c_rbankaccount     CONSTANT CHAR(2) := '13';
   c_rbankaccname     CONSTANT CHAR(2) := '07';
   c_feetype          CONSTANT CHAR(2) := '23';
   c_errordesc        CONSTANT CHAR(2) := '27';
   c_feecode          CONSTANT CHAR(2) := '29';
   c_txamt            CONSTANT CHAR(2) := '08';
   c_taxamt           CONSTANT CHAR(2) := '15';
   c_status           CONSTANT CHAR(2) := '17';
   c_feeamt           CONSTANT CHAR(2) := '19';
   c_pstatus          CONSTANT CHAR(2) := '21';
   c_notes            CONSTANT CHAR(2) := '30';
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
    V_REQID NUMBER;
    V_BANKACCTNO VARCHAR2(50);
    V_RBANKACCTNO VARCHAR2(50);

    v_rqtxnum varchar2(100);
    v_rqtxdate varchar2(50);
    v_rqtltxcd varchar2(100);
    v_custodycd varchar2(100);--88
    v_ddacctno varchar2(100);--03
    v_currency varchar2(100);--09
    v_dorc varchar2(100);--05
    v_citad varchar2(100);--06
    v_bankname varchar2(100);--11
    v_ddacctno_receive varchar2(100);--13
    v_name_receive varchar2(100);--07
    v_amount varchar2(100);--08
    v_tax varchar2(100);--15
    v_fee varchar2(100);--19
    v_feecode varchar2(100);--29
    v_feetype varchar2(100);--23
    v_reqkey varchar2(100);
    v_reqcode varchar2(100);
    v_banktrans varchar2(100);
    v_tlid varchar2(100);
    v_desc varchar2(100);
    v_memberid varchar2(100);
    v_brname varchar2(100);
    v_brphone  varchar2(100);
    l_err_param varchar2(300);
    L_txnum         VARCHAR2(20);
    l_txmsg         tx.msg_rectype;
    p_sqlcommand VARCHAR2(4000);
    v_repval varchar2(50);
    v_BANKACCT varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN
        --trung.luu : 18-05-2020
        begin
            v_reqid := p_txmsg.txfields ('00').VALUE;
            v_custodycd := p_txmsg.txfields ('88').VALUE;--88
            v_ddacctno := p_txmsg.txfields ('33').VALUE;--03
            v_currency := p_txmsg.txfields ('09').VALUE;--09
            v_dorc := p_txmsg.txfields ('05').VALUE;--05
            v_citad := p_txmsg.txfields ('06').VALUE;--06
            v_bankname := p_txmsg.txfields ('11').VALUE;--11
            v_BANKACCT := p_txmsg.txfields ('31').VALUE;
            v_name_receive := p_txmsg.txfields ('07').VALUE;--07
            v_amount := p_txmsg.txfields ('08').VALUE;--08
            v_tax := p_txmsg.txfields ('15').VALUE;--15
            v_fee := p_txmsg.txfields ('19').VALUE;--19
            v_feecode := p_txmsg.txfields ('29').VALUE;--29
            v_feetype := p_txmsg.txfields ('23').VALUE;--23
            v_ddacctno_receive:= p_txmsg.txfields ('13').VALUE;
            begin
                select trim(objname), objkey, to_char(txdate,'DD/MM/RRRR'), reqcode, reqtxnum into v_rqtltxcd, v_rqtxnum, v_rqtxdate, v_reqcode, v_reqkey from crbtxreq where reqid = v_reqid;
                select tlid, txdesc into v_tlid, v_desc from vw_tllog_all where txnum = v_rqtxnum and to_char(txdate,'DD/MM/RRRR') = v_rqtxdate;
            exception when OTHERS then
                v_tlid := '0000';
                v_desc:= '';
            end;
            
            if v_rqtltxcd ='6690' then --Bank_holdbalance
                begin
                    select MAX (CASE WHEN f.fldcd = '05' THEN f.cvalue ELSE '' END)  memberid into v_memberid
                    from vw_tllogfld_all f
                    where   f.fldcd IN ('05')
                    and f.txnum = v_rqtxnum
                    and to_char(f.txdate,'DD/MM/RRRR') = v_rqtxdate;

                    select MAX (CASE WHEN f.fldcd = '06' THEN f.cvalue ELSE '' END)  brname into v_brname
                    from vw_tllogfld_all f
                    where   f.fldcd IN ('06')
                    and f.txnum = v_rqtxnum
                    and to_char(f.txdate,'DD/MM/RRRR') = v_rqtxdate;

                    select MAX (CASE WHEN f.fldcd = '07' THEN f.cvalue ELSE '' END)  brphone into v_brphone
                    from vw_tllogfld_all f
                    where   f.fldcd IN ('07')
                    and f.txnum = v_rqtxnum
                    and to_char(f.txdate,'DD/MM/RRRR') = v_rqtxdate;
                exception when OTHERS then
                    v_memberid:='';
                    v_brname:='';
                    v_brphone:='';
                end;

                PCK_BANKAPI.BANK_HOLDBALANCE(v_ddacctno, -- tk ddmast
                                              v_memberid, -- ctck dat lenh
                                              v_brname, -- moi gioi dat lenh
                                              v_brphone, --- so dien thoai moi gioi dat lenh
                                              TO_NUMBER(v_amount),  --- so tien
                                              v_reqcode, --- code nghiep vu cua giao dich , select tu alcode
                                              v_reqkey, --request key --> key duy nhat de truy vet giao dich goc
                                              v_desc, -- dien giai
                                              v_tlid, -- nguoi lap giao dich
                                              P_ERR_CODE);
                if P_ERR_CODE <> systemnums.C_SUCCESS then
                    
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            elsif v_rqtltxcd ='6691' then --Bank_UNholdbalance

                begin
                    select trnref into v_repval from crbtxreq where reqid = v_reqid;
                    select reqtxnum into v_rqtxnum from crbtxreq where refval = v_repval and objname = '6690' and unhold = 'N';
                exception when OTHERS then
                    v_repval := '';
                    v_rqtxnum := '';
                end;

                pck_bankapi.Bank_UNholdbalance(
                      v_rqtxnum,  ---txnum cua giao dich hold
                      v_ddacctno,  --- tk ddmast
                      TO_NUMBER(v_amount),  -- so tien
                      v_reqcode, --request code cua nghiep vu trong allcode
                      v_reqkey,  --requestkey duy nhat de truy lai giao dich goc
                      v_desc,
                      v_tlid, -- nguoi tao giao dich
                      P_ERR_CODE);
                if P_ERR_CODE <> systemnums.C_SUCCESS then
                    
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            elsif v_rqtltxcd ='6620' then --Bank_Internal_Tranfer
                begin
                    select acctno into v_ddacctno_receive from ddmast where refcasaacct = p_txmsg.txfields ('13').VALUE;
                exception when OTHERS then
                    v_ddacctno_receive:='';
                end;
                pck_bankapi.Bank_Internal_Tranfer(
                      v_ddacctno,  --- tk ddmast tk chuyen
                      v_name_receive, ---ten tk nhan
                      v_ddacctno_receive, --- so tk nhan
                      to_number(v_amount),  --- so tien
                      v_reqcode, --request code cua nghiep vu trong allcode
                      v_reqkey,  --requestkey duy nhat de truy lai giao dich goc
                      v_desc,  -- dien giai
                      v_tlid, -- nguoi tao giao dich
                      P_ERR_CODE);

                 IF p_err_code <> systemnums.c_success THEN
                    
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                 END IF;
             elsif v_rqtltxcd ='6650' then --Bank_Internal_Tranfer_fa
                pck_bankapi.Bank_Internal_Tranfer_fa(
                              v_ddacctno,
                              v_name_receive, ---ten tk nhan
                              v_ddacctno_receive, --- so tk nhan
                              to_number(v_amount),  --- so tien
                              v_reqcode, --request code cua nghiep vu trong allcode
                              v_reqkey,  --requestkey duy nhat de truy lai giao dich goc
                              v_desc,  -- dien giai
                              v_tlid, -- nguoi tao giao dich
                              P_ERR_CODE);
                 IF p_err_code <> systemnums.c_success THEN
                    
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                 end if;
             elsif v_rqtltxcd ='6673' then --Bank_NostroWtransfer
                begin
                    select banktrans into v_banktrans from banknostro where bankacctno = v_ddacctno_receive AND BANKTRANS = 'OUTTRFODSELLVN';
                exception when OTHERS then
                    v_banktrans:= '';
                end;
                PCK_BANKAPI.Bank_NostroWtransfer(
                              v_ddacctno,  --- tk ddmast tk doi ung (ca nhan)
                              v_ddacctno_receive , --- so tk nostro (tu doanh )
                              v_banktrans, ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
                              v_dorc,  -- Debit or credit
                              to_number(v_amount),  --- so tien
                              v_reqcode, --request code cua nghiep vu trong allcode
                              v_reqkey,  --requestkey duy nhat de truy lai giao dich goc
                              v_desc,  -- dien giai
                              v_tlid, -- nguoi tao giao dich
                              P_ERR_CODE)
                        ;
                if P_ERR_CODE <> systemnums.C_SUCCESS then
                    
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                end if;
            elsif v_rqtltxcd ='6621' then --Bank_Tranfer_Out
                begin
                    select acctno into v_ddacctno_receive from ddmast where refcasaacct = p_txmsg.txfields ('13').VALUE;
                exception when OTHERS then
                    v_ddacctno_receive:='';
                end;
                pck_bankapi.Bank_Tranfer_Out(
                              v_ddacctno,  --- tk ddmast tk chuyen
                              v_name_receive, ---ten tk nhan
                              v_ddacctno_receive, --- so tk nhan
                              v_citad, --- so citad ngan hang nhan
                              to_number(v_amount),  --- so tien
                              v_reqcode, --request code cua nghiep vu trong allcode
                              v_reqkey,  --requestkey duy nhat de truy lai giao dich goc
                              v_desc,  -- dien giai
                              v_tlid , -- nguoi tao giao dich
                              P_ERR_CODE  );
                 if P_ERR_CODE <> systemnums.C_SUCCESS then
                    
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                 end if;
             elsif v_rqtltxcd ='6651' then --Bank_Tranfer_Out_fa
                pck_bankapi.Bank_Tranfer_Out_fa(v_ddacctno,
                                          v_name_receive,
                                          v_ddacctno_receive,
                                          v_citad,
                                          v_feetype,--chi thi truc tiep ko qua SB duyet thi ko thu phi
                                          to_number(v_amount),
                                          v_reqcode,
                                          v_reqkey,
                                          v_desc,
                                          v_tlid,
                                          p_err_code);
                   IF p_err_code <> systemnums.c_success THEN
                      
                      plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                      RETURN errnums.C_BIZ_RULE_INVALID;
                   end if;
             else
                FOR rec IN
                (
                    SELECT * FROM CRBTXREQ WHERE REQID = V_REQID
                )LOOP
                    INSERT INTO CRBTXREQ (
                        REQID,
                        OBJTYPE,
                        OBJNAME,
                        TRFCODE,
                        REQCODE,
                        OBJKEY,
                        TXDATE,
                        BANKCODE,
                        BANKACCT,
                        TXAMT,
                        NOTES,
                        STATUS,
                        REFTXNUM,
                        REFTXDATE,
                        AFFECTDATE,
                        CREATEDATE,
                        VIA,
                        UNHOLD,
                        CURRENCY,
                        REQTXNUM,
                        DORC,
                        FEEAMT,
                        TAXAMT,
                        AFACCTNO,
                        RBANKCITAD,
                        RBANKNAME,
                        RBANKACCOUNT,
                        FEECODE,
                        FEETYPE)
                    SELECT
                        SEQ_CRBTXREQ.NEXTVAL,
                        OBJTYPE,
                        OBJNAME,
                        TRFCODE,
                        REQCODE,
                        OBJKEY,
                        TXDATE,
                        BANKCODE,
                        V_BANKACCT,
                        V_AMOUNT,
                        NOTES,
                        'P',
                        REFTXNUM,
                        REFTXDATE,
                        AFFECTDATE,
                        SYSDATE,
                        VIA,
                        'N',
                        CURRENCY,
                        REQTXNUM,
                        DORC,
                        V_FEE,
                        V_TAX,
                        V_DDACCTNO,
                        V_CITAD,
                        V_BANKNAME,
                        V_DDACCTNO_RECEIVE,
                        V_FEECODE,
                        V_FEETYPE
                    FROM CRBTXREQ
                    WHERE REQID = V_REQID;
                END LOOP;
            end if;
            /*
            IF NVL(P_ERR_CODE, SYSTEMNUMS.C_SUCCESS) = SYSTEMNUMS.C_SUCCESS THEN
                INSERT INTO CRBTXREQ_RESEND
                SELECT * FROM CRBTXREQ WHERE REQID = V_REQID;
                DELETE FROM CRBTXREQ WHERE REQID = V_REQID;
            END IF;
            */

        EXCEPTION when others THEN
            p_err_code := errnums.C_SYSTEM_ERROR;
            plog.error (pkgctx, SQLERRM|| dbms_utility.format_error_backtrace);
        end;
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
         plog.init ('TXPKS_#6614EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#6614EX;
/
