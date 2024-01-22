SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3383ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3383EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      04/01/2012     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3383ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '06';
   c_issuermember     CONSTANT CHAR(2) := '40';
   c_codeid           CONSTANT CHAR(2) := '01';
   c_symbol           CONSTANT CHAR(2) := '35';
   c_custodycd        CONSTANT CHAR(2) := '36';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_iddate           CONSTANT CHAR(2) := '93';
   c_issname          CONSTANT CHAR(2) := '38';
   c_idplace          CONSTANT CHAR(2) := '94';
   c_country          CONSTANT CHAR(2) := '80';
   c_toacctno         CONSTANT CHAR(2) := '07';
   c_tranto           CONSTANT CHAR(2) := '04';
   c_custname2        CONSTANT CHAR(2) := '95';
   c_license2         CONSTANT CHAR(2) := '97';
   c_address2         CONSTANT CHAR(2) := '96';
   c_iddate2          CONSTANT CHAR(2) := '98';
   c_idplace2         CONSTANT CHAR(2) := '99';
   c_country2         CONSTANT CHAR(2) := '81';
   c_amt              CONSTANT CHAR(2) := '21';
   c_ramt             CONSTANT CHAR(2) := '23';
   c_mamt             CONSTANT CHAR(2) := '22';
   c_trflimit         CONSTANT CHAR(2) := '31';
   c_tradeplace       CONSTANT CHAR(2) := '37';
   c_desc             CONSTANT CHAR(2) := '30';
   V_STATUS         CHAR(1);
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_leader_license varchar2(100);
    l_leader_idexpired date;
    l_member_license varchar2(100);
    l_member_idexpired date;
    l_idexpdays apprules.field%TYPE;
    l_afmastcheck_arr txpks_check.afmastcheck_arrtype;
    l_leader_expired boolean;
    l_member_expired boolean;
    l_count number;
    l_trflimit varchar2(100);
    v_country VARCHAR2(5);
     l_vsdmod    varchar2(3);
    l_TRADEQTTY number;
    l_BLOCKQTTY number;
    l_afacctnodr varchar2(20);
    l_afacctnocr varchar2(20);
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
    --So tieu khoan ben ban
    begin
        select afacctno into l_afacctnodr
        from ddmast
        where custodycd=p_txmsg.txfields('36').value and status='A' and CCYCD='VND';
    EXCEPTION
    WHEN OTHERS
       THEN
        l_afacctnodr:='';
    end;
    --So tieu khoan ben nhan neu la SHV
    begin
        select afacctno into l_afacctnocr
        from ddmast
        where custodycd=p_txmsg.txfields('07').value and status='A' and CCYCD='VND';
    EXCEPTION
    WHEN OTHERS
       THEN
        l_afacctnocr:='';
    end;

    select count(*) into l_count from cfmast where custodycd=p_txmsg.txfields('36').value and  status<>'C' and custatcom='Y';
    IF l_count=0 then
        p_err_code := '-330003'; -- Pre-defined in DEFERROR table
        plog.setendsection (pkgctx, 'fn_txAftAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;

    if p_txmsg.deltd <> 'Y' then
        l_leader_expired:= false;
        l_member_expired:= false;

        --trung.luu: 16-09-2020  SHBVNEX-1559
        /*IF p_txmsg.txfields('24').value is null THEN
            p_err_code := '-330002'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txAftAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;*/
        --trung.luu: 16-09-2020  SHBVNEX-1559
           --T07/2017 STP
         l_TRADEQTTY := TO_NUMBER(p_txmsg.txfields('51').value);
        l_BLOCKQTTY := TO_NUMBER(p_txmsg.txfields('53').value);
        l_vsdmod :=cspks_system.fn_get_sysvar('SYSTEM', 'VSDMOD');

        --Check khong dc thuc hien 2 loai CK cung luc
        if l_vsdmod ='A' then --mod Auto
            if l_TRADEQTTY > 0 and l_BLOCKQTTY > 0 then
                p_err_code := '-150027';
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;
        --End T07/2017 STP

        select TRFLIMIT into l_trflimit from CAMAST WHERE CAMASTID= p_txmsg.txfields(c_camastid).value;

        if l_trflimit = 'Y' then
            SELECT count(1)
                into l_count
            FROM CASCHD
            WHERE CAMASTID=p_txmsg.txfields(c_camastid).value
                AND AFACCTNO =l_afacctnodr
                and to_number(p_txmsg.txfields(c_amt).value) > (pbalance-inbalance)
                and deltd <>'Y'
                AND autoid=p_txmsg.txfields('09').value;
            if l_count > 0 then
                p_err_code := '-300021'; -- Pre-defined in DEFERROR table
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        else
            p_err_code := '-300019'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
        --
        SELECT count(1) into l_count FROM CAMAST WHERE CAMASTID= p_txmsg.txfields(c_camastid).value and catype = '014';
        if l_count <= 0 then
            p_err_code := '-300019'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
        --
         SELECT COUNT(1)
            into l_count
        FROM CAMAST CA, SYSVAR SYS
        WHERE SYS.VARNAME = 'CURRDATE' AND SYS.GRNAME = 'SYSTEM' AND CATYPE = '014'
        AND TO_DATE (VARVALUE,'DD/MM/RRRR') >= FRDATETRANSFER AND camastid = p_txmsg.txfields(c_camastid).value;
        if l_count <= 0 then
            p_err_code := '-300029'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

    else
        SELECT MAX(statusre) INTO V_STATUS FROM catransfer
        WHERE TXDATE = p_txmsg.txdate AND TXNUM = p_txmsg.txnum;
        IF(V_STATUS = 'Y') THEN
            p_err_code := '-100017';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
    end if;
    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
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
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_txAftAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppCheck;

FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
 v_balance number;
 l_ddmastcheck_arr txpks_check.ddmastcheck_arrtype;
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
      plog.error (pkgctx, SQLERRM);
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
    l_afacctnodr varchar2(20);
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
    from camast where camastid = p_txmsg.txfields(c_camastid).value and deltd <> 'Y';

    --So tieu khoan ben ban
    begin
        select afacctno into l_afacctnodr
        from ddmast
        where custodycd=p_txmsg.txfields('36').value and status='A' and CCYCD='VND' and isdefault='Y';
    EXCEPTION
    WHEN OTHERS
       THEN
        l_afacctnodr:='';
    end;
    --So tieu khoan ben nhan neu la SHV
    begin
        select afacctno into l_afacctnocr
        from ddmast
        where custodycd=p_txmsg.txfields('07').value and status='A' and CCYCD='VND' and isdefault='Y';
    EXCEPTION
    WHEN OTHERS
       THEN
        l_afacctnocr:='';
    end;

    if p_txmsg.deltd <> 'Y' then
        UPDATE CASCHD
        SET PBALANCE = PBALANCE - l_qtty, OUTBALANCE = OUTBALANCE +l_qtty ,
            PQTTY = TRUNC( FLOOR(( (PBALANCE - l_qtty) * l_right_rightoffrate) / l_left_rightoffrate)  ,l_roundtype) ,
            PAAMT= l_exprice *  TRUNC( FLOOR(( ( PBALANCE - l_qtty ) * l_right_rightoffrate ) / l_left_rightoffrate ) ,l_roundtype ),
            RETAILBAL =  RETAILBAL -  l_qtty
        WHERE AFACCTNO =l_afacctnodr AND camastid = p_txmsg.txfields(c_camastid).value and  deltd <> 'Y'
        AND autoid=p_txmsg.txfields('09').value;
        -- insert mot dong vao CATRANSFER.

          --T07/2017 STP
        --ADD VuTN: log them loai quyen cua loai CK
        if P_TXMSG.TXFIELDS('51').VALUE > 0 then
            l_VSDSTOCKTYPE:='1';
        else
            l_VSDSTOCKTYPE:='2';
        end if;

/*        --NamTv check tai khoan mua trong ngoai SHV
        begin
            select custatcom into l_custatcom
            from cfmast
            where custodycd=replace(trim(p_txmsg.txfields('07').value),'.');
        EXCEPTION
        WHEN OTHERS
           THEN
           l_custatcom:='N' ;
        end;
        IF l_custatcom='Y' THEN
            V_STATUS:='H';
        ELSE
            V_STATUS:='P';
        END IF;*/
        --NamTv gan mat dinh la H
        V_STATUS:='H';

        select refcasaacct into l_refcasaacct from ddmast where acctno=p_txmsg.txfields('19').value and status='A';

        INSERT INTO catransfer (AUTOID,TXDATE,TXNUM,CAMASTID,OPTSEACCTNOCR,OPTSEACCTNODR,CODEID,OPTCODEID,AMT,STATUS,INAMT,retailbal,sendINAMT,SENDRETAILBAL,
          TOACCTNO,TOMEMCUS,COUNTRY2,CUSTNAME2,ADDRESS2,LICENSE2,IDDATE2,IDPLACE2,CASCHDID,VSDSTOCKTYPE,
          NOTRANSCT,REMOACCOUNT,CITAD,THGOMONEY,CUSTODYCD,TRANSFERPRICE,MEMCUSTO,COUNTRY,CUSTNAME,ADDRESS,LICENSE,IDDATE,IDPLACE,DDACCTNO,FEEAMT,TAXAMT)
        VALUES(seq_catransfer.nextval, p_txmsg.txdate, p_txmsg.txnum,p_txmsg.txfields(c_camastid).value,
         l_afacctnocr||l_optcodeid, l_afacctnodr||l_optcodeid,l_codeid ,l_optcodeid, l_qtty,V_STATUS,0,0,0,0,
         UPPER(replace(p_txmsg.txfields('07').value,'.')),p_txmsg.txfields('08').value,p_txmsg.txfields('81').value,
         p_txmsg.txfields('95').value,p_txmsg.txfields('96').value,p_txmsg.txfields('97').value,
         TO_DATE(p_txmsg.txfields('98').value,'DD/MM/RRRR'),p_txmsg.txfields('99').value,to_number(p_txmsg.txfields('09').value),l_VSDSTOCKTYPE,
         p_txmsg.txfields('24').value,p_txmsg.txfields('26').value,p_txmsg.txfields('27').value,p_txmsg.txfields('16').value,
         p_txmsg.txfields('36').value,to_number(p_txmsg.txfields('13').value),
         p_txmsg.txfields('25').value,p_txmsg.txfields('80').value,p_txmsg.txfields('90').value,p_txmsg.txfields('91').value,p_txmsg.txfields('92').value,
         p_txmsg.txfields('93').value,p_txmsg.txfields('94').value,l_refcasaacct,to_number(p_txmsg.txfields('12').value),to_number(p_txmsg.txfields('15').value));

         --xu ly phan log dien
            UPDATE CASCHD_LOG
               SET OUTTRADE = OUTTRADE + P_TXMSG.TXFIELDS('51').VALUE,
                   TRADE = TRADE - P_TXMSG.TXFIELDS('51').VALUE,
                  OUTBLOCKED = OUTBLOCKED + P_TXMSG.TXFIELDS('53').VALUE,
                  BLOCKED = BLOCKED - P_TXMSG.TXFIELDS('53').VALUE,

                  PTRADE = TRUNC( FLOOR((( TRADE + BLOCKED - P_TXMSG.TXFIELDS('51').VALUE) * l_right_rightoffrate) / l_left_rightoffrate)  ,l_roundtype)
                  - PBLOCKED,
                  PBLOCKED = TRUNC( FLOOR((( TRADE + BLOCKED - P_TXMSG.TXFIELDS('53').VALUE) * l_right_rightoffrate) / l_left_rightoffrate)  ,l_roundtype)
                  - PTRADE
                  where camastid = p_txmsg.txfields('06').value
                  and AFACCTNO = l_afacctnodr
                  and deltd = 'N';
    else
        SELECT MIN(statusre) INTO V_STATUS FROM catransfer
        WHERE TXDATE = p_txmsg.txdate AND TXNUM = p_txmsg.txnum;
        IF(V_STATUS = 'Y') THEN
            p_err_code := '-100017';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

        UPDATE CASCHD
        SET PBALANCE = PBALANCE + l_qtty ,OUTBALANCE = OUTBALANCE - l_qtty  ,
            PQTTY = TRUNC( FLOOR(( (PBALANCE +  l_qtty ) * l_right_rightoffrate) / l_left_rightoffrate )  , l_roundtype ) ,
            PAAMT =  l_exprice * TRUNC(FLOOR(((PBALANCE + l_qtty ) * l_right_rightoffrate ) / l_left_rightoffrate )  , l_roundtype)
            , RETAILBAL =  RETAILBAL +  l_qtty
        WHERE AFACCTNO =l_afacctnocr AND camastid = p_txmsg.txfields(c_camastid).value and  deltd <> 'Y'
         AND autoid=p_txmsg.txfields('09').value;
         UPDATE catransfer SET STATUS = 'C' WHERE TXDATE = p_txmsg.txdate AND TXNUM = p_txmsg.txnum;


         --- xu ly phan log dien
            UPDATE CASCHD_LOG
                   SET OUTTRADE = OUTTRADE - P_TXMSG.TXFIELDS('51').VALUE,
                   TRADE = TRADE + P_TXMSG.TXFIELDS('51').VALUE,
                   OUTBLOCKED = OUTBLOCKED - P_TXMSG.TXFIELDS('53').VALUE,
                   BLOCKED = BLOCKED + P_TXMSG.TXFIELDS('53').VALUE,

                   PTRADE = TRUNC( FLOOR((( TRADE + BLOCKED + P_TXMSG.TXFIELDS('51').VALUE) * l_right_rightoffrate) / l_left_rightoffrate)  ,l_roundtype)
                   - PBLOCKED,
                   PBLOCKED = TRUNC( FLOOR((( TRADE + BLOCKED + P_TXMSG.TXFIELDS('53').VALUE) * l_right_rightoffrate) / l_left_rightoffrate)  ,l_roundtype)
                   - PTRADE
                   where camastid = p_txmsg.txfields('06').value
                   and AFACCTNO = l_afacctnodr
                   and deltd = 'N';

    end if;

    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
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
         plog.init ('TXPKS_#3383EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3383EX;
/
