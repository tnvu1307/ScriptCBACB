SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3303ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3303EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      24/11/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3303ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '06';
   c_toacctno         CONSTANT CHAR(2) := '07';
   c_toafacctno       CONSTANT CHAR(2) := '10';
   c_remoaccount      CONSTANT CHAR(2) := '26';
   c_notransct        CONSTANT CHAR(2) := '24';
   c_thgomoney        CONSTANT CHAR(2) := '16';
   c_issuermember     CONSTANT CHAR(2) := '40';
   c_tosymbol         CONSTANT CHAR(2) := '60';
   c_tocodeid         CONSTANT CHAR(2) := '62';
   c_baldefavl        CONSTANT CHAR(2) := '17';
   c_fromcusadd       CONSTANT CHAR(2) := '25';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_toissname        CONSTANT CHAR(2) := '61';
   c_iddate           CONSTANT CHAR(2) := '93';
   c_issname          CONSTANT CHAR(2) := '38';
   c_idplace          CONSTANT CHAR(2) := '94';
   c_country          CONSTANT CHAR(2) := '80';
   c_custodycd        CONSTANT CHAR(2) := '36';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_ddacctno         CONSTANT CHAR(2) := '19';
   c_citad            CONSTANT CHAR(2) := '27';
   c_tomemcus         CONSTANT CHAR(2) := '08';
   c_custname2        CONSTANT CHAR(2) := '95';
   c_license2         CONSTANT CHAR(2) := '97';
   c_address2         CONSTANT CHAR(2) := '96';
   c_iddate2          CONSTANT CHAR(2) := '98';
   c_idplace2         CONSTANT CHAR(2) := '99';
   c_country2         CONSTANT CHAR(2) := '81';
   c_outptrade        CONSTANT CHAR(2) := '51';
   c_outpblocked      CONSTANT CHAR(2) := '53';
   c_amt              CONSTANT CHAR(2) := '21';
   c_trflimit         CONSTANT CHAR(2) := '31';
   c_$feecd           CONSTANT CHAR(2) := '11';
   c_tradeplace       CONSTANT CHAR(2) := '37';
   c_sendto           CONSTANT CHAR(2) := '41';
   c_tranferprice     CONSTANT CHAR(2) := '13';
   c_feeamt           CONSTANT CHAR(2) := '12';
   c_taxrate          CONSTANT CHAR(2) := '14';
   c_taxamt           CONSTANT CHAR(2) := '15';
   c_desc             CONSTANT CHAR(2) := '30';
   c_autoid           CONSTANT CHAR(2) := '09';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
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
    IF p_txmsg.txfields('24').value is null THEN
        p_err_code := '-330002'; -- Pre-defined in DEFERROR table
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    select count(*) into v_count from cfmast where custodycd=p_txmsg.txfields('07').value and  status<>'C' and custatcom='Y';
    IF v_count>0 then
        p_err_code := '-330003'; -- Pre-defined in DEFERROR table
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;

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
    l_qtty number(20,4);
    l_left_rightoffrate varchar2(30);
    l_right_rightoffrate varchar2(30);
    l_roundtype number(20,4);
    l_exprice number(20,4);
    l_transfertimes number(20,4);
    l_retailbal number(20,4);
    l_optcodeid varchar2(100);
    l_count number;
    V_STATUS         CHAR(1);
    l_VSDSTOCKTYPE      varchar2(3);
    l_codeid varchar2(20);
    l_custatcom varchar2(1);
    l_afacctnocr varchar2(20);
    l_refcasaacct varchar2(50);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_qtty:= to_number(p_txmsg.txfields(c_amt).value);
    SELECT      substr(rightoffrate,1,instr(rightoffrate,'/')-1),
           substr(rightoffrate,instr(rightoffrate,'/') + 1,length(rightoffrate)),
           roundtype, TRANSFERTIMES, OPTCODEID, exprice, codeid
    INTO    l_left_rightoffrate, l_right_rightoffrate, l_roundtype, l_transfertimes, l_optcodeid, l_exprice, l_codeid
    from camast where camastid = replace(p_txmsg.txfields(c_camastid).value,'.') and deltd <> 'Y';

    --So tieu khoan ben nhan neu la SHV
    begin
        select afacctno into l_afacctnocr
        from ddmast
        where custodycd=p_txmsg.txfields('36').value and status='A' and CCYCD='VND' and isdefault='Y';
    EXCEPTION
    WHEN OTHERS
       THEN
        l_afacctnocr:='';
    end;

    if p_txmsg.deltd <> 'Y' then
        -- insert mot dong vao CATRANSFER.
        --T07/2017 STP
        --ADD VuTN: log them loai quyen cua loai CK
        if P_TXMSG.TXFIELDS('51').VALUE > 0 then
            l_VSDSTOCKTYPE:='1';
        else
            l_VSDSTOCKTYPE:='2';
        end if;
/*        -- su dung them trang thai P,C de phan biet voi jao dich lam qua 3382 (N,Y)
        select custatcom into l_custatcom
        from cfmast
        where custodycd=replace(trim(p_txmsg.txfields('36').value),'.');*/

        --NamTv gan trang thai mat dinh la H
        V_STATUS:='H';

        --Lay thong tin ma di tien
        select refcasaacct into l_refcasaacct from ddmast where acctno=p_txmsg.txfields('19').value and status='A';

        INSERT INTO catransfer (AUTOID,TXDATE,TXNUM,CAMASTID,OPTSEACCTNOCR,OPTSEACCTNODR,CODEID,OPTCODEID,AMT,STATUS,INAMT,retailbal,sendINAMT,SENDRETAILBAL,
          TOACCTNO,TOMEMCUS,COUNTRY2,CUSTNAME2,ADDRESS2,LICENSE2,IDDATE2,IDPLACE2,CASCHDID,VSDSTOCKTYPE,
          NOTRANSCT,REMOACCOUNT,CITAD,THGOMONEY,CUSTODYCD,TRANSFERPRICE,DDACCTNO,MEMCUSTO,COUNTRY,CUSTNAME,ADDRESS,LICENSE,IDDATE,IDPLACE,FEEAMT,TAXAMT)
        VALUES(seq_catransfer.nextval, p_txmsg.txdate, p_txmsg.txnum,p_txmsg.txfields(c_camastid).value,
         l_afacctnocr  || l_optcodeid,'', l_codeid ,l_optcodeid, l_qtty,V_STATUS,0,0,0,0,
         p_txmsg.txfields('36').value,p_txmsg.txfields('08').value,p_txmsg.txfields('81').value,
         p_txmsg.txfields('95').value,p_txmsg.txfields('96').value,p_txmsg.txfields('97').value,
         TO_DATE(p_txmsg.txfields('98').value,'DD/MM/RRRR'),p_txmsg.txfields('99').value,0,l_VSDSTOCKTYPE,
         p_txmsg.txfields('24').value,l_refcasaacct,p_txmsg.txfields('27').value,p_txmsg.txfields('16').value,
         p_txmsg.txfields('07').value,to_number(p_txmsg.txfields('13').value),p_txmsg.txfields('26').value,p_txmsg.txfields('25').value,p_txmsg.txfields('80').value,p_txmsg.txfields('90').value,p_txmsg.txfields('91').value,p_txmsg.txfields('92').value,
         p_txmsg.txfields('93').value,p_txmsg.txfields('94').value,to_number(p_txmsg.txfields('12').value),to_number(p_txmsg.txfields('15').value));
    else
        SELECT MIN(statusre) INTO V_STATUS FROM catransfer
        WHERE TXDATE = p_txmsg.txdate AND TXNUM = p_txmsg.txnum;
        IF(V_STATUS = 'Y') THEN
            p_err_code := '-100017';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

        UPDATE catransfer SET STATUS = 'C' WHERE TXDATE = p_txmsg.txdate AND TXNUM = p_txmsg.txnum;
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
         plog.init ('TXPKS_#3303EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3303EX;
/
