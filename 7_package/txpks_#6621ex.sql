SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#6621ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#6621EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      16/08/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#6621ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_txdate           CONSTANT CHAR(2) := '20';
   c_citad            CONSTANT CHAR(2) := '04';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_address          CONSTANT CHAR(2) := '65';
   c_desacctno        CONSTANT CHAR(2) := '06';
   c_castbal          CONSTANT CHAR(2) := '89';
   c_bankbalance      CONSTANT CHAR(2) := '14';
   c_bankavlbal       CONSTANT CHAR(2) := '15';
   c_benefid          CONSTANT CHAR(2) := '87';
   c_benefbank        CONSTANT CHAR(2) := '85';
   c_citybank         CONSTANT CHAR(2) := '84';
   c_benefacct        CONSTANT CHAR(2) := '81';
   c_benefcustname    CONSTANT CHAR(2) := '82';
   c_benefaddress     CONSTANT CHAR(2) := '86';
   c_amt              CONSTANT CHAR(2) := '10';
   c_vatamt           CONSTANT CHAR(2) := '12';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
Status varchar(2);
v_str94 varchar2(100);
v_str95 varchar2(100);
v_custodycd varchar2(100);
v_count number;
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

        v_str94 := NVL(p_txmsg.txfields('94').value,'XXX');
        v_str95 := NVL(p_txmsg.txfields('95').value,'XXX');

        IF v_str94 = 'XXX' AND v_str95 = 'XXX' THEN --manual
            v_custodycd := p_txmsg.txfields('88').value;
            SELECT COUNT(1) INTO v_count FROM CFMAST WHERE CUSTODYCD = V_CUSTODYCD AND (SUPEBANK = 'Y' OR SBCHECK = 'Y');
            IF v_count > 0 THEN
                p_err_code := '-260174';
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        END IF;

        select status into Status from afmast where acctno = p_txmsg.txfields('03').value;

        IF Status LIKE 'B' THEN
            p_err_code := '-670411';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

        SELECT COUNT(1) INTO v_count FROM CFMAST WHERE CUSTODYCD = V_CUSTODYCD AND NVL(CITADFEERT, 'N') = 'Y';
        IF v_count > 0 THEN
            /*
            p_err_code := '-260177';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
            */
            p_txmsg.txWarningException('-260177').value := cspks_system.fn_get_errmsg('-260177');
            p_txmsg.txWarningException('-260177').errlev := '1';
        END IF;

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
    IF p_txmsg.deltd <> 'Y' THEN
        if p_txmsg.txstatus = 0 then --cho duyet
           pck_bankapi.Checkblacklist( p_txmsg.txfields('82').value,p_txmsg.txnum,p_txmsg.txdate,p_txmsg.tlid,'',p_err_code);
        end if;
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
v_fee_ccycd varchar2(50);
v_tax_ccycd varchar2(50);
v_amt number;
v_custodycd varchar(20);
v_feeamt number;
v_ccycd varchar2(10);
v_feerate number;
v_feecd varchar2(10);
v_vatrate number;
v_vatamt number;
v_feemfeecd varchar2(20);
v_feecode varchar2(10);
l_ccycd varchar2(10);
l_autoid number;
l_refcode varchar2(10);
l_subtype varchar2(10);
v_desc varchar2(500);
v_Result number(20,4);
l_desc varchar2(500);
l_bondagent varchar2(1);
l_sysvar varchar2(10);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
IF p_txmsg.deltd <> 'Y' THEN

    v_amt := p_txmsg.txfields('10').value;
    v_custodycd:=p_txmsg.txfields('88').value;
    --trung.luu: 08/06/2020 SHBVNEX-1073 Kh?ng ti?nh d??i vo?i kha?ch ha`ng Bondagent = Yes
    select bondagent into l_bondagent from cfmast where custodycd = p_txmsg.txfields('88').value;

    --trung.luu: 08/06/2020 SHBVNEX-1158 b? t?nh ph? cho TK t? doanh
    SELECT varvalue into l_sysvar from sysvar where varname = 'DEALINGCUSTODYCD';
    if l_bondagent <> 'Y' and substr(p_txmsg.txfields('88').value,0,4) <> l_sysvar then
        v_Result := cspks_feecalc.FN_CB_CITAD_CALC(p_txmsg.txfields('88').value, p_txmsg.txfields('10').value, 0, v_feecd, v_feeamt, v_feerate, v_ccycd);
        --
        --trung.luu: 21-09-2020  SHBVNEX-1569
        v_Result := cspks_feecalc.fn_tax_calc ( p_txmsg.txfields('88').value, v_feeamt,v_ccycd,v_feecd,2/*pv_round in number*/,v_vatamt,v_vatrate);
        begin
            SELECT feecode into v_feecode
            from FEEMASTER
            where feecd =v_feecd and status='Y';
        exception when OTHERS then
            p_err_code := '-930026';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end;
    end if;
end if;

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
V_CURRENCY VARCHAR2(3);
V_BANKACCTNO VARCHAR2(50);
v_fee_ccycd varchar2(50);
v_tax_ccycd varchar2(50);
v_amt number;
v_custodycd varchar(20);
v_feeamt number;
v_ccycd varchar2(10);
v_feerate number;
v_feecd varchar2(10);
v_vatrate number;
v_vatamt number;
v_feemfeecd varchar2(20);
v_feecode varchar2(10);
l_ccycd varchar2(10);
l_autoid number;
l_refcode varchar2(10);
l_subtype varchar2(10);
v_desc varchar2(500);
v_Result number(20,4);
l_desc varchar2(500);
l_bondagent varchar2(1);
l_sysvar varchar2(10);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
 IF p_txmsg.deltd <> 'Y' THEN

    v_amt := p_txmsg.txfields('10').value;
    v_custodycd:=p_txmsg.txfields('88').value;
    --trung.luu: 08/06/2020 SHBVNEX-1073 Kh?ng ti?nh d??i vo?i kha?ch ha`ng Bondagent = Yes
    select bondagent into l_bondagent from cfmast where custodycd = p_txmsg.txfields('88').value;

    --trung.luu: 08/06/2020 SHBVNEX-1158 b? t?nh ph? cho TK t? doanh
    SELECT varvalue into l_sysvar from sysvar where varname = 'DEALINGCUSTODYCD';
    if l_bondagent <> 'Y' and substr(p_txmsg.txfields('88').value,0,4) <> l_sysvar then

        v_Result := cspks_feecalc.FN_CB_CITAD_CALC(p_txmsg.txfields('88').value, p_txmsg.txfields('10').value, 0, v_feecd, v_feeamt, v_feerate, v_ccycd);
        --
        --trung.luu: 21-09-2020  SHBVNEX-1569
        v_Result := cspks_feecalc.fn_tax_calc ( p_txmsg.txfields('88').value, v_feeamt,v_ccycd,v_feecd,2/*pv_round in number*/,v_vatamt,v_vatrate);

        SELECT en_display into v_desc FROM vw_feedetails_all
        WHERE filtercd ='014' and id='OTHER';

        l_desc:=v_desc||' dated '||to_char(TO_DATE (p_txmsg.txfields('20').value, systemnums.C_DATE_FORMAT),'DD Mon YYYY');
        -- v_vatamt:=round((v_vatrate/100)*v_feeamt,2);
        --

        begin
            SELECT feecode into v_feecode
            from FEEMASTER
            where feecd =v_feecd and status='Y';
        exception when OTHERS then
            p_err_code := '-930026';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end;

        INSERT INTO FEETRAN(TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE, VATAMT, AUTOID, TRDESC, CCYCD, ORDERID, TYPE, DEDUCTEDPLACE, STATUS,PAIDDATE,PSTATUS,SUBTYPE,FEETYPES,CUSTODYCD,FEECODE)
        VALUES (p_txmsg.busdate,p_txmsg.txnum,'N',v_feecd,NULL,v_amt,v_feeamt,v_feerate,v_vatrate,v_vatamt,SEQ_FEETRAN.NEXTVAL,l_desc,v_ccycd,NULL,'F', NULL, 'N', NULL, NULL,'014','OTHER',v_custodycd,v_feecode);
    end if;


    SELECT CCYCD,REFCASAACCT INTO V_CURRENCY, V_BANKACCTNO
    FROM DDMAST WHERE ACCTNO = p_txmsg.txfields ('06').VALUE;
         --locpt 20190819 add phan sinh request qua bank
        --Sinh bankrequest,banklog
    /* Formatted on 8/19/2019 3:43:04 PM (QP5 v5.126) */
    INSERT INTO crbtxreq (reqid,
                      objtype,
                      objname,
                      trfcode,
                      reqcode,
                      reqtxnum,
                      objkey,
                      txdate,
                      affectdate,
                      bankcode,
                      bankacct,
                      afacctno,
                      txamt,
                      status,
                      reftxnum,
                      reftxdate,
                      refval,
                      notes,
                      RBANKACCOUNT, --recieve bank account
                      RBANKNAME,--recieve bankname
                      RBANKACCNAME,--recieve bankname
                      RBANKCITAD,
                      CURRENCY,
                      busdate)
  VALUES   (seq_crbtxreq.NEXTVAL,
            'T',
            '6621',
            'OTRANSFER',
            decode(p_txmsg.txfields ('94').VALUE,'',p_txmsg.tltxcd,p_txmsg.txfields ('94').VALUE),
            decode(p_txmsg.txfields ('95').VALUE,'','CB.'||TO_CHAR(p_txmsg.txdate,'YYYYMMDD')||'.'||p_txmsg.txnum,p_txmsg.txfields ('95').VALUE),
            p_txmsg.txnum,
            TO_DATE (p_txmsg.txdate, systemnums.c_date_format),
            TO_DATE (p_txmsg.txdate, systemnums.c_date_format),
            'SHV',
            V_BANKACCTNO,
            p_txmsg.txfields ('06').VALUE,
            p_txmsg.txfields ('10').VALUE,
            'P',
            NULL,
            NULL,
            NULL,
            p_txmsg.txfields ('30').VALUE,
            p_txmsg.txfields ('81').VALUE,
            p_txmsg.txfields ('85').VALUE,
            p_txmsg.txfields ('82').VALUE,
             p_txmsg.txfields ('04').VALUE,
            V_CURRENCY,
            TO_DATE (p_txmsg.busdate, systemnums.c_date_format));

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
         plog.init ('TXPKS_#6621EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#6621EX;
/
