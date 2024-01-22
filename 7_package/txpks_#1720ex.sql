SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1720ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1720EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      04/01/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1720ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_requestid        CONSTANT CHAR(2) := '99';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_dracctno         CONSTANT CHAR(2) := '03';
   c_cracctno         CONSTANT CHAR(2) := '05';
   c_fxtype           CONSTANT CHAR(2) := '06';
   c_amount           CONSTANT CHAR(2) := '10';
   c_exrate           CONSTANT CHAR(2) := '20';
   c_examt            CONSTANT CHAR(2) := '21';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
l_count       NUMBER;
l_cr_ccycd    VARCHAR2(100);
l_dr_ccycd    VARCHAR2(100);
l_ccycd       VARCHAR2(100);
l_bors        VARCHAR2(10);
l_cifid       VARCHAR2(100);
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
    SELECT ccycd INTO l_cr_ccycd FROM ddmast WHERE acctno = p_txmsg.txfields(c_cracctno).value;
    SELECT ccycd INTO l_dr_ccycd FROM ddmast WHERE acctno = p_txmsg.txfields(c_dracctno).value;
    IF NOT ((l_cr_ccycd = 'VND' OR l_dr_ccycd = 'VND')
            AND (l_cr_ccycd <> 'VND' OR l_dr_ccycd <> 'VND')) THEN
      -- Mua: CR <> 'VND' - DR = VND
      -- Sell: CR = 'VND' - DR <> VND
      p_err_code := '-150010';
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    SELECT cifid INTO l_cifid FROM cfmast WHERE custodycd = p_txmsg.txfields(c_custodycd).value;
    l_ccycd := CASE WHEN l_cr_ccycd = 'VND' THEN l_dr_ccycd ELSE l_cr_ccycd END ;
    l_bors := CASE WHEN l_cr_ccycd = 'VND' THEN 'S' ELSE 'B' END;

    IF NOT p_txmsg.txfields(c_requestid).value IS NULL THEN
        IF p_txmsg.txfields('11').value = 'N' THEN
            -- Ton Tai Yc Doi Tien --> valid thong tin khop vs yc
            -- Trang thai khong hop le
            SELECT COUNT(1) INTO l_count FROM tbl_mt380_inf inf WHERE inf.reqid = NVL(p_txmsg.txfields(c_requestid).value, '') AND status = 'P';
            IF NOT l_count = 1 THEN
                p_err_code := '-150011';
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        ELSE
            SELECT COUNT(1) INTO l_count FROM log_1721 inf WHERE inf.autoid = NVL(p_txmsg.txfields(c_requestid).value, 0) AND status = 'P';
            IF NOT l_count = 1 THEN
                p_err_code := '-150011';
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
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
v_fracctno varchar2(20);
v_frccycd varchar2(20);
v_cifid varchar2(20);
v_toacctno varchar2(20);
v_toccycd varchar2(20);

v_fr_custodycd varchar2(100);
v_to_custodycd varchar2(100);
v_fr_accounttype varchar2(100);
v_to_accounttype varchar2(100);
v_fr_refcasaacct varchar2(100);
v_to_refcasaacct varchar2(100);
v_fr_ccycd varchar2(100);
v_to_ccycd varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        IF NOT p_txmsg.txfields(c_requestid).value IS NULL THEN
            IF p_txmsg.txfields('11').value = 'N' THEN
                UPDATE tbl_mt380_inf SET status = 'A' WHERE reqid = p_txmsg.txfields(c_requestid).value AND status = 'P';

                UPDATE SWIFTMSGMAPLOG
                SET CFNSTATUS = 'C', STATUS = 'C' , CFNDESC = p_txmsg.txfields('30').value, CFTXNUM = p_txmsg.txnum, CFTXDATE = p_txmsg.txdate
                WHERE MSGID = p_txmsg.txfields(c_requestid).value
                and CFNSTATUS = 'P';
            ELSE
                UPDATE log_1721 SET status = 'A' WHERE autoid = p_txmsg.txfields(c_requestid).value AND status = 'P';
            END IF;
        END IF;
        IF p_txmsg.txfields('22').value = 'Y' THEN
                  --locpt 20190819 add phan sinh request qua bank
                --Sinh bankrequest,banklog
            /* Formatted on 8/19/2019 3:43:04 PM (QP5 v5.126) */
            select dd.refcasaacct, dd.ccycd, cf.cifid
            into v_fracctno ,v_frccycd, v_cifid
            from ddmast dd, cfmast cf where dd.acctno = p_txmsg.txfields ('03').VALUE and dd.custid =cf.custid;

             select refcasaacct, ccycd
            into v_toacctno ,v_toccycd
            from ddmast where acctno = p_txmsg.txfields ('05').VALUE;

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
                                  notes,unhold,rbankaccount,currency,tocurrency,
                                  exchangerate,exchangevalue,feecode,feetype,busdate)
              VALUES   (seq_crbtxreq.NEXTVAL,
                        'T',
                        '1720',
                        'FX',
                       'FXREQUEST',
                        p_txmsg.txnum,
                        p_txmsg.txnum,
                        TO_DATE (p_txmsg.txdate, systemnums.c_date_format),
                        TO_DATE (p_txmsg.txdate, systemnums.c_date_format),
                        'SHV',
                       v_fracctno,
                        v_cifid,
                        p_txmsg.txfields ('10').VALUE,
                        'P',
                        NULL,
                        NULL,
                        NULL,
                        p_txmsg.txfields ('30').VALUE,'N',v_toacctno,v_frccycd,v_toccycd,p_txmsg.txfields ('20').VALUE,p_txmsg.txfields ('21').VALUE,p_txmsg.txfields ('33').VALUE,p_txmsg.txfields ('06').VALUE,TO_DATE (p_txmsg.busdate, systemnums.c_date_format));


                 --trung.luu : 11-05-2021 log lai de lay bao cao cho de

                begin
                    select custodycd,accounttype,refcasaacct,ccycd into v_fr_custodycd,v_fr_accounttype,v_fr_refcasaacct,v_fr_ccycd
                        from ddmast
                        where   acctno = p_txmsg.txfields('03').value
                            and status <> 'C';

                    --tk nhan
                    select custodycd,accounttype,refcasaacct,ccycd into v_to_custodycd,v_to_accounttype,v_to_refcasaacct,v_to_ccycd
                        from ddmast
                        where   acctno = p_txmsg.txfields('05').value
                            and status <> 'C';
                exception when NO_DATA_FOUND
                    then
                    v_fr_custodycd :='';
                    v_to_custodycd:='';
                    v_fr_accounttype:= '';
                    v_to_accounttype:='';
                    v_fr_refcasaacct:='';
                    v_to_refcasaacct:='';
                    v_to_ccycd:= '';
                    v_fr_ccycd:='';
                end;

                if v_to_accounttype = 'IICA' and v_fr_ccycd=  'USD' then  --Cash amount(After exchange)
                    insert into log_od6004
                    (autoid, txnum, txdate, tltxcd, fccycd, tccycd,
                    custodycd, fraccount, toaccount, amount, deltd,lastchange)
                    values
                    (seq_log_od6004.nextval,p_txmsg.txnum,to_date(p_txmsg.txdate,'dd/MM/RRRR'),p_txmsg.tltxcd,v_fr_ccycd,v_to_ccycd,
                    v_to_custodycd,v_fr_refcasaacct,v_to_refcasaacct,to_number(p_txmsg.txfields('10').value),'N',SYSTIMESTAMP);
                elsif v_fr_accounttype = 'IICA' and v_to_ccycd =  'USD' then --Credit Amount
                    insert into log_od6004
                    (autoid, txnum, txdate, tltxcd, fccycd, tccycd,
                    custodycd, fraccount, toaccount, amount, deltd,lastchange)
                    values
                    (seq_log_od6004.nextval,p_txmsg.txnum,to_date(p_txmsg.txdate,'dd/MM/RRRR'),p_txmsg.tltxcd,v_fr_ccycd,v_to_ccycd,
                    v_fr_custodycd,v_fr_refcasaacct,v_to_refcasaacct,to_number(p_txmsg.txfields('21').value),'N',SYSTIMESTAMP);
                end if;

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
         plog.init ('TXPKS_#1720EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1720EX;
/
