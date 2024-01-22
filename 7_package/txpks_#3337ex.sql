SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3337ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3337EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      23/10/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3337ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '01';
   c_notransct        CONSTANT CHAR(2) := '71';
   c_camastid         CONSTANT CHAR(2) := '02';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_optsymbol        CONSTANT CHAR(2) := '24';
   c_custodycd        CONSTANT CHAR(2) := '81';
   c_fullname         CONSTANT CHAR(2) := '08';
   c_iddate           CONSTANT CHAR(2) := '33';
   c_tocustodycd      CONSTANT CHAR(2) := '82';
   c_remoaccount      CONSTANT CHAR(2) := '31';
   c_citad            CONSTANT CHAR(2) := '32';
   c_tomemcus         CONSTANT CHAR(2) := '34';
   c_qtty             CONSTANT CHAR(2) := '10';
   c_exprice          CONSTANT CHAR(2) := '05';
   c_amount           CONSTANT CHAR(2) := '11';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
l_catype VARCHAR2(3);
l_status VARCHAR2(1);
l_count NUMBER(20);
l_trntime NUMBER(20);
l_trnlimit VARCHAR2(3);
l_optseacctnocr varchar2(50);
l_optcodeid varchar2(20);
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
        SELECT catype,status,optcodeid INTO l_catype,l_status,l_optcodeid
        from camast WHERE camastid=replace(p_txmsg.txfields('02').value,'.')
        AND deltd='N';
    --Chi thuc hien voi su kien Stock RightOff
    if(l_catype <> '014') THEN
        p_err_code := '-300019'; -- Pre-defined in DEFERROR table
        plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    -- transfer time
    select TransferTimes ,TRFLIMIT
    INTO l_trntime,l_trnlimit
    from CAMAST WHERE CAMASTID= replace(p_txmsg.txfields('02').value,'.');
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
    AND camastid = replace(p_txmsg.txfields('02').value,'.');
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
l_optcodeid varchar2(20);
l_optseacctnocr varchar2(50);
l_optseacctnodr varchar2(50);
l_sectype  semast.actype%TYPE;
l_custid afmast.custid%TYPE;
l_vsdstocktype varchar2(3);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    if p_txmsg.deltd <> 'Y' then
        update catransfer set STATUS = 'C'
        where autoid = TO_NUMBER(p_txmsg.txfields('01').value);

        l_qtty := to_number(p_txmsg.txfields('10').value);

        select optseacctnodr into l_optseacctnodr  from catransfer where autoid = TO_NUMBER(p_txmsg.txfields('01').value);

        --Giam trade khach hang ban
        UPDATE SEMAST
         SET
           TRADE = TRADE - l_qtty, LAST_CHANGE = SYSTIMESTAMP
        WHERE ACCTNO=l_optseacctnodr;

        select en_txdesc into l_txdesc from tltx where tltxcd='3337';
        INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_optseacctnodr,'0040',l_qtty,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || l_txdesc || '');

        SELECT codeid,excodeid,REPORTDATE,ACTIONDATE,DUEDATE,rightoffrate,to_number(roundtype), exprice,optcodeid
        INTO   l_codeid,l_excodeid,l_REPORTDATE,l_ACTIONDATE,l_duedate,l_RIGHTOFFRATE,l_roundtype,l_exprice,l_optcodeid
        FROM camast WHERE camastid= replace(trim(p_txmsg.txfields('02').value),'.');

        l_left_rightoffrate := to_number( substr(l_rightoffrate,0,instr(l_rightoffrate,'/') - 1));
        l_right_rightoffrate := to_number(substr(l_rightoffrate,instr(l_rightoffrate,'/') + 1,length(l_rightoffrate)));

        select count(*) into v_count from cfmast where custodycd=p_txmsg.txfields('82').value and custatcom='Y';
        IF v_count>0 THEN
            select (afacctno||l_optcodeid) into l_optseacctnocr
            from ddmast where custodycd=p_txmsg.txfields('82').value and isdefault='Y';

          select en_txdesc into l_txdesc from tltx where tltxcd='3337';
          INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),l_optseacctnocr,'0045',l_qtty,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || l_txdesc || '');
          select count(*) into v_count from semast where acctno=l_optseacctnocr;
          if v_count>0 then
              UPDATE SEMAST
                 SET
                   TRADE = TRADE + l_qtty, LAST_CHANGE = SYSTIMESTAMP
                WHERE ACCTNO=l_optseacctnocr;
          else
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
          end if;

            select COUNT(1) INTO l_count from  -- kiem tra xem tk nhan da co caschd tuong ung chua
            caschd where camastid=p_txmsg.txfields('02').value
            and afacctno = substr(l_optseacctnocr,0,10)
            AND isreceive='N';

            if(L_count >0) THEN

               SELECT autoid
                 INTO l_autoid
                 FROM  caschd
                 where camastid=p_txmsg.txfields('02').value
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
             VALUES(l_autoid, p_txmsg.txfields('02').value ,substr(l_optseacctnocr,0,10),l_codeid , ' ' , 0 , 0 , 0 , 0  , 0 , 'V'  ,0 , 0 , 'N' ,
             l_qtty, TRUNC( FLOOR((l_qtty * l_right_rightoffrate) / l_left_rightoffrate)  ,l_ROUNDTYPE)  ,l_EXPRICE * TRUNC(  FLOOR((  l_qtty   * l_right_rightoffrate) / l_left_rightoffrate) , l_ROUNDTYPE),l_qtty,'N');
            END IF;

            update catransfer set statusre = 'Y' where autoid = TO_NUMBER(p_txmsg.txfields('01').value);

            UPDATE setran SET ACCTREF=l_autoid,ref=l_autoid
            WHERE TXNUM=p_txmsg.txnum AND txdate= TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT)
            AND txcd='0045' AND acctno=l_optseacctnocr;

        --ghi log de lam dien
      select COUNT(1) INTO l_count
      from caschd_log
      where camastid=p_txmsg.txfields('02').value
      and afacctno = substr(l_optseacctnocr,0,10)
      AND deltd='N';

      if(L_count >0) THEN
        if p_txmsg.txfields('78').value = '1' then
            update caschd_log
            set trade = trade + l_qtty,
                ptrade = TRUNC( FLOOR(( (trade + blocked + l_qtty) * l_right_rightoffrate) / l_left_rightoffrate),l_ROUNDTYPE ) - pblocked,
                intrade = intrade + l_qtty
            where camastid=p_txmsg.txfields('02').value
            and afacctno = substr(l_optseacctnocr,0,10)
            and deltd = 'N';
        else
            update caschd_log
            set blocked = blocked + l_qtty,
                pblocked = TRUNC( FLOOR(( (trade + blocked + l_qtty) * l_right_rightoffrate) / l_left_rightoffrate),l_ROUNDTYPE ) - ptrade,
                inblocked = inblocked + l_qtty
            where camastid=p_txmsg.txfields('02').value
            and afacctno = substr(l_optseacctnocr,0,10)
            and deltd = 'N';
        end if;
      else
        if p_txmsg.txfields('78').value = '1' then
            insert into CASCHD_LOG(CAMASTID,CODEID,AFACCTNO,TRADE,PTRADE,BLOCKED,PBLOCKED)
            VALUES(p_txmsg.txfields('02').value,l_codeid,substr(l_optseacctnocr,0,10),l_qtty,TRUNC( FLOOR(( l_qtty * l_right_rightoffrate) / l_left_rightoffrate),l_ROUNDTYPE ),0,0);
        else
            insert into CASCHD_LOG(CAMASTID,CODEID,AFACCTNO,TRADE,PTRADE,BLOCKED,PBLOCKED)
            VALUES(p_txmsg.txfields('02').value,l_codeid,0,0,substr(l_optseacctnocr,0,10),l_qtty,TRUNC( FLOOR(( l_qtty * l_right_rightoffrate) / l_left_rightoffrate),l_ROUNDTYPE ));
        end if;
      end if;
      --end ghi log
        END IF;
    else
        update catransfer set STATUS = 'P'
        where autoid = TO_NUMBER(p_txmsg.txfields('01').value);

        select count(*) into v_count from cfmast where custodycd=p_txmsg.txfields('82').value and custatcom='Y';
        select optseacctnocr,optseacctnodr into l_optseacctnocr, l_optseacctnocr  from catransfer where autoid = TO_NUMBER(p_txmsg.txfields('01').value);

        --Giam trade khach hang ban
        UPDATE SEMAST
         SET
           TRADE = TRADE + l_qtty, LAST_CHANGE = SYSTIMESTAMP
        WHERE ACCTNO=l_optseacctnodr;

        IF v_count>0 THEN
            UPDATE   SETRAN set DELTD='Y' WHERE TXNUM=p_txmsg.txnum and txdate=TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT);

            UPDATE SEMAST
             SET
               TRADE = TRADE - (ROUND(p_txmsg.txfields('10').value,0)), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=l_optseacctnocr;
        END IF;

         UPDATE CASCHD  SET PBALANCE = PBALANCE - l_qtty ,
                        INBALANCE = INBALANCE - l_qtty ,
                        PQTTY = TRUNC( FLOOR(( (PBALANCE - l_qtty) * l_right_rightoffrate) / l_left_rightoffrate)  ,l_ROUNDTYPE) ,
                        PAAMT= l_exprice* TRUNC(  FLOOR(( ( PBALANCE - l_qtty) * l_right_rightoffrate) / l_left_rightoffrate)  ,l_ROUNDTYPE)
         WHERE AFACCTNO =substr(l_optseacctnocr,0,10) AND camastid = p_txmsg.txfields('02').value
            AND isreceive='N'
            and  deltd <> 'Y';

        update catransfer set statusre = 'N' where autoid = TO_NUMBER(p_txmsg.txfields('01').value);

        select VSDSTOCKTYPE into l_vsdstocktype
        from CATRANSFER
        where camastid=p_txmsg.txfields('02').value
        and autoid = TO_NUMBER(p_txmsg.txfields('01').value);

       --- xu ly log phan dien
       if p_txmsg.txfields('78').value = '1' then
            update caschd_log
            set trade = trade - l_qtty,
                ptrade = TRUNC( FLOOR(( (trade + blocked - l_qtty) * l_right_rightoffrate) / l_left_rightoffrate),l_ROUNDTYPE ) - pblocked,
                intrade = intrade - l_qtty
            where camastid=p_txmsg.txfields('02').value
            and afacctno = substr(l_optseacctnocr,0,10)
            and deltd = 'N';
        else
            update caschd_log
            set blocked = blocked - l_qtty,
                pblocked = TRUNC( FLOOR(( (trade + blocked - l_qtty) * l_right_rightoffrate) / l_left_rightoffrate),l_ROUNDTYPE ) - ptrade,
                inblocked = inblocked - l_qtty
            where camastid=p_txmsg.txfields('02').value
            and afacctno = substr(l_optseacctnocr,0,10)
            and deltd = 'N';
        end if;
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
         plog.init ('TXPKS_#3337EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3337EX;
/
