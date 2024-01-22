SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8864ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8864EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      30/10/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#8864ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_codeid           CONSTANT CHAR(2) := '01';
   c_symbol           CONSTANT CHAR(2) := '68';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_acct             CONSTANT CHAR(2) := '03';
   c_desacctno        CONSTANT CHAR(2) := '06';
   c_acctno           CONSTANT CHAR(2) := '05';
   c_exectype         CONSTANT CHAR(2) := '23';
   c_tradedate        CONSTANT CHAR(2) := '20';
   c_settledate       CONSTANT CHAR(2) := '21';
   c_qtty             CONSTANT CHAR(2) := '12';
   c_parvalue         CONSTANT CHAR(2) := '11';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_source varchar2(10);
    l_identity varchar2(200);
    l_vsdorderid varchar2(200);
    l_codeid varchar2(50);
    l_count number;
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
    IF P_TXMSG.DELTD <> 'Y' THEN
        L_SOURCE := P_TXMSG.TXFIELDS('04').VALUE;
        L_IDENTITY := P_TXMSG.TXFIELDS('29').VALUE;
        L_VSDORDERID := P_TXMSG.TXFIELDS('37').VALUE;
        L_CODEID := P_TXMSG.TXFIELDS('01').VALUE;

        IF L_SOURCE = '3' THEN
            IF NVL(L_VSDORDERID, 'XXX') = 'XXX' THEN
                P_ERR_CODE := '-400505';
                PLOG.SETENDSECTION (PKGCTX, 'FN_TXPREAPPCHECK');
                RETURN ERRNUMS.C_BIZ_RULE_INVALID;
            END IF;

            SELECT COUNT(1) INTO L_COUNT FROM SBSECURITIES WHERE CODEID = L_CODEID AND TRADEPLACE = '099';
            IF L_COUNT = 0 THEN
                P_ERR_CODE := '-400507';
                PLOG.SETENDSECTION (PKGCTX, 'FN_TXPREAPPCHECK');
                RETURN ERRNUMS.C_BIZ_RULE_INVALID;
            END IF;

            SELECT COUNT(1) INTO L_COUNT FROM ODMASTVSD WHERE VSDORDERID = L_VSDORDERID AND DELTD = 'N';
            IF L_COUNT > 0 THEN
                P_ERR_CODE := '-100065';
                PLOG.SETENDSECTION (PKGCTX, 'FN_TXPREAPPCHECK');
                RETURN ERRNUMS.C_BIZ_RULE_INVALID;
            END IF;
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
v_deposit varchar2(100);
v_shortname varchar2(100);
p_err_message   varchar2(1000);
v_bondtype varchar2(100);
--8890
v_trfcode varchar2(100);
L_PREFIX varchar2(100);
L_orderid varchar2(100);
v_seacctno varchar2(100);
v_codeid varchar2(100);
v_custid varchar2(100);
v_afacctno varchar2(100);
v_ddacctno varchar2(100);
L_COUNT number;
v_fileid varchar2(100);
v_symbol varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
      
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    --0   Nguon client
    --1   Nguon broker
    --2   Nguon VSD'
    v_fileid := to_char(p_txmsg.txdate,'RRRRMMDD') || p_txmsg.txnum;
    IF p_txmsg.deltd <> 'Y' THEN -- Reversal transaction
        select symbol into v_symbol from sbsecurities where codeid = p_txmsg.txfields('01').value;
        IF p_txmsg.txfields('04').value = '0' THEN
            
            SELECT depositmember INTO v_deposit FROM FAMEMBERS WHERE AUTOID = p_txmsg.txfields('99').value;
            --delete lenh cung ctck da co truoc do
            /*
            delete odmastcust
                where   broker_code = v_deposit
                    and custodycd =p_txmsg.txfields('88').value
                    and sec_id = p_txmsg.txfields('68').value
                    and trans_type = p_txmsg.txfields('23').value
                    and trade_date = p_txmsg.txfields('20').value
                    and quantity =p_txmsg.txfields('12').value
                    or trans_type is null or sec_id is null and FILEID = p_txmsg.tltxcd;
            */
            --trung.luu 24-02-2020 : bo rule ghi de khi insert trung lenh
            /*update odmastcust set deltd ='Y'
            where broker_code = v_deposit
                    and custodycd =p_txmsg.txfields('88').value
                    and sec_id = p_txmsg.txfields('68').value
                    and trans_type = p_txmsg.txfields('23').value
                    and trade_date = p_txmsg.txfields('20').value
                    and via ='T';*/

            INSERT INTO odmastcust (BROKER_CODE,TRANS_TYPE,custodycd,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,PRICE,GROSS_AMOUNT,COMMISSION_FEE,TAX,NET_AMOUNT,AUTOID,ISODMAST,TRANSACTIONTYPE,AP,CITAD,IDENTITY,FILEID, deltd, txtime, VIA,APACCT,ETFDATE)
            VALUES (v_deposit,p_txmsg.txfields('23').value,p_txmsg.txfields('88').value,v_symbol,p_txmsg.txfields('20').value,p_txmsg.txfields('21').value,p_txmsg.txfields('12').value,
                    p_txmsg.txfields('11').value, -- Gia
                    p_txmsg.txfields('14').value, -- Gia tri
                    p_txmsg.txfields('25').value, -- Fee
                    p_txmsg.txfields('26').value, -- VAT
                    p_txmsg.txfields('10').value,seq_imp_temp.nextval,'N',
                    p_txmsg.txfields('27').value,p_txmsg.txfields('31').value,p_txmsg.txfields('13').value,'',v_fileid, p_txmsg.deltd, sysdate,decode(p_txmsg.tlid,'6868','O', 'T'),
                    p_txmsg.txfields('35').value,to_date(p_txmsg.txfields('36').value,'dd/MM/RRRR')
                );
        END IF;
        IF p_txmsg.txfields('04').value = '1' THEN
            SELECT depositmember INTO v_deposit FROM FAMEMBERS WHERE AUTOID = p_txmsg.txfields('99').value;
            --delete lenh cung ctck da co truoc do
            /*
            delete odmastcmp
                where   broker_code = v_deposit
                    and custodycd =p_txmsg.txfields('88').value
                    and sec_id = p_txmsg.txfields('68').value
                    and trans_type = p_txmsg.txfields('23').value
                    and trade_date = p_txmsg.txfields('20').value
                    and quantity =p_txmsg.txfields('12').value
                    or trans_type is null or sec_id is null and FILEID = p_txmsg.tltxcd;
            */
            --trung.luu 24-02-2020 : bo rule ghi de khi insert trung lenh
            /*Update odmastcmp set deltd ='Y'
            where broker_code = v_deposit
                    and custodycd =p_txmsg.txfields('88').value
                    and sec_id = p_txmsg.txfields('68').value
                    and trans_type = p_txmsg.txfields('23').value
                    and trade_date = p_txmsg.txfields('20').value;*/

            INSERT INTO odmastcmp (BROKER_CODE,TRANS_TYPE,custodycd,SEC_ID,TRADE_DATE,SETTLE_DATE,QUANTITY,PRICE,GROSS_AMOUNT,COMMISSION_FEE,TAX,NET_AMOUNT,DELTD,AUTOID,ISODMAST,CITAD,FILEID,txtime,VIA)
            VALUES (v_deposit,p_txmsg.txfields('23').value,p_txmsg.txfields('88').value,v_symbol,p_txmsg.txfields('20').value,p_txmsg.txfields('21').value,p_txmsg.txfields('12').value,
                    p_txmsg.txfields('11').value ,p_txmsg.txfields('14').value,p_txmsg.txfields('25').value,p_txmsg.txfields('26').value,
                        p_txmsg.txfields('10').value,'N',seq_imp_temp.nextval,'N',p_txmsg.txfields('13').value, v_fileid,sysdate,'T');
        END IF;
        IF p_txmsg.txfields('04').value = '2' THEN
            begin
                SELECT depositmember INTO v_deposit FROM FAMEMBERS WHERE AUTOID = p_txmsg.txfields('99').value;
            EXCEPTION WHEN OTHERS THEN
                v_deposit := p_txmsg.txfields('99').value;
            end;
            --delete lenh cung ctck da co truoc do
            /*
            delete odmastvsd
                where   broker_code = v_deposit
                    and custodycd =p_txmsg.txfields('88').value
                    and sec_id = p_txmsg.txfields('68').value
                    and trans_type = p_txmsg.txfields('23').value
                    and trade_date = p_txmsg.txfields('20').value
                    and quantity =p_txmsg.txfields('12').value
                    or trans_type is null or sec_id is null and FILEID = p_txmsg.tltxcd;
            */
            --trung.luu 24-02-2020 : bo rule ghi de khi insert trung lenh
            /*update odmastvsd set deltd ='Y'
            where   broker_code = v_deposit
                    and custodycd =p_txmsg.txfields('88').value
                    and sec_id = p_txmsg.txfields('68').value
                    and trans_type = p_txmsg.txfields('23').value
                    and trade_date = p_txmsg.txfields('20').value;*/

                    --trung.luu: 24/06/2020 SHBVNEX-801 identity lay tu vsd thay vi client nhu truoc
            INSERT INTO odmastvsd (BROKER_CODE,trans_type,custodycd,SEC_ID,TRADE_DATE,SETTLE_DATE,PRICE,QUANTITY,DELTD,AUTOID,ISODMAST,CITAD,FILEID, txtime,grossamount,NET_AMOUNT,identity)
            VALUES (v_deposit,p_txmsg.txfields('23').value,p_txmsg.txfields('88').value,v_symbol,p_txmsg.txfields('20').value,p_txmsg.txfields('21').value,p_txmsg.txfields('11').value,
                    p_txmsg.txfields('12').value ,'N',seq_imp_temp.nextval,'N',p_txmsg.txfields('13').value, v_fileid, sysdate,p_txmsg.txfields('14').value,p_txmsg.txfields('10').value,p_txmsg.txfields('29').value);
        END IF;
        IF p_txmsg.txfields('04').value = '3' THEN
            begin
                SELECT depositmember INTO v_deposit FROM FAMEMBERS WHERE AUTOID = p_txmsg.txfields('99').value;
            EXCEPTION WHEN OTHERS THEN
                v_deposit := p_txmsg.txfields('99').value;
            end;

            INSERT INTO odmastvsd (BROKER_CODE,trans_type,custodycd,SEC_ID,TRADE_DATE,SETTLE_DATE,PRICE,QUANTITY,DELTD,AUTOID,ISODMAST,CITAD,FILEID, txtime,grossamount,NET_AMOUNT,VSDORDERID)
            VALUES (v_deposit,p_txmsg.txfields('23').value,p_txmsg.txfields('88').value,v_symbol,p_txmsg.txfields('20').value,p_txmsg.txfields('21').value,p_txmsg.txfields('11').value,
                    p_txmsg.txfields('12').value ,'N',seq_imp_temp.nextval,'N',p_txmsg.txfields('13').value, v_fileid, sysdate,p_txmsg.txfields('14').value,p_txmsg.txfields('10').value,p_txmsg.txfields('37').value);
        END IF;
    Else
        IF p_txmsg.txfields('04').value = '0' THEN
            update odmastcust set deltd ='Y' where fileid =v_fileid;
        elsif p_txmsg.txfields('04').value = '1' THEN
            update odmastcmp set deltd ='Y' where fileid =v_fileid;
        elsif p_txmsg.txfields('04').value = '2' THEN
            update odmastvsd set deltd ='Y' where fileid =v_fileid;
        End If;
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
         plog.init ('TXPKS_#8864EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8864EX;
/
