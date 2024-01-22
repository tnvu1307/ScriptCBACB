SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1204ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1204EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      29/07/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1204ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_postdate         CONSTANT CHAR(2) := '20';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_profoliocd       CONSTANT CHAR(2) := '91';
   c_custname         CONSTANT CHAR(2) := '90';
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
l_rbankaccount varchar2(50);
l_bankglobalid varchar2(100);
v_autoid number;
v_mcifid varchar2(250);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN --SHBVNEX-968
        select fn_getglobalid(to_date(p_txmsg.txdate,'dd/MM/RRRR'),p_txmsg.txnum) into l_bankglobalid from dual;
        begin
            select bankacctno into l_rbankaccount FROM BANKNOSTRO where banktrans='OUTTRFCACASH';
        exception when NO_DATA_FOUND
            THEN
            p_err_code := '-930017';
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end;

        BEGIN


            for r in (
                            SELECT fee.custodycd||fee.feecode keys,
                               (CASE WHEN NVL(CF.SETTLETYPE, '60') = '60' THEN NOSTRO.BANKACCTNO ELSE DD.REFCASAACCT END) BANKACCOUNT,
                               cf.cifid CIFID,fee.ccycd CURRENCY,
                               'Fee of ' || to_char(to_date(p_txmsg.txdate,'dd/MM/RRRR'),'MM/RRRR') || (case when nvl(fa.shortname,'---') = '---' then '' else ' - ' || fa.shortname end) || ' - ' || cf.custodycd REMARK,
                               fee.feeamt FEEAMOUNT,
                               1 FXRATE,
                               fee.feeamt FXAMOUNT,
                               l_rbankaccount NOSTROACCOUNT, 'P' STATUS,
                               --fn_getglobalid(to_date(p_txmsg.txdate,'dd/MM/RRRR'),p_txmsg.txnum) BANKGLOBALID,
                               to_date(p_txmsg.txdate,'dd/MM/RRRR') TRANSDATE,
                               to_date(p_txmsg.txdate,'dd/MM/RRRR') SETTLEDATE,
                               fee.feecode FEETYPE,
                               fee.feecode FEECODE,null FEETXDATE,null FEETXNUM,
                               to_date(p_txmsg.txdate,'dd/MM/RRRR') TXDATE,fee.vatamt TAXAMOUNT,a1.cdcontent FEENAME,cf.mcifid--trung.luu: 28-04-2021 SHBVNEX-2161 khong co mastercif thi de null
                        FROM  cfmast cf , famembers fa,
                        (select * from allcode where cdname ='FEECODES' and cdtype='SA') a1,
                        (SELECT * FROM DDMAST WHERE PAYMENTFEE = 'Y' AND STATUS <> 'C') dd,
                        (
                            SELECT BANKACCTNO, 'VND' CCYCD FROM BANKNOSTRO WHERE BANKTRANS = 'OUTTRFMONFEESETTVND' AND ROWNUM = 1
                            UNION ALL
                            SELECT BANKACCTNO, 'USD' CCYCD FROM BANKNOSTRO WHERE BANKTRANS = 'OUTTRFMONFEESETTUSD' AND ROWNUM = 1
                        ) NOSTRO,
                        (
                            select f.feecode,f.custodycd,f.ccycd,round(sum(f.feeamt),2) feeamt,round(sum(f.feerate),2) feerate,
                                round(sum(f.vatrate),2) vatrate,round(sum(f.vatamt),2) vatamt
                            from feetran f
                            where f.status ='N' and f.deltd <>'Y' and (f.pautoid is not null or f.type='F')
                                and f.custodycd = p_txmsg.txfields('88').value
                            group by f.feecode,f.custodycd,f.ccycd
                        ) fee
                        WHERE cf.custodycd = dd.custodycd(+)
                        and fee.feecode = a1.cdval(+)
                        and fee.custodycd = cf.custodycd(+)
                        and cf.amcid = fa.autoid(+)
                        AND FEE.CCYCD = NOSTRO.CCYCD(+)
              )
                loop
                    v_autoid := seq_fee_booking_result.nextval;
                    

                    INSERT INTO FEE_BOOKING_RESULT (AUTOID,GRAUTOID,BANKACCOUNT,CIFID,CURRENCY,REMARK,FEEAMOUNT,FXRATE,FXAMOUNT,NOSTROACCOUNT,STATUS,
                                                    BANKGLOBALID,TRANSDATE,SETTLEDATE,FEETYPE,FEECODE,FEETXDATE,FEETXNUM,TXDATE,TAXAMOUNT,FEENAME,MCIFID)
                    values (seq_fee_booking_result.nextval,v_autoid,r.BANKACCOUNT,r.CIFID,r.CURRENCY,r.REMARK,r.FEEAMOUNT,r.FXRATE,r.FXAMOUNT,r.NOSTROACCOUNT,r.STATUS,
                            'CB.FEE1204',null,null,r.FEETYPE,r.FEECODE,r.FEETXDATE,r.FEETXNUM,r.TXDATE,r.TAXAMOUNT,r.FEENAME,r.mcifid);

                    UPDATE FEETRAN SET STATUS='S', GLACCTNO=V_AUTOID
                    WHERE CUSTODYCD||FEECODE = R.KEYS
                    AND CCYCD = R.CURRENCY;

                end loop;

            --trung.luu: 18-02-2021 SHBVNEX-2067 lay so cifid cua tai khoan me

            --trung.luu: 18-03-2021 SHBVNEX-2161 khong dung cifid cua tai khoan me nua, dung master cifid
            /*BEGIN
                --SELECT CIFID INTO v_mcifid FROM CFMAST WHERE CUSTODYCD IN (select CF.MCUSTODYCD FROM CFMAST CF, FEE_BOOKING_RESULT FE WHERE CF.cifid = FE.cifid AND FE.autoid = v_autoid);
                SELECT nvl(MCIFID,cifid) INTO v_mcifid FROM CFMAST WHERE cifid IN (select cifid FROM FEE_BOOKING_RESULT  WHERE autoid = v_autoid);
            EXCEPTION WHEN NO_DATA_FOUND
                THEN
                v_mcifid:='';
            END;
            IF v_mcifid IS NOT NULL OR v_mcifid <> '' THEN
                UPDATE fee_booking_result
                    SET     MCIFID= v_mcifid
                    WHERE AUTOID = v_autoid
                ;
            END IF;*/


        END;
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
         plog.init ('TXPKS_#1204EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1204EX;
/
