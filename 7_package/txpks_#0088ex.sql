SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#0088ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0088EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      16/09/2011     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#0088ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_acctno           CONSTANT CHAR(2) := '02';
   c_setacctno        CONSTANT CHAR(2) := '03';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_name             CONSTANT CHAR(2) := '31';
   c_idcode           CONSTANT CHAR(2) := '32';
   c_balance          CONSTANT CHAR(2) := '10';
   c_crintacr         CONSTANT CHAR(2) := '04';
   c_odamt            CONSTANT CHAR(2) := '06';
   c_odintacr         CONSTANT CHAR(2) := '05';
   c_ciwithdrawal     CONSTANT CHAR(2) := '07';
   c_blocked          CONSTANT CHAR(2) := '08';
   c_withdraw         CONSTANT CHAR(2) := '09';
   c_deposit          CONSTANT CHAR(2) := '11';
   c_mrcrlimitmax     CONSTANT CHAR(2) := '12';
   c_mrcrlimit        CONSTANT CHAR(2) := '13';
   c_t0amt            CONSTANT CHAR(2) := '14';
   c_ca_qtty          CONSTANT CHAR(2) := '15';
   c_groupleader      CONSTANT CHAR(2) := '16';
   c_cidepofeeacr     CONSTANT CHAR(2) := '66';
   c_datefeeac        CONSTANT CHAR(2) := '18';
   c_cidatefeeacr     CONSTANT CHAR(2) := '17';
   c_chk_qtty         CONSTANT CHAR(2) := '67';
   c_trfee            CONSTANT CHAR(2) := '68';
   c_desc             CONSTANT CHAR(2) := '30';
   c_closetype        CONSTANT CHAR(2) := '80';
   c_desttype         CONSTANT CHAR(2) := '81';

FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_number number;
v_aamt number;
v_ramt number;
v_bamt number;
v_namt number;
v_EMKAMT number;
v_MMARGINBAL number;
v_MARGINBAL number;
v_autoadv VARCHAR2(2);

v_mortage number;
v_margin number;
v_netting number;
v_stading number;
v_secured number;
v_receiving number;
v_withdraw number;
v_senddeposit number;
v_deposit number;
v_loan number;
v_blocked number;
v_repo number;
v_pending number;
v_transfer number;

v_sumse number;
v_sumci number;
v_count number;
v_mrcount number;
v_mrtype varchar2(10);
v_mrstatus VARCHAR2(10);
v_odamt    number;
v_afcount number;
v_limitmax number;
v_afcountT0 number;
v_afcountT1 number;
v_accnum  number;
--
V_OUTSTANDING NUMBER;
V_MRCRLIMITMAX NUMBER;
V_MRCRLIMIT NUMBER;
v_T0AMT NUMBER;
v_CHK_QTTY NUMBER;
V_STANDING NUMBER;
v_DF_QTTY NUMBER;
v_depofeeamt NUMBER ;
v_cidepofeeacr NUMBER ;
    l_leader_license varchar2(100);
    l_leader_idexpired date;
    l_idexpdays apprules.field%TYPE;
    l_afmastcheck_arr txpks_check.afmastcheck_arrtype;

    l_count number;
    l_txmsg               tx.msg_rectype;
    l_CURRDATE date;
    l_Desc varchar2(1000);
    l_EN_Desc varchar2(1000);
    l_OrgDesc varchar2(1000);
    l_EN_OrgDesc varchar2(1000);
    l_err_param varchar2(300);
    v_AccTemp varchar2(10);


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
    --- check con su kien chua phan bo thi canh bao.
    IF (p_txmsg.txfields('80').value = '001')THEN
        SELECT COUNT(1) INTO l_count
        FROM caschd ca, afmast af, cfmast cf
        WHERE ca.deltd = 'N' AND ca.isexec = 'Y'
            AND ((ca.isse = 'N' AND ca.qtty>0)or(ca.isci = 'N' AND ca.amt > 0))
            and ca.afacctno = af.acctno and cf.custid = af.custid
            and cf.custodycd = p_txmsg.txfields('88').value;
    ELSE
        SELECT COUNT(1) INTO l_count
        FROM caschd ca, afmast af, cfmast cf
        WHERE ca.deltd = 'N' AND ca.isexec = 'Y'
            AND ((ca.isse = 'N' AND ca.qtty>0)or(ca.isci = 'N' AND ca.amt > 0))
            and ca.afacctno = af.acctno and cf.custid = af.custid
            and ca.afacctno = p_txmsg.txfields('03').value;
    END IF;

    if l_count >= 1 then
        p_txmsg.txWarningException('-2004141').value:= cspks_system.fn_get_errmsg('-200414');
        p_txmsg.txWarningException('-2004141').errlev:= '1';
    end if;

    for rec in
    (
        select af.acctno, af.status--, ci.odamt--, ci.ODINTACR
        from afmast af, cfmast cf, ddmast ci
        where af.custid = cf.custid and af.acctno = ci.acctno and cf.custodycd = p_txmsg.txfields('88').value and af.status not in ('N','C')
        and (p_txmsg.txfields('80').value = '001' or (p_txmsg.txfields('80').value = '002' and p_txmsg.txfields('03').value = af.acctno))
    )
    loop
        if rec.status <> 'A' then
            p_err_code := '-200010'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;


    end loop;

    -- Neu co Can chuyen CK la Y, bat buoc nhap ma thanh vien chuyen di va so tai khoan luu ky chuyen di.
    if(p_txmsg.txfields('45').value ='Y') THEN
         if((LENGTH(nvl(p_txmsg.txfields('48').value,'X'))<3) or(LENGTH(nvl(p_txmsg.txfields('47').value,'X'))<10)) THEN
          p_err_code:='-260163';
          plog.setendsection (pkgctx, 'fn_txPreAppCheck');
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
---Gent bang ke thu phi luu ky
---TuanNH add

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
    v_mrcount VARCHAR2(10);
    v_rightname_h varchar2(100);
    l_txdesc varchar2(500);
    v_blnREVERSAL boolean;
    v_strOBJTYPE    varchar2(100);
    v_strTRFCODE    varchar2(100);
    v_strBANK    varchar2(200);
    v_strAMTEXP    varchar2(200);
    v_strAFACCTNO    varchar2(100);
    v_strREFCODE    varchar2(100);
    v_strBANKACCT    varchar2(100);
    v_strFLDAFFECTDATE    varchar2(100);
    v_strAFFECTDATE    varchar2(100);
    v_strNOTES    varchar2(1000);
    v_strVALUE     varchar2(1000);
    v_strStatus char(1);
    v_strCOREBANK    char(1);
    v_strafbankname varchar(100);
    v_strafbankacctno    varchar2(100);
    V_BALANCE           NUMBER;
    l_CURRDATE date;
    v_macctno varchar2(250);
    v_dblNumDATE NUMBER(10);
    v_feeacr NUMBER(20,4);

BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    if(p_txmsg.txfields('18').value > 0) THEN
        v_dblNumDATE:=to_number(p_txmsg.txfields('18').value);
        for rec_af in
        (
            select af.acctno,cf.custodycd
            from cfmast cf, afmast af
            where cf.custid = af.custid
                and instr((select fn_get_custodycd_fr_motherfund(p_txmsg.txfields('88').value) from dual),cf.custodycd) >0 --trung.luu: 22-02-2021 loop theo tai khoan con cua 88
                and af.status not in ('C','N')
                and case when p_txmsg.txfields('80').value = '001' then 1
                when p_txmsg.txfields('80').value <> '001' and af.acctno = p_txmsg.txfields('03').value then 1
                else 0 end = 1

        )
        loop
            
            FOR rec IN
            (
                SELECT se.acctno,se.TBALDT,
                    (se.trade + se.margin + se.mortage + se.blocked + se.secured + se.repo + se.netting + se.dtoclose + se.withdraw) qtty
                FROM semast se WHERE se.afacctno=rec_af.acctno
            )
            LOOP
                BEGIN
                    SELECT round(FEEACR,4)
                        INTO v_feeacr
                    FROM (
                        SELECT A2.AFACCTNO,
                            DECODE(A2.FORP,'P',A2.FEEAMT/100,A2.FEEAMT)*A2.SEBAL*v_dblNumDATE/(A2.LOTDAY*A2.LOTVAL) FEEACR
                        FROM (SELECT T.ACCTNO, MIN(T.ODRNUM) RFNUM FROM VW_SEMAST_VSDDEP_FEETERM T GROUP BY T.ACCTNO) A1,
                        VW_SEMAST_VSDDEP_FEETERM A2
                    WHERE A1.ACCTNO=A2.ACCTNO AND A1.RFNUM=A2.ODRNUM
                    AND a2.ACCTNO=rec.acctno ) T2;

                EXCEPTION WHEN OTHERS THEN
                    v_feeacr:=0;
                END;

                INSERT INTO SEDEPOBAL (AUTOID, ACCTNO, TXDATE, DAYS, QTTY, DELTD,AMT,ID)
                VALUES (SEQ_SEDEPOBAL.NEXTVAL, rec.ACCTNO, rec.TBALDT,p_txmsg.txfields('18').value, rec.qtty, 'N',v_feeacr,p_txmsg.txdate||p_txmsg.txnum);

            END LOOP;

        end loop;
    END IF;


    SELECT TO_DATE (varvalue, systemnums.c_date_format)
    INTO l_CURRDATE
    FROM sysvar
    WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';


    -- Gen bang ke 01 TRFSECLSFEE.
       v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;

       if not v_blnREVERSAL then
           v_strAFACCTNO:=p_txmsg.txfields('03').value;
           --Kiem tra neu la TK corebank thi tiep tuc
           select corebank,bankname,bankacctno into v_strCOREBANK, v_strafbankname, v_strafbankacctno from afmast where acctno =  v_strAFACCTNO;
               --locpt: gom ham check corebank ve 1 cho de tien cho viec chinh sua
             v_strCOREBANK := fn_GET_COREBANK(v_strAFACCTNO);


    end if;

    --End gent bang ke
    -- Gen bang ke 02 TRFSEFEE.
       v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;

       if not v_blnREVERSAL then
           v_strAFACCTNO:=p_txmsg.txfields('03').value;
           --Kiem tra neu la TK corebank thi tiep tuc
           select corebank,bankname,bankacctno into v_strCOREBANK, v_strafbankname, v_strafbankacctno from afmast where acctno =  v_strAFACCTNO;
           --locpt: gom ham check corebank ve 1 cho de tien cho viec chinh sua
           v_strCOREBANK := fn_GET_COREBANK(v_strAFACCTNO);

           if v_strCOREBANK ='Y' then

               --Begin Gen yeu cau sang ngan hang 0088-TRFNML
               v_strOBJTYPE:='T';
               v_strTRFCODE:='TRFSEFEE';
               v_strREFCODE:= to_char(p_txmsg.txdate,'DD/MM/RRRR') || p_txmsg.txnum;
               v_strAFFECTDATE:= to_char(p_txmsg.txdate,'DD/MM/RRRR');
               v_strBANK:=v_strafbankname;
               v_strBANKACCT:=v_strafbankacctno;
               v_strNOTES:=p_txmsg.txfields('30').value;
               v_strVALUE:=p_txmsg.txfields('17').value;

           else

               begin
                   SELECT STATUS into v_strStatus FROM CRBTXREQ MST WHERE MST.OBJNAME=p_txmsg.tltxcd AND MST.OBJKEY=p_txmsg.txnum AND MST.TXDATE=TO_DATE(p_txmsg.txdate, 'DD/MM/RRRR');
                   if  v_strStatus = 'P' then
                       update CRBTXREQ set status ='D' WHERE OBJNAME=p_txmsg.tltxcd AND OBJKEY=p_txmsg.txnum AND TXDATE=TO_DATE(p_txmsg.txdate, 'DD/MM/RRRR');
                       update ddmast
                        set HOLDBALANCE = HOLDBALANCE + ROUND(p_txmsg.txfields('17').value,0)
                        where acctno = p_txmsg.txfields('03').value;
                   else
                       plog.setendsection (pkgctx, 'fn_txAppUpdate');
                       p_err_code:=-670101;--Trang thai bang ke khong hop le
                       Return errnums.C_BIZ_RULE_INVALID;
                   end if;
               exception when others then
                   null; --Khong co bang ke can xoa
               end;
           End if;
    end if;

    l_txdesc:= 'Thu phi luu ky dong tai khoan';
    INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
        VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields('03').value,'0003',ROUND(p_txmsg.txfields('17').value,0),NULL,'',p_txmsg.deltd,'',seq_CITRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || l_txdesc || '');

     -- Log SENDSETOCLOSE neu can chuyen chung khoan ra ngoai
    if(p_txmsg.txfields('45').value ='Y') THEN
        for r in (select *from cfmast where custodycd IN (SELECT custodycd_org FROM vw_cfmast_m WHERE custodycd = p_txmsg.txfields('88').value or custodycd_org = p_txmsg.txfields('88').value))
        loop
            UPDATE SENDSETOCLOSE SET deltd='Y' WHERE  CUSTID=R.CUSTID;

            INSERT INTO SENDSETOCLOSE (AUTOID,CUSTID,REFCUSTODYCD,REFINWARD,DELTD,txnum,txdate,desttype)
            VALUES(seq_SENDSETOCLOSE.nextval,R.CUSTID, p_txmsg.txfields('47').value ,p_txmsg.txfields('48').value ,'N',p_txmsg.txnum,to_DAte(p_txmsg.txdate,'DD/MM/RRRR'),p_txmsg.txfields('81').value);

        end loop;
    END IF;

    for rec_af in
    (
        select af.acctno, cf.custid, cf.custodycd
        from cfmast cf, afmast af--, ddmast ci
        where cf.custid = af.custid --and af.acctno = ci.afacctno (+)
        and cf.custodycd IN (SELECT custodycd_org FROM vw_cfmast_m WHERE custodycd = p_txmsg.txfields('88').value or custodycd_org = p_txmsg.txfields('88').value)
            and af.status not in ('C','N')
            and case when p_txmsg.txfields('80').value = '001' then 1
                    when p_txmsg.txfields('80').value <> '001' and af.acctno = p_txmsg.txfields('03').value then 1
                    else 0 end = 1
    )
    loop
        
        -- Gen bang ke in Loop
       v_blnREVERSAL:=case when p_txmsg.deltd ='Y' then true else false end;
       if not v_blnREVERSAL then
           v_strAFACCTNO:=rec_af.acctno;
           --Kiem tra neu la TK corebank thi tiep tuc
           select corebank,bankname,bankacctno into v_strCOREBANK, v_strafbankname, v_strafbankacctno from afmast where acctno = rec_af.acctno;
                --locpt: gom ham check corebank ve 1 cho de tien cho viec chinh sua
           v_strCOREBANK := fn_GET_COREBANK(v_strAFACCTNO);

           if v_strCOREBANK ='Y' then
               --Begin Gen yeu cau sang ngan hang 0088-TRFNML
               v_strOBJTYPE:='T';
               v_strTRFCODE:='TRFSEFEE';
               v_strREFCODE:= to_char(p_txmsg.txdate,'DD/MM/RRRR') || p_txmsg.txnum;
               v_strAFFECTDATE:= to_char(p_txmsg.txdate,'DD/MM/RRRR');
               v_strBANK:=v_strafbankname;
               v_strBANKACCT:=v_strafbankacctno;
               v_strNOTES:=p_txmsg.txfields('30').value;

           end if;
       End if;

        --28/09/2015 DieuNDA: Neu chon Huy tra ve trang thai tieu khoan luc ban dau
        IF p_txmsg.deltd <> 'Y' THEN
            INSERT INTO AFTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec_af.acctno,'0001',0,'N','',p_txmsg.deltd,'',seq_AFTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            UPDATE DDMAST SET
                PSTATUS=PSTATUS||STATUS, STATUS='N',
                LASTCHANGE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=rec_af.acctno;

            UPDATE AFMAST SET
               PSTATUS=PSTATUS||STATUS,STATUS='N',
               LASTDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=rec_af.acctno;

            UPDATE cifeeschd SET paidamt = nmlamt, paidtxnum= p_txmsg.txnum, paidtxdate=p_txmsg.busdate
            WHERE afacctno = rec_af.acctno;

            V_BALANCE := NVL(V_BALANCE,0);

            INSERT INTO CF0080_LOG (CUSTODYCD, AFACCTNO, TXDATE, TXNUM, TLTXCD, BRID, BRNAME, FULLNAME, IDCODE, IDDATE, IDPLACE, ADDRESS,
                    PHONE, MOBILE, SYMBOL, TRADEPLACE, TRADE, BLOCKED, TRADE_WFT, BLOCKED_WFT, ISCLOSED, balance )
            SELECT  rec_af.custodycd, rec_af.acctno, to_DAte(p_txmsg.txdate,'DD/MM/RRRR'),p_txmsg.txnum, p_txmsg.tltxcd,
                 BRID,BRNAME, main.fullname, main.idcode, main.iddate, main.idplace, main.address, main.phone, main.mobile,
                  main.wft_symbol symbol, tradeplace,
                sum(CASE WHEN instr(symbol,'_WFT') = 0 THEN nvl(trade,0) + NVL(B.BUYQTTY,0)- nvl(b.SELLQTTY,0) ELSE 0 END) trade,
                 sum(CASE WHEN instr(symbol,'_WFT') = 0 THEN blocked ELSE 0 END) blocked,
                 sum(CASE WHEN instr(symbol,'_WFT') <> 0 THEN nvl(trade,0) + NVL(B.BUYQTTY,0)- nvl(b.SELLQTTY,0) ELSE 0 END) trade_WFT,
                 sum(CASE WHEN instr(symbol,'_WFT') <> 0 THEN blocked ELSE 0 END) blocked_WFT,
                 CASE WHEN 0 >0 THEN 'N' ELSE 'Y' END ISCLOSED, V_BALANCE
            FROM (SELECT BR.BRID, BRNAME,cf.fullname, DECODE(SUBSTR(CF.CUSTODYCD,4,1),'F',CF.TRADINGCODE,CF.IDCODE) idcode,
                                   DECODE(SUBSTR(CF.CUSTODYCD,4,1),'F',CF.TRADINGCODEDT,CF.IDDATE) iddate,
                                 cf.idplace, cf.address, CF.phone, cf.mobile,cf.custodycd,
                      nvl(sb.symbol,'') symbol, nvl(sb_wft.symbol,'') wft_symbol,
                             nvl(sb_wft.sectype,'') sectype, nvl(sb_wft.issuerid,'') issuerid ,
                             --nvl(sb_wft.tradeplace,'') tradeplace,
                             nvl(se.trade,0) - sum(CASE WHEN tran.field = 'TRADE' AND tran.txcd = 'D' THEN - nvl(tran.namt,0)
                                              WHEN tran.field = 'TRADE' AND tran.txcd = 'C' THEN nvl(tran.namt,0)
                                              ELSE 0 END) trade,
                             nvl(se.blocked,0) - sum(CASE WHEN tran.field = 'BLOCKED' AND tran.txcd = 'D' THEN - nvl(tran.namt,0)
                                                  WHEN tran.field = 'BLOCKED' AND tran.txcd = 'C' THEN nvl(tran.namt,0)
                                                  ELSE 0 END) blocked,
                             SE.receiving,
                           CASE --WHEN sb.markettype = '001' AND sb.sectype IN ('003','006','222','333','444') THEN utf8nums.c_const_df_marketname
                              WHEN  nvl(sb_wft.tradeplace,'') = '010' AND sb.sectype IN ('003','006','222','333','444') THEN 'BOND'
                              WHEN  nvl(sb_wft.tradeplace,'') = '001' THEN 'HOSE'
                              WHEN  nvl(sb_wft.tradeplace,'') = '002' THEN 'HNX'
                              WHEN  nvl(sb_wft.tradeplace,'') = '005' THEN 'UPCOM'  END tradeplace

                      FROM BRGRP BR, cfmast cf, afmast af,semast se,
                      (SELECT * FROM vw_setran_gen WHERE txdate >= to_DAte(p_txmsg.txdate,'DD/MM/RRRR') and field in ('TRADE','BLOCKED')) tran, sbsecurities sb,
                           sbsecurities sb_wft
                      WHERE
                      cf.custodycd = rec_af.custodycd
                      AND af.custid = cf.custid AND AF.ACCTNO = rec_af.acctno
                      AND SE.afacctno = rec_af.acctno
                      and sb.sectype not in ('111','222','333','444','004')
                      AND BR.BRID = SUBSTR(CF.CUSTID,1,4)
                      AND af.acctno =  se.afacctno (+)
                      and se.acctno = tran.acctno (+)
                      AND se.codeid = sb.codeid (+)
                      AND nvl(sb.refcodeid, sb.codeid) = sb_wft.codeid (+)
                      GROUP BY BR.BRID,BRNAME,sb.markettype,sb.sectype,cf.fullname, cf.idcode, cf.iddate, cf.idplace, cf.address, cf.phone, cf.mobile,
                      cf.custodycd, se.trade, se.blocked,SE.receiving, sb.symbol, sb_wft.symbol,
                      sb_wft.sectype, sb_wft.issuerid,sb_wft.tradeplace,cf.TRADINGCODEDT,CF.TRADINGCODE--, tran.field
                  ) main left join
                    (SELECT CUSTODYCD,CODEID,SYMBOL SYMBOLL, 0 SELLQTTY,
                            0 BUYQTTY
                        FROM IOD WHERE DELTD <> 'Y' AND custodycd = rec_af.custodycd
                        GROUP BY CUSTODYCD, CODEID,SYMBOL) b
                    on main.custodycd=b.custodycd and main.symbol=b.symboll
                GROUP BY BRID,BRNAME,main.fullname, main.idcode, main.iddate, main.idplace, main.address, main.phone, main.mobile,main.custodycd, main.wft_symbol, main.tradeplace;


            -- HaiLT them de log cho bao cao CF0081
            insert into CF0081_LOG
            SELECT rec_af.custodycd, rec_af.acctno, to_DAte(p_txmsg.txdate,'DD/MM/RRRR'),p_txmsg.txnum, p_txmsg.tltxcd,
                   CAMASTID, CA_GROUP, CATYPENAME, TRADEPLACE, SYMBOL, DEVIDENTSHARES, DEVIDENTRATE, RIGHTOFFRATE,
                   EXPRICE, INTERESTRATE, EXRATE, REPORTDATE, CATYPE,
                   SUM(TRADE) TRADE, SUM(AMT) AMT, SUM(QTTY) QTTY, SUM(RQTTY) RQTTY, SUM(PBALANCE) PBALANCE,
                   SUM(BALANCE) BALANCE, CASE WHEN v_mrcount >0 THEN 'N' ELSE 'Y' END ISCLOSED
            FROM
            (
                SELECT CAS.CAMASTID,CAS.BALANCE, CAS.PBALANCE, CAS.RQTTY, CAS.QTTY, CAS.AMT, CAS.TRADE,
                    CA.CATYPE , CA.REPORTDATE, CA.EXRATE,CA.INTERESTRATE, CA.EXPRICE, CA.RIGHTOFFRATE,
                    CASE WHEN CA.CATYPE='010' AND CA.DEVIDENTRATE=0 THEN TO_CHAR(CA.DEVIDENTVALUE) ELSE CA.DEVIDENTRATE END DEVIDENTRATE,
                    CA.DEVIDENTSHARES , SB.SYMBOL, A1.CDCONTENT TRADEPLACE,
                    CASE WHEN CA.CATYPE = '011' THEN utf8nums.c_const_ca_rightname_a -- 'A. QUY?N NH?N C? T?C B?NG C? PHI?U'
                         WHEN CA.CATYPE = '010' THEN utf8nums.c_const_ca_rightname_c -- 'C. QUY?N NH?N C? T?C B?NG TI?N'
                         WHEN CA.CATYPE = '021' THEN utf8nums.c_const_ca_rightname_b -- 'B. QUY?N C? PHI?U THU?NG'
                         WHEN CA.CATYPE = '014' THEN utf8nums.c_const_ca_rightname_d -- 'D. QUY?N MUA'
                         WHEN CA.CATYPE = '020' THEN utf8nums.c_const_ca_rightname_e -- 'E. QUY?N HO?N ?I C? PHI?U'
                         WHEN CA.CATYPE in ('017','023') THEN utf8nums.c_const_ca_rightname_f --'F. QUY?N CHUY?N ?I TR?I PHI?U'
                         WHEN CA.CATYPE IN ('022','005','006') THEN utf8nums.c_const_ca_rightname_g --'G. QUY?N BI?U QUY?T'
                         ELSE v_rightname_h --'H. QUY?N KH?C'
                    end CATYPENAME,
                    CASE WHEN CA.CATYPE IN ('011','021') THEN 1
                         WHEN CA.CATYPE IN ('010') THEN 2
                         WHEN CA.CATYPE IN ('014') THEN 3
                         WHEN CA.CATYPE IN ('020') THEN 4
                         WHEN CA.CATYPE IN ('017','023') THEN 5
                         WHEN CA.CATYPE IN ('022','005','006')  THEN 6 ELSE 7
                    END CA_GROUP
                    FROM CASCHD CAS, CAMAST CA, SBSECURITIES SB, ALLCODE A1, ALLCODE A2, AFMAST AF, CFMAST CF
                WHERE CAS.CAMASTID = CA.CAMASTID AND CAS.CODEID=SB.CODEID AND CAS.AFACCTNO = AF.ACCTNO
                AND AF.CUSTID= CF.CUSTID
                AND A1.CDNAME='TRADEPLACE' AND A1.CDTYPE='SE' AND A1.CDVAL=SB.TRADEPLACE
                AND A2.CDNAME='CATYPE' AND A2.CDTYPE='CA' AND CA.CATYPE = A2.CDVAL
                AND CF.CUSTODYCD = rec_af.custodycd
                AND AF.ACCTNO = rec_af.acctno
                AND AF.STATUS='N' AND CAS.AFACCTNO = rec_af.acctno
                AND CAS.DELTD <> 'Y'
                AND (CASE WHEN CAS.STATUS IN ('C','J') THEN 0 ELSE 1 END) > 0
            ) A
            GROUP BY
              CATYPE , REPORTDATE, EXRATE,INTERESTRATE, EXPRICE, RIGHTOFFRATE, DEVIDENTRATE, DEVIDENTSHARES , SYMBOL, TRADEPLACE,
              CATYPENAME, CA_GROUP,CAMASTID
            ORDER BY A.CATYPENAME;

        else
            UPDATE AFTRAN SET
                DELTD = 'Y'
            WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);

            UPDATE DDMAST SET
                PSTATUS=PSTATUS||STATUS,STATUS=substr(PSTATUS,length(PSTATUS),1),
                LASTCHANGE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=rec_af.acctno;

            UPDATE AFMAST SET
               PSTATUS=PSTATUS||STATUS,STATUS=substr(PSTATUS,length(PSTATUS),1),
               LASTDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=rec_af.acctno;

            UPDATE cifeeschd SET paidamt = 0, paidtxnum= p_txmsg.txnum, paidtxdate=p_txmsg.busdate
            WHERE afacctno = rec_af.acctno;

        end if;
        --End 28/09/2015 DieuNDA
    end loop;

    --Gom bang ke tu dong
    cspks_rmproc.sp_exec_create_crbtrflog_auto(TO_char(p_txmsg.txdate, 'dd/mm/rrrr'), p_txmsg.txnum,p_err_code);
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
         plog.init ('TXPKS_#0088EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#0088EX;
/
