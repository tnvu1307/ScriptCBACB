SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3351ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3351EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      20/10/2011     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3351ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '01';
   c_camastid         CONSTANT CHAR(2) := '02';
   c_afacctno         CONSTANT CHAR(2) := '03';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_catype           CONSTANT CHAR(2) := '05';
   c_reportdate       CONSTANT CHAR(2) := '06';
   c_actiondate       CONSTANT CHAR(2) := '07';
   c_seacctno         CONSTANT CHAR(2) := '08';
   c_exseacctno       CONSTANT CHAR(2) := '09';
   c_qtty             CONSTANT CHAR(2) := '11';
   c_dutyamt          CONSTANT CHAR(2) := '20';
   c_aqtty            CONSTANT CHAR(2) := '13';
   c_parvalue         CONSTANT CHAR(2) := '14';
   c_exparvalue       CONSTANT CHAR(2) := '15';
   c_description      CONSTANT CHAR(2) := '30';
   c_priceaccounting   CONSTANT CHAR(2) := '21';
   c_status           CONSTANT CHAR(2) := '40';
   c_fullname         CONSTANT CHAR(2) := '17';
   c_idcode           CONSTANT CHAR(2) := '18';
   c_custodycd        CONSTANT CHAR(2) := '19';
   c_catypevalue      CONSTANT CHAR(2) := '22';
   c_taskcd           CONSTANT CHAR(2) := '16';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS

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
l_TRADE NUMBER(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
         -- neu la xoa jao dich: check xem TK co du tien, CK de revert ko
    if(p_txmsg.deltd = 'Y') THEN
    -- lay ra so du hien tai
        BEGIN
            SELECT trade INTO l_TRADE
            FROM semast WHERE acctno=p_txmsg.txfields('08').value;
        EXCEPTION WHEN OTHERS THEN
            p_err_code := '-300053'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END ;


        if l_TRADE < (ROUND(p_txmsg.txfields('11').value,0))
        then
              p_err_code := '-300053'; -- Pre-defined in DEFERROR table
              plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
              RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
    END IF;
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
v_catype VARCHAR2(3);
v_MARGIN NUMBER(20);
v_WTRADE NUMBER(20);
v_MORTAGE  NUMBER(20);
v_BLOCKED  NUMBER(20);
v_SECURED  NUMBER(20);
v_REPO     NUMBER(20);
v_NETTING  NUMBER(20);
v_DTOCLOSE NUMBER(20);
v_WITHDRAW NUMBER(20);
v_dbseacctno VARCHAR2(20);
l_txdesc     VARCHAR2(1000);
v_blocked_dtl  NUMBER(20);
v_emkqtty NUMBER(20);
v_blockwithdraw NUMBER(20);
v_blockdtoclose NUMBER(20);
v_count number;
v_countCI number;
v_countSE number;
l_catype VARCHAR2(3);
l_codeid VARCHAR2(6);
v_status varchar2(1);
v_execreate number;
l_formofpayment varchar2(3);
v_TBALDT DATE;
v_count_days NUMBER;

BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/


 /*   --locpt 20141128 cap nhat trang thai cua su kien
       if not(p_txmsg.deltd = 'Y') THEN
        --cap nhat caschd----
         update caschd set status ='J' where autoid = p_txmsg.txfields('01').value AND CAMASTID=p_txmsg.txfields('02').value;

        SELECT ca.catype, ca.codeid, ca.status, ca.exerate
         INTO l_Catype , l_codeid, v_status, v_execreate  from camast ca
         WHERE camastid = p_txmsg.txfields('02').value;

          --Kiem tra neu lam xong thi chuyen trang thai cua su kien quyen
        SELECT count(1) into v_countCI FROM CASCHD
         WHERE  CAMASTID=p_txmsg.txfields('02').value  AND DELTD ='N'
         AND amt> 0 AND ISCI='N' AND isexec='Y' ;
        -- kiem tra xem co tai khoan nao chua dc phan bo CK khong
         SELECT count(1) into v_countSE FROM CASCHD
         WHERE  CAMASTID=p_txmsg.txfields('02').value  AND DELTD ='N'
         AND qtty> 0 AND ISSE='N' AND isexec='Y' AND autoid <> p_txmsg.txfields('01').value;


         -- update trang thai trong CAMAST
         if(v_countCI = 0 AND v_countSE = 0) THEN
         UPDATE CAMAST SET STATUS ='J'
         WHERE CAMASTID=p_txmsg.txfields('02').value;
         ELSIF (v_countCI= 0 AND v_countSE > 0) THEN
         UPDATE CAMAST SET STATUS ='G'
         WHERE CAMASTID=p_txmsg.txfields('02').value;
         END IF;
       --cap nhat trang thai cua su kien co tuc bang tien them trang thai phan bo 1 phan.
        if(L_CATYPE = '010') then
        if(v_status = 'K' or v_execreate = 100) then
            UPDATE CAMAST SET STATUS = 'J'
            WHERE CAMASTID = p_txmsg.txfields('02').value;
        else
            UPDATE CAMAST SET STATUS = 'K'
            WHERE CAMASTID = p_txmsg.txfields('02').value;
        end if;
        end if;

       end if;



           --end locpt----*/


    v_catype:=p_txmsg.txfields('22').value;
    v_dbseacctno:=p_txmsg.txfields('09').value;
    V_BLOCKED:=0;
    --SONLT 20141220 Tinh phi luu ky backdate
    --Select GREATEST (DEPOLASTDT+1,p_txmsg.busdate) into v_TBALDT from cimast where acctno = p_txmsg.txfields('03').value;
    -- so ngay tinh phi luu ky chua den han
    v_count_days:= p_txmsg.txdate - v_TBALDT;

    --END SONLT 2011220
    IF cspks_caproc.fn_executecontractcaevent(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    -- update cac truong chung khoan ve 0 doi voi cac sk: IN ('017','020','023')
    IF p_txmsg.deltd <> 'Y' THEN
      --secmast_generate(p_txmsg.txnum, p_txmsg.txdate, p_txmsg.busdate, PV_AFACCTNO=>?, PV_SYMBOL=>?, PV_SECTYPE=>?, PV_PTYPE=>?, PV_CAMASTID=>?, PV_ORDERID=>?, PV_QTTY=>?, PV_COSTPRICE=>?, PV_MAPAVL=>?);
        --SONLT 20141220 Them buoc log lai phi luu ky
        IF ( p_txmsg.txfields('26').VALUE > 0 ) THEN
          -- tang phi luu ky voi tk chuyen
          INSERT INTO SEDEPOBAL (AUTOID, ACCTNO, TXDATE, DAYS, QTTY, DELTD,ID,AMT)
          VALUES (SEQ_SEDEPOBAL.NEXTVAL, p_txmsg.txfields('08').value,v_TBALDT,v_count_days, p_txmsg.txfields('11').value, 'N',to_char(p_txmsg.txdate)||p_txmsg.txnum, p_txmsg.txfields('26').VALUE);

        END IF;
        -- ghi nhan them mot dong phi LK den han
        IF ( p_txmsg.txfields('25').VALUE > 0 ) THEN
          IF cspks_ciproc.fn_FeeDepoMaturityBackdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
          RETURN errnums.C_BIZ_RULE_INVALID;
          END IF;
        END IF;
    --END SONLT 20141220 Them buoc log lai phi luu ky
      --locpt sinh du lieu cho secmast sk 027-----------------
            if(v_catype ='027') then
                  secmast_generate(p_txmsg.txnum, p_txmsg.txdate,  p_txmsg.busdate, p_txmsg.txfields('03').value,
                 SUBSTR(p_txmsg.txfields('08').value,11,6), 'C', 'O', p_txmsg.txfields('02').value, NULL,  p_txmsg.txfields('13').value, p_txmsg.txfields('12').value, 'Y');
            --19/04/2017 DieuNDA: Xu ly dac biet them dong Out cho SKQ chuyen CP thanh CP
            ELSIF to_number(p_txmsg.txfields('13').value) > 0 then
                 secmast_generate(p_txmsg.txnum, p_txmsg.txdate,  p_txmsg.busdate, p_txmsg.txfields('03').value,
                 SUBSTR(p_txmsg.txfields('09').value,11,6), 'C', 'O', p_txmsg.txfields('02').value, NULL,  p_txmsg.txfields('13').value, p_txmsg.txfields('12').value, 'Y');
            --end 19/04/2017 DieuNDA
            elsif to_number(p_txmsg.txfields('11').value) > 0 then
                 secmast_generate(p_txmsg.txnum, p_txmsg.txdate,  p_txmsg.busdate, p_txmsg.txfields('03').value,
                 SUBSTR(p_txmsg.txfields('08').value,11,6), 'C', 'I', p_txmsg.txfields('02').value, NULL,  p_txmsg.txfields('11').value, p_txmsg.txfields('12').value, 'Y');
            end if;
        ---end locpt
    ELSE
        --SONLT 20141220 Them buoc log lai phi luu ky
        IF ( p_txmsg.txfields('26').VALUE > 0 ) THEN
            UPDATE sedepobal SET deltd='Y' WHERE id=to_char(p_txmsg.txdate)||p_txmsg.txnum ;
        END IF;

        IF ( p_txmsg.txfields('25').VALUE > 0 ) THEN
            IF cspks_ciproc.fn_FeeDepoMaturityBackdate(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        END IF;
        secnet_un_map(p_txmsg.txnum, p_txmsg.txdate);
    end if;
    --thunt-17/01/2020: doi voi skq 023 thi khong co buoc huy doi voi tra lai~
          select nvl(FORMOFPAYMENT,null) FORMOFPAYMENT into l_formofpayment from camast where camastid=p_txmsg.txfields('02').VALUE;

    IF (v_catype IN ('017','027') or (v_catype IN ('023','020') and p_txmsg.txfields('10').value = 'Y')) THEN
      -- not xoa
      IF p_txmsg.deltd <> 'Y' THEN
            SELECT margin,wtrade,mortage,BLOCKED,secured,repo,netting,dtoclose,withdraw,emkqtty,blockwithdraw,blockdtoclose
            INTO v_MARGIN,v_WTRADE,v_MORTAGE,v_BLOCKED,v_SECURED,v_REPO,v_NETTING,v_DTOCLOSE,v_WITHDRAW,v_emkqtty,v_blockwithdraw,v_blockdtoclose
            FROM semast WHERE acctno=v_dbseacctno;
            -- update cac truong ck ve 0 va insert vao setran
            UPDATE semast
            SET margin=0,wtrade=0,mortage=0,BLOCKED=0,secured=0,repo=0,netting=0,dtoclose=0,withdraw=0
            WHERE acctno=v_dbseacctno;
            l_txdesc:= cspks_system.fn_DBgen_trandesc_with_format(p_txmsg,'3351','SE','0040','0002');

            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_dbseacctno,
            '0083',v_MARGIN,NULL,p_txmsg.txfields ('01').value,
            p_txmsg.deltd,p_txmsg.txfields ('01').value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,l_txdesc);

             INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_dbseacctno,
            '0080',v_WTRADE,NULL,p_txmsg.txfields ('01').value,
            p_txmsg.deltd,p_txmsg.txfields ('01').value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,l_txdesc);

            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_dbseacctno,
            '0066',v_MORTAGE,NULL,p_txmsg.txfields ('01').value,
            p_txmsg.deltd,p_txmsg.txfields ('01').value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,l_txdesc);

            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_dbseacctno,
            '0044',v_BLOCKED ,NULL,p_txmsg.txfields ('01').value,
            p_txmsg.deltd,p_txmsg.txfields ('01').value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,l_txdesc);

            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_dbseacctno,
            '0088',v_BLOCKWITHDRAW,NULL,p_txmsg.txfields ('01').value,
            p_txmsg.deltd,p_txmsg.txfields ('01').value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,l_txdesc);

            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_dbseacctno,
            '0090',v_blockdtoclose,NULL,p_txmsg.txfields ('01').value,
            p_txmsg.deltd,p_txmsg.txfields ('01').value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,l_txdesc);


            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_dbseacctno,
            '0018',v_SECURED,NULL,p_txmsg.txfields ('01').value,
            p_txmsg.deltd,p_txmsg.txfields ('01').value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,l_txdesc);

            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_dbseacctno,
            '0084',v_REPO,NULL,p_txmsg.txfields ('01').value,
            p_txmsg.deltd,p_txmsg.txfields ('01').value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,l_txdesc);

            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_dbseacctno,
            '0020',v_NETTING,NULL,p_txmsg.txfields ('01').value,
            p_txmsg.deltd,p_txmsg.txfields ('01').value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,l_txdesc);

             INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO, TXCD, NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_dbseacctno,
            '0071',v_DTOCLOSE,NULL,p_txmsg.txfields ('01').value,
            p_txmsg.deltd,p_txmsg.txfields ('01').value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,l_txdesc);

            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_dbseacctno,
            '0042',v_WITHDRAW,NULL,p_txmsg.txfields ('01').value,
            p_txmsg.deltd,p_txmsg.txfields ('01').value,seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,l_txdesc);

      ELSE -- xoa jao dich
        -- lay du lieu trong setran_gen de revert
        UPDATE CAMAST SET cancelstatus = 'N', STATUS = 'I'
        WHERE CAMASTID = p_txmsg.txfields('02').value AND CATYPE IN ('023','020');

        
        SELECT nvl(namt,0) INTO v_margin FROM setran
        WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate
        AND acctno=v_dbseacctno AND txcd='0083';

        SELECT nvl(namt,0) INTO v_WTRADE FROM setran
        WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate
        AND acctno=v_dbseacctno AND txcd='0080';

        SELECT nvl(namt,0) INTO v_MORTAGE FROM setran
        WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate
        AND acctno=v_dbseacctno AND txcd='0066';


        SELECT nvl(namt,0) INTO v_SECURED FROM setran
        WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate
        AND acctno=v_dbseacctno AND txcd='0018';

        SELECT nvl(namt,0) INTO v_REPO FROM setran
        WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate
        AND acctno=v_dbseacctno AND txcd='0084';

        SELECT nvl(namt,0) INTO v_NETTING FROM setran
        WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate
        AND acctno=v_dbseacctno AND txcd='0020';

        SELECT nvl(namt,0) INTO v_DTOCLOSE FROM setran
        WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate
        AND acctno=v_dbseacctno AND txcd='0071';

        SELECT nvl(namt,0) INTO v_WITHDRAW FROM setran
        WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate
        AND acctno=v_dbseacctno AND txcd='0042';

        SELECT nvl(namt,0) INTO v_BLOCKED FROM setran
        WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate
        AND acctno=v_dbseacctno AND txcd='0044';

        SELECT nvl(namt,0) INTO v_blockwithdraw FROM setran
        WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate
        AND acctno=v_dbseacctno AND txcd='0088';

        SELECT nvl(namt,0) INTO v_blockdtoclose FROM setran
        WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate
        AND acctno=v_dbseacctno AND txcd='0090';
        -- revert du lieu
        UPDATE semast
        SET margin=margin+v_margin,wtrade=wtrade+v_wtrade,
        mortage=mortage+v_mortage,BLOCKED=BLOCKED+v_BLOCKED,
        secured=secured+v_secured,repo=repo+v_repo,netting=netting+v_netting,
        dtoclose=dtoclose+v_dtoclose,withdraw=withdraw+v_withdraw,
        blockwithdraw=blockwithdraw+v_blockwithdraw,
        blockdtoclose=blockdtoclose+v_blockdtoclose
        WHERE acctno=v_dbseacctno;

        UPDATE setran SET deltd='Y'
        WHERE txnum=p_txmsg.txnum AND txdate=p_txmsg.txdate ;

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
         plog.init ('TXPKS_#3351EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3351EX;
/
