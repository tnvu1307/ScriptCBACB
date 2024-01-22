SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1905ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1905EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      03/12/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1905ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '01';
   c_camastid         CONSTANT CHAR(2) := '02';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_fullname         CONSTANT CHAR(2) := '03';
   c_quantity         CONSTANT CHAR(2) := '23';
   c_depositarycnt    CONSTANT CHAR(2) := '04';
   c_bankacc          CONSTANT CHAR(2) := '05';
   c_ciaccount        CONSTANT CHAR(2) := '06';
   c_bankname         CONSTANT CHAR(2) := '11';
   c_amount           CONSTANT CHAR(2) := '34';
   c_tax              CONSTANT CHAR(2) := '77';
   c_netamount        CONSTANT CHAR(2) := '10';
   c_txdesc           CONSTANT CHAR(2) := '30';
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
l_custatcom varchar2(3);
l_BANKACC varchar2(30);
l_ddacctno varchar2(40);
l_trfcode varchar(100);
l_banktrans varchar(100);
l_count number;
l_thue_shv varchar(100);
l_bankaccount varchar2(100);
l_type varchar2(10);
l_bankname varchar2(100);
l_bankacname varchar2(250);
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
    begin
        --select distinct REPLACE(cth.bankacc,'.',''), cth.type, cth.bankname,cth.bankacname
        select distinct cth.bankacc, cth.type, cth.bankname,cth.bankacname
        into l_bankaccount, l_type, l_bankname,l_bankacname
        from bondcaschd bo, cfmast cf, cfotheracc cth, crbbanklist crb, camast ca, sbsecurities sb
        where BO.AUTOID = p_txmsg.txfields(c_autoid).value--bo.status = 'P'
        and bo.custodycd = cf.custodycd
        and cf.custid = cth.cfcustid(+) and cth.defaultacct(+) = 'Y'
        and cth.bankcode = crb.citad(+)
        and bo.camastid = ca.camastid
        and ca.optsymbol = sb.symbol
        and bo.depositary ='N'
        and bo.custodycd =p_txmsg.txfields(c_custodycd).value
        and cth.deltd <> 'Y';
    exception when no_data_found then
        l_bankaccount := null;
        l_type := null;
        l_bankname := null;
    end;
    if l_type <> '2' or (l_type = '4' and UPPER(l_bankname) not LIKE '%SHINHAN%') then
        if p_txmsg.txstatus = 0  and p_txmsg.deltd <> 'Y' then --cho duyet
           pck_bankapi.Checkblacklist(l_bankacname,p_txmsg.txnum,p_txmsg.txdate,p_txmsg.tlid,'',p_err_code);
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
l_custatcom varchar2(3);
l_BANKACC varchar2(30);
l_ddacctno varchar2(40);
l_trfcode varchar(100);
l_banktrans varchar(100);
l_count number;
l_thue_shv varchar(100);
l_bankaccount varchar2(100);
l_type varchar2(10);
l_bankname varchar2(100);
l_bankacname varchar2(500);
v_txdesc varchar2(4000);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN

        v_txdesc := FN_CONVERT_TO_VN(p_txmsg.txfields(c_txdesc).value);

        UPDATE BONDCASCHD SET STATUS = 'A',STATUS_1905='Y' WHERE AUTOID = p_txmsg.txfields(c_autoid).value;
        l_BANKACC := p_txmsg.txfields(c_bankacc).value;

        -----------------------------------------LUU KY TAI SHV
        begin
            select distinct bo.depositary
            into l_custatcom
            from bondcaschd  bo
            where bo.custodycd = p_txmsg.txfields(c_custodycd).value
                    and bo.autoid = p_txmsg.txfields(c_autoid).value ;
        exception when no_data_found then l_custatcom := null;
        end;
        --------------------------KIEM TRA THU THUE TAI SHV HAY TCPH
        /*
        select count(ca.pitratemethod)
        into l_count
        from bondcaschd bo, camast ca
        where ca.camastid=bo.camastid
        and ca.pitratemethod='SC' -- Tai SHV
        and bo.custodycd =p_txmsg.txfields(c_custodycd).value ;

        if l_count > 0 then
        l_thue_shv := 'YES';
        else
        l_thue_shv := 'NO';
        end if;
        */
        ---------------------------------------
        --select max(dd.acctno) into l_ddacctno from ddmast dd where dd.custodycd = p_txmsg.txfields(c_custodycd).value and status <> 'C';
        if (l_custatcom <> 'Y' and l_BANKACC is not null) THEN --khong lk tai shv
            --lay tai khoan chuyen
            begin
                SELECT distinct bankacctno
                into l_ddacctno
                from banknostro
                where banktype='002' and BANKTRANS='OUTTRFBA';
            exception when no_data_found then
                l_ddacctno := null;
            end;

            --lay tai khoan nhan
            begin
                --select distinct REPLACE(cth.bankacc,'.',''), cth.type, cth.bankname
                select distinct cth.bankacc, cth.type, cth.bankname, cth.bankacname
                into l_bankaccount, l_type, l_bankname, l_bankacname
                from bondcaschd bo, cfmast cf, cfotheracc cth, crbbanklist crb, camast ca, sbsecurities sb
                where BO.AUTOID = p_txmsg.txfields(c_autoid).value--bo.status = 'P'
                and bo.custodycd = cf.custodycd
                and cf.custid = cth.cfcustid(+) and cth.defaultacct(+) = 'Y'
                and cth.bankcode = crb.citad(+)
                and bo.camastid = ca.camastid
                and ca.optsymbol = sb.symbol
                and bo.depositary ='N'
                and bo.custodycd =p_txmsg.txfields(c_custodycd).value
                and cth.deltd <> 'Y';
            exception when no_data_found then
                l_bankaccount := null;
                l_type := null;
                l_bankname := null;
                l_bankacname := p_txmsg.txfields(c_fullname).value;
            end;

            if l_type = '3' then --Nostro
                INSERT INTO PAYMENT_INTEREST (AUTOID,BANKACCOUNT,REMARK,AMOUNT,NOSTROACCOUNT,STATUS,BANKGLOBALID,TRANSDATE,SETTLEDATE,currency,refcode)
                VALUES(seq_payment_interest.NEXTVAL,l_bankaccount, v_txdesc,p_txmsg.txfields('10').value ,l_ddacctno , 'N',NULL ,to_char(to_date(p_txmsg.TXDATE,'DD/MM/YYYY'),'RRRRMMDD'),
                to_char(to_date(getcurrdate(),'DD/MM/YYYY'),'RRRRMMDD'),'VND','PAYMENTINTEREST');
                pck_bankflms.sp_auto_gen_payment_interest();
            elsif l_type = '4' then --Citad
                if UPPER(l_bankname) LIKE '%SHINHAN%' then
                    INSERT INTO PAYMENT_INTEREST (AUTOID,BANKACCOUNT,REMARK,AMOUNT,NOSTROACCOUNT,STATUS,BANKGLOBALID,TRANSDATE,SETTLEDATE,currency,refcode,citad)
                    VALUES(seq_payment_interest.NEXTVAL,l_bankaccount, v_txdesc,p_txmsg.txfields('10').value ,l_ddacctno , 'N',NULL ,to_char(to_date(p_txmsg.TXDATE,'DD/MM/YYYY'),'RRRRMMDD'),
                    to_char(to_date(getcurrdate(),'DD/MM/YYYY'),'RRRRMMDD'),'VND','PAYMENTINTEREST_IN',null);
                    pck_bankflms.sp_auto_gen_payment_interest_in();
                else
                    INSERT INTO PAYMENT_INTEREST (AUTOID,BANKACCOUNT,REMARK,AMOUNT,NOSTROACCOUNT,STATUS,BANKGLOBALID,TRANSDATE,SETTLEDATE,currency,refcode,citad, RBANKACCNAME)
                    VALUES(seq_payment_interest.NEXTVAL,l_bankaccount, v_txdesc,p_txmsg.txfields('10').value ,l_ddacctno , 'N',NULL ,to_char(to_date(p_txmsg.TXDATE,'DD/MM/YYYY'),'RRRRMMDD'),
                    to_char(to_date(getcurrdate(),'DD/MM/YYYY'),'RRRRMMDD'),'VND','PAYMENTINTEREST_OUT',p_txmsg.txfields(c_ciaccount).value, l_bankacname);
                    pck_bankflms.sp_auto_gen_payment_interest_out();
                end if;
            elsif l_type = '2' then --CK noi bo
                INSERT INTO PAYMENT_INTEREST (AUTOID,BANKACCOUNT,REMARK,AMOUNT,NOSTROACCOUNT,STATUS,BANKGLOBALID,TRANSDATE,SETTLEDATE,currency,refcode,citad)
                VALUES(seq_payment_interest.NEXTVAL,l_bankaccount, v_txdesc,p_txmsg.txfields('10').value ,l_ddacctno , 'N',NULL ,to_char(to_date(p_txmsg.TXDATE,'DD/MM/YYYY'),'RRRRMMDD'),
                to_char(to_date(getcurrdate(),'DD/MM/YYYY'),'RRRRMMDD'),'VND','PAYMENTINTEREST_IN',null);
                pck_bankflms.sp_auto_gen_payment_interest_in();
            else
                INSERT INTO PAYMENT_INTEREST (AUTOID,BANKACCOUNT,REMARK,AMOUNT,NOSTROACCOUNT,STATUS,BANKGLOBALID,TRANSDATE,SETTLEDATE,currency,refcode,citad, RBANKACCNAME)
                VALUES(seq_payment_interest.NEXTVAL,l_bankaccount, v_txdesc,p_txmsg.txfields('10').value ,l_ddacctno , 'N',NULL ,to_char(to_date(p_txmsg.TXDATE,'DD/MM/YYYY'),'RRRRMMDD'),
                to_char(to_date(getcurrdate(),'DD/MM/YYYY'),'RRRRMMDD'),'VND','PAYMENTINTEREST_OUT',p_txmsg.txfields(c_ciaccount).value, l_bankacname);
                pck_bankflms.sp_auto_gen_payment_interest_out();
            end if;

             -- Gen template EM15
             nmpks_ems.pr_GenTemplateEM15 (p_camastId     => p_txmsg.txfields(c_camastid).value,
                                  p_txdate       => TO_CHAR(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                                  p_custodycd    => p_txmsg.txfields(c_custodycd).value,
                                  p_quantity     => p_txmsg.txfields(c_quantity).value,
                                  p_amount       => p_txmsg.txfields(c_amount).value,
                                  p_benefit_acct => p_txmsg.txfields(c_bankacc).value,
                                  p_desc         => v_txdesc);

        elsif (l_custatcom = 'Y' and l_BANKACC is not null) THEN
            --lay tai khoan chuyen
            begin
                SELECT distinct bankacctno
                into l_ddacctno
                from banknostro
                where banktype='002' and BANKTRANS='OUTTRFBA';
            exception when no_data_found then
                l_ddacctno := null;
            end;
            --lay tai khoan nhan
            begin
                SELECT distinct bankacctno
                into l_bankaccount
                from banknostro
                where banktype='001' and BANKTRANS='INTRFBA';
            exception when no_data_found then
                l_bankaccount := null;
            end;
            --------------------------------
            INSERT INTO PAYMENT_INTEREST (AUTOID,BANKACCOUNT,REMARK,AMOUNT,NOSTROACCOUNT,STATUS,BANKGLOBALID,TRANSDATE,SETTLEDATE,currency,refcode)
            VALUES(seq_payment_interest.NEXTVAL,l_bankaccount, v_txdesc,p_txmsg.txfields('10').value ,l_ddacctno , 'N',NULL ,to_char(to_date(p_txmsg.TXDATE,'DD/MM/YYYY'),'RRRRMMDD'),
            to_char(to_date(getcurrdate(),'DD/MM/YYYY'),'RRRRMMDD'),'VND','PAYMENTINTEREST');
            pck_bankflms.sp_auto_gen_payment_interest();

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
         plog.init ('TXPKS_#1905EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1905EX;
/
