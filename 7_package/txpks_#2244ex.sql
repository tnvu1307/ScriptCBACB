SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#2244ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2244EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      13/09/2011     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#2244ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_codeid           CONSTANT CHAR(2) := '01';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_outward          CONSTANT CHAR(2) := '05';
   c_price            CONSTANT CHAR(2) := '09';
   c_amt              CONSTANT CHAR(2) := '10';
   c_depoblock        CONSTANT CHAR(2) := '06';
   c_parvalue         CONSTANT CHAR(2) := '11';
   c_qtty             CONSTANT CHAR(2) := '12';
   c_trtype           CONSTANT CHAR(2) := '31';
   c_qttytype         CONSTANT CHAR(2) := '14';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_mrrate number;
    l_mrirate number;
    l_marginrate number;
    l_BALDEFAVL NUMBER(20,2);
    l_ddmastcheck_arr txpks_check.ddmastcheck_arrtype;
    l_symbol varchar2(20);
    l_DEPOTRADE number;
    l_DEPOBLOCK number;
    l_vsdmod    varchar2(3);
    l_SEASS     number;
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

    l_DEPOTRADE := p_txmsg.txfields('10').value;
    l_DEPOBLOCK := TO_NUMBER(p_txmsg.txfields('06').value);
    l_vsdmod :=cspks_system.fn_get_sysvar('SYSTEM', 'VSDMOD');

  IF p_txmsg.deltd <> 'Y' THEN
       --check ma dot phat hanh doi voi ck WFT
        select symbol into l_symbol from sbsecurities where codeid = p_txmsg.txfields('01').value;


        if instr(l_symbol,'_WFT') > 0 and p_txmsg.txfields('77').value is null then
         p_err_code := '-150016';
         RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

            --Check khong dc thuc hien 2 loai CK cung luc
        if l_vsdmod ='A' then --mod Auto
            if l_DEPOTRADE > 0 and l_DEPOBLOCK > 0 then
                p_err_code := '-150026';
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
        end if;

    --End T07/2017 STP

    l_DDMASTcheck_arr := txpks_check.fn_DDMASTcheck(to_char(p_txmsg.txfields('02').value),'DDMAST','ACCTNO');

    --l_SEASS := l_CIMASTcheck_arr(0).SEASS;
    l_BALDEFAVL := l_DDMASTcheck_arr(0).BALANCE;
    if l_baldefavl < to_number(p_txmsg.txfields('45').value) then
        p_err_code := '-400101';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;

    --plog.error (pkgctx, 'Long cui bap:'||p_txmsg.txfields(01).value );
    /*select nvl(max(rsk.mrratiorate * least(rsk.mrpricerate,se.margincallprice) / 100),0)
        into l_mrrate
    from afserisk rsk, afmast af, aftype aft, mrtype mrt, securities_info se
    where af.actype = rsk.actype and af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T' and aft.istrfbuy = 'N'
    and af.acctno = p_txmsg.txfields('02').value and rsk.codeid = p_txmsg.txfields('01').value and rsk.codeid = se.codeid;

    --plog.error (pkgctx, 'Long cui bap:' ||l_mrrate);
    if l_mrrate > 0 then -- check them khi chuyen chung khoan di, tai san con lai phai dam bao ty le.
        select round((case when ci.balance +LEAST(nvl(af.MRCRLIMIT,0),nvl(sec.secureamt,0) + ci.trfbuyamt)+ nvl(sec.avladvance,0) - ci.odamt - nvl(sec.secureamt,0) - ci.trfbuyamt - ci.ramt>=0 then 100000
                else least( greatest(nvl(l_SEASS,0) - to_number(p_txmsg.txfields('10').value) * l_mrrate,0), af.mrcrlimitmax - sec.dfodamt)
                    / abs(ci.balance +LEAST(nvl(af.MRCRLIMIT,0),nvl(sec.secureamt,0) + ci.trfbuyamt)+ nvl(sec.avladvance,0) - ci.odamt - nvl(sec.secureamt,0) - ci.trfbuyamt - ci.ramt) end),4) * 100 MARGINRATE,
                af.mrirate
                    into l_marginrate, l_mrirate
        from afmast af, cimast ci, v_getsecmarginratio sec
        where af.acctno = ci.acctno and af.acctno = sec.afacctno(+)
        and af.acctno = p_txmsg.txfields('02').value;

        if l_marginrate < l_mrirate then
            p_err_code:='-180064';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
    end if;*/



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
    l_Count number;
    v_blockqtty number;
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
   /*if  p_txmsg.txfields('06').VALUE > 0 Then
        Begin
            select Count(1) into l_Count from SEMASTDTL
            where acctno = p_txmsg.txfields('03').VALUE
                  and QTTYTYPE = p_txmsg.txfields('14').VALUE
                  and qtty >= p_txmsg.txfields('06').VALUE and autoid =(p_txmsg.txfields('18').value);
        EXCEPTION
        WHEN OTHERS THEN
            l_Count :=0;
        End;

        IF l_count = 0 THEN
            plog.error(pkgctx,'l_lngErrCode: ' || '-900055');
            p_err_code := -900055;
            return errnums.C_SYSTEM_ERROR;
        END IF;
   End if;*/

        /*IF l_count = 0 THEN
            plog.error(pkgctx,'l_lngErrCode: ' || '-900055');
            p_err_code := -900055;
            return errnums.C_SYSTEM_ERROR;
        END IF;*/


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
l_count NUMBER(20);
l_trade NUMBER(20);
l_blocked NUMBER(20);
l_caqtty NUMBER(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd = 'Y' THEN
     l_trade:=p_txmsg.txfields('10').value;
     l_blocked:=p_txmsg.txfields('06').value;
     l_caqtty:=p_txmsg.txfields('13').value;

          BEGIN
                   SELECT COUNT(*) INTO L_count
                   FROM sesendout
                   WHERE
                   txdate=p_txmsg.txdate AND TXnum=p_txmsg.txnum
                   AND  ((trade >= l_trade) AND (blocked >=l_blocked) AND(caqtty>=l_caqtty))
                   AND deltd='N';
          EXCEPTION WHEN OTHERS THEN
                    p_err_code:='-200404';
                    plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
          END;
           IF(l_count <=0) THEN
              p_err_code := '-200404'; -- Pre-defined in DEFERROR table
              plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
              RETURN errnums.C_BIZ_RULE_INVALID;
           END IF;


    END IF;
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
v_caqtty number;
v_nDEPOBLOCK number;
v_sendoutid number;
v_autoid varchar2(10);
v_amt number(20,4);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    IF p_txmsg.deltd <> 'Y' THEN

        /*UPDATE SEMASTDTL
        SET QTTY=QTTY-(p_txmsg.txfields('06').value)
        WHERE autoid =(p_txmsg.txfields('18').value);*/
        v_nDEPOBLOCK:=p_txmsg.txfields('06').value;


        --Phan bo phan chung khoan quyen, chuyen sang tai khoan nhan chuyen nhuong
        v_caqtty:= p_txmsg.txfields('13').value;

        v_sendoutid := SEQ_SESENDOUT.NEXTVAL;

        for rec in (
            select * from sepitlog where acctno = p_txmsg.txfields('03').value
            and deltd <> 'Y' and qtty - mapqtty >0
            order by txdate
        )
        loop
            if v_caqtty > rec.qtty - rec.mapqtty then

                update sepitlog set mapqtty = mapqtty + rec.qtty - rec.mapqtty where autoid = rec.autoid;

                INSERT INTO se2244_log (sendoutid, codeid, camastid, afacctno, qtty, deltd)
                    VALUES (v_sendoutid, rec.codeid, rec.camastid, rec.afacctno, rec.qtty - rec.mapqtty, 'N');
                v_caqtty:=v_caqtty-(rec.qtty-rec.mapqtty);
            else

                update sepitlog set mapqtty = mapqtty + v_caqtty, status ='C' where autoid = rec.autoid;

                INSERT INTO se2244_log (sendoutid, codeid, camastid, afacctno, qtty, deltd)
                    VALUES (v_sendoutid, rec.codeid, rec.camastid, rec.afacctno, v_caqtty, 'N');
                v_caqtty:=0;
            end if;


            exit when v_caqtty<=0;
        end loop;
        -- insert v?SESENDOUT
          INSERT INTO SESENDOUT
              (
              AUTOID, TXNUM, TXDATE, ACCTNO, TRADE,
              BLOCKED,CAQTTY,
              STRADE,SBLOCKED,SCAQTTY,
              CTRADE,CBLOCKED,CCAQTTY,DELTD,STATUS,RECUSTODYCD,RECUSTNAME,codeid,PRICE,OUTWARD,TRTYPE,QTTYTYPE,FEE,TAX,FEESV,REFERENCEID)
          VALUES (
              v_sendoutid, p_txmsg.txnum,p_txmsg.txdate,p_txmsg.txfields('03').value, p_txmsg.txfields('10').value, --AUTOID, TXNUM, TXDATE, ACCTNO, TRADE,
              p_txmsg.txfields('06').value,p_txmsg.txfields('13').value,--BLOCKED,CAQTTY,
              0,0,0,--STRADE,SBLOCKED,SCAQTTY,
               0,0, 0,'N','N',p_txmsg.txfields('88').value,p_txmsg.txfields('49').value,p_txmsg.txfields('01').value,p_txmsg.txfields('09').value,p_txmsg.txfields('05').value,
              p_txmsg.txfields('31').value,p_txmsg.txfields('14').value,p_txmsg.txfields('45').value,p_txmsg.txfields('46').value,'',p_txmsg.txfields('77').value);

        /*---Insert feetran
        v_autoid := seq_feetran.nextval;
        v_amt := p_txmsg.txfields('45').value;
        insert into feetran (TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE, VATAMT, AUTOID, TRDESC, CCYCD, ORDERID , TYPE, DEDUCTEDPLACE, STATUS, PAIDDATE, PSTATUS, SUBTYPE, FEETYPES, CUSTODYCD)
               values (p_txmsg.txdate, p_txmsg.txnum, 'N', p_txmsg.txfields('44').value, null ,v_amt, 0.0000, 0.0000, 0.0000, p_txmsg.txfields('46').value, v_autoid,'Tax of '|| p_txmsg.txfields('30').value, 'USD', null , 'T', 'SHV', 'N', null, null, null, null, p_txmsg.txfields('15').value );


        insert into feetrandetail (AUTOID, REFID, TXDATE, TXNUM, SUBTYPE, FEETYPES, TXAMT, FEEAMT, ORDERID, CUSTODYCD, CCYCD, RATEAMT, FORP, CODEID, SEBAL, ASSET)
               values (seq_feetrandetail.nextval, v_autoid, p_txmsg.txdate, p_txmsg.txnum, null, null, v_amt, 0.0000, null, p_txmsg.txfields('15').value, 'USD', p_txmsg.txfields('46').value, 'T', p_txmsg.txfields('01').value, 0, 0);
         */
    Else

         for rec in (
            select * from sepitlog where acctno = p_txmsg.txfields('03').value
            and deltd <> 'Y' --and qtty - mapqtty >0
            order by txdate desc
        )
        loop
            if v_caqtty > rec.mapqtty then

                update sepitlog set mapqtty = 0 where autoid = rec.autoid;
                v_caqtty:=v_caqtty-rec.mapqtty;
            else

                update sepitlog set mapqtty = mapqtty - v_caqtty, status =(case when status='C' then 'N' else status end) where autoid = rec.autoid;
                v_caqtty:=0;
            end if;
            exit when v_caqtty<=0;
        end loop;


        FOR rec1 IN (SELECT * FROM sesendout WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate)
        LOOP
            UPDATE sesendout SET deltd='Y' WHERE autoid = rec1.autoid;
            UPDATE se2244_log SET deltd='Y' WHERE sendoutid = rec1.autoid;
        END LOOP;

        /*UPDATE FEETRAN fe
        SET
            fe.deltd = 'Y'
        WHERE fe.txdate = p_txmsg.txdate
        AND fe.txnum = p_txmsg.txnum
        AND TYPE = 'T';

        DELETE FEETRANDETAIL fe
        WHERE fe.txdate = p_txmsg.txdate
        AND fe.txnum = p_txmsg.txnum
        AND fe.forp = 'T';*/
    End If;

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
         plog.init ('TXPKS_#2244EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2244EX;
/
