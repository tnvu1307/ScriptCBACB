SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1402ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1402EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      02/12/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1402ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;
   c_appendixid       CONSTANT CHAR(2) := '88';
   c_custodycd        CONSTANT CHAR(2) := '18';
   c_symbol           CONSTANT CHAR(2) := '33';
   c_codeid           CONSTANT CHAR(2) := '01';
   c_paymentstatus    CONSTANT CHAR(2) := '32';
   c_desc             CONSTANT CHAR(2) := '30';
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
V_APPENDIXID     NUMBER;
V_PAYMENTSTATUS  VARCHAR2(5);
V_CRPHYSAGREEID  VARCHAR2(10);
--BEGIN OF NAM.LY 10-03-2020
V_TAXABLEPARTY   VARCHAR2(3);
V_DEDUCTIONPLACE VARCHAR2(3);
V_AUTOID         VARCHAR2(10);
V_VAT            NUMBER(20,4);
V_SALEVALUE      NUMBER(20,4);
V_CUSTODYCDSELL  VARCHAR2(20);
V_CODEID         VARCHAR2(20);
v_sellqtty      number;
v_amt number;
 V_DESC           VARCHAR2(500);
 V_SYMBOL         VARCHAR2(500);
--END OF NAM.LY 10-03-2020
v_custid         varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    BEGIN
        SELECT CF.CUSTID INTO V_CUSTID FROM CFMAST CF WHERE CF.CUSTODYCD = p_txmsg.txfields(c_custodycd).value;
    END;
    V_APPENDIXID    := p_txmsg.txfields(c_appendixid).value;
    V_PAYMENTSTATUS := p_txmsg.txfields(c_paymentstatus).value;

    IF p_txmsg.deltd <> 'Y' then
        UPDATE APPENDIX AP SET AP.STATUS = V_PAYMENTSTATUS
        WHERE AP.AUTOID = V_APPENDIXID;
        --
        BEGIN
            SELECT CR.CRPHYSAGREEID, CR.TAXABLEPARTY, CR.DEDUCTIONPLACE,aqtty INTO V_CRPHYSAGREEID, V_TAXABLEPARTY, V_DEDUCTIONPLACE,v_sellqtty
            FROM APPENDIX CR
            WHERE CR.AUTOID = V_APPENDIXID;
            EXCEPTION WHEN OTHERS THEN V_TAXABLEPARTY   := '';
                                       V_DEDUCTIONPLACE := '';
                                       v_sellqtty:= 0;
        END;
        --
        UPDATE CRPHYSAGREE CR SET CR.PAYSTATUS = V_PAYMENTSTATUS
        WHERE CR.CRPHYSAGREEID = V_CRPHYSAGREEID;
        --GHI NHAN THUE cho tk ban
        --NAM.LY 10/03/2020: CHUYEN GHI NHAN THUE CHO TK BAN TU GD 1400 SANG GD 1402
        BEGIN
            --LAY THONG TIN PHI THUE CUA PHU LUC
            SELECT CL.TAX, CL.NETAMT, CR.CUSTODYCD, CR.CODEID,cl.amt
            INTO V_VAT, V_SALEVALUE, V_CUSTODYCDSELL, V_CODEID,v_amt
            FROM CRPHYSAGREE_SELL_LOG CL, CRPHYSAGREE CR
            WHERE CL.CRPHYSAGREEID = CR.CRPHYSAGREEID AND CL.APPENDIXID = V_APPENDIXID;
            EXCEPTION WHEN OTHERS THEN V_VAT   := '0.0000';
                                       V_SALEVALUE := '0.0000';
                                       V_CUSTODYCDSELL := '';
                                       v_amt:=0;
        END;

        V_DESC := 'FCT_Securities transferring_' || V_SYMBOL || '_original amount: VND ' || TO_CHAR(V_VAT, 'FM999,999,999,999,990');

        if V_SALEVALUE = 0 then
            p_err_code := '-912000'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
         --trung.luu: 02-07-2020 log lai de len view physical/ xac nhan thanh toan physical
         --bao.nguyen: 25-07-2022 SHBVNEX-2730
       insert into CRPHYSAGREE_LOG_ALL (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC,CITAD,TLTXCD,FEETYPE,SYMBOL,CUSTODYCD,
                VAT,TAXABLEPARTY -- ben chiu thue
                ,DEDUCTIONPLACE-- noi khau tru thue
                ,typedoc, CUSTID
        )
       values (p_txmsg.txdate, p_txmsg.txnum,'XNP',V_APPENDIXID ,null, v_amt, v_amt, v_sellqtty, v_sellqtty, 'A', 'N',p_txmsg.txfields('30').value,null,p_txmsg.tltxcd,null,p_txmsg.txfields('33').value,p_txmsg.txfields('18').value,
                V_VAT,V_TAXABLEPARTY,
                V_DEDUCTIONPLACE,
                '1400', V_CUSTID
        );

        V_AUTOID := SEQ_FEETRAN.NEXTVAL;
        INSERT INTO FEETRAN (TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE, VATAMT, AUTOID, TRDESC, CCYCD, ORDERID, TYPE, DEDUCTEDPLACE, STATUS, PAIDDATE, PSTATUS, SUBTYPE, FEETYPES, CUSTODYCD)
        VALUES (P_TXMSG.TXDATE, P_TXMSG.TXNUM, 'N', NULL, NULL , V_SALEVALUE, 0.0000, 0.0000, ROUND(V_VAT/V_SALEVALUE,4), V_VAT, V_AUTOID, V_DESC, 'VND', NULL, 'T', 'CTCK', 'N', NULL, NULL, NULL, NULL, V_CUSTODYCDSELL);

        INSERT INTO FEETRANDETAIL (AUTOID, REFID, TXDATE, TXNUM, SUBTYPE, FEETYPES, TXAMT, FEEAMT, ORDERID, CUSTODYCD, CCYCD, RATEAMT, FORP, CODEID, SEBAL, ASSET)
        VALUES (SEQ_FEETRANDETAIL.NEXTVAL, V_AUTOID, P_TXMSG.TXDATE, P_TXMSG.TXNUM, NULL, NULL, V_SALEVALUE, 0.0000, NULL, V_CUSTODYCDSELL, 'VND', V_VAT, 'T', V_CODEID, 0, 0);
        --BOOK THUE CHO BEN BANK
        IF (V_TAXABLEPARTY = '002' AND V_DEDUCTIONPLACE = '001') THEN
                sp_gen_taxinvoice(p_txmsg.txdate,p_txmsg.txnum);
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
         plog.init ('TXPKS_#1402EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1402EX;
/
