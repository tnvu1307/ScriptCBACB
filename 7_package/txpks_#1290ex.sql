SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1290ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1290EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      12/01/2021     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1290ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_postdate         CONSTANT CHAR(2) := '20';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_feetype          CONSTANT CHAR(2) := '23';
   c_profoliocd       CONSTANT CHAR(2) := '91';
   c_custname         CONSTANT CHAR(2) := '90';
   c_ccycd            CONSTANT CHAR(2) := '21';
   c_feeamt           CONSTANT CHAR(2) := '10';
   c_vatamt           CONSTANT CHAR(2) := '26';
   c_feeamtvat        CONSTANT CHAR(2) := '27';
   c_description      CONSTANT CHAR(2) := '30';
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
v_bankaccount varchar2(250);
v_remark varchar2(4000);
v_feename varchar2(4000);
v_globalid varchar2(250);
v_mcifid varchar2(250);
l_rbankaccount varchar2(250);
v_amcname varchar2(250);
v_ccycd varchar2(50);
v_custodycd varchar2(50);
v_postdate date;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN

        V_CCYCD := P_TXMSG.TXFIELDS('21').VALUE;
        V_CUSTODYCD := P_TXMSG.TXFIELDS('88').VALUE;
        V_POSTDATE := TO_DATE(P_TXMSG.TXFIELDS('20').VALUE,'DD/MM/RRRR');

        begin
            select bankacctno into l_rbankaccount FROM BANKNOSTRO where banktrans='OUTTRFCACASH';
        exception when NO_DATA_FOUND
            THEN
            p_err_code := '-930017';
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end;

        SELECT CDCONTENT into v_feename FROM ALLCODE WHERE CDTYPE = 'SA' AND CDNAME = 'FEECODES' and cdval =p_txmsg.txfields('23').value;
        select fn_getglobalid(p_txmsg.txdate,p_txmsg.txnum) into v_globalid from dual;

        /*
        BEGIN
            select (CASE WHEN NVL(FA.SHORTNAME,'xxx') = 'xxx' THEN '' ELSE ' - ' || FA.SHORTNAME END)
            into v_amcname
            from famembers fa, cfmast cf
            where fa.activestatus = 'Y'
            and fa.roles = 'AMC'
            and fa.autoid = cf.amcid(+)
            and cf.cifid = p_txmsg.txfields('91').value;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            v_amcname := '';
        END;
        */
        --v_remark:= 'Fee of '||to_char(to_date(p_txmsg.txfields('20').value,'dd/MM/RRRR'),'MM/RRRR') || v_amcname;

        v_remark := p_txmsg.txfields('30').value; --SHBVNEX-2627

        --trung.luu: 18-02-2021 SHBVNEX-2067 lay so cifid cua tai khoan me

        --trung.luu: 18-03-2021 SHBVNEX-2161 khong dung cifid cua tai khoan me nua, dung master cifid
        begin
            --select cifid into v_mcifid from cfmast where custodycd in( select mcustodycd  from cfmast where cifid = p_txmsg.txfields('91').value);
            --trung.luu: 28-04-2021 SHBVNEX-2161 khong co mastercif thi de null
            select mcifid into v_mcifid from cfmast where custodycd = V_CUSTODYCD;
        exception when NO_DATA_FOUND
            then
            v_mcifid:= '';
        end;

        BEGIN
            SELECT (CASE WHEN NVL(CF.SETTLETYPE, '60') = '60' THEN NOSTRO.BANKACCTNO ELSE DD.REFCASAACCT END) BANKACCOUNT INTO V_BANKACCOUNT
            FROM
            (
                SELECT * FROM CFMAST WHERE CUSTODYCD = V_CUSTODYCD AND STATUS NOT IN ('C')
            ) CF,
            (
                SELECT * FROM DDMAST WHERE PAYMENTFEE = 'Y' AND STATUS NOT IN ('C')
            ) DD,
            (
                SELECT BANKACCTNO, 'VND' CCYCD FROM BANKNOSTRO WHERE BANKTRANS = 'OUTTRFMONFEESETTVND' AND ROWNUM = 1
                UNION ALL
                SELECT BANKACCTNO, 'USD' CCYCD FROM BANKNOSTRO WHERE BANKTRANS = 'OUTTRFMONFEESETTUSD' AND ROWNUM = 1
            ) NOSTRO
            WHERE CF.CUSTID = DD.CUSTID(+)
            AND NOSTRO.CCYCD = V_CCYCD;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            V_BANKACCOUNT:='';
        END;

        insert into fee_booking_result
                (   autoid, bankaccount, cifid, currency, remark,
                    feeamount, fxrate, fxamount, nostroaccount, status,
                    bankglobalid, transdate, settledate, feetype, feecode,
                    pstatus, taxamount, txdate, deltd, lastchange,
                    feetxdate, feetxnum, feename, bankrefid, refcode,
                    subtype, settletype, branch, spracno,mcifid
                )
       values
                (   seq_fee_booking_result.NEXTVAL,v_bankaccount,p_txmsg.txfields('91').value,v_ccycd,v_remark,
                    nvl(to_number(p_txmsg.txfields('10').value),0),0,0,l_rbankaccount,'P',
                    'CB.FEE1290',null,null,p_txmsg.txfields('23').value,p_txmsg.txfields('23').value,
                    '',nvl(to_number(p_txmsg.txfields('26').value),0),V_POSTDATE,'N',SYSTIMESTAMP,
                    TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txnum,v_feename,'','',
                    '','55','8146','',v_mcifid
                )
        ;
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
         plog.init ('TXPKS_#1290EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1290EX;
/
