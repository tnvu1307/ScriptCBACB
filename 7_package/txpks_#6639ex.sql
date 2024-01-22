SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#6639ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#6639EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      11/12/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#6639ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_postingdate      CONSTANT CHAR(2) := '01';
   c_tradingacct      CONSTANT CHAR(2) := '02';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_porfolio         CONSTANT CHAR(2) := '04';
   c_balance          CONSTANT CHAR(2) := '05';
   c_available        CONSTANT CHAR(2) := '06';
   c_instruction      CONSTANT CHAR(2) := '07';
   c_transfer         CONSTANT CHAR(2) := '08';
   c_citad            CONSTANT CHAR(2) := '09';
   c_bank             CONSTANT CHAR(2) := '11';
   c_bankbranch       CONSTANT CHAR(2) := '12';
   c_bankacctno       CONSTANT CHAR(2) := '13';
   c_name             CONSTANT CHAR(2) := '14';
   c_amt              CONSTANT CHAR(2) := '10';
   c_refcontract      CONSTANT CHAR(2) := '15';
   c_desc             CONSTANT CHAR(2) := '30';
   c_feetype          CONSTANT CHAR(2) := '16';
   c_valuedate        CONSTANT CHAR(2) := '17';
   c_fee              CONSTANT CHAR(2) := '19';
   c_netamt           CONSTANT CHAR(2) := '20';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
  v_citad varchar2(50);
  v_transfer varchar2(1);
  v_holiday varchar2(1);
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
    v_citad := p_txmsg.txfields(c_citad).value;
    v_transfer := p_txmsg.txfields(c_transfer).value;

    select holiday into v_holiday From sbcldr where  cldrtype = '000' and sbdate = to_date(p_txmsg.txfields('17').value,'dd/MM/RRRR');
    IF p_txmsg.deltd <> 'Y'  THEN
        --trung.luu sua theo yeu cau anh Hac 13-03-2020 : neu la gd online  voi 3 type kia thi cho phep null citad
        if p_txmsg.tlid <> '6868' or p_txmsg.txfields(c_instruction).value not in('ETFEX','TAEX','TARD') then
           IF (length(v_citad) = 0 OR v_citad IS NULL) AND v_transfer = 'D' THEN
              p_err_code := '-670413';
              RETURN errnums.C_BIZ_RULE_INVALID;
           END IF;
        END IF;
        --trung.luu: SHBVNEX-2345
        if v_holiday = 'Y' then
            p_err_code := '-930110';
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
    END IF;

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
    IF P_TXMSG.DELTD <> 'Y' THEN --CHO DUYET
        IF P_TXMSG.TXSTATUS = '0' AND P_TXMSG.TXFIELDS(C_TRANSFER).VALUE = 'D' AND NVL(P_TXMSG.OFFID, '0001') <> '6868' THEN --CHO DUYET(WEB GUI O FOPKSTX)
           PCK_BANKAPI.CHECKBLACKLIST( P_TXMSG.TXFIELDS(C_NAME).VALUE,P_TXMSG.TXNUM,P_TXMSG.TXDATE,P_TXMSG.TLID,'',P_ERR_CODE);
        END IF;
    END IF;

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
l_custodycd varchar2(20);
l_ddacctno varchar2(40);
l_custatcom varchar2(3);
l_bankacc varchar2(30);
l_bankname varchar(500);
l_porfolio varchar(500);
l_feetype varchar(1);
l_txamt number;
l_balance number;
l_available number;
l_fee number;
l_netamt number;
l_citad varchar2(20);
l_instruction varchar2(20);
l_transtype varchar(1);
l_bankbranch varchar(100);
l_custname varchar(100);
l_valuedate date;
l_postingdate date;
l_refcontract varchar2(500);
l_desc varchar2(2000);
l_currdate date;
v_count number;
v_toacctno varchar2(50);
v_refbankacct varchar(100);
v_sb varchar2(1);
v_supebank varchar2(1);
v_fundcode varchar2(50);
v_globalid varchar(100);
v_source varchar2(50);
V_CITADFEERT VARCHAR2(10);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    l_custodycd := p_txmsg.txfields(c_tradingacct).value;
    l_bankacc := p_txmsg.txfields(c_bankacctno).value;
    l_bankname := p_txmsg.txfields(c_bank).value;
    l_citad := p_txmsg.txfields(c_citad).value;
    l_ddacctno := p_txmsg.txfields(c_acctno).value;
    l_feetype := p_txmsg.txfields(c_feetype).value;
    l_instruction := p_txmsg.txfields(c_instruction).value;
    l_transtype := p_txmsg.txfields(c_transfer).value;
    l_bankbranch := p_txmsg.txfields(c_bankbranch).value;
    l_custname := p_txmsg.txfields(c_name).value;
    l_txamt := p_txmsg.txfields(c_amt).value;
    l_valuedate := to_date(p_txmsg.txfields(c_valuedate).value,'DD/MM/RRRR');
    l_postingdate := to_date(p_txmsg.txfields(c_postingdate).value,'DD/MM/RRRR');
    l_porfolio := p_txmsg.txfields(c_porfolio).value;
    l_balance := p_txmsg.txfields(c_balance).value;
    l_available := p_txmsg.txfields(c_available).value;
    l_refcontract := p_txmsg.txfields(c_refcontract).value;
    l_desc := p_txmsg.txfields(c_desc).value;
    l_fee := p_txmsg.txfields(c_fee).value;
    l_netamt := p_txmsg.txfields(c_netamt).value;

    l_currdate := getcurrdate();

    IF p_txmsg.deltd <> 'Y' THEN

        SELECT NVL(SUPEBANK,'N'), NVL(SBCHECK,'N'), NVL(FUNDCODE,''), NVL(CITADFEERT, 'N') INTO V_SUPEBANK, V_SB, V_FUNDCODE, V_CITADFEERT FROM CFMAST WHERE CUSTODYCD = L_CUSTODYCD;

        v_globalid := 'CB.'||TO_CHAR(p_txmsg.txdate,'YYYYMMDD')||'.'||p_txmsg.txnum;
        select d.refcasaacct into v_refbankacct from ddmast d where d.acctno = l_ddacctno;

        INSERT INTO CBFA_BANKPAYMENT(AUTOID,GLOBALID,CUSTODYCD,ACCTNO,TXTYPE,TRANSTYPE,TXNUM,TXDATE,
                             CITAD,BANKNAME,BANKBRACH,BENEFICIARYACCOUNT,CUSTNAME,CREATETIME,TXAMT,
                             REFCONTRACT,FEETYPE,SUPERBANK,ISAPPRSB,BANKSTATUS,SYNSTATUS,VALUEDATE,
                             REFBANKACCT,TLTXCD,NOTES)
        SELECT SEQ_CBFABANKPAYMENT.NEXTVAL,v_globalid,l_custodycd,l_ddacctno,l_instruction,l_transtype,p_txmsg.txnum,
             p_txmsg.txdate,l_citad,l_bankname,l_bankbranch,l_BANKACC,l_custname, systimestamp,l_txamt,
             l_refcontract,l_feetype,v_sb,CASE WHEN v_sb = 'N' THEN 'Y' ELSE 'N' END,
             'P','P',l_valuedate,v_refbankacct,p_txmsg.tltxcd,l_desc
        FROM DUAL;
        IF v_sb = 'Y' AND v_supebank = 'Y' then--gui events sang SB
          insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
          values (v_globalid,seq_log_notify_cbfa.nextval,'CBFABANKPAYMENT','GLOBALID',v_globalid,l_desc,p_txmsg.txnum,p_txmsg.txdate,p_txmsg.tltxcd,SYSDATE,p_txmsg.busdate);
        ELSE --Goi truc tiep bankapi
            IF l_valuedate > l_currdate THEN
                SELECT (CASE WHEN p_txmsg.tlid = '6868' THEN 'Online' ELSE 'Manual' END) INTO v_source FROM DUAL;
                INSERT INTO LOG_FUTURE6639(AUTOID, POSTINGDATE, TRADINGACCT, ACCTNO, PORFOLIO, BALANCE, AVAILABLE, INSTRUCTION, TRANSFER, CITAD, BANK, BANKBRANCH, BANKACCTNO, FULLNAME, AMT, REFCONTRACT,
                    FEETYPE, FEE, NETAMT, VALUEDATE, DESCRIPTION, TXNUM, TXDATE, STATUS, SOURCE)
                VALUES (SEQ_LOG_FUTURE6639.NEXTVAL, l_postingdate, l_custodycd, l_ddacctno, l_porfolio, l_balance, l_available, l_instruction, l_transtype, l_citad, l_bankname, l_bankbranch, l_bankacc, l_custname, l_txamt, l_refcontract,
                    l_feetype, l_fee, l_netamt, l_valuedate, l_desc, p_txmsg.txnum, p_txmsg.txdate, 'P', v_source);
            ELSE
                if l_transtype = 'D' THEN--chuyen tien ra ngoai

                    IF V_SUPEBANK = 'N' THEN
                        IF V_CITADFEERT = 'Y' THEN
                            --XU LY DAC BIET CHO KHAC CB
                            IF L_FEETYPE = '1' THEN
                                L_FEETYPE := '5';
                            ELSIF L_FEETYPE = '3' THEN
                                L_FEETYPE := '6';
                            END IF;
                        ELSE
                            L_FEETYPE := '4';
                        END IF;
                    END IF;

                    pck_bankapi.Bank_Tranfer_Out_fa(l_ddacctno,
                                          l_custname,
                                          l_BANKACC,
                                          l_citad,
                                          --'2',chi thi truc tiep ko qua SB duyet thi ko thu phi
                                          l_feetype, --trung.luu: 19-04-2021 SHBVNEX-2228 Khach CB thi tinh phi domestic
                                          l_txamt,
                                          l_instruction,
                                          v_globalid,
                                          l_desc,
                                          p_txmsg.tlid,
                                          p_err_code);
                   IF p_err_code <> systemnums.c_success THEN
                      UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E' WHERE GLOBALID = v_globalid;
                      
                      plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                      Return errnums.C_BIZ_RULE_INVALID;
                   ELSE
                      UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S' WHERE GLOBALID = v_globalid;
                   end if;
                else
                  select count(*) into v_count from ddmast d where d.refcasaacct = l_BANKACC;
                  IF v_count = 0 THEN
                     pck_bankapi.Bank_Internal_Tranfer_fa(
                          l_ddacctno,
                          l_custname, ---ten tk nhan
                          l_BANKACC, --- so tk nhan
                          l_txamt,  --- so tien
                          l_instruction, --request code cua nghiep vu trong allcode
                          v_globalid,  --requestkey duy nhat de truy lai giao dich goc
                          l_desc,  -- dien giai
                          p_txmsg.tlid, -- nguoi tao giao dich
                          P_ERR_CODE);
                     IF p_err_code <> systemnums.c_success THEN
                        UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E' WHERE GLOBALID = v_globalid;
                        
                        plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                        Return errnums.C_BIZ_RULE_INVALID;
                     ELSE
                        UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S' WHERE GLOBALID = v_globalid;
                     end if;
                   ELSE
                   select acctno into v_toacctno from ddmast  where refcasaacct = l_BANKACC;
                     pck_bankapi.Bank_Internal_Tranfer(
                          l_ddacctno,
                          l_custname, ---ten tk nhan
                          v_toacctno, --- so tk nhan
                          l_txamt,  --- so tien
                          l_instruction, --request code cua nghiep vu trong allcode
                          v_globalid,  --requestkey duy nhat de truy lai giao dich goc
                          l_desc,  -- dien giai
                          p_txmsg.tlid, -- nguoi tao giao dich
                          P_ERR_CODE);
                     IF p_err_code <> systemnums.c_success THEN
                        UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E' WHERE GLOBALID = v_globalid;
                        
                        plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                        Return errnums.C_BIZ_RULE_INVALID;
                     ELSE
                        UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S' WHERE GLOBALID = v_globalid;
                     end if;
                   END IF;
                end if;
            END IF;
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
         plog.init ('TXPKS_#6639EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#6639EX;
/
