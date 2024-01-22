SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3388ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3388EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      20/02/2012     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3388ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '03';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_catype           CONSTANT CHAR(2) := '05';
   c_reportdate       CONSTANT CHAR(2) := '06';
   c_actiondate       CONSTANT CHAR(2) := '07';
   c_rate             CONSTANT CHAR(2) := '10';
   c_status           CONSTANT CHAR(2) := '20';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
l_count NUMBER;
l_status apprules.field%TYPE;
l_catype varchar2(20);
v_status varchar2(10);
v_deltd varchar2(10);
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
    IF p_txmsg.deltd <> 'Y' THEN
        -- check xem co caschd nao van chua dc thuc hien khong
        /*SELECT COUNT(*) INTO l_count
        FROM caschd
        WHERE isexec='Y' AND DELTD='N' AND (( qtty> 0 AND isse='N') OR (amt>0 AND isci='N'))
        AND CAMASTID=p_txmsg.txfields('03').value;
        if(l_count > 0) THEN
        p_err_code := '-300048'; -- Pre-defined in DEFERROR table
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;*/


        --trung.luu: 27-08-2020 SHBVNEX-1465 doi rule3388
        --phan backup
                /*select count(*) into l_count
                from CAMAST
                where --Kiem tran nhung su kien khong thuoc danh sach ben duoi
                camastid not in
                    (select camastid
                        from CAMAST
                        where (catype IN ('010', '015', '016', '027', '024', '021', '011', '017', '020', '014', '023', '033') and INSTR('JB',STATUS) > 0)
                            OR (catype IN ('005', '028', '006') and INSTR('IB',STATUS) > 0)
                            OR (catype IN ('029', '031', '032', '003', '030', '019') and INSTR('AB',STATUS) > 0))
                and CAMASTID = p_txmsg.txfields('03').value;
                */
        --phan backup


        --trung.luu: 27-08-2020 Begin SHBVNEX-1465 doi rule3388

        --'005', '028', '006' -> khi ho?n th?nh x?c nh?n VCA3340/VCA3335
        --'029', '031', '032', '003', '030', '019' khi approved tai 111501
        select count(*) into l_count
        from CAMAST
        where --Kiem tran nhung su kien khong thuoc danh sach ben duoi
        camastid not in
            (select camastid
                from CAMAST
                where (catype IN ('010', '015', '016', '027', '024', '021', '011', '017', '020', '014', '023', '033') and INSTR('JB',STATUS) > 0)
                    OR (catype IN ('005', '028', '006') and INSTR('IBS',STATUS) > 0)
                    OR (catype IN ('029', '031', '032', '003', '030', '019') and INSTR('NBA',STATUS) > 0))
        and CAMASTID = p_txmsg.txfields('03').value;

        --016 status ='G' cho lam gd 3388
        select catype,status into l_catype,v_status from camast where camastid = p_txmsg.txfields('03').value;
        if l_catype= '016' and v_status ='G' then
            l_count:= 0;
        end if;

        --ho?n tat 3375 v? ko c? holding n?o: tat ca c?c event
        begin
            select status into v_status from camast where camastid = p_txmsg.txfields('03').value;
        exception when NO_DATA_FOUND
            then
            v_status := '';
        end;
        if v_status = 'B' then
            select count(*) into l_count from caschd where camastid = p_txmsg.txfields('03').value;
        end if;
        --trung.luu: 27-08-2020 End SHBVNEX-1465 doi rule3388

        --trung.luu: 25-01-2021 SHBVNEX-1952 doi rule 3388 (khong case rieng theo loai sqk)
        select status,deltd into v_status,v_deltd from camast where camastid = p_txmsg.txfields('03').value;
        --IF l_count>0 THEN
        IF v_status in ('C','P') or v_deltd = 'Y'  THEN
            /*SELECT  STATUS INTO l_STATUS
                FROM CAMAST
                WHERE CAMASTID = p_txmsg.txfields('03').value;

            IF NOT INSTR('IJBAGH',l_STATUS) > 0 THEN
                p_err_code := '-300013';
                plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;*/

            p_err_code := '-300013';
            plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
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
l_txmsg               tx.msg_rectype;
l_err_param varchar2(500);
v_strCURRDATE varchar2(20);
v_iscancel    varchar2(1);
v_cidepofeeacr NUMBER(20,4);
v_depofeeamt NUMBER(20,4);
v_countCI number;
v_countSE number;
l_catype VARCHAR2(3);
l_countmail number;
p_batchname varchar2(20);
V_TXDATE DATE;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    --trung.luu: 27-08-2020 SHBVNEX-1465 duyet 3388
    p_batchname:='BATCHFEEAUTO';
    V_TXDATE := getcurrdate;
    IF p_txmsg.deltd <> 'Y' THEN--thunt-06/04/2020: SHBVNEX-748
        
        FOR REC IN (
            select round(sum(chd.amt)+sum(chd.aamt)) amt,sum(chd.aamt) aamt,chd.codeid,sum(chd.balance) qtty,sum(chd.aqtty) aqtty,a.cancelstatus,a.content, a.description
            from camast a, sbsecurities b, caschd chd ,allcode cd, sbsecurities b2
            where nvl(a.tocodeid,a.codeid) = b.codeid and a.status  in ('I','G','H','K')
             and a.deltd<>'Y' and a.camastid = chd.camastid and chd.deltd <> 'Y'
             and cd.cdname ='CATYPE' and cd.cdtype ='CA' and cd.cdval = a.catype
             and b2.codeid=a.codeid and a.catype in ('016','033') and a.camastid=p_txmsg.txfields('03').value
            group by chd.codeid,a.cancelstatus,a.content, a.description
        )LOOP
            l_txmsg.tltxcd := '3341';
            l_txmsg.msgtype := 'T';
            l_txmsg.local   := 'N';
            l_txmsg.tlid    := systemnums.c_system_userid;
            select sys_context('USERENV', 'HOST'),
                 sys_context('USERENV', 'IP_ADDRESS', 15)
            into l_txmsg.wsname, l_txmsg.ipaddress
            from dual;
            l_txmsg.off_line  := 'N';
            l_txmsg.deltd     := txnums.c_deltd_txnormal;
            l_txmsg.txstatus  := txstatusnums.c_txcompleted;
            l_txmsg.msgsts    := '0';
            l_txmsg.ovrsts    := '0';
            l_txmsg.batchname := p_batchname;
            l_txmsg.busdate   := V_TXDATE;
            l_txmsg.txdate    := V_TXDATE;
            l_txmsg.reftxnum  := p_txmsg.txnum;
            select systemnums.c_batch_prefixed ||
                  lpad(seq_batchtxnum.nextval, 8, '0')
            into l_txmsg.txnum
            from dual;
            select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;

            --03  CAMASTID    C
            l_txmsg.txfields ('03').defname   := 'CAMASTID';
            l_txmsg.txfields ('03').TYPE      := 'C';
            l_txmsg.txfields ('03').VALUE     := p_txmsg.txfields('03').value;
            --04  SYMBOL    C
            l_txmsg.txfields ('04').defname   := 'SYMBOL';
            l_txmsg.txfields ('04').TYPE      := 'C';
            l_txmsg.txfields ('04').VALUE     := p_txmsg.txfields('04').value;
            --05  CATYPE      C
            l_txmsg.txfields ('05').defname   := 'CATYPE';
            l_txmsg.txfields ('05').TYPE      := 'C';
            l_txmsg.txfields ('05').VALUE     := p_txmsg.txfields('05').value;
            --06  CODEID    C
            l_txmsg.txfields ('06').defname   := 'CODEID';
            l_txmsg.txfields ('06').TYPE      := 'C';
            l_txmsg.txfields ('06').VALUE     := rec.codeid;
            --07  ACTIONDATE D
            l_txmsg.txfields ('07').defname   := 'ACTIONDATE';
            l_txmsg.txfields ('07').TYPE      := 'D';
            l_txmsg.txfields ('07').VALUE     := p_txmsg.txfields('07').value;
            --08  QTTY N
            l_txmsg.txfields ('08').defname   := 'QTTY';
            l_txmsg.txfields ('08').TYPE      := 'N';
            l_txmsg.txfields ('08').VALUE     := rec.qtty;
            --09  CONVERTED N
            l_txmsg.txfields ('09').defname   := 'CONVERTED';
            l_txmsg.txfields ('09').TYPE      := 'N';
            l_txmsg.txfields ('09').VALUE     := rec.aqtty;
            --10  ISCANCEL    C
            l_txmsg.txfields ('10').defname   := 'ISCANCEL';
            l_txmsg.txfields ('10').TYPE      := 'C';
            l_txmsg.txfields ('10').VALUE     := rec.cancelstatus;
            --12  CASHAMT N
            l_txmsg.txfields ('12').defname   := 'CASHAMT';
            l_txmsg.txfields ('12').TYPE      := 'N';
            l_txmsg.txfields ('12').VALUE     := rec.amt;
            --13  CONTENTS    C
            l_txmsg.txfields ('13').defname   := 'CONTENTS';
            l_txmsg.txfields ('13').TYPE      := 'C';
            l_txmsg.txfields ('13').VALUE     := rec.content;
            --30  DESC    C
            l_txmsg.txfields ('30').defname   := 'DESC';
            l_txmsg.txfields ('30').TYPE      := 'C';
            l_txmsg.txfields ('30').VALUE     := rec.description;
            --71  SYMBOL_ORG      C
            l_txmsg.txfields ('71').defname   := 'SYMBOL_ORG';
            l_txmsg.txfields ('71').TYPE      := 'N';
            l_txmsg.txfields ('71').VALUE     := '';

            
            BEGIN
                IF txpks_#3341.fn_AutoTxProcess (l_txmsg,
                                                 p_err_code,
                                                 l_err_param
                   ) <> systemnums.c_success
                THEN
                   plog.error (pkgctx,
                               'got error 3341: ' || p_err_code
                   );
                   ROLLBACK;
                   RETURN -1;
                END IF;
            END;
        END LOOP;
        --trung.luu: 11-09-2020 chuyen tu txpks_#3388.autoupdate ve day
        INSERT INTO CATRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
        VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('03').value,'0001',0,'C','',p_txmsg.deltd,'',seq_CATRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

        UPDATE CAMAST
        SET PSTATUS=PSTATUS||STATUS,STATUS='C', LAST_CHANGE = SYSTIMESTAMP
        WHERE CAMASTID=p_txmsg.txfields('03').value;

        UPDATE CASCHD SET PSTATUS = PSTATUS||STATUS, STATUS = 'C'
        WHERE CAMASTID=p_txmsg.txfields('03').value
        AND status <> 'O';
    ELSE
        UPDATE CATRAN
        SET DELTD = 'Y'
        WHERE TXNUM = p_txmsg.txnum
        AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);

        UPDATE CAMAST
        SET PSTATUS = PSTATUS||STATUS, STATUS = SUBSTR(PSTATUS,LENGTH(PSTATUS),1), LAST_CHANGE = SYSTIMESTAMP
        WHERE CAMASTID=p_txmsg.txfields('03').value;

        UPDATE CASCHD SET STATUS = SUBSTR(PSTATUS,LENGTH(PSTATUS),1), PSTATUS=PSTATUS||'C'    --27/11/2017 DieuNDA Lay trang thai truoc do thay vao Status
        WHERE CAMASTID=p_txmsg.txfields('03').value AND status <> 'O';

        FOR REC IN
        (
            SELECT * FROM TLLOG WHERE REFTXNUM = P_TXMSG.TXNUM  AND TLTXCD IN ('3341') AND DELTD = 'N'
        )
        LOOP
            IF TXPKS_#3341.FN_TXREVERT(REC.TXNUM,TO_CHAR(REC.TXDATE,'DD/MM/RRRR'),P_ERR_CODE,L_ERR_PARAM) <> 0 THEN
                PLOG.ERROR(PKGCTX, 'LOI KHI THUC HIEN XOA GIAO DICH 3341');
                PLOG.SETENDSECTION(PKGCTX, 'FN_TXAFTAPPUPDATE');
                RETURN ERRNUMS.C_SYSTEM_ERROR;
            END IF;
        END LOOP;
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
         plog.init ('TXPKS_#3388EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3388EX;
/
