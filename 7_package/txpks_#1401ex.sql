SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1401ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1401EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      03/12/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1401ex
 IS
    pkgctx   plog.log_ctx;
    logrow   tlogdebug%ROWTYPE;
    c_crphysagreeid    CONSTANT CHAR(2) := '88';
    c_custodycd        CONSTANT CHAR(2) := '18';
    c_symbol           CONSTANT CHAR(2) := '33';
    c_codeid           CONSTANT CHAR(2) := '01';
    c_citad            CONSTANT CHAR(2) := '06';
    c_bankcode         CONSTANT CHAR(2) := '32';
    c_bname            CONSTANT CHAR(2) := '34';
    c_bankacctno       CONSTANT CHAR(2) := '02';
    c_clvalue          CONSTANT CHAR(2) := '55';
    c_remamt           CONSTANT CHAR(2) := '09';
    c_ccyname          CONSTANT CHAR(2) := '35';
    c_faceamt          CONSTANT CHAR(2) := '12';
    c_amt              CONSTANT CHAR(2) := '10';
    c_desc             CONSTANT CHAR(2) := '30';
    --BEGIN OF NAM.LY 15-01-2020
    c_tltxcd           CONSTANT CHAR(2) := '03';
    --END OF NAM.LY 15-01-2020
 FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
 RETURN NUMBER
 IS
 v_balance number(20,4);
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
     BEGIN
         select dd.balance into v_balance from ddmast dd where dd.custodycd = p_txmsg.txfields(c_custodycd).value and status <> 'C' and dd.isdefault = 'Y';
     EXCEPTION
     WHEN OTHERS THEN v_balance := 0;
     END;
     if to_number(p_txmsg.txfields(c_amt).value) > v_balance then
         p_err_code:= -400101;
         
         plog.setendsection (pkgctx, 'fn_txPreAppCheck');
         Return errnums.C_BIZ_RULE_INVALID;
     end if;
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
     if p_txmsg.txfields(c_citad).value is not null then
         if p_txmsg.txstatus = 0  and p_txmsg.deltd <> 'Y' then --cho duyet
           pck_bankapi.Checkblacklist( p_txmsg.txfields(c_bname).value,p_txmsg.txnum,p_txmsg.txdate,p_txmsg.tlid,'',p_err_code);
         end if;
     end if;
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
 v_balance number(20,4);
 BEGIN
     plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
     plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
    /***************************************************************************************************
     ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
     ***************************************************************************************************/
     BEGIN
         select dd.balance into v_balance from ddmast dd where dd.custodycd = p_txmsg.txfields(c_custodycd).value and status <> 'C' and dd.isdefault = 'Y';
     EXCEPTION
     WHEN OTHERS THEN v_balance := 0;
     END;
     if to_number(p_txmsg.txfields(c_amt).value) > v_balance  then
         p_err_code:= -400101;
         
         plog.setendsection (pkgctx, 'fn_txPreAppCheck');
         Return errnums.C_BIZ_RULE_INVALID;
     end if;
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
 l_trfcode          varchar(100);
 l_ddacctno         varchar2(40);
 l_sumamt           number(20,4);
 l_clvalue          number(20,4);
 l_custatcom        varchar2(3);
 l_BANKACC          varchar2(30);
 l_bankname         varchar(500);
 l_bname            varchar(500);
 l_ciaccount        varchar(100);
 l_ddamt            number(20,4);
 v_custodycd        varchar2(20);
 v_sb               varchar2(1);
 v_fundcode         varchar2(50);
 l_ddacctno_issuer  varchar2(30);
 l_txtype           varchar2(20);
 v_globalid         varchar2(200);
 v_refbankacct      varchar2(200);
 --BEGIN OF NAM.LY 15-01-2020
 l_tltxcd           VARCHAR2(10);
 l_taxableparty     VARCHAR2(3);
 l_deductionplace   VARCHAR2(3);
 l_appendixid       VARCHAR2(4);
 l_codeid           VARCHAR2(10);
 --END OF NAM.LY 15-01-2020
 --BEGIN OF NAM.LY 10-03-2020
 V_AUTOID         VARCHAR2(10);
 V_VAT            NUMBER(20,4);
 V_SALEVALUE      NUMBER(20,4);
 V_CUSTODYCDBUY   VARCHAR2(20);
 V_CUSTODYCDSELL  VARCHAR2(20);
 V_CODEID         VARCHAR2(20);
 V_DESC           VARCHAR2(500);
 V_SYMBOL         VARCHAR2(500);
 --END OF NAM.LY 10-03-2020
 V_CUSTID         VARCHAR2(20);
 BEGIN
     plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
     plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
    /***************************************************************************************************
     ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
     ***************************************************************************************************/
     BEGIN
        SELECT CF.CUSTID INTO V_CUSTID FROM CFMAST CF WHERE CF.CUSTODYCD = p_txmsg.txfields(c_custodycd).value;
     END;
     v_custodycd := p_txmsg.txfields(c_custodycd).value;
     l_BANKACC := p_txmsg.txfields(c_bankacctno).value;
     l_bankname := p_txmsg.txfields(c_bankcode).value;
     l_bname    := p_txmsg.txfields(c_bname).value;--04082020 TriBui chuyen tien lay theo Ten TK huong thu
     l_ciaccount := p_txmsg.txfields(c_citad).value;
     l_codeid    :=  p_txmsg.txfields(c_codeid).value;

     SELECT CASE WHEN SECTYPE = '009' THEN 'TDM'
                 WHEN SECTYPE = '013' THEN 'CDPAY'
                 ELSE 'OTCPAY'
            END
     INTO l_txtype
     FROM SBSECURITIES WHERE CODEID = l_codeid;
     --BEGIN OF NAM.LY 15-01-2020
     if p_txmsg.txfields('03').value = '1400' then
        l_appendixid := p_txmsg.txfields('88').value;
        SELECT taxableparty, deductionplace INTO l_taxableparty, l_deductionplace FROM appendix WHERE autoid = l_appendixid;
     end if;

     l_tltxcd := p_txmsg.txfields(c_tltxcd).value;
     IF (l_tltxcd = '1400') THEN
        --NAM.LY: 1400,1407 dung chung giao dich 1401

        --BOOK THUE CHO BEN BANK
        --NAM.LY 10/03/2020: CHUYEN GHI NHAN THUE CHO TK MUA/BAN TU GD 1400 SANG GD 1401
        BEGIN
            --LAY THONG TIN PHI THUE CUA PHU LUC
            SELECT CL.TAX, CL.AMT, CL.BUYCUSTODYCD, CR.CUSTODYCD, CR.CODEID, CR.SYMBOL
            INTO V_VAT, V_SALEVALUE, V_CUSTODYCDBUY, V_CUSTODYCDSELL, V_CODEID, V_SYMBOL
            FROM CRPHYSAGREE_SELL_LOG CL, CRPHYSAGREE CR
            WHERE CL.CRPHYSAGREEID = CR.CRPHYSAGREEID AND CL.APPENDIXID = l_appendixid;
            EXCEPTION WHEN OTHERS THEN V_VAT   := '0.0000';
                                       V_SALEVALUE := '0.0000';
                                       V_CUSTODYCDBUY:= '';
                                       V_CUSTODYCDSELL:= '';
        END;

        V_DESC := 'FCT_Securities transferring_' || V_SYMBOL || '_original amount: VND ' || TO_CHAR(V_VAT, 'FM999,999,999,999,990');

        IF (l_taxableparty = '001' AND l_deductionplace = '001') THEN
            --GHI NHAN THUE CHO TK MUA
            V_AUTOID := SEQ_FEETRAN.NEXTVAL;
            INSERT INTO FEETRAN (TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE, VATAMT, AUTOID, TRDESC, CCYCD, ORDERID, TYPE, DEDUCTEDPLACE, STATUS, PAIDDATE, PSTATUS, SUBTYPE, FEETYPES, CUSTODYCD)
            VALUES (P_TXMSG.TXDATE, P_TXMSG.TXNUM, 'N', NULL, NULL , V_SALEVALUE, 0.0000, 0.0000, ROUND(V_VAT/V_SALEVALUE,4), V_VAT, V_AUTOID, V_DESC, 'VND', NULL, 'T', 'CTCK', 'N', NULL, NULL, NULL, NULL, V_CUSTODYCDBUY);

            INSERT INTO FEETRANDETAIL (AUTOID, REFID, TXDATE, TXNUM, SUBTYPE, FEETYPES, TXAMT, FEEAMT, ORDERID, CUSTODYCD, CCYCD, RATEAMT, FORP, CODEID, SEBAL, ASSET)
            VALUES (SEQ_FEETRANDETAIL.NEXTVAL, V_AUTOID, P_TXMSG.TXDATE, P_TXMSG.TXNUM, NULL, NULL, V_SALEVALUE, 0.0000, NULL, V_CUSTODYCDBUY, 'VND', V_VAT, 'T', V_CODEID, 0, 0);
            --Goi proc Insert vao TAX_BOOKING_RESULT
            sp_gen_taxinvoice(p_txmsg.txdate,p_txmsg.txnum);
        ELSIF (l_taxableparty = '002' AND l_deductionplace = '001') THEN
            --GHI NHAN THUE CHO TK BAN
            V_AUTOID := SEQ_FEETRAN.NEXTVAL;
            INSERT INTO FEETRAN (TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE, VATAMT, AUTOID, TRDESC, CCYCD, ORDERID, TYPE, DEDUCTEDPLACE, STATUS, PAIDDATE, PSTATUS, SUBTYPE, FEETYPES, CUSTODYCD)
            VALUES (P_TXMSG.TXDATE, P_TXMSG.TXNUM, 'N', NULL, NULL , V_SALEVALUE, 0.0000, 0.0000, ROUND(V_VAT/V_SALEVALUE,4), V_VAT, V_AUTOID, V_DESC, 'VND', NULL, 'T', 'CTCK', 'N', NULL, NULL, NULL, NULL, V_CUSTODYCDSELL);

            INSERT INTO FEETRANDETAIL (AUTOID, REFID, TXDATE, TXNUM, SUBTYPE, FEETYPES, TXAMT, FEEAMT, ORDERID, CUSTODYCD, CCYCD, RATEAMT, FORP, CODEID, SEBAL, ASSET)
            VALUES (SEQ_FEETRANDETAIL.NEXTVAL, V_AUTOID, P_TXMSG.TXDATE, P_TXMSG.TXNUM, NULL, NULL, V_SALEVALUE, 0.0000, NULL, V_CUSTODYCDSELL, 'VND', V_VAT, 'T', V_CODEID, 0, 0);
            --Goi proc Insert vao TAX_BOOKING_RESULT
            sp_gen_taxinvoice(p_txmsg.txdate,p_txmsg.txnum);
        END IF;
     ELSE
        l_appendixid := '';
     END IF;
     --END OF NAM.LY 15-01-2020
     select NVL(SUPEBANK,'N'), NVL(FUNDCODE,'') into v_sb, v_fundcode from CFMAST where CUSTODYCD = v_custodycd;
     v_globalid := fn_getglobalid(p_txmsg.txdate,p_txmsg.txnum);
     select max(dd.acctno) into l_ddacctno from ddmast dd where dd.custodycd = p_txmsg.txfields(c_custodycd).value and status <> 'C' and dd.isdefault = 'Y';
     select d.refcasaacct into v_refbankacct from ddmast d where d.acctno = l_ddacctno;
     INSERT INTO CBFA_BANKPAYMENT(AUTOID,GLOBALID,CUSTODYCD,ACCTNO,TXTYPE,TRANSTYPE,TXNUM,TXDATE,
                                  CITAD,BANKNAME,BANKBRACH,BENEFICIARYACCOUNT,CUSTNAME,CREATETIME,TXAMT,
                                  REFCONTRACT,FEETYPE,SUPERBANK,ISAPPRSB,BANKSTATUS,SYNSTATUS,VALUEDATE,
                                  REFBANKACCT,TLTXCD,NOTES)
     SELECT SEQ_CBFABANKPAYMENT.NEXTVAL,v_globalid,v_custodycd,l_ddacctno,l_txtype,
     case when l_ciaccount is null then 'I' else 'D' end,p_txmsg.txnum,
            p_txmsg.txdate,l_ciaccount,l_bankname,null,l_bankacc,l_bname, systimestamp,p_txmsg.txfields(c_amt).value,
            p_txmsg.txfields('88').value,p_txmsg.txfields('16').value,v_sb,CASE WHEN v_sb = 'N' THEN 'Y' ELSE 'N' END,
            'P','P',null,v_refbankacct,p_txmsg.tltxcd,p_txmsg.txfields(c_desc).value
     FROM DUAL;
     IF p_txmsg.deltd <> 'Y' THEN
       IF v_sb = 'Y' OR (v_fundcode is not null and length(trim(v_fundcode)) >0) then--gui events sang SB
       BEGIN
       insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
        values
             ('CB.'||TO_CHAR(p_txmsg.txdate,'YYYYMMDD')||'.'||p_txmsg.txnum,seq_log_notify_cbfa.nextval,
             'CBFABANKPAYMENT','GLOBALID',v_globalid,p_txmsg.txdesc,
              p_txmsg.txnum,p_txmsg.txdate,p_txmsg.tltxcd,SYSDATE,p_txmsg.busdate);
       --trung.luu: 02-07-2020 log lai de len view physical
       --bao.nguyen: 25-07-2022 SHBVNEX-2730
        insert into CRPHYSAGREE_LOG_ALL (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC,CITAD,TLTXCD,FEETYPE,SUPEBANK,CUSTODYCD,TYPEDOC,SYMBOL,BANKACCNAME,
            Beneficiary_Name,
            Beneficiary_account ,
            VAT,
            TAXABLEPARTY -- ben chiu thue
            ,DEDUCTIONPLACE, CUSTID
        )
         values (p_txmsg.txdate, p_txmsg.txnum, 'CT', p_txmsg.txfields(c_crphysagreeid).value, null, p_txmsg.txfields(c_faceamt).value, p_txmsg.txfields(c_amt).value, null, null, 'A', 'N',  p_txmsg.txfields(c_desc).value
         ,l_ciaccount,p_txmsg.TLTXCD,p_txmsg.txfields('16').value,'Y',v_custodycd,l_tltxcd,p_txmsg.txfields('33').value,l_bankname,
            p_txmsg.txfields('34').value,
            p_txmsg.txfields('02').value,
            p_txmsg.txfields('19').value,
            l_taxableparty,
            l_deductionplace, V_CUSTID
         );
         END;
       ELSE --Goi truc tiep bankapi
        if (l_ddacctno is not null) then
        if p_txmsg.txfields(c_citad).value is not null then
            pck_bankapi.Bank_Tranfer_Out(l_ddacctno,
                                           l_bname,--l_bankname --TriBui 04042020 fix lay theo Ten TK thu huong
                                           l_BANKACC,
                                           l_ciaccount,
                                           p_txmsg.txfields(c_amt).value,
                                           l_txtype,
                                           v_globalid,
                                           p_txmsg.txfields(c_desc).value,
                                           p_txmsg.tlid,
                                           p_err_code);
            IF p_err_code <> systemnums.c_success THEN
                UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',TRANSTYPE = 'D', ACCTNO = l_ddacctno
                WHERE GLOBALID = v_globalid;
                
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                Return errnums.C_BIZ_RULE_INVALID;
            else
                /*insert into CRPHYSAGREE_LOG (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC)
                    values (p_txmsg.txdate, p_txmsg.txnum, 'T', null, p_txmsg.txfields(c_crphysagreeid).value, p_txmsg.txfields(c_faceamt).value, p_txmsg.txfields(c_amt).value, null, null, 'A', 'N',  p_txmsg.txfields(c_desc).value);
                select sum(cr.amt) into l_sumamt from CRPHYSAGREE_LOG CR where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value and cr.type = 'T' and cr.deltd <> 'Y';
                select cr.clvalue into l_clvalue from crphysagree cr where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
                if l_sumamt >= l_clvalue then
                    update crphysagree cr set cr.paystatus = 'T' where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
                end if;*/
                --BEGIN OF NAM.LY 15-01-2020
                IF (l_tltxcd = '1400') THEN
                    BEGIN
                        --trung.luu: 02-07-2020 log lai de len view physical
                        --bao.nguyen: 25-07-2022 SHBVNEX-2730
                        insert into CRPHYSAGREE_LOG_ALL (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC,CITAD,TLTXCD,FEETYPE,CUSTODYCD,TYPEDOC,SYMBOL,BANKACCNAME,
                                                    Beneficiary_Name,
                                                    Beneficiary_account ,
                                                    VAT,
                                                    TAXABLEPARTY, -- ben chiu thue
                                                    DEDUCTIONPLACE, CUSTID
                            )
                         values (p_txmsg.txdate, p_txmsg.txnum, 'CT', p_txmsg.txfields(c_crphysagreeid).value, null, p_txmsg.txfields(c_faceamt).value, p_txmsg.txfields(c_amt).value, null, null, 'A', 'N',  p_txmsg.txfields(c_desc).value
                         ,l_ciaccount,p_txmsg.TLTXCD,p_txmsg.txfields('16').value,v_custodycd,l_tltxcd,p_txmsg.txfields('33').value,l_bankname,
                                    p_txmsg.txfields('34').value,
                                    p_txmsg.txfields('02').value,
                                    p_txmsg.txfields('19').value,
                                    l_taxableparty,
                                    l_deductionplace, V_CUSTID
                         );



                        insert into CRPHYSAGREE_LOG (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC)
                        values (p_txmsg.txdate, p_txmsg.txnum, 'T', p_txmsg.txfields(c_crphysagreeid).value, null, p_txmsg.txfields(c_faceamt).value, p_txmsg.txfields(c_amt).value, null, null, 'A', 'N',  p_txmsg.txfields(c_desc).value);
                        select sum(cr.amt) into l_sumamt from CRPHYSAGREE_LOG CR where cr.appendixid = p_txmsg.txfields(c_crphysagreeid).value and cr.type = 'T' and cr.deltd <> 'Y';
                        select AP.CLVALUE into l_clvalue from APPENDIX AP where AP.AUTOID = l_appendixid;
                        if l_sumamt >= l_clvalue then
                            UPDATE APPENDIX AP set AP.paystatus = 'T' where AP.AUTOID = l_appendixid;
                        END if;
                    END;
                ELSE
                    BEGIN
                        ---trung.luu: 02-07-2020 log lai de len view physical
                        --bao.nguyen: 25-07-2022 SHBVNEX-2730
                        insert into CRPHYSAGREE_LOG_ALL (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC,CITAD,TLTXCD,FEETYPE,CUSTODYCD,TYPEDOC,SYMBOL,BANKACCNAME,
                                        Beneficiary_Name,
                                        Beneficiary_account ,
                                        VAT,
                                        TAXABLEPARTY -- ben chiu thue
                                        ,DEDUCTIONPLACE, CUSTID

                        )
                         values (p_txmsg.txdate, p_txmsg.txnum, 'CT', p_txmsg.txfields(c_crphysagreeid).value, null, p_txmsg.txfields(c_faceamt).value, p_txmsg.txfields(c_amt).value, null, null, 'A', 'N',  p_txmsg.txfields(c_desc).value
                         ,l_ciaccount,p_txmsg.TLTXCD,p_txmsg.txfields('16').value,v_custodycd,l_tltxcd,p_txmsg.txfields('33').value,l_bankname,
                                        p_txmsg.txfields('34').value,
                                        p_txmsg.txfields('02').value,
                                        p_txmsg.txfields('19').value,
                                        l_taxableparty,
                                        l_deductionplace, V_CUSTID

                         );

                        insert into CRPHYSAGREE_LOG (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC)
                        values (p_txmsg.txdate, p_txmsg.txnum, 'T', null, p_txmsg.txfields(c_crphysagreeid).value, p_txmsg.txfields(c_faceamt).value, p_txmsg.txfields(c_amt).value, null, null, 'A', 'N',  p_txmsg.txfields(c_desc).value);
                        select sum(cr.amt) into l_sumamt from CRPHYSAGREE_LOG CR where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value and cr.type = 'T' and cr.deltd <> 'Y';
                        select cr.clvalue into l_clvalue from crphysagree cr where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
                        if l_sumamt >= l_clvalue then
                            update crphysagree cr set cr.paystatus = 'T' where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
                        END if;
                    END;
                END IF;
                --END OF NAM.LY 15-01-2020

                UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S',TRANSTYPE = 'D', ACCTNO = l_ddacctno
                WHERE GLOBALID = v_globalid;
            end if;
        else
            select dd.acctno into l_ddacctno_issuer from ddmast dd where dd.refcasaacct = l_BANKACC;
            pck_bankapi.Bank_Internal_Tranfer(
                   l_ddacctno,
                   l_bname,--l_bankname --TriBui 04042020 fix lay theo Ten TK thu huong
                   l_ddacctno_issuer, --- so tk nhan
                   p_txmsg.txfields(c_amt).value,  --- so tien
                   l_txtype, --request code cua nghiep vu trong allcode
                   v_globalid, --requestkey duy nhat de truy lai giao dich goc
                   p_txmsg.txfields(c_desc).value,  -- dien giai
                   p_txmsg.tlid, -- nguoi tao giao dich
                   P_ERR_CODE);
             IF p_err_code <> systemnums.c_success THEN
                UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',TRANSTYPE = 'I', ACCTNO = l_ddacctno
                WHERE GLOBALID = v_globalid;
                
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                Return errnums.C_BIZ_RULE_INVALID;
             else
                 /*insert into CRPHYSAGREE_LOG (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC)
                     values (p_txmsg.txdate, p_txmsg.txnum, 'T', null, p_txmsg.txfields(c_crphysagreeid).value, p_txmsg.txfields(c_faceamt).value, p_txmsg.txfields(c_amt).value, null, null, 'A', 'N',  p_txmsg.txfields(c_desc).value);
                 select sum(cr.amt) into l_sumamt from CRPHYSAGREE_LOG CR where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value and cr.type = 'T' and cr.deltd <> 'Y';
                 select cr.clvalue into l_clvalue from crphysagree cr where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
                 if l_sumamt >= l_clvalue then
                     update crphysagree cr set cr.paystatus = 'T' where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
                 end if;*/
                --BEGIN OF NAM.LY 15-01-2020
                IF (l_tltxcd = '1400') THEN
                    BEGIN
                        --trung.luu: 02-07-2020 log lai de len view physical
                        --bao.nguyen: 25-07-2022 SHBVNEX-2730
                        insert into CRPHYSAGREE_LOG_ALL (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC,CITAD,TLTXCD,FEETYPE,CUSTODYCD,TYPEDOC,SYMBOL,BANKACCNAME,
                                    Beneficiary_Name,
                                    Beneficiary_account ,
                                    VAT,
                                    TAXABLEPARTY -- ben chiu thue
                                    ,DEDUCTIONPLACE, CUSTID

                        )
                         values (p_txmsg.txdate, p_txmsg.txnum, 'CT', p_txmsg.txfields(c_crphysagreeid).value, null, p_txmsg.txfields(c_faceamt).value, p_txmsg.txfields(c_amt).value, null, null, 'A', 'N',  p_txmsg.txfields(c_desc).value
                         ,l_ciaccount,p_txmsg.TLTXCD,p_txmsg.txfields('16').value,v_custodycd,l_tltxcd,p_txmsg.txfields('33').value,l_bankname,
                                    p_txmsg.txfields('34').value,
                                    p_txmsg.txfields('02').value,
                                    p_txmsg.txfields('19').value,
                                    l_taxableparty,
                                    l_deductionplace, V_CUSTID

                         );


                        insert into CRPHYSAGREE_LOG (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC)
                         values (p_txmsg.txdate, p_txmsg.txnum, 'T', p_txmsg.txfields(c_crphysagreeid).value, null, p_txmsg.txfields(c_faceamt).value, p_txmsg.txfields(c_amt).value, null, null, 'A', 'N',  p_txmsg.txfields(c_desc).value);
                        select sum(cr.amt) into l_sumamt from CRPHYSAGREE_LOG CR where cr.APPENDIXID = p_txmsg.txfields(c_crphysagreeid).value and cr.type = 'T' and cr.deltd <> 'Y';
                        select AP.clvalue into l_clvalue from APPENDIX AP where AP.AUTOID = p_txmsg.txfields(c_crphysagreeid).value;
                        if l_sumamt >= l_clvalue then
                         UPDATE APPENDIX AP set AP.paystatus = 'T' where AP.AUTOID = p_txmsg.txfields(c_crphysagreeid).value;
                        END if;
                    END;
                ELSE
                    BEGIN
                        --trung.luu: 02-07-2020 log lai de len view physical
                        --bao.nguyen: 25-07-2022 SHBVNEX-2730
                        insert into CRPHYSAGREE_LOG_ALL (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC,CITAD,TLTXCD,FEETYPE,CUSTODYCD,TYPEDOC,SYMBOL,BANKACCNAME,
                                        Beneficiary_Name,
                                        Beneficiary_account ,
                                        VAT,
                                        TAXABLEPARTY -- ben chiu thue
                                        ,DEDUCTIONPLACE, CUSTID

                        )
                         values (p_txmsg.txdate, p_txmsg.txnum, 'CT', p_txmsg.txfields(c_crphysagreeid).value, null, p_txmsg.txfields(c_faceamt).value, p_txmsg.txfields(c_amt).value, null, null, 'A', 'N',  p_txmsg.txfields(c_desc).value
                         ,l_ciaccount,p_txmsg.TLTXCD,p_txmsg.txfields('16').value,v_custodycd,l_tltxcd,p_txmsg.txfields('33').value,l_bankname,
                                        p_txmsg.txfields('34').value,
                                        p_txmsg.txfields('02').value,
                                        p_txmsg.txfields('19').value,
                                        l_taxableparty,
                                        l_deductionplace, V_CUSTID

                         );


                        insert into CRPHYSAGREE_LOG (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC)
                             values (p_txmsg.txdate, p_txmsg.txnum, 'T', null, p_txmsg.txfields(c_crphysagreeid).value, p_txmsg.txfields(c_faceamt).value, p_txmsg.txfields(c_amt).value, null, null, 'A', 'N',  p_txmsg.txfields(c_desc).value);
                         select sum(cr.amt) into l_sumamt from CRPHYSAGREE_LOG CR where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value and cr.type = 'T' and cr.deltd <> 'Y';
                         select cr.clvalue into l_clvalue from crphysagree cr where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
                         if l_sumamt >= l_clvalue then
                             update crphysagree cr set cr.paystatus = 'T' where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
                         END if;
                    END;
                END IF;
                --END OF NAM.LY 15-01-2020
                 UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S',TRANSTYPE = 'I', ACCTNO = l_ddacctno
                 WHERE GLOBALID = v_globalid;
             end if;
        end if;
        else
          UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E', ACCTNO = l_ddacctno
          WHERE GLOBALID = v_globalid;
          
          plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
          Return errnums.C_BIZ_RULE_INVALID;
        end if;
      END IF;
     Else
        update CRPHYSAGREE_LOG cr set cr.deltd = 'Y' where cr.txdate = p_txmsg.txdate and cr.txnum = p_txmsg.txnum;
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
          plog.init ('TXPKS_#1401EX',
                     plevel => NVL(logrow.loglevel,30),
                     plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                     palert => (NVL(logrow.log4alert,'N') = 'Y'),
                     ptrace => (NVL(logrow.log4trace,'N') = 'Y')
             );
 END TXPKS_#1401EX;
/
