SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#2242ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2242EX
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


CREATE OR REPLACE PACKAGE BODY txpks_#2242ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_codeid           CONSTANT CHAR(2) := '01';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_afacct2          CONSTANT CHAR(2) := '04';
   c_acct2            CONSTANT CHAR(2) := '05';
   c_custname2        CONSTANT CHAR(2) := '93';
   c_address2         CONSTANT CHAR(2) := '94';
   c_license2         CONSTANT CHAR(2) := '95';
   c_depoblock        CONSTANT CHAR(2) := '06';
   c_amt              CONSTANT CHAR(2) := '10';
   c_parvalue         CONSTANT CHAR(2) := '11';
   c_qtty             CONSTANT CHAR(2) := '12';
   c_price            CONSTANT CHAR(2) := '09';
   c_DEPOFEEAMT     CONSTANT CHAR(2) := '15';
   c_DEPOFEEACR     CONSTANT CHAR(2) := '16';
   c_qttytype         CONSTANT CHAR(2) := '14';
   c_trtype           CONSTANT CHAR(2) := '31';
   c_desc             CONSTANT CHAR(2) := '30';
   c_DEPOLASTDT       CONSTANT CHAR(2) := '32'; -- ngay chuyen phi luu ky den han gan nhat
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_leader_license varchar2(100);
    l_leader_idexpired date;
    l_idexpdays apprules.field%TYPE;
    l_afmastcheck_arr txpks_check.afmastcheck_arrtype;
    l_leader_expired boolean;
    l_count number;
    l_MCUSTODYCD1 VARCHAR2(10);
    l_MCUSTODYCD2 VARCHAR2(10);
    l_CUSTODYCD1 VARCHAR2(10);
    l_CUSTODYCD2 VARCHAR2(10);
    l_mrrateFrom    number;
    l_mrrateTo    number;
    l_marginrate  number;
    l_mrirate number;
    l_chksysctrl char(1);
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

    IF p_txmsg.deltd = 'N' THEN
        --29/01/2018 DieuNDA: Check chan nhap so am
        if to_number(p_txmsg.txfields('10').value) < 0 or to_number(p_txmsg.txfields('06').value) < 0 or to_number(p_txmsg.txfields('12').value) <= 0  then
            p_err_code := '-100810';
            
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

    end if;

    l_leader_expired:= false;

    select idcode, idexpired into l_leader_license, l_leader_idexpired
    from cfmast cf, afmast af
    where cf.custid = af.custid
    and af.acctno = p_txmsg.txfields(c_afacctno).value;

    IF l_leader_idexpired < p_txmsg.txdate THEN --leader expired
        l_leader_expired:=true;
        p_txmsg.txWarningException('-2002081').value:= cspks_system.fn_get_errmsg('-200208');
        p_txmsg.txWarningException('-2002081').errlev:= '1';
    END IF;

    -- check chi cho chuyen nhuong trong cung mot KH
    SELECT CF.MCUSTODYCD, CF.CUSTODYCD INTO L_MCUSTODYCD1, L_CUSTODYCD1 FROM AFMAST AF, CFMAST CF WHERE AF.CUSTID = CF.CUSTID AND ACCTNO = p_txmsg.txfields(c_afacctno).value;
    SELECT CF.MCUSTODYCD, CF.CUSTODYCD INTO L_MCUSTODYCD2, L_CUSTODYCD2 FROM AFMAST AF, CFMAST CF WHERE AF.CUSTID = CF.CUSTID AND ACCTNO = p_txmsg.txfields(c_afacct2).value;

    if(L_MCUSTODYCD1 <> L_MCUSTODYCD2)  THEN
        p_err_code:='-901218'; --'-900101';
        plog.setendsection(pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    IF L_CUSTODYCD1 = L_CUSTODYCD2 THEN
        p_err_code:='-900109';
        plog.setendsection(pkgctx, 'fn_txPreAppCheck');
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
    l_Count     number;
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
v_strCODEID varchar2(10);
v_strAFACCTNO varchar2(20);
v_strACCTNO varchar2(20);
v_strTYPEDEPOBLOCK varchar2(20);
v_nAMT number;
v_count number;
v_nPRICE number;
v_nDEPOTRADE number;
v_nDEPOBLOCK number;
v_txnum varchar2(20);
V_txdate date;
v_currmonth VARCHAR2(10);
v_TBALDT DATE;
v_count_days NUMBER;
v_caqtty number;

v_seqtty    number;

BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_strAFACCTNO := p_txmsg.txfields('04').VALUE;
    v_strACCTNO := p_txmsg.txfields('05').VALUE;
    v_nAMT := p_txmsg.txfields('12').VALUE;
    v_nDEPOTRADE := p_txmsg.txfields('10').VALUE;
    v_nDEPOBLOCK := p_txmsg.txfields('06').VALUE;
    v_strTYPEDEPOBLOCK := p_txmsg.txfields('14').VALUE;
    v_count:=0;
    v_txnum:= p_txmsg.txnum;
    V_txdate:= p_txmsg.txdate;
    v_TBALDT:= Greatest(to_date ( p_txmsg.txfields('32').value,'DD/MM/RRRR')+1, p_txmsg.busdate);
    -- so ngay tinh phi luu ky chua den han
    v_count_days:= p_txmsg.txdate - v_TBALDT;
    v_currmonth := to_char(to_date(V_txdate,'DD/MM/RRRR'),'RRRRMM');

    IF p_txmsg.deltd <> 'Y' THEN
        --PhuongHT comment: chuyen sang ghi log vao sedepobal
      /*  If p_txmsg.txfields('15').VALUE > 0 then
            -- Xu ly D/v TK Chuyen
            INSERT INTO cidepofeetran (autoid, afacctno, frdate, todate, depoqtty, deporate, depotype, cidepofeeacr, status, txnum, txdate, tltxcd, txdesc, MONTH)
            Select seq_cidepofeetran.nextval autoid, p_txmsg.txfields('02').VALUE afacctno ,
                   p_txmsg.txdate frdate, p_txmsg.txdate todate,
                   p_txmsg.txfields('12').VALUE depoqtty, 0 deporate, 'C' depotype,
                   -p_txmsg.txfields('15').VALUE cidepofeeacr, 'P',
                   p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                   p_txmsg.tltxcd tltxcd, p_txmsg.txdesc txdesc, v_currmonth MONTH
            from dual;

            -- Xu ly D/v TK nhan
            INSERT INTO cidepofeetran (autoid, afacctno, frdate, todate, depoqtty, deporate, depotype, cidepofeeacr, status, txnum, txdate, tltxcd, txdesc, Month)
            Select seq_cidepofeetran.nextval autoid, p_txmsg.txfields('04').VALUE afacctno ,
                   p_txmsg.txdate frdate, p_txmsg.txdate todate,
                   p_txmsg.txfields('12').VALUE depoqtty, 0 deporate, 'C' depotype,
                   p_txmsg.txfields('15').VALUE cidepofeeacr, 'P',
                   p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                   p_txmsg.tltxcd tltxcd, p_txmsg.txdesc txdesc, v_currmonth MONTH
            from dual;
        End If;*/

        -- chi tang phi luu ky voi TK nhan
        IF ( p_txmsg.txfields('16').VALUE > 0 ) THEN
         INSERT INTO SEDEPOBAL (AUTOID, ACCTNO, TXDATE, DAYS, QTTY, DELTD,ID,AMT)
         VALUES (SEQ_SEDEPOBAL.NEXTVAL, p_txmsg.txfields('05').value,v_TBALDT,v_count_days, p_txmsg.txfields('12').value, 'N',to_char(V_txdate)||V_txnum, p_txmsg.txfields('16').VALUE);
         END IF;
         -- ghi nhan them mot dong phi LK den han
            IF ( p_txmsg.txfields('15').VALUE > 0 ) THEN
               IF cspks_ciproc.fn_FeeDepoMaturityBackdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
               RETURN errnums.C_BIZ_RULE_INVALID;
               END IF;
             END IF;
        --End of PhuongHT edit

        ----HaiLT them cho chuyen khoan chung khoan lo le qua file
        select count(*) into v_count from tbltrfstock where afacctno= p_txmsg.txfields('02').VALUE and afacctno2= p_txmsg.txfields('04').VALUE
            and autoid=p_txmsg.txfields('18').VALUE;
        plog.debug(pkgctx,v_count || ' update tbltrfstock: ' || p_txmsg.txfields('02').VALUE || ' ' || p_txmsg.txfields('04').VALUE || ' ' || p_txmsg.txfields('18').VALUE);
        if v_count>0 then
            update tbltrfstock set pstatus=status, status='A' where autoid=p_txmsg.txfields('18').VALUE;
        end if;
        ----End of HaiLT them cho chuyen khoan chung khoan lo le qua file

        --Phan bo phan chung khoan quyen, chuyen sang tai khoan nhan chuyen nhuong
        v_caqtty:= p_txmsg.txfields('13').value;
        for rec in (
            select * from sepitlog where acctno = p_txmsg.txfields('03').value
            and deltd <> 'Y' and qtty - mapqtty >0
            order by txdate
        )
        loop
            if v_caqtty > rec.qtty - rec.mapqtty then

                update sepitlog set mapqtty = mapqtty + rec.qtty - rec.mapqtty where autoid = rec.autoid;
                INSERT INTO sepitlog (AUTOID,ACCTNO,TXDATE,TXNUM,QTTY,MAPQTTY,CODEID,CAMASTID,MODIFIEDDATE,AFACCTNO,PRICE,STATUS,DELTD,PITRATE,PCAMASTID,CARATE)
                values (seq_sepitlog.nextval,p_txmsg.txfields('05').value,
                p_txmsg.txdate,p_txmsg.txnum,rec.qtty - rec.mapqtty,0,rec.codeid,rec.CAMASTID,
                p_txmsg.txdate,p_txmsg.txfields('04').value,rec.PRICE,rec.STATUS,rec.DELTD,rec.PITRATE,rec.PCAMASTID,rec.CARATE);
                v_caqtty:=v_caqtty - rec.qtty + rec.mapqtty;

            else

                update sepitlog set mapqtty = mapqtty + v_caqtty, status ='C' where autoid = rec.autoid;
                INSERT INTO sepitlog (AUTOID,ACCTNO,TXDATE,TXNUM,QTTY,MAPQTTY,CODEID,CAMASTID,MODIFIEDDATE,AFACCTNO,PRICE,STATUS,DELTD,PITRATE,PCAMASTID,CARATE)
                values(seq_sepitlog.nextval,p_txmsg.txfields('05').value,
                p_txmsg.txdate,p_txmsg.txnum,v_caqtty,0,rec.codeid,rec.CAMASTID,
                p_txmsg.txdate,p_txmsg.txfields('04').value,rec.PRICE,rec.STATUS,rec.DELTD,rec.PITRATE,rec.PCAMASTID,rec.CARATE);
                v_caqtty:=0;

            end if;
            exit when v_caqtty<=0;
        end loop;

    /*
        PV_TXNUM        IN VARCHAR2, ---MA CHUNG TU CUA LENH
        PV_TXDATE       IN VARCHAR2, ---NGAY TAO GIAO DICH
        PV_BUSDATE      IN VARCHAR2, ---NGAY GIAO DICH CO HIEU LUC
        PV_AFACCTNO     IN VARCHAR2, ---SO TIEU KHOAN
        PV_SYMBOL       IN VARCHAR2, ---CHUNG KHOANG
        PV_SECTYPE      IN VARCHAR2, ---LOAI GIAO DICH (T:MUA/BAN ; D:LUU KY ; S:CHUYEN KHOAN ; C:QUYEN)
        PV_PTYPE        IN VARCHAR2, ---GIAO DICH NHAP XUAT (I:NHAP ; O:XUAT)
        PV_CAMASTID     IN VARCHAR2, ---MA SU KIEN(VOI SECTYPE = C. SECTYPE <> 'C' DE NULL)
        PV_ORDERID      IN VARCHAR2, ---MA LENH(VOI SECTYPE = T. SECTYPE <> 'T' DE NULL)
        PV_QTTY         IN NUMBER,   ---SO LUONG
        PV_COSTPRICE    IN NUMBER,   ---GIA VON (GIA CUA LAN NHAP/XUAT)
        PV_MAPAVL       IN VARCHAR2  ---CO DUOC MAP LUON HAY KHONG.
    */

    v_seqtty := p_txmsg.txfields('10').value + p_txmsg.txfields('06').value;
    for rec1 IN (SELECT AUTOID, qtty-mapqtty REMAIN_QTTY, BUSDATE, costprice costprice
        FROM secmast WHERE ACCTNO = p_txmsg.txfields('02').value AND codeid = p_txmsg.txfields('01').value
            AND PTYPE = 'I' AND mapavl = 'Y' AND deltd = 'N' AND qtty > 0 and qtty-mapqtty <> 0
            and v_seqtty > 0
        ORDER BY BUSDATE,AUTOID, TXNUM
    ) loop
        IF (v_seqtty > 0) THEN
            if(v_seqtty <= rec1.REMAIN_QTTY) then
                ---TH ben nhan CK.
                secmast_generate(p_txmsg.txnum, p_txmsg.txdate, p_txmsg.busdate, p_txmsg.txfields('04').value,p_txmsg.txfields('01').value, 'D', 'I', NULL, NULL,  v_seqtty, p_txmsg.txfields('09').value, 'Y');
                ---TH ben chuyen CK.
                secmast_generate(p_txmsg.txnum, p_txmsg.txdate, p_txmsg.busdate, p_txmsg.txfields('02').value,p_txmsg.txfields('01').value, 'D', 'O', NULL, NULL,  v_seqtty, p_txmsg.txfields('09').value, 'Y');
                v_seqtty := 0;
            else
                ---TH ben nhan CK.
                secmast_generate(p_txmsg.txnum, p_txmsg.txdate, p_txmsg.busdate, p_txmsg.txfields('04').value,p_txmsg.txfields('01').value, 'D', 'I', NULL, NULL,  rec1.REMAIN_QTTY, p_txmsg.txfields('09').value, 'Y');
                ---TH ben chuyen CK.
                secmast_generate(p_txmsg.txnum, p_txmsg.txdate, p_txmsg.busdate, p_txmsg.txfields('02').value,p_txmsg.txfields('01').value, 'D', 'O', NULL, NULL,  rec1.REMAIN_QTTY, p_txmsg.txfields('09').value, 'Y');
                v_seqtty := v_seqtty-rec1.REMAIN_QTTY;
            end if;
        END IF;
    end loop;


    else
     /*   If p_txmsg.txfields('15').VALUE > 0 then

            -- Xu ly D/v TK Chuyen
            update cidepofeetran set status = 'R'
            where afacctno= p_txmsg.txfields('02').VALUE
                    and tltxcd = p_txmsg.tltxcd
                    and txnum = p_txmsg.txnum
                    and txdate = TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT);

            -- Xu ly D/v TK nhan
            update cidepofeetran set status = 'R'
            where afacctno= p_txmsg.txfields('04').VALUE
                    and tltxcd = p_txmsg.tltxcd
                    and txnum = p_txmsg.txnum
                    and txdate = TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT);

        End If;*/
        -- PhuongHT edit: log phi luu ky backdate
        IF ( p_txmsg.txfields('16').VALUE > 0 ) THEN
        UPDATE sedepobal SET deltd='Y' WHERE id=to_char(V_txdate)||V_txnum ;
        END IF;
            IF ( p_txmsg.txfields('15').VALUE > 0 ) THEN
               IF cspks_ciproc.fn_FeeDepoMaturityBackdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
               RETURN errnums.C_BIZ_RULE_INVALID;
               END IF;
             END IF;
             -- end of PhuongHT
        ----HaiLT them cho chuyen khoan chung khoan lo le qua file
        select count(*) into v_count from tbltrfstock where afacctno= p_txmsg.txfields('02').VALUE and afacctno2= p_txmsg.txfields('04').VALUE
            and autoid=p_txmsg.txfields('18').VALUE;

        if v_count>0 then
            update tbltrfstock set pstatus=status, status='' where autoid=p_txmsg.txfields('18').VALUE;
        end if;
        ----End of HaiLT them cho chuyen khoan chung khoan lo le qua file
        --Phan bo phan chung khoan quyen, chuyen sang tai khoan nhan chuyen nhuong
        for rec in (
            select * from sepitlog where txnum = p_txmsg.txnum and txdate = p_txmsg.txdate
            and acctno = p_txmsg.txfields('05').VALUE
        )
        loop
            update sepitlog set acctno = p_txmsg.txfields('03').VALUE , afacctno = p_txmsg.txfields('02').VALUE
            where autoid = rec.autoid;
        end loop;
    secnet_un_map(p_txmsg.txnum, p_txmsg.txdate);
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
         plog.init ('TXPKS_#2242EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2242EX;
/
