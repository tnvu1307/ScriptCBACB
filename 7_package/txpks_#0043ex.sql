SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#0043ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#0043EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      12/11/2014     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#0043ex IS
  pkgctx plog.log_ctx;
  logrow tlogdebug%ROWTYPE;

  c_custodycd CONSTANT CHAR(2) := '88';
  c_acctno    CONSTANT CHAR(2) := '03';
  c_fullname  CONSTANT CHAR(2) := '04';
  c_idcode    CONSTANT CHAR(2) := '05';
  c_iddate    CONSTANT CHAR(2) := '06';
  c_idplace   CONSTANT CHAR(2) := '07';
  c_smstype   CONSTANT CHAR(2) := '08';
  c_desc      CONSTANT CHAR(2) := '30';
  FUNCTION fn_txPreAppCheck(p_txmsg    in tx.msg_rectype,
                            p_err_code out varchar2) RETURN NUMBER IS
    l_txmsg       tx.msg_rectype;
    v_count       VARCHAR2(20);
    v_counttype   VARCHAR2(20);
    v_counttele   VARCHAR2(20);
    v_countaf     VARCHAR2(20);
    v_totalfee    NUMBER;
    v_feemax      NUMBER;
    v_totalmax    NUMBER;
    v_vatmax      NUMBER;
    v_feenew      NUMBER;
    l_txdesc      VARCHAR2(200);
    v_tomon       DATE;
    v_endmon      DATE;
    v_strCURRDATE DATE;
    l_err_param   VARCHAR2(300);
    v_ftodate     VARCHAR2(20);
    l_custid     varchar2(20);
    v_strDesc     VARCHAR2(1000);
    v_strEN_Desc  VARCHAR2(1000);
    v_Whithdraw   NUMBER;

  BEGIN
    plog.setbeginsection(pkgctx, 'fn_txPreAppCheck');
    plog.debug(pkgctx, 'BEGIN OF fn_txPreAppCheck');
    /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/

    SELECT getbaldefovd(p_txmsg.txfields('03').value)
      INTO v_Whithdraw
    FROM dual;

    --TK phai co SDT moi dc dang ky
    SELECT COUNT(*)
      INTO v_counttele
    FROM afmast af, cfmast cf
    WHERE acctno = p_txmsg.txfields('03').value and af.custid = cf.custid
          AND cf.mobilesms IS NOT NULL;
    IF v_counttele = 0 THEN
      p_err_code := '-200089';
      RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    --Check trung loai hinh dang ky
    SELECT COUNT(*)
      INTO v_counttype
    FROM smstype
    WHERE actype = p_txmsg.txfields('08').value
       AND status = 'Y'
       AND apprv_sts = 'A';
    IF v_counttype = 0 THEN
      p_err_code := '-100303';
      RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    --Check tieu khoan phai luu ky tai Cty va hoat dong
    SELECT COUNT(*)
      INTO v_countaf
    FROM afmast af, cfmast cf
    WHERE af.custid = cf.custid
       AND af.status = 'A'
       --AND cf.isbanking = 'N'
       AND cf.custatcom = 'Y'
       AND af.acctno = p_txmsg.txfields('03').value;

    IF v_countaf = 0 THEN
      p_err_code := '-100305';
      RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    --Check TK chua dang ky moi dc dang ky moi
    SELECT COUNT(*)
      INTO v_count
    FROM afmast
    WHERE acctno = p_txmsg.txfields('03').value AND smstype IS NOT NULL;
    IF v_count > 0 THEN
      p_err_code := '-100302';
      RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    ----
    /*
    BEGIN
      SELECT SUM(sc.feeamt + sc.vatamt - sc.paidfeeamt - sc.paidvatamt)
        INTO v_totalfee
      FROM smsfeeschd sc
      WHERE sc.afacctno = p_txmsg.txfields('03').value
      GROUP BY sc.afacctno;
    EXCEPTION
      WHEN OTHERS THEN
        v_totalfee := 0;
    END;

    SELECT feeamt * (1 + (vat / 100))
      INTO v_feenew
      FROM smstype
     WHERE actype = p_txmsg.txfields('08').value;

    BEGIN
      SELECT feeamt, feeamt * (vat / 100), feeamt * (1 + (vat / 100))
        INTO v_feemax, v_vatmax, v_totalmax
        FROM smstype sm, afmast af
       WHERE sm.actype = af.psmstype
         AND acctno = p_txmsg.txfields('03').value;
    EXCEPTION
      WHEN OTHERS THEN
        v_feemax   := 0;
        v_vatmax   := 0;
        v_totalmax := 0;
    END;

    SELECT TRUNC(GETCURRDATE, 'MM') INTO v_tomon FROM DUAL;
    SELECT ADD_MONTHS(TO_DATE(v_tomon, 'DD/MM/RRRR'), 1) - 1
      INTO v_endmon
      FROM DUAL;
    --Ckeck so tien dc rut khi dang ky
    IF v_feenew > v_totalmax THEN
      IF v_totalfee > v_Whithdraw OR v_feenew - v_totalmax > v_Whithdraw THEN
        p_err_code := '-100304';
        RETURN errnums.C_BIZ_RULE_INVALID;
      END IF;
    ELSIF v_totalmax = 0 THEN
      IF v_Whithdraw < v_feenew THEN
        p_err_code := '-100304';
        RETURN errnums.C_BIZ_RULE_INVALID;
      END IF;
    END IF;
    */

    plog.debug(pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection(pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_txPreAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_txPreAppCheck;

  FUNCTION fn_txAftAppCheck(p_txmsg    in tx.msg_rectype,
                            p_err_code out varchar2) RETURN NUMBER IS
    l_txmsg       tx.msg_rectype;
    v_count       VARCHAR2(20);
    v_counttype   VARCHAR2(20);
    v_countaf     VARCHAR2(20);
    v_totalfee    NUMBER;
    v_feemax      NUMBER;
    v_totalmax    NUMBER;
    v_vatmax      NUMBER;
    v_feenew      NUMBER;
    l_txdesc      VARCHAR2(200);
    v_tomon       DATE;
    v_endmon      DATE;
    v_strCURRDATE DATE;
    l_err_param   VARCHAR2(300);
    v_ftodate     VARCHAR2(20);
    v_strDesc     VARCHAR2(1000);
    v_strEN_Desc  VARCHAR2(1000);
    v_Whithdraw   NUMBER;

  BEGIN
    plog.setbeginsection(pkgctx, 'fn_txAftAppCheck');
    plog.debug(pkgctx, '<<BEGIN OF fn_txAftAppCheck>>');
    /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
    /*
    SELECT getbaldefovd(p_txmsg.txfields('03').value)
      INTO v_Whithdraw
      FROM dual;

    BEGIN
      SELECT SUM(sc.feeamt + sc.vatamt - sc.paidfeeamt - sc.paidvatamt)
        INTO v_totalfee
        FROM smsfeeschd sc
       WHERE sc.afacctno = p_txmsg.txfields('03').value
       GROUP BY sc.afacctno;
    EXCEPTION
      WHEN OTHERS THEN
        v_totalfee := 0;
    END;

    SELECT feeamt * (1 + (vat / 100))
      INTO v_feenew
      FROM smstype
     WHERE actype = p_txmsg.txfields('08').value;

    BEGIN
      SELECT feeamt, feeamt * (vat / 100), feeamt * (1 + (vat / 100))
        INTO v_feemax, v_vatmax, v_totalmax
        FROM smstype sm, afmast af
       WHERE sm.actype = af.psmstype
         AND acctno = p_txmsg.txfields('03').value;
    EXCEPTION
      WHEN OTHERS THEN
        v_feemax   := 0;
        v_vatmax   := 0;
        v_totalmax := 0;
    END;
    IF v_feenew > v_totalmax THEN
      IF v_totalfee + v_feenew - v_totalmax > v_Whithdraw OR
         v_feenew - v_totalmax > v_Whithdraw THEN
        p_err_code := '-100304';
        RETURN errnums.C_BIZ_RULE_INVALID;
      END IF;
    ELSIF v_totalmax = 0 THEN
      IF v_Whithdraw < v_feenew THEN
        p_err_code := '-100304';
        RETURN errnums.C_BIZ_RULE_INVALID;
      END IF;
    END IF;
    */

    plog.debug(pkgctx, '<<END OF fn_txAftAppCheck>>');
    plog.setendsection(pkgctx, 'fn_txAftAppCheck');
    RETURN systemnums.C_SUCCESS;
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_txAftAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_txAftAppCheck;

  FUNCTION fn_txPreAppUpdate(p_txmsg    in tx.msg_rectype,
                             p_err_code out varchar2) RETURN NUMBER IS
  BEGIN
    plog.setbeginsection(pkgctx, 'fn_txPreAppUpdate');
    plog.debug(pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
    /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    plog.debug(pkgctx, '<<END OF fn_txPreAppUpdate');
    plog.setendsection(pkgctx, 'fn_txPreAppUpdate');
    RETURN systemnums.C_SUCCESS;
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_txPreAppUpdate;

  FUNCTION fn_txAftAppUpdate(p_txmsg    in tx.msg_rectype,
                             p_err_code out varchar2) RETURN NUMBER IS
    v_feemax   NUMBER;
    v_fee      NUMBER;
    v_feenew   NUMBER;
    v_tomon    DATE;
    v_endmon   DATE;
    v_totalnew NUMBER;
    v_vatnew   NUMBER;
    v_totalmax NUMBER;
    v_vatmax   NUMBER;
    v_count    VARCHAR2(20);
    l_txdesc   VARCHAR2(500);

    l_txmsg       tx.msg_rectype;
    v_counttype   VARCHAR2(20);
    v_counttele   VARCHAR2(20);
    v_countaf     VARCHAR2(20);
    v_totalfee    NUMBER;
    v_strCURRDATE DATE;
    l_err_param   VARCHAR2(300);
    v_ftodate     VARCHAR2(20);
    v_strDesc     VARCHAR2(1000);
    v_strEN_Desc  VARCHAR2(1000);
    v_Whithdraw   NUMBER;

    v_mobile      varchar2(20);
    v_template_id varchar2(4) := '0324';
    v_data        varchar2(250);
    l_custid      varchar2(10);

  BEGIN
    plog.setbeginsection(pkgctx, 'fn_txAftAppUpdate');
    plog.debug(pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
    /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    -- PHS ko thu ngay --> bo doan nay di
    /*
    SELECT getbaldefovd(p_txmsg.txfields('03').value)
      INTO v_Whithdraw
      FROM dual;

    SELECT to_date(varvalue, 'DD/MM/RRRR')
      INTO v_strCURRDATE
      FROM sysvar
     WHERE grname = 'SYSTEM'
       AND varname = 'CURRDATE';

    BEGIN
      SELECT SUM(sc.feeamt + sc.vatamt - sc.paidfeeamt - sc.paidvatamt)
        INTO v_totalfee
        FROM smsfeeschd sc
       WHERE sc.afacctno = p_txmsg.txfields('03').value
       GROUP BY sc.afacctno;
    EXCEPTION
      WHEN OTHERS THEN
        v_totalfee := 0;
    END;


    IF v_totalfee > 0 THEN
      FOR rec IN (SELECT *
                    FROM smsfeeschd sc
                   WHERE afacctno = p_txmsg.txfields('03').value
                     AND (sc.feeamt + sc.vatamt - sc.paidfeeamt -
                         sc.paidvatamt) > 0
                     AND deltd <> 'Y') LOOP
        -- goi den giao dich 1184
        l_txmsg.msgtype := 'T';
        l_txmsg.local   := 'N';
        l_txmsg.tlid    := systemnums.c_system_userid;
        plog.debug(pkgctx, 'l_txmsg.tlid' || l_txmsg.tlid);
        SELECT SYS_CONTEXT('USERENV', 'HOST'),
               SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15)
          INTO l_txmsg.wsname, l_txmsg.ipaddress
          FROM DUAL;
        l_txmsg.off_line  := 'N';
        l_txmsg.deltd     := txnums.c_deltd_txnormal;
        l_txmsg.txstatus  := txstatusnums.c_txcompleted;
        l_txmsg.msgsts    := '0';
        l_txmsg.ovrsts    := '0';
        l_txmsg.batchname := '';
        l_txmsg.txdate    := P_TXMSG.txdate;
        l_txmsg.busdate   := P_TXMSG.BUSDATE;
        l_txmsg.tltxcd    := '1184';

        SELECT TXDESC, EN_TXDESC
          into v_strDesc, v_strEN_Desc
          FROM TLTX
         WHERE TLTXCD = '1184';

        SELECT to_Char(rec.todate, 'MM/RRRR') INTO v_ftodate FROM dual;
        plog.debug(pkgctx,
                   'Loop for account:' || rec.afacctno || ' ngay' ||
                   v_strCURRDATE);
        SELECT systemnums.C_BATCH_PREFIXED ||
               LPAD(seq_BATCHTXNUM.NEXTVAL, 8, '0')
          INTO l_txmsg.txnum
          FROM DUAL;
        l_txmsg.brid := substr(rec.afACCTNO, 1, 4);

        --Set cac field giao dich
        --03  ACCTNO      C
        l_txmsg.txfields('03').defname  := 'ACCTNO';
        l_txmsg.txfields('03').TYPE     := 'C';
        l_txmsg.txfields('03').VALUE    := rec.afacctno;
        --10  FEEAMT      N
        l_txmsg.txfields('10').defname  := 'FEEAMT';
        l_txmsg.txfields('10').TYPE     := 'N';
        l_txmsg.txfields('10').VALUE    := REC.FEEAMT;
        --11  VATAMT      N
        l_txmsg.txfields('11').defname  := 'VATAMT';
        l_txmsg.txfields('11').TYPE     := 'N';
        l_txmsg.txfields('11').VALUE    := REC.VATAMT;
        --07  FTODATE      N
        l_txmsg.txfields('07').defname  := 'FTODATE';
        l_txmsg.txfields('07').TYPE     := 'C';
        l_txmsg.txfields('07').VALUE    := v_ftodate;
        --30    DESC        C
        l_txmsg.txfields('30').defname  := 'DESC';
        l_txmsg.txfields('30').TYPE     := 'C';
        l_txmsg.txfields('30').VALUE    := v_strDesc || ' ' || to_char(rec.TODATE, 'MM/RRRR');

        BEGIN
          IF TXPKS_#5503.fn_batchtxprocess(l_txmsg, p_err_code, l_err_param) <>
             systemnums.c_success THEN
            plog.debug(pkgctx, 'got error 5504: ' || p_err_code);
            plog.setendsection(pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
          END IF;
        END;

        UPDATE smsfeeschd
           SET paidfeeamt = rec.feeamt,
               paidvatamt = rec.vatamt,
               paidtxdate = p_txmsg.txdate,
               paidtxnum  = p_txmsg.txnum
         WHERE DELTD <> 'Y'
           AND AFACCTNO = rec.afacctno
           AND TODATE = rec.TODATE;
        UPDATE CIMAST
           SET SMSFEEAMT = SMSFEEAMT - rec.feeamt - rec.vatamt
         WHERE ACCTNO = p_txmsg.txfields('03').VALUE;

      END LOOP;
    END IF;
    */

    /*
    BEGIN
      SELECT feeamt + feeamt * (1 + (vat / 100))
        INTO v_fee
      FROM smstype sm, afmast af
      WHERE sm.actype = af.smstype AND acctno = p_txmsg.txfields('03').value;
    EXCEPTION
      WHEN OTHERS THEN
        v_fee := 0;
    END;

    BEGIN
      SELECT feeamt, feeamt * (vat / 100), feeamt * (1 + (vat / 100))
        INTO v_feemax, v_vatmax, v_totalmax
        FROM smstype sm, afmast af
      WHERE sm.actype = af.psmstype
            AND acctno = p_txmsg.txfields('03').value;
    EXCEPTION
      WHEN OTHERS THEN
        v_feemax   := 0;
        v_vatmax   := 0;
        v_totalmax := 0;
    END;

    SELECT TRUNC(GETCURRDATE, 'MM') INTO v_tomon FROM DUAL;
    SELECT ADD_MONTHS(TO_DATE(v_tomon, 'DD/MM/RRRR'), 1) - 1
      INTO v_endmon
      FROM DUAL;

    SELECT feeamt, feeamt * (vat / 100), feeamt * (1 + (vat / 100))
      INTO v_feenew, v_vatnew, v_totalnew
      FROM smstype
     WHERE actype = p_txmsg.txfields('08').value;

    IF v_feenew > v_feemax THEN
      INSERT INTO smsfeeschd
        (AUTOID,
         TXDATE,
         AFACCTNO,
         FRDATE,
         TODATE,
         FEEAMT,
         VATAMT,
         PAIDFEEAMT,
         PAIDVATAMT,
         PAIDTXDATE,
         PAIDTXNUM,
         DELTD,
         TXNUM,
         smstype)
      VALUES
        (seq_smsfeeschd.nextval,
         getcurrdate,
         p_txmsg.txfields('03').value,
         TO_DATE(v_tomon, 'DD/MM/RRRR'),
         TO_DATE(v_endmon, 'DD/MM/RRRR'),
         v_feenew - v_feemax,
         v_vatnew - v_vatmax,
         v_feenew - v_feemax,
         v_vatnew - v_vatmax,
         TO_DATE(getcurrdate, 'DD/MM/RRRR'),
         p_txmsg.txnum,
         'N',
         p_txmsg.txnum,
         p_txmsg.txfields('08').value);
      UPDATE afmast
         SET psmstype = p_txmsg.txfields('08').value
       WHERE acctno = p_txmsg.txfields('03').value
         AND psmstype IS NOT NULL;
      UPDATE cimast
         SET balance     = balance - (v_totalnew - v_totalmax),
             LASTDATE    = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
             LAST_CHANGE = SYSTIMESTAMP
       WHERE afacctno = p_txmsg.txfields('03').value;

      l_txdesc:= 'Thu phi SMS thang ' || to_char(getcurrdate,'MM/YYYY') ;

      INSERT INTO CITRAN
        (TXNUM,
         TXDATE,
         ACCTNO,
         TXCD,
         NAMT,
         CAMT,
         ACCTREF,
         DELTD,
         REF,
         AUTOID,
         TLTXCD,
         BKDATE,
         TRDESC)
      VALUES
        (p_txmsg.txnum,
         TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
         p_txmsg.txfields('03').value,
         '0028',
         ROUND(v_feenew - v_feemax, 0) + ROUND(v_vatnew - v_vatmax, 0),
         NULL,
         '',
         p_txmsg.deltd,
         '',
         seq_CITRAN.NEXTVAL,
         p_txmsg.tltxcd,
         p_txmsg.busdate,
         '' || l_txdesc || '');
    END IF;
    */

    -- 27/02/2015 TruongLD Add
    -- Tinh so tien phi phai thu
    Begin
        SELECT feeamt, feeamt * (vat / 100), feeamt * (1 + (vat / 100))
        INTO v_feenew, v_vatnew, v_totalnew
        FROM smstype
        WHERE actype = p_txmsg.txfields('08').value;
    EXCEPTION
        WHEN OTHERS THEN
            v_feenew := 0;
            v_vatnew := 0;
            v_totalnew :=0;
    END;

    Select custid into l_custid from afmast where acctno = p_txmsg.txfields('03').value;

    Begin
        for rec in
        (
            Select * from afmast where custid =  l_custid
        ) Loop
            UPDATE afmast
                SET smstype = p_txmsg.txfields('08').value
            WHERE acctno = rec.acctno;--p_txmsg.txfields('03').value;

            INSERT INTO smsregislog(AUTOID, TXDATE, AFACCTNO, SMSTYPE, ACTION, TXNUM, FEEAMT)
            VALUES(seq_smsregislog.NEXTVAL, TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                    rec.acctno,--p_txmsg.txfields('03').value,
                    p_txmsg.txfields('08').value,'ADD', p_txmsg.txnum, v_feenew);
        End Loop;
    End;


    /*
    select custid into l_custid from afmast where acctno = p_txmsg.txfields('03').value;

    FOR rec IN (SELECT *
                  FROM smstyplnk
                 WHERE actype = p_txmsg.txfields('08').value
               ) LOOP
                  INSERT INTO AFTEMPLATES
                    (AUTOID, CUSTID, TEMPLATE_CODE)
                  VALUES
                    (seq_aftemplates.NEXTVAL, l_custid, rec.code);
    END LOOP;
    */




    --------------------------------------
    --Gui SMS thong bao dang ky thanh cong
    --------------------------------------

    -- Lay thong tin khach hang
    -- plog.error(pkgctx, p_txmsg.txfields(c_acctno).value);
    -- 07/09/2015, TruongLD Add --> Khong can gui Email/Sms khi dang ky thanh cong
    /*begin
      select cf.mobilesms
        into v_mobile
        from afmast af, cfmast cf
       where cf.custid = af.custid and acctno = p_txmsg.txfields(c_acctno).value;

      v_data := 'SELECT ''' || p_txmsg.txfields(c_custodycd).value || ', ' || p_txmsg.txfields(c_acctno)
               .value || ' da dang ky thanh cong dich vu nhan tin nhan SMS. Phi SMS ' ||
               ltrim(replace(to_char(v_totalnew,
                                                '9,999,999,999,999'),
                                        ',',
                                        '.')) || ' VND/thang' ||
                ''' detail from dual';

      --plog.error(pkgctx, v_data);

      nmpks_ems.insertemaillog(p_email       => v_mobile,
                               p_template_id => v_template_id,
                               p_data_source => v_data,
                               p_account     => p_txmsg.txfields(c_acctno)
                                                .value);

    exception
      when others then
        plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
    end;*/
    --End TruongLD

    plog.debug(pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection(pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
  EXCEPTION
    WHEN OTHERS THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection(pkgctx, 'fn_txAftAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
  END fn_txAftAppUpdate;

BEGIN
  FOR i IN (SELECT * FROM tlogdebug) LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;
  pkgctx := plog.init('TXPKS_#0043EX',
                      plevel         => NVL(logrow.loglevel, 30),
                      plogtable      => (NVL(logrow.log4table, 'N') = 'Y'),
                      palert         => (NVL(logrow.log4alert, 'N') = 'Y'),
                      ptrace         => (NVL(logrow.log4trace, 'N') = 'Y'));
END TXPKS_#0043EX;
/
