SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1904ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1904EX
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


CREATE OR REPLACE PACKAGE BODY txpks_#1904ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_postdate         CONSTANT CHAR(2) := '20';
   c_camastid         CONSTANT CHAR(2) := '88';
   c_ticker           CONSTANT CHAR(2) := '12';
   c_periodinterest   CONSTANT CHAR(2) := '16';
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
l_camastid varchar2(30);
l_catype varchar2(10);
l_reportdate date;
l_bondcode varchar2(20);
l_iqtty number;--tang
l_dqtty number;--gi?m
l_qtty number;
l_amt number;
l_amt_tax number;
l_parvalue number(20,4);
l_interestrate number(20,4);
l_pitrate number(20,4);
l_tax number(20,4);
l_custodycd varchar2(30);
l_fullname varchar2(200);
l_depositary varchar2(1);
l_count number;
dd_depositary varchar2(1);
l_countdays number;
l_interestdate number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_camastid := REPLACE(p_txmsg.txfields(c_camastid).value,'.','');
     
    select a.reportdate, a.codeid, a.catype, a.pitrate, sb.parvalue, a.interestrate,sb.interestdate
    into l_reportdate, l_bondcode, l_catype, l_pitrate, l_parvalue, l_interestrate,l_interestdate
    from camast a, sbsecurities sb where a.camastid = l_camastid and a.codeid = sb.codeid;

    -- Thoai.tran 30/05/2022 SHBVNEX-2702
    -- Dieu chinh gtri tinh lai theo so ngay tinh lai
    select get_countday('N',begindate,paymentdate) into l_countdays
    from BONDTYPEPAY where autoid = p_txmsg.txfields(c_periodinterest).value;
    IF p_txmsg.deltd <> 'Y' THEN -- NORMAL TRANSACTION
        -- update parvalue trong camast
        UPDATE camast SET parvalue=
          (SELECT se.parvalue FROM sbsecurities se WHERE  se.codeid = l_bondcode)
         WHERE camastid = l_camastid;
        for rec in
        (
            select * from bondsemast se where se.bondcode = l_bondcode
        )
        loop
            
            select a.custodycd, a.fullname, a.custatcom into l_custodycd, l_fullname, l_depositary from cfmast a where a.custodycd = rec.CUSTODYCD;
            --t? t?ng s? lu?ng tp tang sau ng?ch?t
            select NVL(sum(a.namt), 0) into l_iqtty
            from VW_BONDTRAN a, APPTX app
            where a.ref = rec.ACCTNO
            and a.TXCD = app.txcd
            and app.txtype = 'C'
            and a.DELTD <> 'Y'
            and a.bkdate > TO_DATE(l_reportdate,systemnums.C_DATE_FORMAT);
            --t? t?ng s? lu?ng tp gi?m sau ng?ch?t
            select NVL(sum(a.namt), 0) into l_dqtty
            from VW_BONDTRAN a, APPTX app
            where a.ref = rec.ACCTNO
            and a.TXCD = app.txcd
            and app.txtype = 'D'
            and a.DELTD <> 'Y'
            and a.bkdate > TO_DATE(l_reportdate,systemnums.C_DATE_FORMAT);
            l_qtty := rec.TRADE - l_iqtty + l_dqtty;

            
            if l_qtty > 0 then

                if l_catype = '016' then
                    l_amt := (l_parvalue + l_parvalue * l_interestrate/100 * l_countdays/l_interestdate )* l_qtty;
                    l_amt_tax:=l_parvalue * l_interestrate/100  * l_qtty * l_countdays/l_interestdate;
                else
                    l_amt := l_parvalue * l_interestrate/100  * l_qtty * l_countdays/l_interestdate;
                    l_amt_tax:=l_parvalue * l_interestrate/100  * l_qtty * l_countdays/l_interestdate;
                end if;
                l_tax := l_pitrate * l_amt_tax/100;
                select NVL(count(*), 0) into l_count from bondcaschd a where a.camastid = l_camastid and a.custodycd = l_custodycd and a.periodinterest = p_txmsg.txfields(c_periodinterest).value;
               

                l_amt := ROUND(l_amt, 0);
                l_tax := ROUND(l_tax, 0);

                if l_count > 0 then --run one more time
                /*
                    update bondcaschd bo
                    set bo.quantity = bo.quantity + l_qtty,
                        bo.amount = bo.amount + l_amt,
                        bo.tax = bo.tax + l_tax,
                        bo.netamount = bo.netamount + (l_amt - l_tax)
                    where bo.camastid = l_camastid
                    and bo.custodycd = l_custodycd
                    and bo.periodinterest = p_txmsg.txfields(c_periodinterest).value;
                */
                    -- get depositary bondcaschd and insert for new record
                    select a.depositary into dd_depositary
                    from bondcaschd a
                    where a.camastid = l_camastid
                    and a.custodycd = l_custodycd and rownum=1;
                    -- delete record old
                    delete bondcaschd a
                    where a.camastid = l_camastid and a.custodycd = l_custodycd and a.periodinterest = p_txmsg.txfields(c_periodinterest).value and a.status ='P';
                    -- insert new record
                    insert into bondcaschd (AUTOID, CAMASTID, CUSTODYCD, FULLNAME, QUANTITY, AMOUNT, TAX, NETAMOUNT, DEPOSITARY, STATUS, DELTD, PERIODINTEREST)
                        values (SEQ_BONDCASCHD.Nextval, l_camastid, l_custodycd, l_fullname, l_qtty, l_amt, l_tax, l_amt - l_tax, dd_depositary, 'P', 'N',p_txmsg.txfields(c_periodinterest).value);
                    -- set custatcom = NO when ?s yes.
                    -- Thoai.tran 14/06/20222
                    -- DiemNQ yeu cau bo
                    /*if l_depositary ='Y' then
                         update cfmast a SET a.custatcom ='N' where a.custodycd = rec.CUSTODYCD;
                    end if;*/
                else -- first run.
                    insert into bondcaschd (AUTOID, CAMASTID, CUSTODYCD, FULLNAME, QUANTITY, AMOUNT, TAX, NETAMOUNT, DEPOSITARY, STATUS, DELTD, PERIODINTEREST)
                        values (SEQ_BONDCASCHD.Nextval, l_camastid, l_custodycd, l_fullname, l_qtty, l_amt, l_tax, l_amt - l_tax, l_depositary, 'P', 'N',p_txmsg.txfields(c_periodinterest).value);
                end if;
            end if;
        end loop;
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
         plog.init ('TXPKS_#1904EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1904EX;
/
