SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1400ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1400EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      28/11/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1400ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;
   c_crphysagreeid    CONSTANT CHAR(2) := '88';
   c_referenceid      CONSTANT CHAR(2) := '02';
   c_appendixno       CONSTANT CHAR(2) := '35';
   c_appendixname     CONSTANT CHAR(2) := '32';
   c_effdate          CONSTANT CHAR(2) := '05';
   c_custodycd        CONSTANT CHAR(2) := '03';
   c_codeid           CONSTANT CHAR(2) := '04';
   c_symbol           CONSTANT CHAR(2) := '33';
   c_issuername       CONSTANT CHAR(2) := '34';
   c_buyparty         CONSTANT CHAR(2) := '18';
   c_bank             CONSTANT CHAR(2) := '27';
   c_custodycdbuy     CONSTANT CHAR(2) := '07';
   c_fullnamebuy      CONSTANT CHAR(2) := '09';
   c_qtty             CONSTANT CHAR(2) := '12';
   c_aqtty            CONSTANT CHAR(2) := '13';
   c_int              CONSTANT CHAR(2) := '15';
   c_salevalue        CONSTANT CHAR(2) := '17';
   c_feeamt           CONSTANT CHAR(2) := '10';
   c_vat              CONSTANT CHAR(2) := '14';
   c_netamount        CONSTANT CHAR(2) := '11';
   c_setdate          CONSTANT CHAR(2) := '38';
   --BEGIN OF NAM.LY 13-01-2020
   c_taxableparty     CONSTANT CHAR(2) := '19';
   c_deductionplace   CONSTANT CHAR(2) := '20';
   --END OF NAM.LY 13-01-2020
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    v_index number;
    v_count number;
    l_semastcheck_arr txpks_check.semastcheck_arrtype;
    l_STATUS        varchar2(100);
    l_seacctno      varchar2(100);
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
    select NVL(instr(p_txmsg.txfields(c_custodycdbuy).value, 'SHV'),0) into v_index from dual;
    select count(*) into v_count from cfmast where custodycd = p_txmsg.txfields(c_custodycdbuy).value;
    if p_txmsg.txfields(c_buyparty).value = 'OC' and p_txmsg.txfields(c_fullnamebuy).value is null then
        p_err_code:= -911006;
        
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        Return errnums.C_BIZ_RULE_INVALID;
    end if;
    if  p_txmsg.txfields(c_buyparty).value = 'OC' and v_index = '1' and v_count = 0 then
        p_err_code:= -911003;
        
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        Return errnums.C_BIZ_RULE_INVALID;
    end if;

    BEGIN
        SELECT AF.ACCTNO || p_txmsg.txfields(c_codeid).value
            INTO l_seacctno
        FROM CFMAST CF, AFMAST AF
        WHERE CF.custid = AF.custid AND CUSTODYCD = p_txmsg.txfields('07').value;
        EXCEPTION WHEN OTHERS THEN l_seacctno := NULL;
    END;
    IF l_seacctno IS NOT NULL THEN
        l_SEMASTcheck_arr := txpks_check.fn_SEMASTcheck(l_seacctno,'SEMAST','ACCTNO');
        l_STATUS := l_SEMASTcheck_arr(0).STATUS;
        IF NOT ( INSTR('A',l_STATUS) > 0) THEN
            p_err_code := '-900019';
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
v_autoid         VARCHAR2(10);
--BEGIN OF NAM.LY 13-01-2020
v_check_custody  VARCHAR2(10);
v_check_semast   NUMBER(1) := 0;
v_custid_buy     CFMAST.CUSTID%TYPE;
v_acctno_buy     SEMAST.ACCTNO%TYPE;
v_actype_buy     SEMAST.ACTYPE%TYPE;
l_sellseacctno   SEMAST.AFACCTNO%TYPE;
l_buyseacctno    SEMAST.AFACCTNO%TYPE;
l_bankacctno     DDMAST.REFCASAACCT%TYPE;
v_custid         varchar2(20);
--END OF NAM.LY 13-01-2020
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    --BEGIN OF NAM.LY 13-01-2020
    -- Lay TK CK MUA
    BEGIN
        SELECT af.acctno || p_txmsg.txfields(c_codeid).value, p_txmsg.txfields(c_bank).value
            INTO l_buyseacctno, v_check_custody
        FROM cfmast cf, afmast af
        WHERE cf.custid = af.custid AND cf.custodycd = p_txmsg.txfields(c_custodycdbuy).value;
    EXCEPTION
        WHEN OTHERS
           THEN
            l_buyseacctno :='';
            v_check_custody := '';
    END;
    BEGIN
        SELECT CF.CUSTID INTO V_CUSTID FROM CFMAST CF WHERE CF.CUSTODYCD = p_txmsg.txfields(c_custodycd).value;
    END;
    -- Lay TK CK BAN
    SELECT acctno || codeid INTO l_sellseacctno
    FROM crphysagree WHERE  crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
    --
    IF p_txmsg.deltd <> 'Y' THEN



        --GHI NHAN THUE cho tk ban
/*      --NAM.LY CHUYEN GHI NHAN THUE CHO TK BAN TU GD 1400 SANG GD 1402
        v_autoid := seq_feetran.nextval;
        insert into feetran (TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE
                 , VATAMT, AUTOID, TRDESC, CCYCD, ORDERID
                 , TYPE, DEDUCTEDPLACE, STATUS, PAIDDATE, PSTATUS, SUBTYPE, FEETYPES, CUSTODYCD)
        values (p_txmsg.txdate, p_txmsg.txnum, 'N', null, null , p_txmsg.txfields(c_salevalue).value, 0.0000, 0.0000, ROUND(p_txmsg.txfields(c_vat).value/p_txmsg.txfields(c_salevalue).value,4)
                   , p_txmsg.txfields(c_vat).value, v_autoid,'Tax of '|| 'Order selling physical', 'VND', null
                   , 'T', 'CTCK', 'N', null, null, null, null, p_txmsg.txfields(c_custodycd).value);
        insert into feetrandetail (AUTOID, REFID, TXDATE, TXNUM, SUBTYPE, FEETYPES, TXAMT, FEEAMT, ORDERID, CUSTODYCD, CCYCD, RATEAMT, FORP, CODEID, SEBAL, ASSET)
        values (seq_feetrandetail.nextval, v_autoid, p_txmsg.txdate, p_txmsg.txnum, null, null, p_txmsg.txfields(c_salevalue).value, 0.0000, null, p_txmsg.txfields(c_custodycd).value, 'VND', p_txmsg.txfields(c_vat).value, 'T', p_txmsg.txfields(c_codeid).value, 0, 0);*/
        -----------------------------------------
        BEGIN
            SELECT REFCASAACCT INTO l_bankacctno FROM DDMAST WHERE ISDEFAULT = 'Y' AND CUSTODYCD = p_txmsg.txfields(c_custodycd).value;
            EXCEPTION
                WHEN OTHERS
                   THEN
                    l_bankacctno :='';
        END;
        v_autoid := SEQ_APPENDIX.NEXTVAL;
        INSERT INTO APPENDIX (AUTOID, BANKACCTNO, BANKCODE, BUYPARTY
                            , DESCRIPTION, EFFDATE, NAME, NO, CRPHYSAGREEID, AQTTY, CLVALUE, ACCTNO, CODEID,STATUS, TXNUM, TXDATE
                            , TAXABLEPARTY, DEDUCTIONPLACE)
            VALUES (v_autoid,l_bankacctno ,'Shinhan bank Vietnam' , p_txmsg.txfields(c_buyparty).value
                  , null, TO_DATE( p_txmsg.txfields(c_effdate).value,systemnums.C_DATE_FORMAT)
                  , p_txmsg.txfields(c_appendixname).value, p_txmsg.txfields(c_appendixno).value
                  , p_txmsg.txfields(c_crphysagreeid).value, p_txmsg.txfields(c_aqtty).value
                  , p_txmsg.txfields(c_netamount).value, null,p_txmsg.txfields(c_codeid).value,'P', p_txmsg.txnum,TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)
                  , p_txmsg.txfields(c_taxableparty).value, p_txmsg.txfields(c_deductionplace).value);

        --trung.luu: 02-07-2020 log lai de len view physical
        --bao.nguyen: 25-07-2022 SHBVNEX-2730
       insert into CRPHYSAGREE_LOG_ALL (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC,CITAD,TLTXCD,FEETYPE,SYMBOL,CUSTODYCD,
                Beneficiary_Name,Beneficiary_account,VAT,TAXABLEPARTY -- ben chiu thue
                ,DEDUCTIONPLACE-- noi khau tru thue
                ,typedoc, custid
        )
       values (p_txmsg.txdate, p_txmsg.txnum,'BP',v_autoid ,p_txmsg.txfields(c_crphysagreeid).value, p_txmsg.txfields(c_netamount).value, p_txmsg.txfields(c_netamount).value, p_txmsg.txfields('12').value, p_txmsg.txfields('13').value, 'A', 'N',p_txmsg.txfields('30').value,null,p_txmsg.tltxcd,null,p_txmsg.txfields('33').value,p_txmsg.txfields('03').value,
                p_txmsg.txfields('09').value,p_txmsg.txfields('07').value,p_txmsg.txfields('14').value,p_txmsg.txfields('19').value,
                p_txmsg.txfields('20').value,
                '1400', v_custid
        );

        --
        INSERT INTO crphysagree_sell_log (TXDATE, TXNUM, CRPHYSAGREEID, APPENDIXID, BUYMEMBER
        , BUYCUSTODYCD, FULLNAME, REMQTTY, QTTY
        , INTERESTRATE, AMT, FEE, TAX, NETAMT, SELLDATE, STATUS, CUSTID)
            VALUES (p_txmsg.txdate, p_txmsg.txnum, p_txmsg.txfields(c_crphysagreeid).value, v_autoid, p_txmsg.txfields(c_bank).value
            , p_txmsg.txfields(c_custodycdbuy).value, p_txmsg.txfields(c_fullnamebuy).value, p_txmsg.txfields(c_qtty).value, p_txmsg.txfields(c_aqtty).value
            , p_txmsg.txfields(c_int).value, p_txmsg.txfields(c_salevalue).value, p_txmsg.txfields(c_feeamt).value, p_txmsg.txfields(c_vat).value, p_txmsg.txfields(c_netamount).value, TO_DATE( p_txmsg.txfields(c_setdate).value,systemnums.C_DATE_FORMAT), 'P', v_custid);

        -- Xu ly cho  TK BAN
        UPDATE semast se
        SET se.trade = se.trade - p_txmsg.txfields(c_aqtty).value,
            se.netting = se.netting + p_txmsg.txfields(c_aqtty).value
        WHERE se.acctno = l_sellseacctno;
        --
        INSERT INTO SETRAN (TXNUM, TXDATE, ACCTNO, TXCD, NAMT, CAMT, REF, DELTD, AUTOID, ACCTREF, TLTXCD, BKDATE, TRDESC)
        VALUES (p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT), l_sellseacctno, '0011', p_txmsg.txfields(c_aqtty).value, null, null, 'N', seq_setran.nextval, null, p_txmsg.tltxcd, to_date(p_txmsg.busdate, systemnums.C_DATE_FORMAT), null);
        --
        INSERT INTO SETRAN (TXNUM, TXDATE, ACCTNO, TXCD, NAMT, CAMT, REF, DELTD, AUTOID, ACCTREF, TLTXCD, BKDATE, TRDESC)
        VALUES (p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT), l_sellseacctno, '0019', p_txmsg.txfields(c_aqtty).value, null, null, 'N', seq_setran.nextval, null, p_txmsg.tltxcd, to_date(p_txmsg.busdate, systemnums.C_DATE_FORMAT), null);
        --
        UPDATE crphysagree cr
            set cr.reqtty = cr.reqtty + p_txmsg.txfields(c_aqtty).value
        WHERE cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
        -- Xu ly cho TK MUA luu ky tai SHV
        IF v_check_custody = 'SHV' THEN
            BEGIN
                UPDATE SEMAST SE
                    SET
                        SE.RECEIVING = SE.RECEIVING + p_txmsg.txfields(c_aqtty).value
                WHERE SE.ACCTNO = l_buyseacctno;
                --
                INSERT INTO SETRAN (TXNUM, TXDATE, ACCTNO, TXCD, NAMT, CAMT, REF, DELTD, AUTOID, ACCTREF, TLTXCD, BKDATE, TRDESC)
                VALUES (p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT), l_buyseacctno, '0016', p_txmsg.txfields(c_aqtty).value, null, null, 'N', seq_setran.nextval, null, p_txmsg.tltxcd, to_date(p_txmsg.busdate, systemnums.C_DATE_FORMAT), null);
            END;
        END IF;
    ELSE
        DELETE FROM APPENDIX WHERE TXNUM = p_txmsg.txnum AND TXDATE =TO_DATE(p_txmsg.txdate, systemnums.c_date_format);
        DELETE FROM CRPHYSAGREE_SELL_LOG WHERE TXNUM = p_txmsg.txnum AND TXDATE =TO_DATE(p_txmsg.txdate, systemnums.c_date_format);
        UPDATE CRPHYSAGREE CR
            SET CR.REQTTY = REQTTY- p_txmsg.txfields(c_aqtty).VALUE
        WHERE CR.CRPHYSAGREEID = p_txmsg.txfields(c_crphysagreeid).VALUE;
        --
        UPDATE SETRAN
            SET DELTD = 'Y'
        WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
        --
        UPDATE SEMAST SE
                    SET
                        SE.RECEIVING = SE.RECEIVING + p_txmsg.txfields(c_aqtty).value
                WHERE SE.ACCTNO = l_buyseacctno;
        --
        UPDATE SEMAST SE
        SET SE.TRADE = SE.TRADE + p_txmsg.txfields(c_aqtty).VALUE,
            SE.NETTING = SE.NETTING - p_txmsg.txfields(c_aqtty).VALUE
        WHERE SE.ACCTNO = l_sellseacctno;
        --
        IF v_check_custody = 'SHV' THEN
            Update SEMAST SET RECEIVING = RECEIVING - p_txmsg.txfields(c_qtty).value WHERE ACCTNO = l_buyseacctno;
        END IF;
    END IF;
    --END OF NAM.LY 13-01-2020
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
         plog.init ('TXPKS_#1400EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1400EX;
/
