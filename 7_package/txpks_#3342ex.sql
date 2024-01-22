SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3342ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3342EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      11/10/2011     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3342ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '03';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_catype           CONSTANT CHAR(2) := '05';
   c_actiondate       CONSTANT CHAR(2) := '07';
   c_contents         CONSTANT CHAR(2) := '13';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
l_status varchar2(1);
l_catype varchar2(4);
l_count number;
l_afacctno varchar2(50);
l_count2 number;
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
/*    -- thunt
    if(p_txmsg.deltd = 'Y') THEN
    -- lay ra so du hien tai

        SELECT balance INTO l_balance
        FROM ddmast WHERE acctno=p_txmsg.txfields('23').value;

        IF l_balance < (ROUND((p_txmsg.txfields('10').value-p_txmsg.txfields('13').value)*p_txmsg.txfields('60').value,0))
                       +(ROUND(p_txmsg.txfields('13').value*p_txmsg.txfields('60').value,0))
                       -(ROUND(p_txmsg.txfields('20').value*p_txmsg.txfields('60').value,0))
        THEN
              p_err_code := '-300052'; -- Pre-defined in DEFERROR table
              plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
              RETURN errnums.C_BIZ_RULE_INVALID;
        ELSE
            UPDATE DDMAST SET BALANCE = l_balance - (ROUND((p_txmsg.txfields('10').value-p_txmsg.txfields('13').value)*p_txmsg.txfields('60').value,0))
                       +(ROUND(p_txmsg.txfields('13').value*p_txmsg.txfields('60').value,0))
                       -(ROUND(p_txmsg.txfields('20').value*p_txmsg.txfields('60').value,0))
            WHERE AFACCTNO=p_txmsg.txfields('23').value;
        END IF;

    END IF; */
        --Ngay 10/02/2020 NamTv check them tai khoan chua khai bao tieu khoan tien
    begin
        select count(*) into l_count
        from caschd
        where camastid= trim(p_txmsg.txfields('03').value)
        and deltd<>'Y'
        and afacctno not in (select afacctno from ddmast where  status <> 'C');
        IF ( l_count > 0 ) THEN
            p_err_code := '-330004';
            plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

        FOR REC IN (
            SELECT DD.AFACCTNO L_DDMAST
            FROM CASCHD CAS,
            (
                SELECT AFACCTNO FROM DDMAST WHERE ISDEFAULT='Y' AND STATUS <> 'C'
            ) DD
            WHERE CAS.AFACCTNO = DD.AFACCTNO(+)
            AND CAS.DELTD <> 'Y'
            AND CAS.CAMASTID = P_TXMSG.TXFIELDS('03').VALUE
        )LOOP
            IF REC.L_DDMAST IS NULL THEN
                P_ERR_CODE := '-330004';
                PLOG.SETENDSECTION (PKGCTX, 'FN_TXAPPAUTOCHECK');
                RETURN ERRNUMS.C_BIZ_RULE_INVALID;
            END IF;
        END LOOP;

    exception
      when others then
        p_err_code := '-330004';
        RETURN errnums.C_BIZ_RULE_INVALID;
    end;
        --Ngay 10/02/2020 NamTv End
    --thunt:18/02/2020: do not active double transactions
    IF NOT(INSTR('GJC',l_STATUS) > 0) THEN
        p_err_code := '-300013';
        plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
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
    l_err_param varchar2(500);
    v_countCI number;
    v_countSE number;
    l_catype VARCHAR2(3);
    l_codeid VARCHAR2(6);
    v_status varchar2(1);
    v_execreate number;
    l_Count Number;
    l_execrate  number;
    l_data_source clob;
    l_email varchar2(100);
    l_desc varchar2(1000);
    l_countmail number;
    l_caschdId varchar2(100);
    l_custid varchar2(100);
    l_afacctno varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    SELECT ca.catype, ca.codeid, ca.status, ca.exerate
    INTO l_Catype , l_codeid, v_status, v_execreate  from camast ca
    WHERE camastid = p_txmsg.txfields('03').value;
    if p_txmsg.deltd<>'Y' then
        cspks_caproc.pr_3350_Exec_Money_CA(p_txmsg,p_err_code);
        if p_err_code <> systemnums.C_SUCCESS THEN
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
        if p_err_code <> systemnums.C_SUCCESS then
            plog.setendsection(pkgctx, 'pr_SAAfterBatch');
            return errnums.C_BIZ_RULE_INVALID;
        end if;
        --Kiem tra neu lam xong thi chuyen trang thai cua su kien quyen
        SELECT count(1) into v_countCI
        FROM CASCHD
        WHERE CAMASTID=p_txmsg.txfields('03').value
              AND DELTD ='N' AND amt> 0 AND ISCI='N' AND isexec='Y';
        -- kiem tra xem co tai khoan nao chua dc phan bo CK khong
        SELECT count(1) into v_countSE
        FROM CASCHD
        WHERE CAMASTID=p_txmsg.txfields('03').value  AND DELTD ='N'
              AND (qtty> 0 or L_CATYPE in ('016','027')) AND ISSE='N' AND isexec='Y';
        -- update trang thai trong CAMAST
        if(v_countCI = 0 AND v_countSE = 0) THEN
            /*
            UPDATE CAMAST SET STATUS ='J', PSTATUS = PSTATUS || STATUS
            WHERE CAMASTID=p_txmsg.txfields('03').value;
            */
            -- Da phan bo tien, chung khoan & huy chung khoan cu => J,
            -- Da phan bo tien, chung khoan nhung chua huy chung khoan cu => G,
            UPDATE CAMAST SET STATUS = (case when instr(cspks_caproc.c_convert_catype,l_catype) > 0 and cancelstatus ='Y' then 'J'
                                             when instr(cspks_caproc.c_convert_catype,l_catype) > 0 and cancelstatus ='N' then 'G'
                                            else 'J' end)
            WHERE CAMASTID=p_txmsg.txfields('03').value;
        Elsif (v_countCI= 0 AND v_countSE > 0) THEN
            UPDATE CAMAST SET STATUS ='G', PSTATUS = PSTATUS || STATUS
            WHERE CAMASTID=p_txmsg.txfields('03').value;
        End if;
         --30/05/2015 TruongLD Comment
         -- PHS da xu ly cho phep thuc hien nhieu lan --> chinh lai doan nay
        ---DungNh cap nhat trang thai cua su kien co tuc bang tien them trang thai phan bo 1 phan.
        if(L_CATYPE = '010') then
            if(v_status = 'K' or v_execreate = 100) then
                UPDATE CAMAST SET STATUS = 'J'
                WHERE CAMASTID = p_txmsg.txfields('03').value;
            else
                UPDATE CAMAST SET STATUS = 'K'
                WHERE CAMASTID = p_txmsg.txfields('03').value;
            end if;
        end if;
        ---- end DungNH*/
        if(l_catype = '010') then
            Begin
                Select Nvl(Sum(execrate),0) into l_execrate from camastdtl where deltd <> 'Y' and camastid=p_txmsg.txfields('03').value;
            EXCEPTION
                WHEN OTHERS
                   THEN l_execrate := 0;
            End;
            If nvl(l_execrate,0) = 100 Then -- Da phan bo het
               UPDATE CAMAST SET STATUS = 'J', PSTATUS = PSTATUS || STATUS
                    WHERE CAMASTID = p_txmsg.txfields('03').value;
            Else  --> Chua phan bo het
               UPDATE CAMAST SET STATUS = 'K', PSTATUS = PSTATUS || STATUS
                    WHERE CAMASTID = p_txmsg.txfields('03').value;
            End If;
            UPDATE CAMASTDTL SET STATUS ='C' WHERE CAMASTID = P_TXMSG.TXFIELDS('03').VALUE AND STATUS ='P';
        End If;
        --End TruongLD
        -- NEU LA TRA GOC LAI TRAI PHIEU: UPDATE SEMAST CUA CAC TK SE ko duoc phan bo = 0
        IF(L_CATYPE ='016') THEN
            FOR rec IN (SELECT se.acctno,se.trade
                        FROM semast se
                        WHERE codeid= l_codeid AND trade >0
                              AND afacctno NOT IN (SELECT afacctno from caschd WHERE deltd='N' AND camastid=p_txmsg.txfields('03').value)
                       )
            LOOP
                 INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                 VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.acctno,'0011',rec.trade,NULL,p_txmsg.txfields ('03').value,p_txmsg.deltd,NULL,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
                 UPDATE semast SET trade=0 WHERE acctno=rec.acctno;
            END LOOP;

        END IF;
        nmpks_ems.pr_GenTemplateE282 (p_camastId => p_txmsg.txfields(c_camastid).value,
                                 p_txdate => p_txmsg.txdate);
                --Send mail
                -- ThoaiTran 12/09/2019

        -----------------------------------SEND MAIL---------------------------------------------
        select count(*) into l_countmail
        from camast ca,caschd cas
            where ca.camastid=cas.camastid and ca.camastid like p_txmsg.txfields('03').value and ca.catype in ('021','010','015','027','023','011','020','017','016','024');
        if l_countmail <> 0
            then
                sendmailall(p_txmsg.txfields('03').value,'3342');
        end if;

        for rec in(
            --select af.custid,sch.afacctno  from camast ca, CASCHD_LIST sch, afmast af
            select af.custid,sch.afacctno, sch.autoid , sch.amt from camast ca, CASCHD sch, afmast af
            where ca.camastid=sch.camastid
            and sch.afacctno=af.acctno
            --and sch.ISRECEIVE = 'N'
            --and ((sch.isreceive = 'N' AND sch.actiontype = 'N') OR sch.actiontype = 'U')
            AND SCH.DELTD <> 'Y'
            and ca.camastid = p_txmsg.txfields('03').value
        ) loop
            nmpks_ems.pr_GenTemplateUnlistedCAExec(p_camastId => p_txmsg.txfields('03').value,
                                                p_caschdId => rec.autoid,
                                                p_date     => p_txmsg.txdate,
                                                p_custId   => rec.custid,
                                                p_acctno   => rec.afacctno,
                                                p_taxamt   => p_txmsg.txfields('10').value,
                                                p_amt      =>  rec.amt,
                                                p_isTax    => 'Y',
                                                p_desc     => p_txmsg.txfields('30').value,
                                                p_txmsg    => p_txmsg);

        END LOOP;
        -------------------------------------revert info---------------------------------------------------
    ELSE
        for rec in
        (
            select * from tllog where msgacct = p_txmsg.txfields('03').value and tltxcd in ('3350', '3354') and deltd = 'N'
        )
        loop
            if rec.tltxcd = '3350' then
                if txpks_#3350.fn_txrevert(rec.txnum,to_char(rec.txdate,'dd/mm/rrrr'),p_err_code,l_err_param) <> 0 then
                    plog.error (pkgctx, 'Loi khi thuc hien xoa giao dich');
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    return errnums.C_SYSTEM_ERROR;
                end if;
            ELSIF rec.tltxcd = '3354' then
                if txpks_#3354.fn_txrevert(rec.txnum,to_char(rec.txdate,'dd/mm/rrrr'),p_err_code,l_err_param) <> 0 then
                    plog.error (pkgctx, 'Loi khi thuc hien xoa giao dich');
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    return errnums.C_SYSTEM_ERROR;
                end if;
            end if ;
        end loop;
        SELECT count(1) into v_countCI FROM CASCHD
        WHERE CAMASTID = p_txmsg.txfields('03').value
              AND DELTD ='N' AND ISCI='N' AND isexec='Y';
        -- kiem tra xem co tai khoan nao chua dc phan bo CK khong
        SELECT count(1) into v_countSE FROM CASCHD
        WHERE CAMASTID=p_txmsg.txfields('03').value  AND DELTD ='N'
              AND  ISSE='N' AND isexec='Y';
         -- update trang thai trong CAMAST
         if(v_countCI > 0 AND v_countSE > 0) THEN
             UPDATE CAMAST SET STATUS ='I', PSTATUS = PSTATUS || STATUS
             WHERE CAMASTID=p_txmsg.txfields('03').value;
         ELSIF (v_countCI> 0 AND v_countSE = 0) THEN
             UPDATE CAMAST SET STATUS ='H', PSTATUS = PSTATUS || STATUS
             WHERE CAMASTID=p_txmsg.txfields('03').value;
         ELSIF (v_countCI= 0 AND v_countSE > 0) THEN
             UPDATE CAMAST SET STATUS ='G', PSTATUS = PSTATUS || STATUS
             WHERE CAMASTID=p_txmsg.txfields('03').value;
         END IF;
         ---- end DungNH*/
         if(l_catype = '010') then
            --SHBVNEX-1436 16-09-2020
            UPDATE CAMAST SET STATUS = 'I', PSTATUS = PSTATUS || STATUS WHERE CAMASTID = p_txmsg.txfields('03').value;
            UPDATE CAMASTDTL SET STATUS ='P' WHERE CAMASTID = P_TXMSG.TXFIELDS('03').VALUE AND STATUS ='C';
         End If;
         --End TruongLD
         -- revert lai doi voi cac TK ko duoc chia co tuc cua su kien tra goc lai trai phieu
         IF(l_catype ='016') THEN
             -- xoa trong setran
             UPDATE SETRAN        SET DELTD = 'Y'
             WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
         END IF;
         --xoa tllog
/*            UPDATE TLLOG SET DELTD = 'Y'
            WHERE REFTXNUM =P_TXMSG.TXNUM;*/
    end if;

    /*nmpks_ems.pr_GenTemplateEM24(p_codeid => l_codeid,
                                     p_custid   => '0001000014',
                                     p_acctno => '0001000014',
                                     p_qtty   => p_txmsg.txfields('08').value,
                                     p_buyQtty => p_txmsg.txfields('08').value,
                                     p_buyAmt   => p_txmsg.txfields('08').value,
                                     p_interestAmt => p_txmsg.txfields('08').value,
                                     p_settleDate   => '01/July/2032',
                                     p_desc => p_txmsg.txfields('30').value); */




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
         plog.init ('TXPKS_#3342EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3342EX;
/
