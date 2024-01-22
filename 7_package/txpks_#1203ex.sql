SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1203ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1203EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      29/07/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1203ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_postdate         CONSTANT CHAR(2) := '20';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_profoliocd       CONSTANT CHAR(2) := '91';
   c_custname         CONSTANT CHAR(2) := '90';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    v_count_log number;
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

    select count(*) into v_count_log
    from log_1203_by_month
    where feemonth =substr(p_txmsg.txfields('20').value,4,7)
    and custodycd = p_txmsg.txfields('88').value
    and subtype = '001'
    and feetypes ='SEDEPO'
    and deltd <>'Y';

    if v_count_log > 0 then
        p_err_code := '-930111';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;

    select count(*) into v_count_log
    from log_1203_by_month
    where feemonth = substr(p_txmsg.txfields('20').value,4,7)
    and custodycd = p_txmsg.txfields('88').value
    and subtype = '015'
    and feetypes ='OTHER'
    and deltd <>'Y';

    if v_count_log > 0 then
        p_err_code := '-930111';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;

    select count(*) into v_count_log
    from log_1203_by_month
    where feemonth = substr(p_txmsg.txfields('20').value,4,7)
    and custodycd = p_txmsg.txfields('88').value
    and subtype = '001'
    and feetypes ='TRANREPAIR'
    and deltd <>'Y';

    if v_count_log > 0 then
        p_err_code := '-930111';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;

    select count(*) into v_count_log
    from log_1203_by_month
    where feemonth =substr(p_txmsg.txfields('20').value,4,7)
    and custodycd = p_txmsg.txfields('88').value
    and subtype = '007'
    and feetypes ='OTHER'
    and deltd <>'Y';

    if v_count_log > 0 then
        p_err_code := '-930111';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;
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
V_GETCURRENT DATE;
V_FEEAMT     NUMBER;
V_TAXAMT     NUMBER;
V_TAXRATE    NUMBER;
V_CCYCD      VARCHAR2(20);
V_AUTOID    NUMBER;
V_CUSTODYCD  VARCHAR2(50);
V_FEECODE    VARCHAR2(20);
V_FEECD      VARCHAR2(20);
V_REFCODE    VARCHAR2(20);
V_SUBTYPE    VARCHAR2(20);
V_CODEID     VARCHAR2(10);
V_SUBTYPE_NM VARCHAR2(1000);
V_STATUS     VARCHAR2(3);
V_SYMBOL     VARCHAR2(100);
v_sysvar    varchar2(10);
v_feeamtorder NUMBER;
v_feecalc varchar2(1);
V_TAUTOID NUMBER;
v_feerate NUMBER;
v_result NUMBER;
v_deltd varchar2(1);
v_vatrate NUMBER;
v_tax NUMBER;
v_lastday date;
v_desc varchar2(500);
l_count NUMBER;
l_countamc NUMBER;
l_countgcb NUMBER;
l_amcid varchar2(20);
l_gcbid varchar2(20);
v_cfdesc varchar2(20);
l_feetypes varchar(20);
l_subtypes varchar(20);
V_TOTALFEE   NUMBER;
V_REPAIRFEE  NUMBER;
V_COUNT NUMBER;
v_vatamt NUMBER;
v_date_minium NUMBER;
v_fee_minium NUMBER;
v_autoiddetail NUMBER;
V_LASTMONTH NUMBER;
v_count_log NUMBER;
v_date_fee date;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN --SHBVNEX-968
        SELECT varvalue into v_sysvar from sysvar where varname = 'DEALINGCUSTODYCD';
        
        v_getcurrent := GETCURRDATE;

        v_date_fee := TO_DATE(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT);
        IF TO_DATE(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT) > v_getcurrent THEN
            v_date_fee := v_getcurrent;
        END IF;

        -- ================================ Phi? luu ky? =====================================================
        FOR rec IN
        (
            SELECT SE1.CUSTODYCD, SUM(SE1.SEBAL) SEBAL, SUM(SE1.ASSET_VND) ASSET_VND, SUM(SE1.ASSET_USD) ASSET_USD
            FROM SEDEPO_DAILY SE1,
            (
                SELECT ACCTNO, MAX(TRADEDATE) TRADEDATE
                FROM SEDEPO_DAILY
                WHERE CUSTODYCD = P_TXMSG.TXFIELDS('88').VALUE
                AND TO_CHAR(TRADEDATE,'MM/RRRR') = TO_CHAR(TO_DATE(P_TXMSG.TXFIELDS('20').VALUE, SYSTEMNUMS.C_DATE_FORMAT),'MM/RRRR')
                GROUP BY ACCTNO
            ) SE2
            WHERE SE1.ACCTNO = SE2.ACCTNO
            AND SE1.TRADEDATE = SE2.TRADEDATE
            GROUP BY SE1.CUSTODYCD

            UNION ALL

            SELECT CUSTODYCD, SUM(SEBAL) SEBAL, SUM(ASSET_VND) ASSET_VND, SUM(ASSET_USD) ASSET_USD
            FROM VW_SEDEPO_DAILY
            WHERE CUSTODYCD = P_TXMSG.TXFIELDS('88').VALUE
            AND NOT EXISTS (
                SELECT 1
                FROM SEDEPO_DAILY
                WHERE CUSTODYCD = P_TXMSG.TXFIELDS('88').VALUE
                AND TO_CHAR(TRADEDATE,'MM/RRRR') = TO_CHAR(TO_DATE(P_TXMSG.TXFIELDS('20').VALUE, SYSTEMNUMS.C_DATE_FORMAT),'MM/RRRR')
            )
            GROUP BY CUSTODYCD

        )LOOP
            BEGIN
                SELECT AUTOID INTO v_AUTOID FROM FEETRAN
                WHERE  TYPE = 'F' AND DELTD <> 'Y'
                AND TO_CHAR(TO_DATE(TXDATE,SYSTEMNUMS.C_DATE_FORMAT), 'MM/RRRR') = TO_CHAR(TO_DATE(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT), 'MM/RRRR')
                AND SUBTYPE = '001' AND FEETYPES = 'SEDEPO'
                AND CUSTODYCD = rec.CUSTODYCD;
            EXCEPTION WHEN OTHERS THEN
                v_AUTOID := 0;
            END;

            BEGIN
                v_result := cspks_feecalc.fn_sedepo_manual_calc(rec.custodycd, rec.ASSET_USD, rec.SEBAL,substr(p_txmsg.txfields('20').value,0,2), v_feecd, v_feeamt,v_feerate, v_ccycd, v_feecode);
                if v_ccycd = 'USD' then
                    v_result := cspks_feecalc.fn_sedepo_manual_calc(rec.custodycd, rec.ASSET_USD, rec.SEBAL,substr(p_txmsg.txfields('20').value,0,2), v_feecd, v_feeamt,v_feerate, v_ccycd, v_feecode);
                Else
                    v_result := cspks_feecalc.fn_sedepo_manual_calc(rec.custodycd, rec.ASSET_VND, rec.SEBAL,substr(p_txmsg.txfields('20').value,0,2), v_feecd, v_feeamt,v_feerate, v_ccycd, v_feecode);
                End If;
                if v_feecd is not null or v_feecd <> '' then
                    v_Result := cspks_feecalc.fn_tax_calc (rec.custodycd, v_feeamt,v_ccycd,v_feecd,2/*pv_round in number*/,v_tax,v_vatrate);
                end if;
            EXCEPTION WHEN OTHERS THEN
                v_result := -1;
                plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
            END;

            IF v_result = 0 THEN
                  IF(v_AUTOID = 0) THEN
                    SELECT  FE.REFCODE , FE.SUBTYPE INTO l_feetypes,l_subtypes FROM FEEMASTER FE where feecd=v_feecd;
                    SELECT en_display into v_desc FROM vw_feedetails_all WHERE filtercd = l_subtypes  and id=l_feetypes;

                    v_AUTOID := SEQ_FEETRAN.NEXTVAL;
                    --v_tax := v_feeamt*v_vatrate/100;
                      INSERT INTO FEETRAN (TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE, VATAMT, AUTOID, TRDESC, CCYCD, ORDERID, TYPE, DEDUCTEDPLACE, STATUS, PAIDDATE, PSTATUS, SUBTYPE, FEETYPES, CUSTODYCD, FEECODE)
                      VALUES (to_date(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT), p_txmsg.txnum, 'N', v_feecd, null, DECODE(v_ccycd,'VND',rec.ASSET_VND,rec.ASSET_USD), v_feeamt, v_feerate, v_vatrate, v_tax, v_AUTOID , v_desc||' dated '||to_char(to_date(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT),'DD Mon YYYY'), v_ccycd, null, 'F', null, 'N', null, null,'001', 'SEDEPO' , rec.custodycd, v_feecode);
                  ELSE
                      UPDATE FEETRAN fe
                      SET fe.txdate = to_date(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT),
                          fe.txnum = p_txmsg.txnum,
                          fe.ccycd = v_ccycd,
                          fe.feecd = v_feecd,
                          fe.txamt = DECODE(v_ccycd,'VND',rec.ASSET_VND,rec.ASSET_USD),
                          fe.feeamt = v_feeamt,
                          fe.feerate = v_feerate
                      WHERE fe.autoid = v_AUTOID;
                 END IF;
             END IF;
             v_autoiddetail := SEQ_FEETRANDETAIL.NEXTVAL;
             INSERT INTO feetrandetail (AUTOID, REFID, TXDATE, TXNUM, SUBTYPE, FEETYPES, TXAMT, FEEAMT, ORDERID, CUSTODYCD, CCYCD, RATEAMT, FORP, SEBAL, ASSET)
             VALUES (v_autoiddetail, v_AUTOID, to_date(p_txmsg.txdate, SYSTEMNUMS.C_DATE_FORMAT), p_txmsg.txnum, '001', 'SEDEPO', DECODE(v_ccycd,'VND',rec.ASSET_VND,rec.ASSET_USD), v_feeamt, null, rec.custodycd ,v_ccycd,0.0000,'F', rec.SEBAL , DECODE(v_ccycd,'VND',rec.ASSET_VND,rec.ASSET_USD));

             IF v_vatrate > 0 THEN
                 INSERT INTO feetrandetail (AUTOID, REFID, TXDATE, TXNUM, SUBTYPE, FEETYPES, TXAMT, FEEAMT, ORDERID, CUSTODYCD, CCYCD, RATEAMT, FORP, SEBAL, ASSET, PAUTOID)
                 VALUES (SEQ_FEETRANDETAIL.NEXTVAL, v_TAUTOID,to_date(p_txmsg.txdate, SYSTEMNUMS.C_DATE_FORMAT), p_txmsg.txnum,'001', 'SEDEPO' , v_feeamt,0.0000, null,rec.custodycd ,v_ccycd,v_tax,'T', rec.SEBAL , DECODE(v_ccycd,'VND',rec.ASSET_VND,rec.ASSET_USD), v_autoiddetail);
             END IF;

             --trung.luu: 29-06-2021  SHBVNEX-2367
             --log lai de check sinh phi trung trong thang
             insert into log_1203_by_month (autoid, txnum, txdate, feetxdate,feemonth, custodycd, subtype,feetypes, deltd)
             values (seq_log_1203_by_month.nextval,p_txmsg.txnum,to_date(p_txmsg.txdate,SYSTEMNUMS.C_DATE_FORMAT),to_date(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT),substr(p_txmsg.txfields('20').value,4,7) ,rec.custodycd ,'001', 'SEDEPO' ,'N');
        END LOOP;
         -- ================================End  Phi? luu ky? =====================================================

           -- ================================ Phi? nh??p/ ru?t kho =====================================================
        V_REFCODE    := 'OTHER';
        V_SUBTYPE    := '015';
        BEGIN
            SELECT EN_CDCONTENT
            INTO V_SUBTYPE_NM
            FROM ALLCODE
            WHERE CDNAME = V_REFCODE AND CDVAL = V_SUBTYPE AND CDTYPE = 'SA';
        EXCEPTION WHEN OTHERS THEN
            V_SUBTYPE_NM := NULL;
        END;

        FOR rec IN
        (
            SELECT DOC.*
            FROM (
                    SELECT DISTINCT CUSTODYCD, CODEID, SYMBOL, 'OPN' STATUS
                    FROM DOCSTRANSFER
                    WHERE DELTD <> 'Y'
                    AND STATUS = 'CLS'
                    AND OPNTXDATE = v_date_fee
                    UNION ALL
                    SELECT DISTINCT CUSTODYCD, CODEID, SYMBOL, 'CLS' STATUS
                    FROM DOCSTRANSFER
                    WHERE DELTD <> 'Y'
                    AND STATUS = 'CLS'
                    AND CLSTXDATE = v_date_fee
                    UNION
                    SELECT DISTINCT CUSTODYCD, CODEID, SYMBOL, STATUS
                    FROM DOCSTRANSFER
                    WHERE DELTD <> 'Y'
                    AND STATUS = 'OPN'
                    AND OPNTXDATE = v_date_fee
              ) DOC, CFMAST CF
              WHERE DOC.CUSTODYCD = CF.CUSTODYCD
              and DOC.CUSTODYCD = p_txmsg.txfields('88').value
              AND CF.SUPEBANK <> 'Y'
              and cf.bondagent <>'Y'
              and substr(CF.CUSTODYCD,0,4) <> v_sysvar
        ) LOOP
            V_CUSTODYCD := rec.CUSTODYCD;
            V_FEEAMT    := cspks_feecalc.fn_get_feeamt_without_tier(V_CUSTODYCD,V_REFCODE,V_SUBTYPE,V_TAXRATE,V_CCYCD,V_FEECODE,V_FEECD);
            IF v_feecd IS NOT NULL OR v_feecd <> '' THEN
                v_Result := cspks_feecalc.fn_tax_calc ( V_CUSTODYCD, V_FEEAMT,v_ccycd,v_feecd,4/*pv_round in number*/,V_TAXAMT,V_TAXRATE);
            END IF;
            V_AUTOID    := SEQ_FEETRAN.NEXTVAL;
            V_CODEID    := rec.CODEID;
            V_STATUS    := rec.STATUS;
            V_SYMBOL    := rec.SYMBOL;
            -- Ghi nhan phi rut nhap kho
            INSERT INTO FEETRAN (TXDATE,TXNUM,DELTD,FEECD,GLACCTNO,TXAMT,FEEAMT,FEERATE,VATRATE,VATAMT,AUTOID,TRDESC,CCYCD,ORDERID,TYPE,DEDUCTEDPLACE,STATUS,PAIDDATE,PSTATUS,SUBTYPE,FEETYPES,CUSTODYCD,PAUTOID,FEECODE)
            VALUES (
                     TO_DATE(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT),--TXDATE -------DATE(7)
                     p_txmsg.txnum,--TXNUM -------VARCHAR2(20)
                     'N',--DELTD -------VARCHAR2(2)
                     V_FEECD,--FEECD -------VARCHAR2(5)
                     NULL,--GLACCTNO -------VARCHAR2(30)
                     0,--TXAMT -------NUMBER(22)
                     V_FEEAMT,--FEEAMT -------NUMBER(22)
                     0,--FEERATE -------NUMBER(22)
                     V_TAXRATE,--VATRATE -------NUMBER(22)
                     V_TAXAMT,--VATAMT -------NUMBER(22)
                     V_AUTOID,--AUTOID -------NUMBER(22)
                     V_SUBTYPE_NM||' dated '||TO_CHAR(TO_DATE(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT),'DD Mon RRRR')||' ('||V_SYMBOL||DECODE(V_STATUS,'OPN',' deposited)','CLS',' withdrawn)'),--TRDESC -------VARCHAR2(1000) --Sub-type name + "dated" + txdate;
                     V_CCYCD,--CCYCD -------VARCHAR2(10)
                     V_CODEID,--ORDERID -------VARCHAR2(20)
                     'F',--TYPE -------VARCHAR2(10)
                     NULL,--DEDUCTEDPLACE -------VARCHAR2(50)
                     'N',--STATUS -------VARCHAR2(10)
                     NULL,--PAIDDATE -------DATE(7)
                     NULL,--PSTATUS -------VARCHAR2(200)
                     V_SUBTYPE,--SUBTYPE -------VARCHAR2(200)
                     V_REFCODE,--FEETYPES -------VARCHAR2(200)
                     V_CUSTODYCD,--CUSTODYCD -------VARCHAR2(20)
                     NULL ,--PAUTOID -------NUMBER(22)
                     V_FEECODE--FEECODE -------VARCHAR2(10)
                   );
                   V_CUSTODYCD := NULL;
                   V_FEEAMT    := 0;
                   V_TAXRATE   := 0;
                   V_CCYCD     := NULL;
                   V_FEECODE   := NULL;
                   V_FEECD     := NULL;
                   V_AUTOID    := 0;
                   V_CODEID    := NULL;
           --trung.luu: 29-06-2021  SHBVNEX-2367
             --log lai de check sinh phi trung trong thang
             insert into log_1203_by_month (autoid, txnum, txdate, feetxdate,feemonth, custodycd, subtype,feetypes, deltd)
             values (seq_log_1203_by_month.nextval,p_txmsg.txnum,to_date(p_txmsg.txdate,SYSTEMNUMS.C_DATE_FORMAT),to_date(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT),substr(p_txmsg.txfields('20').value,4,7) ,V_CUSTODYCD,V_SUBTYPE, V_REFCODE,'N');
        END LOOP;
        -- ================================ End Phi? nh??p/ ru?t kho =====================================================

        --SHBVNEX-968 => Phi? chuy??n ti?`n -> ?a~ duo?c ghi nh??n ngay khi pha?t sinh giao di?ch -> Kh?ng c?`n ti?nh nu~a

        --================================ Phi? giao di?ch =====================================================
        --SHBVNEX-968 => Go?i buo?c insert va`o FEETRANREPAIR sau do? go?i buo?c ti?nh phi? d?? insert va`o Feetran va` feetrandetail tu` Feetranrepair (PROCEDURE pr_ODFee)
        --B1:
        v_getcurrent := getcurrdate;
        INSERT INTO FEETRANREPAIR
        SELECT TO_DATE(p_txmsg.txdate, SYSTEMNUMS.C_DATE_FORMAT), p_txmsg.txnum, OD.ORDERID, OD.EXECTYPE, OD.SYMBOL, OD.CLEARDATE, OD.EXECQTTY QTTY, OD.EXECAMT AMOUNT, 0 FEEAMT,
               0 REPAIRAMT, OD.CUSTID, OD.AFACCTNO, 'P' STATUS, 'N' DELTD, OD.TLID MAKERID, OD.TLID CHECKERID,'' FEETYPES
        FROM VW_ODMAST_ALL OD, CFMAST CF
        WHERE OD.DELTD <> 'Y' AND OD.ODTYPE in ('ODT','ODG')
        AND CF.CUSTODYCD=OD.CUSTODYCD
        and CF.CUSTODYCD =p_txmsg.txfields('88').value
        AND CF.SUPEBANK='N'
        AND CF.BONDAGENT <> 'Y'
        AND OD.CLEARDATE >= v_date_fee;
        --B2: Thoai.tran 24/05/2022 Fee theo tung lenh -> FEENUM auto 1/ Update fee, tax theo Orderid
        -- SHBVNEX-2710
        FOR rec IN
        (
            SELECT A.CUSTODYCD, A.CUSTID, A.AMCID, A.GCBID, A.ORDERID, SUM(A.AMT_VND) AMT_VND, SUM(A.AMT_USD) AMT_USD, COUNT(1) FEENUM
            FROM
            (
                SELECT CF.CUSTODYCD, FE.AMOUNT * NVL(EX1.VND,1) AMT_VND, FE.AMOUNT * (NVL(EX1.VND,1)/NVL(EX.VND,1)) AMT_USD, CF.CUSTID, CF.AMCID, CF.GCBID, FE.ORDERID
                FROM VW_ODMAST_ALL OD,
                (
                    SELECT * FROM CFMAST WHERE SUPEBANK = 'N' AND BONDAGENT <> 'Y' AND STATUS <> 'C' AND CUSTODYCD = P_TXMSG.TXFIELDS('88').VALUE
                ) CF,
                (
                    SELECT * FROM FEETRANREPAIR FE WHERE FE.DELTD <> 'Y'
                ) FE,
                (
                    SELECT EB2.CURRENCY, EB2.VND
                    FROM
                    (
                        SELECT CURRENCY, ITYPE, RTYPE, MAX(LASTCHANGE) LASTCHANGE
                        FROM
                        (
                            SELECT * FROM EXCHANGERATE
                            UNION ALL
                            SELECT * FROM EXCHANGERATE_HIST
                        )
                        WHERE TO_DATE(TO_CHAR(LASTCHANGE,SYSTEMNUMS.C_DATE_FORMAT),SYSTEMNUMS.C_DATE_FORMAT) <= V_DATE_FEE
                        AND CURRENCY = 'USD'
                        AND ITYPE = 'SHV'
                        AND RTYPE = 'TTM'
                        GROUP BY CURRENCY, ITYPE, RTYPE
                    )EB1,
                    (
                        SELECT * FROM EXCHANGERATE
                        UNION ALL
                        SELECT * FROM EXCHANGERATE_HIST
                    )EB2
                    WHERE EB1.CURRENCY = EB2.CURRENCY
                    AND EB1.ITYPE = EB2.ITYPE
                    AND EB1.RTYPE = EB2.RTYPE
                    AND EB1.LASTCHANGE = EB2.LASTCHANGE
                )EX,-- LAY TI GIA USD
                (
                    SELECT A.CURRENCY,A.VND,B.CCYCD
                    FROM (
                        SELECT EB2.*
                        FROM
                        (
                            SELECT CURRENCY, ITYPE, RTYPE, MAX(LASTCHANGE) LASTCHANGE
                            FROM (
                            SELECT * FROM EXCHANGERATE
                            UNION ALL
                            SELECT * FROM EXCHANGERATE_HIST
                        )
                        WHERE TO_DATE(TO_CHAR(LASTCHANGE,SYSTEMNUMS.C_DATE_FORMAT),SYSTEMNUMS.C_DATE_FORMAT) <= V_DATE_FEE
                        AND ITYPE = 'SHV'
                        AND RTYPE = 'TTM'
                        GROUP BY CURRENCY, ITYPE, RTYPE
                        )EB1,
                        (
                            SELECT * FROM EXCHANGERATE
                            UNION ALL
                            SELECT * FROM EXCHANGERATE_HIST
                        )EB2
                        WHERE EB1.CURRENCY = EB2.CURRENCY
                        AND EB1.ITYPE = EB2.ITYPE
                        AND EB1.RTYPE = EB2.RTYPE
                        AND EB1.LASTCHANGE = EB2.LASTCHANGE
                    )A, -- LAY TI GIA
                    (
                        SELECT * FROM SBCURRENCY
                    )B -- LAY DON VI TIEN TE
                    WHERE A.CURRENCY = B.SHORTCD
                )EX1,
                (
                    SELECT * FROM SBSECURITIES WHERE NVL(MANAGEMENTTYPE,'LKCK') = 'LKCK'
                ) SB
                WHERE FE.CUSTID = CF.CUSTID
                AND FE.ORDERID = OD.ORDERID
                AND OD.CODEID = SB.CODEID
                AND SB.CCYCD = EX1.CCYCD(+)
            ) A
            GROUP BY A.CUSTODYCD, A.CUSTID, A.AMCID, A.GCBID, A.ORDERID
        ) LOOP
            l_amcid :=rec.amcid;
            l_gcbid :=rec.gcbid;

            select count(*) into l_count from cffeeexp cf, feemaster fe
            where custodycd = rec.custodycd and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'TRANREPAIR'
               and fe.status = 'Y'
               and cf.effdate <= TO_DATE(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT) and cf.expdate >= TO_DATE(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT);
            IF l_count > 0 THEN--case truong ho uu tien
                v_cfdesc:='FUND';
            ELSE
                select count(amcid) INTO l_countamc FROM cffeeexp cf, feemaster fe
                where amcid = l_amcid and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'TRANREPAIR'
                     and fe.status = 'Y'
                     and cf.effdate <= TO_DATE(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT);
                IF l_countamc > 0 THEN
                    v_cfdesc:='AMC';
                ELSE
                    select count(amcid) INTO l_countgcb FROM cffeeexp cf, feemaster fe
                    where amcid = l_gcbid and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'TRANREPAIR'
                           and fe.status = 'Y'
                           and cf.effdate <= TO_DATE(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT);
                    IF l_countgcb > 0 THEN
                        v_cfdesc:='GCB';
                    ELSE
                        v_cfdesc:='MASTER';
                    END IF;
                END IF;
            END IF;

            BEGIN
                v_result := cspks_feecalc.fn_order_calc(rec.custodycd, l_amcid, l_gcbid, rec.amt_vnd, rec.feenum, v_feecd, v_feeamt, v_feerate, v_ccycd, v_cfdesc, v_feecode);
                IF V_CCYCD = 'USD' THEN
                    V_RESULT := CSPKS_FEECALC.FN_ORDER_CALC(REC.CUSTODYCD, L_AMCID, L_GCBID, REC.AMT_USD, REC.FEENUM, V_FEECD, V_FEEAMT, V_FEERATE, V_CCYCD, V_CFDESC, V_FEECODE);
                END IF;
                --trung.luu: 21-09-2020  SHBVNEX-1569
                IF v_feecd IS NOT NULL OR v_feecd <> '' THEN
                    v_Result := cspks_feecalc.fn_tax_calc (rec.custodycd, v_feeamt, v_ccycd, v_feecd, 0/*pv_round in number*/, v_tax, v_vatrate);
                END IF;
                --
            EXCEPTION WHEN OTHERS THEN
                v_result := -1;
                plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                
            END;
            IF v_result = 0 THEN
                SELECT FE.REFCODE, FE.SUBTYPE INTO L_FEETYPES, L_SUBTYPES FROM FEEMASTER FE WHERE FEECD = V_FEECD;
                SELECT EN_DISPLAY INTO V_DESC FROM VW_FEEDETAILS_ALL WHERE FILTERCD = L_SUBTYPES  AND ID = L_FEETYPES;

                v_AUTOID := SEQ_FEETRAN.NEXTVAL;

                INSERT INTO FEETRAN (TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE, VATAMT, AUTOID, TRDESC, CCYCD, ORDERID, TYPE, DEDUCTEDPLACE, STATUS, PAIDDATE, PSTATUS, SUBTYPE, FEETYPES, CUSTODYCD,FEECODE)
                VALUES (TO_DATE(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT), p_txmsg.txnum, 'N',v_feecd , null, decode(v_ccycd,'vnd',rec.amt_vnd,rec.amt_usd), v_feeamt, v_feerate, v_vatrate, v_tax, v_AUTOID , v_desc||' dated '||to_char(TO_DATE(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT),'DD Mon YYYY'), v_ccycd, null, 'F', null, 'N', null, null, '001', 'TRANREPAIR', rec.custodycd, v_feecode);

                UPDATE FEETRANREPAIR fe
                SET fe.feeamt = v_feeamt / rec.FEENUM,
                    fe.status = (CASE WHEN FE.TXNUM = P_TXMSG.TXNUM AND FE.TXDATE = TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT) THEN 'A' ELSE 'C' END)
                WHERE fe.custid = rec.CUSTID AND fe.orderid=rec.orderid
                AND fe.deltd <> 'Y';

                INSERT INTO FEETRANDETAIL
                SELECT SEQ_FEETRANDETAIL.NEXTVAL AUTOID, v_AUTOID REFID, TO_DATE(p_txmsg.txdate, SYSTEMNUMS.C_DATE_FORMAT), p_txmsg.txnum, '001' SUBTYPE, 'TRANREPAIR' FEETYPES,
                    FE.Amount TXAMT, FE.Feeamt, fe.orderid, rec.CUSTODYCD, v_ccycd CCYCD, 0 RATEAMT, 'F' FORP, sb.codeid, 0 SEBAL , 0 ASSET, null PAUTOID
                from FEETRANREPAIR fe, SBSECURITIES sb
                WHERE fe.STATUS IN ('A','C')
                AND fe.deltd <> 'Y'
                AND fe.symbol = sb.symbol
                AND fe.custid = rec.CUSTID
                AND fe.orderid=rec.orderid;

                IF v_vatrate > 0 THEN
                    INSERT INTO FEETRANDETAIL
                    SELECT SEQ_FEETRANDETAIL.NEXTVAL AUTOID, v_TAUTOID REFID, TO_DATE(p_txmsg.txdate, SYSTEMNUMS.C_DATE_FORMAT), p_txmsg.txnum, '001' SUBTYPE, 'TRANREPAIR' FEETYPES,
                       FE.Feeamt  TXAMT, 0.0000 Feeamt, fe.orderid, rec.CUSTODYCD, v_ccycd CCYCD, v_tax / rec.FEENUM RATEAMT, 'T' FORP, sb.codeid, 0 SEBAL , 0 ASSET, fl.autoid PAUTOID
                    from FEETRANREPAIR fe, SBSECURITIES sb, FEETRANDETAIL fl
                    WHERE fe.STATUS IN ('A','C')
                    AND fe.deltd <> 'Y'
                    AND fe.symbol = sb.symbol
                    AND fe.txdate = fl.txdate
                    AND fe.txnum = fl.txnum
                    AND fe.custid = rec.CUSTID
                    AND fe.orderid=rec.orderid;
                END IF;

                --trung.luu: 29-06-2021  SHBVNEX-2367
                --log lai de check sinh phi trung trong thang
                insert into log_1203_by_month (autoid, txnum, txdate, feetxdate,feemonth, custodycd, subtype,feetypes, deltd)
                values (seq_log_1203_by_month.nextval,p_txmsg.txnum,to_date(p_txmsg.txdate,SYSTEMNUMS.C_DATE_FORMAT),to_date(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT),substr(p_txmsg.txfields('20').value,4,7), rec.custodycd,'001', 'TRANREPAIR','N');
            END IF;
        END LOOP;

        INSERT INTO FEETRANREPAIRHIST
        SELECT *
        FROM FEETRANREPAIR FE
        WHERE FE.STATUS IN ('A','C')
        AND FE.DELTD <> 'Y';

        DELETE FEETRANREPAIR
        WHERE STATUS IN ('A','C')
        AND DELTD <> 'Y';
        --================================ End Phi? giao di?ch =====================================================

        --================================ Phi? minimum =====================================================
        FOR rec IN
        (
            SELECT * FROM CFMAST CF WHERE CF.STATUS <> 'C' AND SUPEBANK='N'
            AND CF.CUSTATCOM ='Y'
            and cf.custodycd = p_txmsg.txfields('88').value
            and cf.bondagent <> 'Y'
            and substr(CF.CUSTODYCD,0,4) <> v_sysvar
            ORDER BY CF.CUSTID
        ) LOOP

            SELECT NVL(SUM(fe.feeamt),0) INTO V_TOTALFEE
            FROM VW_FEETRAN_ALL fe
            WHERE fe.custodycd = rec.custodycd
            AND ((fe.feetypes = 'SEDEPO' AND fe.subtype = '001') OR (fe.feetypes = 'TRANREPAIR' AND fe.subtype IN ('001','002')))
            AND fe.deltd <> 'Y'
            AND fe.type = 'F'
            AND TO_CHAR(TO_DATE(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT), 'MM/RRRR') LIKE TO_CHAR(TO_DATE(fe.txdate, SYSTEMNUMS.C_DATE_FORMAT), 'MM/RRRR');

            BEGIN
                SELECT FE.FEECD INTO V_FEECD FROM FEEMASTER FE WHERE FE.REFCODE = 'OTHER' AND FE.SUBTYPE = '007' AND FE.STATUS = 'Y';
            EXCEPTION WHEN OTHERS THEN
                V_FEECD := '';
            END;

            SELECT COUNT(*) INTO V_COUNT
            FROM CFFEEEXP
            WHERE CUSTODYCD = REC.CUSTODYCD
            AND FEECD = V_FEECD
            AND EFFDATE <= TO_DATE(P_TXMSG.TXFIELDS('20').VALUE,SYSTEMNUMS.C_DATE_FORMAT)
            AND EXPDATE >= TO_DATE(P_TXMSG.TXFIELDS('20').VALUE,SYSTEMNUMS.C_DATE_FORMAT);

            IF V_COUNT > 0 THEN
                --trung.luu : 26/06/2020 SHBVNEX-825 neu khai bieu phi rieng thi lay ccycd theo bieu phi rieng
                select cf.feecd, cf.feeval, mst.feecode, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feerate, cf.vatrate
                into V_FEECD, V_REPAIRFEE, V_feecode, V_CCYCD, V_FEERATE, v_vatrate
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.CUSTODYCD = rec.custodycd
                and mst.status = 'Y'
                and mst.refcode = 'OTHER'
                and mst.subtype = '007'
                AND CF.EFFDATE <= TO_DATE(P_TXMSG.TXFIELDS('20').VALUE,SYSTEMNUMS.C_DATE_FORMAT)
                AND CF.EXPDATE >= TO_DATE(P_TXMSG.TXFIELDS('20').VALUE,SYSTEMNUMS.C_DATE_FORMAT);
            ELSE
                SELECT COUNT(*) INTO V_COUNT
                FROM CFFEEEXP
                WHERE AMCID = REC.AMCID
                AND FEECD = V_FEECD
                AND EFFDATE <= TO_DATE(P_TXMSG.TXFIELDS('20').VALUE,SYSTEMNUMS.C_DATE_FORMAT)
                AND EXPDATE >= TO_DATE(P_TXMSG.TXFIELDS('20').VALUE,SYSTEMNUMS.C_DATE_FORMAT);

                IF V_COUNT > 0 THEN
                    select cf.feecd, cf.feeval, mst.feecode, nvl(cf.ccycd,mst.ccycd)ccycd, mst.feerate, cf.vatrate
                    into V_FEECD, V_REPAIRFEE, V_feecode, V_CCYCD, V_FEERATE, v_vatrate
                    from cffeeexp cf, feemaster mst
                    where cf.feecd = mst.feecd
                    and cf.amcid = rec.amcid
                    and mst.status = 'Y'
                    and mst.refcode = 'OTHER'
                    and mst.subtype = '007'
                    AND CF.EFFDATE <= TO_DATE(P_TXMSG.TXFIELDS('20').VALUE,SYSTEMNUMS.C_DATE_FORMAT)
                    AND CF.EXPDATE >= TO_DATE(P_TXMSG.TXFIELDS('20').VALUE,SYSTEMNUMS.C_DATE_FORMAT);
                ELSE
                    SELECT COUNT(*) INTO V_COUNT
                    FROM CFFEEEXP
                    WHERE AMCID = REC.GCBID
                    AND FEECD = V_FEECD
                    AND EFFDATE <= TO_DATE(P_TXMSG.TXFIELDS('20').VALUE,SYSTEMNUMS.C_DATE_FORMAT)
                    AND EXPDATE >= TO_DATE(P_TXMSG.TXFIELDS('20').VALUE,SYSTEMNUMS.C_DATE_FORMAT);

                    IF V_COUNT > 0 THEN
                        select cf.feecd, cf.feeval, mst.feecode, nvl(cf.ccycd,mst.ccycd)ccycd, mst.feerate, cf.vatrate
                        into V_FEECD, V_REPAIRFEE, V_feecode, V_CCYCD, V_FEERATE, v_vatrate
                        from cffeeexp cf, feemaster mst
                        where cf.feecd = mst.feecd
                        and cf.amcid = rec.gcbid
                        and mst.status = 'Y'
                        and mst.refcode = 'OTHER'
                        and mst.subtype = '007'
                        AND CF.EFFDATE <= TO_DATE(P_TXMSG.TXFIELDS('20').VALUE,SYSTEMNUMS.C_DATE_FORMAT)
                        AND CF.EXPDATE >= TO_DATE(P_TXMSG.TXFIELDS('20').VALUE,SYSTEMNUMS.C_DATE_FORMAT);
                    ELSE
                        SELECT fe.feecd, fe.feeamt, fe.feerate, fe.ccycd, fe.feecode, fe.vatrate
                        INTO V_FEECD, V_REPAIRFEE, V_FEERATE, V_CCYCD, V_feecode, v_vatrate
                        FROM FEEMASTER fe
                        WHERE fe.refcode = 'OTHER' AND fe.subtype = '007' and fe.status = 'Y';
                    END IF;
                END IF;
            END IF;

            SELECT en_display into v_desc FROM vw_feedetails_all WHERE filtercd = '007' and id='OTHER';
            IF rec.country = '234' THEN
                V_DESC := 'Phi duy tri toi thieu '|| TO_CHAR(TO_DATE(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT), 'MM/RRRR');
            ELSE
                V_DESC := 'Minimum charge '|| TO_CHAR(TO_DATE(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT), 'MM/RRRR');
            END IF;

            IF(V_REPAIRFEE > V_TOTALFEE ) THEN
                V_AUTOID := SEQ_FEETRAN.NEXTVAL;
                --tinh phi toi thieu *date/30
                SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(P_TXMSG.TXFIELDS('20').VALUE,SYSTEMNUMS.C_DATE_FORMAT)),'DD')) V_LASTMONTH INTO V_LASTMONTH FROM DUAL;
                SELECT TO_NUMBER(SUBSTR(P_TXMSG.TXFIELDS('20').VALUE,0,2)) INTO V_DATE_MINIUM FROM DUAL;

                v_fee_minium := ((V_REPAIRFEE - V_TOTALFEE)*v_date_minium)/V_LASTMONTH;
                if V_CCYCD <> 'VND' then
                    v_fee_minium:= round(v_fee_minium,2);
                    v_vatamt:=  round(v_fee_minium * v_vatrate/100,2);
                else
                    v_fee_minium:= round(v_fee_minium,0);
                    v_vatamt:=  round(v_fee_minium * v_vatrate/100,0);
                end if;

                INSERT INTO FEETRAN (TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE, VATAMT, AUTOID, TRDESC, CCYCD, ORDERID, TYPE, DEDUCTEDPLACE, STATUS, PAIDDATE, PSTATUS, SUBTYPE, FEETYPES, CUSTODYCD, FEECODE)
                VALUES (TO_DATE(p_txmsg.txfields('20').value, SYSTEMNUMS.C_DATE_FORMAT), p_txmsg.txnum, 'N',V_FEECD , null, 0.0000, v_fee_minium, V_FEERATE, v_vatrate, v_vatamt, V_AUTOID , 'Corresponding rounding amount', V_CCYCD, null, 'F', null, 'N', null, null,'007', 'OTHER' , rec.custodycd,V_feecode); --NAM.LY 27/04/2020 SHBVNEX-941

                INSERT INTO feetrandetail (AUTOID, REFID, TXDATE, TXNUM, SUBTYPE, FEETYPES, TXAMT, FEEAMT, ORDERID, CUSTODYCD, CCYCD, RATEAMT, FORP, SEBAL, ASSET)
                VALUES (SEQ_FEETRANDETAIL.NEXTVAL, V_AUTOID,TO_DATE(p_txmsg.txdate, SYSTEMNUMS.C_DATE_FORMAT), null,'007', 'OTHER' , 0.0000,  v_fee_minium, null,rec.custodycd ,V_CCYCD,0.0000,'F', 0 , 0);

                --trung.luu: 29-06-2021  SHBVNEX-2367
                --log lai de check sinh phi trung trong thang
                insert into log_1203_by_month (autoid, txnum, txdate, feetxdate,feemonth, custodycd, subtype,feetypes, deltd)
                values (seq_log_1203_by_month.nextval,p_txmsg.txnum,to_date(p_txmsg.txdate,SYSTEMNUMS.C_DATE_FORMAT),to_date(p_txmsg.txfields('20').value,SYSTEMNUMS.C_DATE_FORMAT),substr(p_txmsg.txfields('20').value,4,7), rec.custodycd,'007', 'OTHER','N');
            END IF;
        END LOOP;
            --================================End Phi? minimum =====================================================
    else --trung.luu: 28-06-2021 SHBVNEX-968 xoa gd

        --phi giao dich:
        UPDATE FEETRANREPAIRHIST SET DELTD = 'Y'
        WHERE TXNUM = P_TXMSG.TXNUM
        AND TXDATE = TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT);

        INSERT INTO FEETRANREPAIR
        SELECT * FROM FEETRANREPAIRHIST WHERE STATUS = 'C' AND DELTD <> 'Y';

        UPDATE FEETRANREPAIR SET STATUS = 'P' WHERE STATUS = 'C';

        UPDATE FEETRANREPAIRHIST SET DELTD = 'Y', STATUS = 'A' WHERE STATUS = 'C';

        --
        DELETE FROM FEETRANDETAIL WHERE TXNUM = P_TXMSG.TXNUM AND TXDATE = TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT);

        --xoa feetran
        update FEETRAN set deltd = 'Y'
        where TXDATE = TO_DATE (p_txmsg.txfields('20').value, systemnums.C_DATE_FORMAT)
        and txnum = p_txmsg.txnum;

        --xoa bang log
        update log_1203_by_month set deltd = 'Y'
        where TXDATE = TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT)
        and txnum = p_txmsg.txnum;

        --xoa tllog
        update tllog set deltd = 'Y'
        where TXDATE = to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT)
        and txnum = p_txmsg.txnum;
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
         plog.init ('TXPKS_#1203EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1203EX;
/
