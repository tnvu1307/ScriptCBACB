SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3350ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3350EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      19/08/2013     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#3350ex
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
   c_amt              CONSTANT CHAR(2) := '10';
   c_dutyamt          CONSTANT CHAR(2) := '20';
   c_aamt             CONSTANT CHAR(2) := '12';
   c_parvalue         CONSTANT CHAR(2) := '14';
   c_exparvalue       CONSTANT CHAR(2) := '15';
   c_description      CONSTANT CHAR(2) := '30';
   c_fullname         CONSTANT CHAR(2) := '17';
   c_idcode           CONSTANT CHAR(2) := '18';
   c_custodycd        CONSTANT CHAR(2) := '19';
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
   plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppCheck');

   plog.debug (pkgctx, '<<END OF fn_txAftAppCheck');
   plog.setendsection (pkgctx, 'fn_txAftAppCheck');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txAftAppCheck');
      RETURN errnums.C_SYSTEM_ERROR;
END fn_txAftAppCheck;

FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
l_balance NUMBER(20);
v_count number;
 v_countCI number;
    v_countSE number;
    l_catype VARCHAR2(3);
    l_codeid VARCHAR2(6);
    v_status varchar2(1);
    v_execreate number;
    l_currency number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

/*
     -- neu la xoa jao dich: check xem TK co du tien, CK de revert ko
    -- thunt
    if(p_txmsg.deltd = 'Y') THEN
    -- lay ra so du hien tai
    for rec in(
        SELECT dd.balance
        FROM ddmast dd, tllog tl
        WHERE tl.cfcustodycd = dd.custodycd and tl.cfcustodycd=p_txmsg.txfields('19').value and dd.acctno = p_txmsg.txfields('23').value
    )loop
        IF rec.balance < (ROUND((p_txmsg.txfields('10').value-p_txmsg.txfields('13').value)*p_txmsg.txfields('60').value,0))
                       +(ROUND(p_txmsg.txfields('13').value*p_txmsg.txfields('60').value,0))
                       -(ROUND(p_txmsg.txfields('20').value*p_txmsg.txfields('60').value,0))
        THEN
              p_err_code := '-300052'; -- Pre-defined in DEFERROR table
              plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
              RETURN errnums.C_BIZ_RULE_INVALID;
        ELSE
            UPDATE DDMAST SET BALANCE = rec.balance - (ROUND((p_txmsg.txfields('10').value-p_txmsg.txfields('13').value)*p_txmsg.txfields('60').value,0))
                       +(ROUND(p_txmsg.txfields('13').value*p_txmsg.txfields('60').value,0))
                       -(ROUND(p_txmsg.txfields('20').value*p_txmsg.txfields('60').value,0))
            WHERE ACCTNO=p_txmsg.txfields('23').value;
        END IF;
    end loop;
    END IF;*/
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
    v_count number;
    v_countCI number;
    v_countSE number;
    l_catype VARCHAR2(3);
    l_codeid VARCHAR2(6);
    v_status varchar2(1);
    v_execreate number;
    P_NOSTROBANKACCT varchar2(100);
    P_BANKTRANS varchar2(100);
    P_TRFCODE varchar2(100);
    l_refcasaacct varchar2(100);
    l_refAcctno    ddmast.refcasaacct%TYPE;
    l_custid       ddmast.custid%TYPE;
    l_data_source clob;
    l_email varchar2(100);
    l_desc varchar2(1000);
    v_autoid varchar2(10);
    l_tradeplace varchar2(50);
    L_txnum varchar2(50);
    l_custodycd varchar2(20);
    v_custodyP varchar2(10);
    l_symbol varchar2(20);
    l_description varchar2(4000);
    l_EnCDContent varchar2(1000);
    l_EnCDContent2 varchar2(1000);
    v_amt_td number;
    l_result number;
    l_vat number;
    v_amt_after_3343 number;
    l_camastid VARCHAR2(100);
    l_camastid_mask VARCHAR2(100);
    l_autoid number;
    l_formofpayment varchar2(20);
    l_isin varchar2(100);
    l_reportdate date;
    l_reportdate_char varchar2(100);
    l_DEPOSITORY varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    *********************************************************  *****************************************/
    IF cspks_caproc.fn_executecontractcaevent(p_txmsg,p_err_code) <> systemnums.C_SUCCESS THEN
        plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    l_custodycd:=trim(p_txmsg.txfields('19').value);
    l_vat:=trim(p_txmsg.txfields('20').value);
    select trim(varvalue) into v_custodyP
    from sysvar
    where varname = 'DEALINGCUSTODYCD';

    



    begin
        SELECT refcasaacct INTO l_refAcctno
        FROM ddmast
        WHERE acctno = trim(p_txmsg.txfields('23').value);
    EXCEPTION
    WHEN others THEN -- caution handles all exceptions
        l_refAcctno :='';
    end;

if p_txmsg.deltd<>'Y' then
    l_camastid := trim(p_txmsg.txfields('02').value);
    l_camastid_mask := SUBSTR(l_camastid,1,4)||'.'||SUBSTR(l_camastid,5,6)||'.'||SUBSTR(l_camastid,11,6);
    --Ngay 09/03/2020 NamTv them phan Remark
    --Lay ma loai su kien quyen
    select catype, formofpayment,isincode,reportdate,to_char(reportdate,'dd/MM/RRRR') into l_catype, l_formofpayment,l_isin,l_reportdate,l_reportdate_char
    from camast
    where camastid=trim(p_txmsg.txfields('02').value);
    
    select amt into l_result
    from caschd
    where camastid=trim(p_txmsg.txfields('02').value) and afacctno=trim(p_txmsg.txfields('03').value) and deltd <> 'Y';

    --Lay dien giai tieng anh
    select (case when cdval = '023' then 'BOND COUPON' else en_cdcontent end),
           (case when cdval = '023' then (CASE WHEN l_formofpayment = '002' THEN 'BOND COUPONS AND REDEMPTION' ELSE 'BOND COUPON' END) else en_cdcontent end)
    into l_EnCDContent,l_EnCDContent2
    from allcode
    where cdname = 'CATYPE' and cdtype='CA' and cdval = l_catype;
    --Lay thong tin san, ma chung khoan
    begin
        select tradeplace,DEPOSITORY,symbol into l_tradeplace,l_DEPOSITORY,l_symbol
        from sbsecurities
        where codeid=trim(p_txmsg.txfields('24').value);
    EXCEPTION
        WHEN OTHERS
           THEN
       l_tradeplace:='';
       l_symbol:='';
       l_DEPOSITORY:='';
    END;
    --trung.luu : 17-04-2020,tinh thue sau 3343 de giam receiving SHBVNEX-777
    begin
        select nvl(cadtl.amt,cas.amt) into v_amt_after_3343
        from camast ca,caschd cas,
        (
            select * from CASCHDDTL where deltd <>'Y'
        ) cadtl
        where   ca.camastid = trim(p_txmsg.txfields('02').value)
        and ca.camastid = cas.camastid
        and cas.afacctno = trim(p_txmsg.txfields('03').value)
        and cas.autoid = cadtl.autoid_caschd(+)
        and cas.deltd <> 'Y';
    EXCEPTION
    WHEN OTHERS THEN
        v_amt_after_3343 := 0;
    end;
    ----trung.luu : 17-04-2020,tinh thue sau 3343 de giam receiving SHBVNEX-777
    IF to_number(p_txmsg.txfields('13').value) > 0 THEN
        --Tao dien giai theo yeu cau
        l_description:='FCT_TAX ON '|| l_symbol || ' ' || UPPER(l_EnCDContent) || ' PAYMENT ' ||to_char(p_txmsg.txdate,systemnums.C_DATE_FORMAT)||'_VND '||trim(to_char(p_txmsg.txfields('13').value,'999,999,999,999,999'));
    ELSE
        --Tao dien giai theo yeu cau
        l_description:='FCT_TAX ON '|| l_symbol || ' ' || UPPER(l_EnCDContent) || ' PAYMENT ' ||to_char(p_txmsg.txdate,systemnums.C_DATE_FORMAT)||'_VND '||trim(to_char(p_txmsg.txfields('10').value,'999,999,999,999,999'));
    END IF;
    --Ngay 09/03/2020 NamTv End
    --Ghi nhan thue
        v_autoid := seq_feetran.nextval;
        insert into feetran (TXDATE, TXNUM, DELTD, FEECD, GLACCTNO, TXAMT, FEEAMT, FEERATE, VATRATE
                 , VATAMT, AUTOID, TRDESC, CCYCD, ORDERID
                 , TYPE, DEDUCTEDPLACE, STATUS, PAIDDATE, PSTATUS, SUBTYPE, FEETYPES, CUSTODYCD)
        values (p_txmsg.txdate, p_txmsg.txnum, 'N', null, null ,to_number(p_txmsg.txfields('10').value), 0.0000, 0.0000, 0.0000
                   , to_number(p_txmsg.txfields('20').value), v_autoid,l_description,
                   'VND', null, 'T', 'CTCK', 'N', null, null, null, null, p_txmsg.txfields(c_custodycd).value);
        insert into feetrandetail (AUTOID, REFID, TXDATE, TXNUM, SUBTYPE, FEETYPES, TXAMT, FEEAMT, ORDERID, CUSTODYCD, CCYCD, RATEAMT, FORP, CODEID, SEBAL, ASSET)
        values (seq_feetrandetail.nextval, v_autoid, p_txmsg.txdate, p_txmsg.txnum, null, null, to_number(p_txmsg.txfields('10').value), 0.0000, null, p_txmsg.txfields(c_custodycd).value, 'VND', p_txmsg.txfields('20').value, 'T', p_txmsg.txfields('24').value, 0, 0);
    --Ngay 10/01/2019 NamTv check xu ly ma chung khoan OTC theo issue: SHBVNEX-253

    IF (l_tradeplace='003' AND l_DEPOSITORY <> '001') OR l_tradeplace = '' THEN

        IF l_tradeplace = '' THEN
            RETURN -1;
        ELSE

        IF l_catype ='023' THEN
            UPDATE DDMAST
             SET
               LASTCHANGE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
               RECEIVING = RECEIVING - to_number(p_txmsg.txfields('10').value), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=p_txmsg.txfields('23').value;
            INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),TRIM(P_TXMSG.TXFIELDS('23').VALUE),'0008',ROUND(p_txmsg.txfields('10').value,0),NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

        ELSE
            if l_vat > 0 then
                UPDATE DDMAST
                 SET
                   LASTCHANGE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                   RECEIVING = RECEIVING - to_number(p_txmsg.txfields('10').value), LAST_CHANGE = SYSTIMESTAMP
                WHERE ACCTNO=p_txmsg.txfields('23').value;
                INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),TRIM(P_TXMSG.TXFIELDS('23').VALUE),'0008',ROUND(p_txmsg.txfields('10').value,0),NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            else
                UPDATE DDMAST
                 SET
                   LASTCHANGE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                   --RECEIVING = RECEIVING - to_number(l_result),
                   --trung.luu : 17-04-2020,tinh thue sau 3343 de giam receiving SHBVNEX-777
                   RECEIVING = RECEIVING - v_amt_after_3343,
                   LAST_CHANGE = SYSTIMESTAMP
                WHERE ACCTNO=p_txmsg.txfields('23').value;
                INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),TRIM(P_TXMSG.TXFIELDS('23').VALUE),'0008',v_amt_after_3343,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            end if;
        END IF ;
            --Ghi nhan vao bang log de corebank xu ly phi thue
            if to_number(p_txmsg.txfields('20').value)>0 then
                sp_gen_taxinvoice(to_char(to_date(p_txmsg.txdate,systemnums.C_DATE_FORMAT)),p_txmsg.txnum);
            end if;
        END IF;
        -- gen template Unlisted Exec
        --thunt-18/02/2020:send mail otc+bond

        select custid into l_custid from cfmast where custodycd=p_txmsg.txfields('19').value;
        nmpks_ems.pr_GenTemplateUnlistedCAExec(p_camastId => p_txmsg.txfields(c_camastid).value,
                                                p_caschdId => p_txmsg.txfields(c_autoid).value,
                                                p_date     => p_txmsg.txdate,
                                                p_custId   => l_custid,
                                                p_acctno   => p_txmsg.txfields('23').value,
                                                p_taxamt   => p_txmsg.txfields(c_dutyamt).value,
                                                p_amt      =>  p_txmsg.txfields('10').value,
                                                p_isTax    => 'Y',
                                                p_desc     => p_txmsg.txfields('30').value,
                                                p_txmsg    => p_txmsg);
    ELSE
        --Tien giao dich
        --thunt - bo phi thue
        
        IF to_number(p_txmsg.txfields('10').value)-to_number(p_txmsg.txfields('20').value)>0 THEN
            L_txnum:=fn_getglobalid(p_txmsg.txdate, p_txmsg.txnum);
            IF L_CATYPE IN ('040') THEN
                BEGIN
                    SELECT BANKACCTNO, BANKTRANS INTO P_NOSTROBANKACCT, P_BANKTRANS FROM BANKNOSTRO WHERE BANKTRANS='OUTTRFCACASH040';
                EXCEPTION WHEN NO_DATA_FOUND THEN
                    P_ERR_CODE := '-930017';
                    PLOG.SETENDSECTION (PKGCTX, 'FN_TXAFTAPPUPDATE');
                    RETURN ERRNUMS.C_BIZ_RULE_INVALID;
                END;
            ELSE
                BEGIN
                    SELECT BANKACCTNO, BANKTRANS INTO P_NOSTROBANKACCT, P_BANKTRANS FROM BANKNOSTRO WHERE BANKTRANS='OUTTRFCACASH';
                EXCEPTION WHEN NO_DATA_FOUND THEN
                    P_ERR_CODE := '-930017';
                    PLOG.SETENDSECTION (PKGCTX, 'FN_TXAFTAPPUPDATE');
                    RETURN ERRNUMS.C_BIZ_RULE_INVALID;
                END;
            END IF;
            if substr(l_custodycd,0,4)=v_custodyP then --Tai khoan tu doanh
                l_autoid := seq_ca3342_td_result.nextval;
                --trung.luu:04-02-2021  SHBVNEX-1986 thay doi dien giai qua bank
                /* backup
                insert into CA3342_TD_result(autoid, bankaccount, currency, remark, amount,
                        nostroaccount, status, bankglobalid, pstatus, txdate, deltd, lastchange, dorc, reqtxnum)
                VALUES(l_autoid,l_refAcctno,'VND',l_EnCDContent || ' - ref '|| l_camastid_mask || ' - Trx No. ' || L_txnum,  -- dien giai
                       to_number(p_txmsg.txfields('10').value)-to_number(p_txmsg.txfields('20').value),  --- so tien
                       P_NOSTROBANKACCT,'N',L_txnum,null,to_date(p_txmsg.txdate,systemnums.C_DATE_FORMAT),'N',sysdate,'C', L_txnum);
                */

                insert into CA3342_TD_result(autoid, bankaccount, currency, remark, amount,
                        nostroaccount, status, bankglobalid, pstatus, txdate, deltd, lastchange, dorc, reqtxnum)
                VALUES(l_autoid,l_refAcctno,'VND',l_EnCDContent ||' - ' ||l_isin || ' - RD ' ||l_reportdate_char || ' - Event: ' || l_camastid_mask || ' - Trx.: ' || p_txmsg.txnum,  -- dien giai
                       to_number(p_txmsg.txfields('10').value)-to_number(p_txmsg.txfields('20').value),  --- so tien
                       P_NOSTROBANKACCT,'N',L_txnum,null,to_date(p_txmsg.txdate,systemnums.C_DATE_FORMAT),'N',sysdate,'C', L_txnum);
               pck_bankflms.sp_auto_gen_CA3342_TD();
                --thunt-14/04/2020: SHBVNEX-777
               --trung.luu 13-04-2020 update RECEIVING cho Tai khoan tu doanh
               IF l_catype ='023' THEN
                    v_amt_td := to_number(p_txmsg.txfields('10').value);
               ELSE
                    if l_vat > 0 then
                        v_amt_td := to_number(to_number(p_txmsg.txfields('10').value));
                    else
                        v_amt_td := to_number(l_result);
                    end if;
               end if;
                --log tran
                   INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('23').value,'0008',v_amt_td,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');
                --update ddmast

                    UPDATE DDMAST
                     SET
                       LASTCHANGE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                       RECEIVING = RECEIVING - v_amt_td, LAST_CHANGE = SYSTIMESTAMP
                    WHERE ACCTNO=p_txmsg.txfields('23').value;

            else
                pck_bankapi.Bank_NostroWtransfer(trim(p_txmsg.txfields('23').value),  --- tk ddmast tk doi ung (ca nhan)
                                                 P_NOSTROBANKACCT, --- so tk nostro (tu doanh )
                                                 P_BANKTRANS, ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
                                                 'C',  -- Debit or credit
                                                 to_number(p_txmsg.txfields('10').value)-to_number(p_txmsg.txfields('20').value),  --- so tien
                                                 'OUTTRFCACASH', --request code cua nghiep vu trong allcode
                                                 L_txnum,  --requestkey duy nhat de truy lai giao dich goc
                                                 --l_EnCDContent2 || ' - ref '|| l_camastid_mask || ' - Trx No. ' || L_txnum, --trung.luu:04-02-2021  SHBVNEX-1986 thay doi dien giai qua bank
                                                 l_EnCDContent ||' - ' ||l_isin || ' - RD ' ||l_reportdate_char|| ' - Event: '|| l_camastid_mask || ' - Trx.: ' || p_txmsg.txnum, -- dien giai
                                                 '0000', -- nguoi tao giao dich
                                                 p_err_code);
                IF p_err_code <> systemnums.C_SUCCESS then
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN -1;
                END IF;
                IF l_catype ='023' THEN
                    UPDATE DDMAST
                     SET
                       LASTCHANGE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                       RECEIVING = RECEIVING - to_number(p_txmsg.txfields('10').value), LAST_CHANGE = SYSTIMESTAMP
                    WHERE ACCTNO=p_txmsg.txfields('23').value;

                    INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('23').value,'0008',p_txmsg.txfields('10').value,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

                ELSE
                    if l_vat > 0 then
                        UPDATE DDMAST
                         SET
                           LASTCHANGE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                           RECEIVING = RECEIVING - to_number(p_txmsg.txfields('10').value), LAST_CHANGE = SYSTIMESTAMP
                        WHERE ACCTNO=p_txmsg.txfields('23').value;

                         INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('23').value,'0008',p_txmsg.txfields('10').value,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

                    else
                        UPDATE DDMAST
                         SET
                           LASTCHANGE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                           --RECEIVING = RECEIVING - to_number(l_result),
                           --trung.luu : 17-04-2020,tinh thue sau 3343 de giam receiving SHBVNEX-777
                           RECEIVING = RECEIVING - v_amt_after_3343,
                           LAST_CHANGE = SYSTIMESTAMP
                        WHERE ACCTNO=p_txmsg.txfields('23').value;

                         INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('23').value,'0008',v_amt_after_3343,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

                    end if;
                END IF ;

            end if;
        END IF;

        --Ghi nhan vao bang log de corebank xu ly phi thue
        if to_number(p_txmsg.txfields('20').value)>0 then
            sp_gen_taxinvoice(to_char(to_date(p_txmsg.txdate,systemnums.C_DATE_FORMAT)),p_txmsg.txnum);
        end if;

        if l_tradeplace='003' then
            -- gen template Unlisted Exec
            --thunt-18/02/2020:send mail otc+bond
            select custid into l_custid from cfmast where custodycd=p_txmsg.txfields('19').value;
            nmpks_ems.pr_GenTemplateUnlistedCAExec(p_camastId => p_txmsg.txfields(c_camastid).value,
                                                    p_caschdId => p_txmsg.txfields(c_autoid).value,
                                                    p_date     => p_txmsg.txdate,
                                                    p_custId   => l_custid,
                                                    p_acctno   => p_txmsg.txfields('23').value,
                                                    p_taxamt   => p_txmsg.txfields(c_dutyamt).value,
                                                    p_amt      =>  p_txmsg.txfields('10').value,
                                                    p_isTax    => 'Y',
                                                    p_desc     => p_txmsg.txfields('30').value,
                                                    p_txmsg    => p_txmsg);
        else
            -- gen template EM15
            nmpks_ems.pr_GenTemplateEM15 (p_camastId     => p_txmsg.txfields(c_camastid).value,
                                        p_txdate       => TO_CHAR(p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                                        p_custodycd    => p_txmsg.txfields(c_custodycd).value,
                                        p_quantity     => p_txmsg.txfields('11').value,
                                        p_amount       => to_number(p_txmsg.txfields('10').value),
                                        p_benefit_acct => l_refAcctno,
                                        p_desc         => p_txmsg.txfields(c_description).value);

            for rec in(
                select cf.custid, cf.custodycd,cf.custtype, ca.afacctno, ca.actiondate, ca.camastid, ca.codeid, ca.tmpl, cf.fullname, cf.email, sb.symbol, iss.fullname symname,iss.en_fullname en_symname,
                    a3.cdcontent tradeplace, se.trade,ca.qtty,cf.cifid,ca.catype,ca.rate, ca.devidentshares,ca.frdatetransfer,ca.advdesc,ca.canceldate,ca.description,
                    nvl(a1.cdcontent,'') FRTRADEPLACE, nvl(a2.cdcontent,'') TOTRADEPLACE,ca.exprice,ca.optsymbol,ca.caisincode,ca.debitdate,ca.meetingplace,ca.aqtty, --chuyen san
                    nvl(a4.symbol,'') symbol2, nvl(a4.fullname,'') symname2, nvl(a4.en_fullname,'') en_symname2, nvl(a4.tradeplace,'') TRADEPLACE2, ca.EXRATE,ca.aamt, --chuyen doi CP thanh CP
                    a4.isincode, ltrim(to_char(sb.parvalue, '9,999,999,999,999')) parvalue, iss.officename, iss.en_officename, iss.address, iss.en_address, iss.phone,
                    iss.fax, a5.cdcontent sectype, a5.en_cdcontent en_sectype, ca.duedate, ca.reportdate, ca.devidentvalue,ca.transfertimes, ca.insdeadline,ca.balance --Giai the to chuc phat hanh
                    ,a6.en_cdcontent encdcontent    --thangpv SHBVNEX-2672
                from
                    (--chi gui cho moi gioi
                        select af.custid,sch.afacctno,ca.actiondate,ca.camastid,sch.qtty+decode(ca.catype,'027',sch.aqtty,0) qtty,sch.codeid,
                                case when ca.catype='019' and ca.totradeplace not in ('009','003') then '116E'
                                  when ca.catype='027' and (DEVIDENTRATE+DEVIDENTVALUE = 0) then '117E'
                                  when ca.catype='027' and (DEVIDENTRATE+DEVIDENTVALUE > 0) then '118E'
                                  when ca.catype in ('017') then '119E'
                                  when ca.catype='019' and ca.totradeplace in ('009','003') then '120E'
                                  when ca.catype in ('010','015') then '240E'
                                  when ca.catype in ('021','011') then '241E'
                                  when ca.catype in ('026','020') then '242E'
                                  when ca.catype in ('023') then '243E'
                                  when ca.catype in ('022') then '244E'
                                  when ca.catype in ('006') then '245E'
                                  when ca.catype in ('016') then '246E'
                                  when ca.catype in ('003','031') then '247E'
                                  else '' end tmpl,
                               ca.FRTRADEPLACE, ca.TOTRADEPLACE, --chuyen san
                               ca.TOCODEID, ca.EXRATE, --chuyen doi CP thanh CP
                               ca.isincode caisincode, ca.duedate, ca.reportdate, ca.devidentvalue, sch.afacctno||sch.codeid seacctno,--giai the to chuc PH
                               ca.rate, ca.catype,ca.devidentshares,ca.frdatetransfer, ca.advdesc, ca.canceldate,ca.description,ca.exprice,
                               ca.optsymbol,ca.transfertimes, ca.insdeadline, ca.debitdate, ca.meetingplace, sch.balance,sch.aamt,sch.qtty aqtty
                        from CASCHD sch, camast ca, afmast af --, cfmast cf
                        where ca.camastid=sch.camastid
                            and sch.afacctno=af.acctno
                            and ca.camastid = p_txmsg.txfields('03').value
                    )ca, /*aftemplates atp,*/ cfmast cf, sbsecurities sb, issuers iss,
                    (
                        select cdval, cdcontent,en_cdcontent from allcode where cdname='TRADEPLACE' and cdtype='OD'
                    ) a1,
                    (
                        select cdval, cdcontent,en_cdcontent from allcode where cdname='TRADEPLACE' and cdtype='OD'
                    ) a2,
                    (
                        select cdval, cdcontent,en_cdcontent from allcode where cdname='TRADEPLACE' and cdtype='OD'
                    ) a3,
                    (
                        select sb.codeid, sb.symbol, iss.fullname,iss.en_fullname, a0.cdcontent tradeplace,sb.isincode
                        from sbsecurities sb, issuers iss, allcode a0
                        where sb.issuerid=iss.issuerid
                            and a0.cdname='TRADEPLACE' and a0.cdtype='OD' and sb.tradeplace=a0.cdval
                    ) a4,
                    (
                        select cdval, cdcontent,en_cdcontent from allcode where cdname='SECTYPE' and cdtype='SA'
                    ) a5,
                    (
                        select cdval, cdcontent,en_cdcontent from allcode where cdname='CATYPE' and cduser='Y'
                    ) a6
                    , templates t, (
                        select nvl(sb.refcodeid,sb.codeid) codeid, se.afacctno||nvl(sb.refcodeid,sb.codeid) acctno, sum(trade+mortage+blocked+emkqtty) trade
                        from semast se, sbsecurities sb where se.codeid=sb.codeid and sb.sectype <> '004'
                        group by nvl(sb.refcodeid,sb.codeid), se.afacctno
                    ) se
                where ca.custid=cf.custid
                  and ca.tmpl=t.code and t.isactive='Y'
                  and sb.codeid=ca.codeid
                  and sb.issuerid=iss.issuerid
                  and nvl(ca.FRTRADEPLACE,' ')=a1.cdval(+)
                  and nvl(ca.TOTRADEPLACE,' ')=a2.cdval(+)
                  and sb.tradeplace=a3.cdval
                  and nvl(ca.TOCODEID,' ')=a4.codeid(+)
                  and sb.sectype=a5.cdval
                  and ca.seacctno=se.acctno
                  and ca.catype =a6.cdval(+)
            ) loop
                     select refcasaacct into l_refcasaacct from ddmast where afacctno = rec.afacctno;
                     l_catype:=to_char(rec.catype);
                     l_desc:=to_char(p_txmsg.txfields('05').value);
                     IF l_catype in ('010','015') then---
                        l_data_source:='select '''||(rec.symbol)||''' p_securitiesid, '''||(rec.isincode)||''' p_isincode, '''||l_desc||''' p_eventtype, '''||(rec.rate)||''' p_cashpershare, '''
                                        || (rec.fullname) ||''' p_portfolioname, '''|| (rec.camastid) ||''' p_event_ref_no, '''|| p_txmsg.txfields('10').value||''' p_cashamountpaid, '
                                        ||(rec.balance)||' p_entitledholding, '''||(rec.cifid)||''' p_portfoliono, '''
                                        ||l_refcasaacct||' p_creditedcashaccount, '''||(p_txmsg.txfields('10').value)||''' p_cashamountbeforetax, case when rec.custtype=''B'' then 0 else '''||(p_txmsg.txfields('10').value-p_txmsg.txfields('20').value)||' end p_withheldtax, '''||(p_txmsg.txfields('20').value)||''' p_cashamountaftertax, '''
                                        ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_recorddate, '''||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_paymentdate,'''||rec.encdcontent||''' p_event_type from dual ';          --thangpv SHBVNEX-2672
                     ELSIF l_catype in ('021','009','011') then---
                        l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''||rec.isincode||''' p_isincode, '''||p_txmsg.txfields('05').value||''' p_eventtype, '''||rec.rate||''' p_paymentratio, '''
                                        || rec.fullname ||''' p_portfolioname, '''|| rec.camastid ||''' p_event_ref_no, '''|| rec.afacctno ||''' acctno, '
                                        ||rec.balance||' p_entitledholding, '''||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_creditedsecuritiesaccount, '''
                                        ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_noofsharesreceived, '''
                                        ||l_refcasaacct||''' p_creditedcashaccount, '''
                                        ||p_txmsg.txfields('10').value||''' p_cashamountpaid, '''
                                        ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_paymentdate,'''||rec.encdcontent||''' p_event_type from dual ';       --thangpv SHBVNEX-2672
                     ELSIF l_catype='023' then---
                        l_data_source:='select '''|| rec.fullname ||''' p_portfolioname, '''|| rec.symbol ||''' p_securitiesid, '''|| rec.isincode ||''' p_isincode, '''
                        ||rec.symbol2||''' p_newsecuritiesid, '''||rec.en_symname||''' p_newsecuritiesisincode, '''||rec.cifid||''' p_portfoliono, '''
                        ||p_txmsg.txfields('05').value||''' p_eventtype, '''||rec.camastid||''' p_event_ref_no, '''||rec.devidentvalue||''' p_conversionprice, '''||rec.devidentshares||''' p_conversionratio, '''
                        ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_conversionregistrationperiod, '''||to_char(rec.duedate,'DD/MM/RRRR')||''' p_conversionregistrationdeadline, '''
                        ||l_refcasaacct||''' p_creditedcashaccount, '''||to_char(rec.duedate,'DD/MM/RRRR')||''' p_paymentdate, '''
                        ||rec.rate||''' p_couponexecutionratio, '''||to_char(rec.duedate,'DD/MM/RRRR')||''' p_paymentdate, '''
                        ||p_txmsg.txfields('10').value||''' p_cashamountpaid, '''||rec.qtty||''' p_creditedsecuritiesaccount, '''||rec.qtty||''' p_noofsharesreceived, '''
                        ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_recorddate, '''||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_conversiondate, '||rec.balance||' p_entitledholding,'''||rec.encdcontent||''' p_event_type from dual ';       --thangpv SHBVNEX-2672
                     ELSIF l_catype  in ('026','020','017','018') then---
                        l_data_source:='select '''|| rec.fullname ||''' p_portfolioname, '''|| rec.symbol ||''' p_securitiesid, '''|| rec.isincode ||''' p_isincode, '''
                        ||rec.symbol2||''' p_newsecuritiesid, '''||rec.en_symname||''' p_newsecuritiesisincode, '''||rec.cifid||''' p_portfoliono, '''
                        ||p_txmsg.txfields('05').value||''' p_eventtype, '''||rec.camastid||''' p_event_ref_no, '''||rec.devidentvalue||''' p_conversionprice, '''||rec.devidentshares||''' p_conversionratio, '''
                        ||to_char(getcurrdate,'DD/MM/RRRR')||''' p_lasttradingdate, '''||rec.qtty||''' p_noofnewsharesreceive, '''
                        ||p_txmsg.txfields('10').value||''' p_cashamountpaid, '''||l_refcasaacct||''' p_creditedcashaccount, '''
                        ||to_char(rec.canceldate,'DD/MM/RRRR')||''' p_creditedsecuritiesaccount, '''||to_char(rec.duedate,'DD/MM/RRRR')||''' p_paymentdate, '''
                        ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_recorddate, '''||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_conversiondate, '||rec.balance||' p_entitledholding,'''||rec.encdcontent||''' p_event_type from dual ';      --thangpv SHBVNEX-2672
                     ELSIF l_catype='016' then---
                        l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''||rec.isincode||''' p_isincode, '''||l_refcasaacct||''' p_creditedcashaccount, '''||rec.exprice||''' p_redemptionvalue, '''
                                        || rec.fullname ||''' p_portfolioname, '''||p_txmsg.txfields('05').value ||''' p_eventtype, '''|| rec.camastid ||''' p_event_ref_no, '||rec.balance||' p_entitledholding, '''
                                        || to_char(rec.duedate,'DD/MM/RRRR') ||''' p_maturitydate, '''|| rec.camastid ||''' p_event_ref_no, '||rec.cifid||' p_portfoliono, '''
                                        ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_recorddate, '''||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_actualpaymentdate,'''||rec.encdcontent||''' p_event_type from dual ';        --thangpv SHBVNEX-2672
                     ELSIF l_catype='014' then---
                        l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''||rec.isincode||''' p_isincode, '''||rec.optsymbol||''' p_rightcode, '''||rec.caisincode||''' p_rightisincode, '''
                                        || rec.fullname ||''' p_portfolioname, '''|| rec.symbol ||''' p_subscriptionsecuritiesid, '''|| p_txmsg.txfields('05').value ||''' p_eventtype, '||rec.balance||' p_entitledholding, '''
                                        || rec.camastid ||''' p_event_ref_no, '''|| rec.rate ||''' p_rightdistributionratio, '''|| rec.devidentshares ||''' p_rightexerciseratio, '||rec.transfertimes||' p_righttransferperiod, '''
                                        ||to_char(rec.insdeadline,'DD/MM/RRRR')||''' p_deadlineforrighttransfer, '''||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_rightsubscriptionperiod, '''
                                        ||to_char(rec.canceldate,'DD/MM/RRRR')||''' p_deadlineforrightsubscription, '''||to_char(rec.debitdate,'DD/MM/RRRR')||''' p_debitdate, '''
                                        ||rec.qtty||''' p_noofentitledrights, '''||rec.aqtty||''' p_noofnewsharespurchase, '''||p_txmsg.txfields('10').value||''' p_cashamountpaid, '''
                                        ||rec.qtty||''' p_noofsharesreceived, '''||rec.aqtty||''' p_creditedsecuritiesaccount, '''
                                        ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_recorddate, '''||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_expectedpaymentdate from dual ';
                     ELSE
                       l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''||rec.isincode||''' p_isincode, '''||p_txmsg.txfields('05').value||''' p_eventtype, '''||rec.camastid||''' p_event_ref_no, '''
                          || rec.fullname ||''' p_portfolioname, '''|| rec.duedate ||''' p_Maturitydate, '''|| rec.devidentvalue ||''' p_redemptionvalue, '||rec.balance||' p_entitledholding, '''
                          || rec.cifid ||''' p_portfoliono, '''|| rec.balance ||''' p_redemptionamountpaid, '''
                          ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_recorddate, '''||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_actualpaymentdate,'''||rec.encdcontent||''' p_event_type from dual ';        --thangpv SHBVNEX-2672
                     END IF;
                    
                    nmpks_ems.pr_sendInternalEmail(l_data_source, rec.tmpl, rec.afacctno);
            end loop;

        end if;
    END IF;
else
    --delete phi' thue'
    update feetran set DELTD='Y' where custodycd=p_txmsg.txfields(c_custodycd).value;
    --revert cash for customer
    IF to_number(p_txmsg.txfields('10').value)-to_number(p_txmsg.txfields('20').value)>0 THEN
        L_txnum:=fn_getglobalid(p_txmsg.txdate, p_txmsg.txnum);
        begin
            select bankacctno,banktrans into P_NOSTROBANKACCT,P_BANKTRANS from banknostro where banktrans='OUTTRFCACASH';
        exception when NO_DATA_FOUND
                THEN
                p_err_code := '-930017';
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
        end;
        if to_number(p_txmsg.txfields('20').value)>0 then
            UPDATE TAX_BOOKING_RESULT set deltd ='Y' where bankglobalid =L_txnum;
        end if;
        pck_bankapi.Bank_NostroWtransfer(trim(p_txmsg.txfields('23').value),  --- tk ddmast tk doi ung (ca nhan)
                                         P_NOSTROBANKACCT, --- so tk nostro (tu doanh )
                                         P_BANKTRANS, ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
                                         'D',  -- Debit or credit
                                         to_number(p_txmsg.txfields('10').value)-to_number(p_txmsg.txfields('20').value),  --- so tien
                                         'OUTTRFCACASH', --request code cua nghiep vu trong allcode
                                         L_txnum,  --requestkey duy nhat de truy lai giao dich goc
                                         l_EnCDContent2 || 'Cancel Trx No.' || L_txnum,  -- dien giai
                                         '0000', -- nguoi tao giao dich
                                         p_err_code);
        IF p_err_code <> systemnums.C_SUCCESS then
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN -1;
        END IF;
    END IF;
end if;
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
         plog.init ('TXPKS_#3350EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3350EX;
/
