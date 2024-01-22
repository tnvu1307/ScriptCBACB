SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#6702ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#6702EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      27/08/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#6702ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_txdate           CONSTANT CHAR(2) := '01';
   c_screen           CONSTANT CHAR(2) := '02';
   c_amt              CONSTANT CHAR(2) := '04';
   c_ccycd            CONSTANT CHAR(2) := '05';
   c_sacctno          CONSTANT CHAR(2) := '11';
   c_bacctno          CONSTANT CHAR(2) := '06';
   c_bname            CONSTANT CHAR(2) := '07';
   c_exrate           CONSTANT CHAR(2) := '09';
   c_vndamount        CONSTANT CHAR(2) := '08';
   c_note             CONSTANT CHAR(2) := '10';
   c_desc             CONSTANT CHAR(2) := '30';
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
v_fee_ccycd varchar2(50);
v_tax_ccycd varchar2(50);
v_amt number(20,4);
v_custodycd varchar(20);
v_feeamt number(20,4);
v_ccycd varchar2(10);
v_feerate number;
v_feecd varchar2(10);
v_forp varchar2(10);
v_vatrate number;
v_vatamt number(20,4);
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
v_refcasaacct varchar2(100);
v_fr_accounttype varchar2(100);
v_to_accounttype varchar2(100);
v_EXRATE number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
IF p_txmsg.deltd <> 'Y' THEN

    v_amt := p_txmsg.txfields('04').value;
     v_refcasaacct:=p_txmsg.txfields('11').value;
     --trung.luu: 08/06/2020 SHBVNEX-1073 Kh?ng ti?nh d??i vo?i kha?ch ha`ng Bondagent = Yes
     begin
        select cf.bondagent,cf.custodycd,dd.accounttype into l_bondagent,v_custodycd,v_fr_accounttype
        from cfmast cf,ddmast dd
        where cf.custodycd = dd.custodycd and dd.refcasaacct = v_refcasaacct and dd.status <> 'C';


    exception when NO_DATA_FOUND
        then
        l_bondagent := '';
     end;

     --trung.luu : 11-05-2021 log lai de lay bao cao cho de
        if v_fr_accounttype = 'IICA' and p_txmsg.txfields('05').value = 'USD' then  --Cash amount(After exchange)
            insert into log_od6004
            (autoid, txnum, txdate, tltxcd, fccycd, tccycd,
            custodycd, fraccount, toaccount, amount, deltd,lastchange)
            values
            (seq_log_od6004.nextval,p_txmsg.txnum,to_date(p_txmsg.txdate,'dd/MM/RRRR'),p_txmsg.tltxcd,'',p_txmsg.txfields('05').value,
            v_custodycd,p_txmsg.txfields('06').value,p_txmsg.txfields('11').value,to_number(p_txmsg.txfields('04').value),'N',SYSTIMESTAMP);
        /*elsif v_fr_accounttype = 'IICA' then --Credit Amount
            insert into log_od6004
            (autoid, txnum, txdate, tltxcd, fccycd, tccycd,
            custodycd, fraccount, toaccount, amount, deltd,lastchange)
            values
            (seq_log_od6004.nextval,p_txmsg.txnum,to_date(p_txmsg.txdate,'dd/MM/RRRR'),p_txmsg.tltxcd,p_txmsg.txfields('07').value,p_txmsg.txfields('09').value,
            v_custodycd,p_txmsg.txfields('06').value,p_txmsg.txfields('08').value,to_number(p_txmsg.txfields('10').value),'N',SYSTIMESTAMP);*/
        end if;



    
     --trung.luu: 08/06/2020 SHBVNEX-1158 b? t?nh ph? cho TK t? doanh
     SELECT varvalue into l_sysvar from sysvar where varname = 'DEALINGCUSTODYCD';
     if l_bondagent <> 'Y' and substr(v_custodycd,0,4) <> l_sysvar then
        v_Result := cspks_feecalc.FN_CB_OVERSEAS_CALC(v_custodycd, v_amt, 0,'003', v_feecd, v_feeamt, v_feerate, v_ccycd, v_forp);  --trung.luu 12-03-2021 chuyen tien thi subtype = 003
        IF v_ccycd = 'VND' THEN
            IF v_forp = 'F' THEN
                V_EXRATE := 1;
            ELSE
                BEGIN
                    V_EXRATE := to_number(p_txmsg.txfields('09').value);
                    IF v_EXRATE = 0 THEN
                        V_EXRATE := FN_GET_EXCHANGERATE('USD', 'SHV', 'TTM', getcurrdate);
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    V_EXRATE := FN_GET_EXCHANGERATE('USD', 'SHV', 'TTM', getcurrdate);
                END;
            END IF;
            v_feeamt := round(v_feeamt * V_EXRATE,0); --SHBVNEX-1679 tinh phi theo VND thi nhan ti gia
        END IF;

        v_Result := cspks_feecalc.fn_tax_calc ( v_custodycd, v_feeamt,v_ccycd,v_feecd,2/*pv_round in number*/,v_vatamt,v_vatrate);
        --
        begin
            SELECT feecode into v_feecode
            from FEEMASTER
            where feecd=v_feecd and status='Y';
        exception when NO_DATA_FOUND
            then
            p_err_code := '-930026';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end;

        SELECT en_display into v_desc FROM vw_feedetails_all
        WHERE filtercd ='003' and id='OTHER';

        l_desc:='Overseas outward remittance (sub) dated '||to_char(TO_DATE (p_txmsg.txfields('01').value, 'dd/MM/RRRR'),'DD Mon YYYY');
        --v_vatamt:=round((v_vatrate/100)*v_feeamt,2);

        --
        INSERT INTO FEETRAN(TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE, VATAMT, AUTOID, TRDESC, CCYCD, ORDERID, TYPE, DEDUCTEDPLACE, STATUS,PAIDDATE,PSTATUS,SUBTYPE,FEETYPES,CUSTODYCD,FEECODE)
        VALUES (TO_DATE (p_txmsg.txfields('01').value, 'dd/MM/RRRR'),p_txmsg.txnum,'N',v_feecd,NULL,v_amt,v_feeamt,v_feerate,v_vatrate,v_vatamt,SEQ_FEETRAN.NEXTVAL,l_desc,v_ccycd,NULL,'F', NULL, 'N', NULL, NULL,'003','OTHER',v_custodycd,v_feecode);
    end if;
    -- Thoai.tran 04-Sep-2020
    -- Send mail FX
    sendmailfx(p_txmsg.txnum,'6702');
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
         plog.init ('TXPKS_#6702EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#6702EX;
/
