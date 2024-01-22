SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3385ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3385EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      08/03/2012     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3385ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '06';
   c_codeid           CONSTANT CHAR(2) := '01';
   c_orgseacctno      CONSTANT CHAR(2) := '12';
   c_orgcodeid        CONSTANT CHAR(2) := '11';
   c_symbol           CONSTANT CHAR(2) := '35';
   c_afacct2          CONSTANT CHAR(2) := '04';
   c_acct2            CONSTANT CHAR(2) := '05';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_idplace          CONSTANT CHAR(2) := '94';
   c_iddate           CONSTANT CHAR(2) := '93';
   c_country          CONSTANT CHAR(2) := '80';
   c_toacctno         CONSTANT CHAR(2) := '09';
   c_tranto           CONSTANT CHAR(2) := '08';
   c_custname2        CONSTANT CHAR(2) := '95';
   c_address2         CONSTANT CHAR(2) := '96';
   c_license2         CONSTANT CHAR(2) := '97';
   c_iddate2          CONSTANT CHAR(2) := '98';
   c_idplace2         CONSTANT CHAR(2) := '99';
   c_country2         CONSTANT CHAR(2) := '81';
   c_amt              CONSTANT CHAR(2) := '21';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
l_catype VARCHAR2(3);
l_status VARCHAR2(1);
l_count NUMBER(20);
l_trntime NUMBER(20);
l_trnlimit VARCHAR2(3);
l_optseacctnocr varchar2(20);
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
    if(p_txmsg.deltd <> 'Y') THEN
        select optseacctnocr into l_optseacctnocr  from catransfer where TO_CHAR(TXDATE,'DDMMRRRR') || TXNUM = p_txmsg.txfields('50').value;

        SELECT catype,status INTO l_catype,l_status
        from camast WHERE camastid=replace(p_txmsg.txfields(c_camastid).value,'.')
        AND deltd='N';
    --Chi thuc hien voi su kien Stock RightOff
    if(l_catype <> '014') THEN
        p_err_code := '-300019'; -- Pre-defined in DEFERROR table
        plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    --Kiem tra ACCTNO1 co trong he thong
      SELECT COUNT(*) INTO l_COUNT
      FROM AFMAST WHERE ACCTNO = substr(l_optseacctnocr,0,10);
      if(l_COUNT <= 0) THEN
        p_err_code := '-300019'; -- Pre-defined in DEFERROR table
        plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
        RETURN errnums.C_BIZ_RULE_INVALID;
      END IF;
    -- transfer time
    select TransferTimes ,TRFLIMIT
    INTO l_trntime,l_trnlimit
    from CAMAST WHERE CAMASTID= replace(p_txmsg.txfields(c_camastid).value,'.');
    if(l_trnlimit='Y') THEN
            IF (l_trntime=0) THEN
              p_err_code := '-300019'; -- Pre-defined in DEFERROR table
              plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
              RETURN errnums.C_BIZ_RULE_INVALID;
              END IF;

    END IF;
   -- check xem den ngay dc chuyen nhuong chua
    SELECT COUNT(1) INTO l_count
    FROM CAMAST CA, SYSVAR SYS
    WHERE SYS.VARNAME = 'CURRDATE'
    AND SYS.GRNAME = 'SYSTEM'
    AND CATYPE = '014' AND TO_DATE (VARVALUE,'DD/MM/RRRR') >= FRDATETRANSFER
    AND camastid = replace(p_txmsg.txfields(c_camastid).value,'.');
    end IF;
    IF (l_count=0) THEN
              p_err_code := '-300029'; -- Pre-defined in DEFERROR table
              plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
              RETURN errnums.C_BIZ_RULE_INVALID;
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
l_count NUMBER(20);
l_qtty NUMBER(20);
l_rightoffrate VARCHAR2(20);
l_left_rightoffrate NUMBER(20);
l_right_rightoffrate NUMBER(20);
l_roundtype NUMBER(20);
l_exprice NUMBER(20);
l_codeid VARCHAR2(20);
l_excodeid VARCHAR2(20);
l_REPORTDATE DATE;
l_ACTIONDATE DATE;
l_duedate DATE;
l_autoid NUMBER;
l_txkey varchar2(50);
v_count number;
l_txdesc varchar2(2000);
l_vsdstocktype varchar2(3);
l_optcodeid varchar2(20);
l_optseacctnocr varchar2(50);
l_sectype  semast.actype%TYPE;
l_custid afmast.custid%TYPE;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT

   ***************************************************************************************************/



    l_qtty := to_number(p_txmsg.txfields('21').value);
    l_txkey := p_txmsg.txfields('50').value;

    update catransfer set STATUS = 'C'
    where TO_CHAR(TXDATE,'DDMMRRRR') || TXNUM = l_txkey;

    SELECT codeid,excodeid,REPORTDATE,ACTIONDATE,DUEDATE,rightoffrate,to_number(roundtype),
           exprice,optcodeid
    INTO   l_codeid,l_excodeid,l_REPORTDATE,l_ACTIONDATE,l_duedate,l_RIGHTOFFRATE,l_roundtype,
           l_exprice,l_optcodeid
    FROM camast WHERE camastid= replace(p_txmsg.txfields(c_camastid).value,'.');

    l_left_rightoffrate := to_number( substr(l_rightoffrate,0,instr(l_rightoffrate,'/') - 1));
    l_right_rightoffrate := to_number(substr(l_rightoffrate,instr(l_rightoffrate,'/') + 1,length(l_rightoffrate)));

    select optseacctnocr into l_optseacctnocr  from catransfer where TO_CHAR(TXDATE,'DDMMRRRR') || TXNUM = l_txkey;

    if(p_txmsg.deltd <>'Y') THEN       -- neu khong pai la xoa jao dich
        select count(*) into v_count from cfmast where custodycd=p_txmsg.txfields('09').value and custatcom='Y';
        IF v_count>0 THEN
        select count(*) into v_count from semast where acctno=l_optseacctnocr;
            IF v_count>0 THEN
                select en_txdesc into l_txdesc from tltx where tltxcd='3385';
                INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_optseacctnocr,'0045',ROUND(l_qtty,0),NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || l_txdesc || '');

                UPDATE SEMAST
                 SET
                   TRADE = TRADE + (ROUND(p_txmsg.txfields('21').value,0)), LAST_CHANGE = SYSTIMESTAMP
                WHERE ACCTNO=l_optseacctnocr;
            ELSE
                --Lay thong tin insert SEMAST
                 BEGIN
                     SELECT b.setype,a.custid
                     INTO l_sectype,l_custid
                     FROM AFMAST A, aftype B
                     WHERE  A.actype= B.actype
                     AND a.ACCTNO = substr(l_optseacctnocr,0,10);
                 EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                     p_err_code := errnums.C_CF_REGTYPE_NOT_FOUND;
                     RAISE errnums.E_CF_REGTYPE_NOT_FOUND;
                 END;
                 --Inser semast
                 INSERT INTO SEMAST
                 (ACTYPE,CUSTID,ACCTNO,CODEID,AFACCTNO,OPNDATE,LASTDATE,COSTDT,TBALDT,STATUS,IRTIED,IRCD,
                 COSTPRICE,TRADE,MORTAGE,MARGIN,NETTING,STANDING,WITHDRAW,DEPOSIT,LOAN)
                 VALUES(
                 l_sectype, l_custid, l_optseacctnocr,l_optcodeid,substr(l_optseacctnocr,0,10),
                 TO_DATE(  p_txmsg.txdate , systemnums.C_DATE_FORMAT ),TO_DATE(  p_txmsg.txdate ,   systemnums.C_DATE_FORMAT ),
                 TO_DATE(  p_txmsg.txdate , systemnums.C_DATE_FORMAT ),TO_DATE(  p_txmsg.txdate ,   systemnums.C_DATE_FORMAT ),
                 'A','Y','000', 0,l_qtty,0,0,0,0,0,0,0);

                    select en_txdesc into l_txdesc from tltx where tltxcd='3385';
                    INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                        VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_optseacctnocr,'0045',ROUND(l_qtty,0),NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || l_txdesc || '');

            END IF;
        END IF;
      select COUNT(1) INTO l_count from  -- kiem tra xem tk nhan da co caschd tuong ung chua
      caschd where camastid=p_txmsg.txfields(c_camastid).value
      and afacctno = substr(l_optseacctnocr,0,10)
      AND isreceive='N';
      if(L_count >0) THEN
         SELECT autoid
         INTO l_autoid
         FROM  caschd
         where camastid=p_txmsg.txfields(c_camastid).value
         and afacctno = substr(l_optseacctnocr,0,10)
         AND isreceive='N' AND deltd='N'
         AND ROWNUM=1;
         UPDATE CASCHD  SET PBALANCE = PBALANCE +l_qtty ,
                INBALANCE = INBALANCE +l_qtty ,
                PQTTY = TRUNC( FLOOR(( (PBALANCE + l_qtty) * l_right_rightoffrate) / l_left_rightoffrate),l_ROUNDTYPE ) ,
                  PAAMT=  l_exprice * TRUNC(  FLOOR(( ( PBALANCE +l_qtty) * l_right_rightoffrate) / l_left_rightoffrate)  ,l_ROUNDTYPE)
         WHERE autoid=l_autoid;


      ELSE


         l_autoid:= SEQ_CASCHD.NEXTVAL;
         INSERT INTO CASCHD (AUTOID, CAMASTID, AFACCTNO, CODEID, EXCODEID, BALANCE, QTTY, AMT, AQTTY, AAMT, STATUS,REQTTY,REAQTTY ,DELTD,PBALANCE,PQTTY,PAAMT,INBALANCE,isreceive)
         VALUES(l_autoid, p_txmsg.txfields(c_camastid).value ,substr(l_optseacctnocr,0,10) ,l_codeid , ' ' , 0 , 0 , 0 , 0  , 0 , 'V'  ,0 , 0 , 'N' ,
         l_qtty, TRUNC( FLOOR((l_qtty * l_right_rightoffrate) / l_left_rightoffrate)  ,l_ROUNDTYPE)  ,l_EXPRICE * TRUNC(  FLOOR((  l_qtty   * l_right_rightoffrate) / l_left_rightoffrate) , l_ROUNDTYPE),l_qtty,'N');

        END IF;
      if (p_txmsg.txfields('50').value is not null and LENGTH(l_txkey) > 10) then
        update catransfer set statusre = 'Y' where to_char(txdate, 'DDMMRRRR') || txnum = l_txkey;
      end if;

        -- update ACCTREF;ref trong setran la autoid  de len bao cao
         UPDATE setran SET ACCTREF=l_autoid,ref=l_autoid
         WHERE TXNUM=p_txmsg.txnum AND txdate= TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT)
         AND txcd='0045' AND acctno=l_optseacctnocr;

        -- update ref trong setran la autoid trong caschd


        --ghi log de lam dien
      select COUNT(1) INTO l_count
      from caschd_log
      where camastid=p_txmsg.txfields(c_camastid).value
      and afacctno = substr(l_optseacctnocr,0,10)
      AND deltd='N';

      if(L_count >0) THEN
        if p_txmsg.txfields('78').value = '1' then
            update caschd_log
            set trade = trade + l_qtty,
                ptrade = TRUNC( FLOOR(( (trade + blocked + l_qtty) * l_right_rightoffrate) / l_left_rightoffrate),l_ROUNDTYPE ) - pblocked,
                intrade = intrade + l_qtty
            where camastid=p_txmsg.txfields(c_camastid).value
            and afacctno = substr(l_optseacctnocr,0,10)
            and deltd = 'N';
        else
            update caschd_log
            set blocked = blocked + l_qtty,
                pblocked = TRUNC( FLOOR(( (trade + blocked + l_qtty) * l_right_rightoffrate) / l_left_rightoffrate),l_ROUNDTYPE ) - ptrade,
                inblocked = inblocked + l_qtty
            where camastid=p_txmsg.txfields(c_camastid).value
            and afacctno = substr(l_optseacctnocr,0,10)
            and deltd = 'N';
        end if;
      else
        if p_txmsg.txfields('78').value = '1' then
            insert into CASCHD_LOG(CAMASTID,CODEID,AFACCTNO,TRADE,PTRADE,BLOCKED,PBLOCKED)
            VALUES(p_txmsg.txfields(c_camastid).value,l_codeid,substr(l_optseacctnocr,0,10),l_qtty,TRUNC( FLOOR(( l_qtty * l_right_rightoffrate) / l_left_rightoffrate),l_ROUNDTYPE ),0,0);
        else
            insert into CASCHD_LOG(CAMASTID,CODEID,AFACCTNO,TRADE,PTRADE,BLOCKED,PBLOCKED)
            VALUES(p_txmsg.txfields(c_camastid).value,l_codeid,0,0,substr(l_optseacctnocr,0,10),l_qtty,TRUNC( FLOOR(( l_qtty * l_right_rightoffrate) / l_left_rightoffrate),l_ROUNDTYPE ));
        end if;
      end if;
      --end ghi log
    ELSE   --- else DELT
        select count(*) into v_count from cfmast where custodycd=p_txmsg.txfields('09').value;
        IF v_count>0 THEN
        UPDATE   SETRAN set DELTD='Y' WHERE TXNUM=p_txmsg.txnum and txdate=TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT);

        UPDATE SEMAST
         SET
           TRADE = TRADE - (ROUND(p_txmsg.txfields('21').value,0)), LAST_CHANGE = SYSTIMESTAMP
        WHERE ACCTNO=l_optseacctnocr;
        END IF;

         UPDATE CASCHD  SET PBALANCE = PBALANCE - l_qtty ,
                        INBALANCE = INBALANCE - l_qtty ,
                        PQTTY = TRUNC( FLOOR(( (PBALANCE - l_qtty) * l_right_rightoffrate) / l_left_rightoffrate)  ,l_ROUNDTYPE) ,
                        PAAMT= l_exprice* TRUNC(  FLOOR(( ( PBALANCE - l_qtty) * l_right_rightoffrate) / l_left_rightoffrate)  ,l_ROUNDTYPE)
         WHERE AFACCTNO =substr(l_optseacctnocr,0,10) AND camastid = p_txmsg.txfields(c_camastid).value
         AND isreceive='N'
         and  deltd <> 'Y';
        if (p_txmsg.txfields('50').value is not null and LENGTH(l_txkey) > 10) then
            update catransfer set statusre = 'N' where to_char(txdate, 'DDMMRRRR') || txnum = l_txkey;
        end if;


       --- xu ly log phan dien
       if p_txmsg.txfields('78').value = '1' then
            update caschd_log
            set trade = trade - l_qtty,
                ptrade = TRUNC( FLOOR(( (trade + blocked - l_qtty) * l_right_rightoffrate) / l_left_rightoffrate),l_ROUNDTYPE ) - pblocked,
                intrade = intrade - l_qtty
            where camastid=p_txmsg.txfields(c_camastid).value
            and afacctno = substr(l_optseacctnocr,0,10)
            and deltd = 'N';
        else
            update caschd_log
            set blocked = blocked - l_qtty,
                pblocked = TRUNC( FLOOR(( (trade + blocked - l_qtty) * l_right_rightoffrate) / l_left_rightoffrate),l_ROUNDTYPE ) - ptrade,
                inblocked = inblocked - l_qtty
            where camastid=p_txmsg.txfields(c_camastid).value
            and afacctno = substr(l_optseacctnocr,0,10)
            and deltd = 'N';
        end if;
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
         plog.init ('TXPKS_#3385EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3385EX;
/
