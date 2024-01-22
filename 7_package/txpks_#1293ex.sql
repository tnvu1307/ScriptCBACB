SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1293ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1293EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      11/10/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1293ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_postdate         CONSTANT CHAR(2) := '20';
   c_billingmonth     CONSTANT CHAR(2) := '22';
   c_feetype          CONSTANT CHAR(2) := '23';
   c_subtype          CONSTANT CHAR(2) := '06';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_profoliocd       CONSTANT CHAR(2) := '91';
   c_custname         CONSTANT CHAR(2) := '90';
   c_feeinput         CONSTANT CHAR(2) := '24';
   c_feename          CONSTANT CHAR(2) := '25';
   c_feeamt           CONSTANT CHAR(2) := '10';
   c_vatamt           CONSTANT CHAR(2) := '26';
   c_ccycd            CONSTANT CHAR(2) := '21';
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
    IF p_txmsg.txfields('91').value IS NULL THEN
        p_err_code := '-930027';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    IF p_txmsg.txfields('24').value in( '002','001') AND  p_txmsg.txfields('21').value = 'VND' THEN --trung.luu:03-02-2021 SHBVNEX-1886
        IF isInt(p_txmsg.txfields('10').value) = 0 OR isInt(p_txmsg.txfields('26').value) = 0 THEN
            p_err_code := '-930102';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
    END IF;

    IF p_txmsg.txfields('24').value = '003' AND  p_txmsg.txfields('29').value = 'VND' THEN --trung.luu:03-02-2021 SHBVNEX-1886
        IF isInt(p_txmsg.txfields('10').value) = 0 OR isInt(p_txmsg.txfields('26').value) = 0 THEN
            p_err_code := '-930102';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
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
v_autoid number;
v_rautoid number;
v_autoiddetail number;
v_feerate number(20,4);
v_vatrate number;
l_custid  cfmast.custid%TYPE;
v_desc varchar2(500);
v_feecode varchar2(10);
l_vndesc varchar2(500);
l_desc varchar2(500);
V_FEETYPE VARCHAR2(50);
V_SUBTYPE VARCHAR2(3);
v_Result number(20,4);
v_feecd varchar2(100);
v_vatamt number(20,4);
v_ccycd varchar2(250);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_feerate:= 0;
    V_FEETYPE := p_txmsg.txfields(c_feetype).value;
    V_SUBTYPE := p_txmsg.txfields(c_subtype).value;
    if p_txmsg.txfields('24').value = '002' then
        v_ccycd:= p_txmsg.txfields('21').value;
    elsif p_txmsg.txfields('24').value = '003' then
        v_ccycd:= p_txmsg.txfields('29').value;
    else
        v_ccycd:= p_txmsg.txfields('21').value;
    end if;
    IF p_txmsg.deltd <> 'Y' THEN
        if p_txmsg.txfields('24').value = '002' then --trung.luu: chon bieu phi thi moi select bieu phi
            BEGIN
                SELECT FE.FEERATE, FE.VATRATE, FE.FEECODE,AL.EN_CDCONTENT,fe.feecd INTO v_feerate, v_vatrate,v_feecode,v_desc,v_feecd FROM FEEMASTER fe, allcode al
                WHERE FE.REFCODE=p_txmsg.txfields(c_feetype).value
                AND FE.SUBTYPE=p_txmsg.txfields(c_subtype).value
                AND FE.STATUS='Y'
                AND FE.FEECODE=AL.CDVAL(+)
                AND AL.CDNAME='FEECODES' AND AL.CDTYPE='SA';

                --trung.luu: 21-09-2020  SHBVNEX-1569
                v_Result := cspks_feecalc.fn_tax_calc ( p_txmsg.txfields('88').value, to_number(p_txmsg.txfields('10').value),v_ccycd,v_feecd,4/*pv_round in number*/,v_vatamt,v_vatrate);
            EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                       v_feerate := 0;
                       v_vatrate := 0;
                       v_feecode:='';
                       v_desc:='';
            END;
        elsif p_txmsg.txfields('24').value = '003' then --trung.luu: 15-03-2021 SHBVNEX-1890
            BEGIN
                SELECT CF.FEERATE, CF.VATRATE, fe.FEECODE,AL.EN_CDCONTENT,CF.feecd INTO v_feerate, v_vatrate,v_feecode,v_desc,v_feecd FROM CFFEEEXP cf,feemaster fe, allcode al
                WHERE FE.REFCODE=p_txmsg.txfields(c_feetype).value
                AND FE.SUBTYPE=p_txmsg.txfields(c_subtype).value
                AND FE.STATUS='Y'
                AND CF.FEECD = FE.FEECD
                AND FE.FEECODE=AL.CDVAL(+)
                and cf.custodycd = p_txmsg.txfields('88').value
                AND AL.CDNAME='FEECODES' AND AL.CDTYPE='SA';

                --trung.luu: 21-09-2020  SHBVNEX-1569
                v_Result := cspks_feecalc.fn_tax_calc ( p_txmsg.txfields('88').value, to_number(p_txmsg.txfields('10').value),v_ccycd,v_feecd,4/*pv_round in number*/,v_vatamt,v_vatrate);
            EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                       v_feerate := 0;
                       v_vatrate := 0;
                       v_feecode:='';
                       v_desc:='';
            END;
        else
            v_vatamt:=p_txmsg.txfields('26').value;
        end if;
            IF v_feecode IS NULL OR v_feecode='' THEN
                   v_feerate := 0;
                   v_vatrate := 0;
                   SELECT fn_get_feecode(p_txmsg.txfields(c_feetype).value,p_txmsg.txfields(c_subtype).value) INTO v_feecode FROM DUAL;
                   SELECT CDCONTENT INTO v_desc FROM ALLCODE WHERE CDNAME='FEECODES' AND CDTYPE='SA' AND CDVAL=v_feecode;
            END IF;


            SELECT en_display into v_desc FROM vw_feedetails_all
            WHERE filtercd = p_txmsg.txfields(c_subtype).value  and id=p_txmsg.txfields(c_feetype).value;

            IF (V_FEETYPE = 'OTHER' AND V_SUBTYPE = '007') THEN --NAM.LY 27/04/2020 SHBVNEX-941
               l_desc := 'Corresponding rounding amount';
            elsif (V_FEETYPE = 'BONDOTHER' or V_FEETYPE = 'BONDMNG' or V_FEETYPE = 'PAYAGENCY' or V_FEETYPE = 'ASSETMNG' or V_FEETYPE = 'SETRAN') then   ---locpt 2020/06/16 SHBVNEX-1212
                select CDCONTENT INTO v_desc from allcode where CDNAME = 'REFCODE' and cdval = p_txmsg.txfields(c_feetype).value;
                l_desc := v_desc;
            ELSE
                IF p_txmsg.txfields('30').value IS NULL THEN
                    l_desc:=v_desc||' dated '||to_char(TO_DATE (p_txmsg.txfields('20').value, systemnums.C_DATE_FORMAT),'DD Mon YYYY');
                ELSE
                    l_desc:=v_desc||' dated '||to_char(TO_DATE (p_txmsg.txfields('20').value, systemnums.C_DATE_FORMAT),'DD Mon YYYY')||'( '||p_txmsg.txfields('30').value||' )';
                END IF;
            END IF;
            v_autoid := SEQ_FEETRAN.NEXTVAL;
            v_autoiddetail := SEQ_FEETRANDETAIL.NEXTVAL;
            IF(p_txmsg.txfields('26').value > 0) THEN
                v_rautoid := SEQ_FEETRAN.NEXTVAL;
            END IF;
            INSERT INTO FEETRAN (TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE, VATAMT, AUTOID, TRDESC, CCYCD, ORDERID, TYPE, DEDUCTEDPLACE, STATUS, PAIDDATE, PSTATUS, SUBTYPE, FEETYPES, CUSTODYCD,FEECODE)
                VALUES (TO_DATE (p_txmsg.txfields('20').value, systemnums.C_DATE_FORMAT) ,p_txmsg.txnum , 'N',p_txmsg.txfields('25').value, null, p_txmsg.txfields('10').value, p_txmsg.txfields('10').value, v_feerate,v_vatrate, v_vatamt, v_autoid, l_desc, v_ccycd, null, 'F', null, 'N', null, null, p_txmsg.txfields('06').value,p_txmsg.txfields('23').value, p_txmsg.txfields('88').value,v_feecode);

            INSERT INTO FEETRANDETAIL (AUTOID, REFID, TXDATE, TXNUM, SUBTYPE, FEETYPES, TXAMT, FEEAMT, ORDERID, CUSTODYCD, CCYCD, RATEAMT, FORP)
                VALUES (v_autoiddetail, v_autoid, TO_DATE (p_txmsg.txfields('20').value, systemnums.C_DATE_FORMAT), p_txmsg.txnum, p_txmsg.txfields('06').value, p_txmsg.txfields('23').value, p_txmsg.txfields('10').value,  p_txmsg.txfields('10').value, null, p_txmsg.txfields('88').value , v_ccycd, v_vatamt, 'F');

        --IF p_txmsg.txfields('23').value = 'STC' THEN --TriBui 24/07/2020 fix gui mail tat ca cac loai phi
          SELECT custid INTO l_custid FROM cfmast WHERE custodycd = p_txmsg.txfields('88').value;
          nmpks_ems.pr_GenTemplateCS23(p_custid  => l_custid,
                                       p_subType => p_txmsg.txfields('06').value,
                                       p_ccycd   => v_ccycd,
                                       p_feeAmt  => p_txmsg.txfields('27').value,
                                       p_feetype => p_txmsg.txfields('23').value);
        --END IF;
        IF p_txmsg.txfields('23').value in ('BONDOTHER','BONDMNG','PAYAGENCY','ASSETMNG','SETRAN') THEN
        sp_gen_feeinvoice_1293_not_ddmast(TO_DATE(p_txmsg.txfields('20').value, systemnums.C_DATE_FORMAT),p_txmsg.txnum,null,null);
        END IF;
    else --trung.luu:17-07-2020 SHBVNEX-1374
        
        --xoa FEE_BOOKING_RESULT
        --IF p_txmsg.txfields('23').value in ('BONDOTHER','BONDMNG','PAYAGENCY','ASSETMNG','SETRAN') THEN
            update FEE_BOOKING_RESULT
                set deltd = 'Y',
                lastchange = SYSTIMESTAMP
            where   FEETXDATE = to_date(p_txmsg.txfields('20').value,'dd/MM/RRRR')
                and FEETXNUM = p_txmsg.txnum
                and status not in ('S','N','C','R','E','S','X','U')
            ;
            -- xoa fee tran
            update FEETRAN
                set deltd = 'Y'
            where   TXDATE = TO_DATE (p_txmsg.txfields('20').value, systemnums.C_DATE_FORMAT)
                and txnum = p_txmsg.txnum
            ;
            --xoa tllog
            update tllog
                set deltd = 'Y'
            where   TXDATE = to_date(p_txmsg.txfields('20').value,'dd/MM/RRRR')
                and txnum = p_txmsg.txnum
            ;
        --else
           -- p_err_code := '-930025';
           -- plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
           -- RETURN errnums.C_BIZ_RULE_INVALID;
       -- end if;
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
         plog.init ('TXPKS_#1293EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1293EX;
/
