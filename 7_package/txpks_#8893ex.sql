SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8893ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8893EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      11/10/2019     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/


CREATE OR REPLACE PACKAGE BODY txpks_#8893ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    v_source varchar2(100);
    v_assettype varchar2(100);
    v_count number;
    v_supebank varchar2(10);
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

    p_txmsg.txWarningException('-930114').value:= cspks_system.fn_get_errmsg('-930114');
    p_txmsg.txWarningException('-930114').errlev:= '2';

    v_source := p_txmsg.txfields('04').value;
    v_assettype := p_txmsg.txfields('05').value;

    IF v_assettype = 'TPRL' AND v_source NOT IN ('VSDBROKER', 'CLIENTVSD', 'OD8893') THEN
        p_err_code := '-930030';
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    IF v_assettype NOT IN ('TPRL') THEN
        if v_source = 'OD8893' or v_source = 'BROKERCLIENT' then
            begin
                select count(*) into v_count
                from
                (
                    select v.tradedatectck,v.cmpsettledate,v.cmpmember,vb.custodycd,v.transtype,v.symbol
                    From
                    (select * from v_compare_import where ISODMASTVAL = 'N') v,
                    (select * from v_sum_broker_m where isodmast = 'N') vb
                    where v.custodycd = vb.mcustodycd
                    and v.symbol = vb.sec_id
                    and v.transtype = vb.trans_type
                    and v.cmpmember = vb.shortname
                    and v.tradedateCTCK = vb.trade_date
                    and v.vsdsettledate = vb.settle_date
                    --and note1 = 'Matched'
                    group by v.tradedatectck,v.cmpsettledate,v.cmpmember,vb.custodycd,v.transtype,v.symbol
                    having count(*) > 1
                )
                where rownum = 1;
            exception when NO_DATA_FOUND then
                v_count :=0;
            end;
            if v_count <> 0 then
                p_err_code := '-930024';
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            --trung.luu: 26-01-2021 SHBVNEX-1992
            for r in (
                select vb.custodycd
                from v_compare_import v, v_sum_broker_m vb
                where v.note1 ='Matched'
                and v.isodmast = 'Not confirmed'
                and v.transtype = vb.trans_type
                and v.custodycd = vb.mcustodycd
                and v.symbol = vb.sec_id
                and v.tradedateCTCK = vb.trade_date
            ) loop
                select supebank into v_supebank from cfmast where custodycd = r.custodycd;
                if v_supebank = 'Y' then
                    p_txmsg.txWarningException('-930101').value:= cspks_system.fn_get_errmsg('-930101');
                    p_txmsg.txWarningException('-930101').errlev:= '1';
                end if;
            end loop;
        elsif v_source = 'VSDBROKER' then
            begin ----trung.luu: 25-02-2021  SHBVNEX-2068 doi chieu theo tai khoan me nhung sinh lenh theo tai khoan con
                select count(*) into v_count
                from (
                    select v.tradedatectck,v.cmpsettledate,v.cmpmember,vb.custodycd,v.transtype,v.symbol
                    From
                    (select * from v_compare_VSDBROKER where ISODMASTVAL = 'N') v,
                    (select * from v_sum_broker_m where isodmast = 'N') vb
                    where v.custodycd = vb.mcustodycd
                    and v.symbol = vb.sec_id
                    and v.transtype = vb.trans_type
                    and v.vsdmember = vb.shortname
                    and v.tradedatevsd = vb.trade_date
                    and v.vsdsettledate = vb.settle_date
                    --and note1 = 'Matched'
                    group by v.tradedatectck,v.cmpsettledate,v.cmpmember,vb.custodycd,v.transtype,v.symbol
                    having count(*) > 1
                )
                where rownum = 1;
            exception when NO_DATA_FOUND then
                v_count :=0;
            end;
            if v_count <> 0 then
                p_err_code := '-930024';
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            --trung.luu: 26-01-2021 SHBVNEX-1992
            --trung.luu: 25-02-2021  SHBVNEX-2068 doi chieu theo tai khoan me nhung sinh lenh theo tai khoan con
            for r in (
                select vb.custodycd
                from v_compare_VSDBROKER v, v_sum_broker_m vb
                where v.note1 ='Matched'
                and v.isodmast = 'Not confirmed'
                and v.transtype = vb.trans_type
                and v.custodycd = vb.mcustodycd
                and v.symbol = vb.sec_id
                and v.tradedatevsd = vb.trade_date
            )
            loop
                select supebank into v_supebank from cfmast where custodycd = r.custodycd;
                if v_supebank = 'Y' then
                    p_txmsg.txWarningException('-930101').value:= cspks_system.fn_get_errmsg('-930101');
                    p_txmsg.txWarningException('-930101').errlev:= '1';
                end if;
            end loop;
        elsif v_source = 'CLIENTVSD' then
            begin--trung.luu: 25-02-2021  SHBVNEX-2068 doi chieu theo tai khoan me nhung sinh lenh theo tai khoan con
                select count(*) into v_count
                from (
                    select v.tradedate,v.custsettledate,v.custmember,vc.custodycd,v.transtype,v.symbol
                    From
                    (select * from v_compare_CLIENTVSD where ISODMASTVAL = 'N') v,
                    (select * from v_sum_client_import where isodmast = 'N') vc
                    where v.custodycd = vc.mcustodycd
                    and v.symbol = vc.sec_id
                    and v.transtype = vc.trans_type
                    and v.tradedate = vc.trade_date
                    and v.vsdmember = vc.shortname
                    and v.custsettledate = vc.settle_date
                    --and note1 = 'Matched'
                    group by v.tradedate,v.custsettledate,v.custmember,vc.custodycd,v.transtype,v.symbol
                    having count(*) > 1
                )
                where rownum = 1;
            exception when NO_DATA_FOUND then
                v_count :=0;
            end;
            if v_count <> 0 then
                p_err_code := '-930024';
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            --trung.luu: 26-01-2021 SHBVNEX-1992
            --trung.luu: 25-02-2021  SHBVNEX-2068 doi chieu theo tai khoan me nhung sinh lenh theo tai khoan con
            for r in (
                select vc.custodycd
                from v_compare_CLIENTVSD v,v_sum_client_import vc
                where v.note1 ='Matched'
                and v.isodmast = 'Not confirmed'
                and v.transtype = vc.trans_type
                and v.custodycd = vc.mcustodycd
                and v.symbol = vc.sec_id
                and v.tradedate = vc.trade_date
            )
            loop
                select supebank into v_supebank from cfmast where custodycd = r.custodycd;
                if v_supebank = 'Y' then
                    p_txmsg.txWarningException('-930101').value:= cspks_system.fn_get_errmsg('-930101');
                    p_txmsg.txWarningException('-930101').errlev:= '1';
                end if;
            end loop;
        elsif v_source = 'CLIENT' then
            for r in (
                select custodycd
                from v_compare_import_only_client
                where note1 ='Matched'
                AND ISODMAST = 'Not confirmed'
                GROUP BY CUSTODYCD,TRANSTYPE,SYMBOL,TRADEDATE
            )
            loop
                select supebank into v_supebank from cfmast where custodycd = r.custodycd;
                if v_supebank = 'Y' then
                    p_txmsg.txWarningException('-930101').value:= cspks_system.fn_get_errmsg('-930101');
                    p_txmsg.txWarningException('-930101').errlev:= '2';
                end if;
            end loop;
        elsif v_source = 'BROKER' then
            begin
                select count(*)into v_count from (
                    select v.tradedatectck,v.cmpsettledate,v.cmpmember,vc.custodycd,v.transtype,v.symbol
                    From
                    (select * from v_compare_import_only_broker where ISODMASTVAL = 'N') v,
                    (select * from v_sum_broker_m where isodmast = 'N') vc
                    where v.custodycd = vc.mcustodycd
                    and v.symbol = vc.sec_id
                    and v.transtype = vc.trans_type
                    and v.tradedatectck = vc.trade_date
                    and v.cmpmember = vc.shortname
                    and v.cmpsettledate = vc.settle_date
                    --and note1 = 'Matched'
                    group by v.tradedatectck,v.cmpsettledate,v.cmpmember,vc.custodycd,v.transtype,v.symbol
                    having count(*) > 1
                )
                where rownum = 1;
            exception when NO_DATA_FOUND then
                v_count :=0;
            end;
            if v_count <> 0 then
                p_err_code := '-930024';
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            for r in (
                select custodycd
                from v_compare_import_only_broker
                where note1 ='Matched'
                AND ISODMAST = 'Not confirmed'
                GROUP BY CUSTODYCD,TRANSTYPE,SYMBOL,TRADEDATE
            )
            loop
                select supebank into v_supebank from cfmast where custodycd = r.custodycd;
                if v_supebank = 'Y' then
                    p_txmsg.txWarningException('-930101').value:= cspks_system.fn_get_errmsg('-930101');
                    p_txmsg.txWarningException('-930101').errlev:= '2';
                end if;
            end loop;
        end if;
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

FUNCTION fn_txPreAppUpdate(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    v_supebank varchar2(10);
    v_source varchar2(100);
    v_assettype varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    v_source := p_txmsg.txfields('04').value;
    v_assettype := p_txmsg.txfields('05').value;
    IF v_assettype NOT IN ('TPRL') THEN
        if v_source = 'OD8893' or v_source = 'BROKERCLIENT' then
            --trung.luu: 26-01-2021 SHBVNEX-1992
            for r in (
                select vb.custodycd
                from v_compare_import v, v_sum_broker_m vb
                where v.note1 ='Matched'
                and v.isodmast = 'Not confirmed'
                and v.transtype = vb.trans_type
                and v.custodycd = vb.mcustodycd
                and v.symbol = vb.sec_id
                and v.tradedateCTCK = vb.trade_date
                and v.vsdmember = vb.shortname
            )
            loop
                select supebank into v_supebank from cfmast where custodycd = r.custodycd;
                if v_supebank = 'Y' then
                    p_txmsg.txWarningException('-930101').value:= cspks_system.fn_get_errmsg('-930101');
                    p_txmsg.txWarningException('-930101').errlev:= '1';
                end if;
            end loop;
        elsif v_source = 'VSDBROKER' then
            --trung.luu: 26-01-2021 SHBVNEX-1992
            --trung.luu: 25-02-2021  SHBVNEX-2068 doi chieu theo tai khoan me nhung sinh lenh theo tai khoan con
            for r in (
                select vb.custodycd
                from v_compare_VSDBROKER v,v_sum_broker_m vb
                where v.note1 ='Matched'
                and v.isodmast = 'Not confirmed'
                and v.transtype = vb.trans_type
                and v.custodycd = vb.mcustodycd
                and v.symbol = vb.sec_id
                and v.tradedatevsd = vb.trade_date
                and v.vsdmember = vb.shortname
            )
            loop
                select supebank into v_supebank from cfmast where custodycd = r.custodycd;
                if v_supebank = 'Y' then
                    p_txmsg.txWarningException('-930101').value:= cspks_system.fn_get_errmsg('-930101');
                    p_txmsg.txWarningException('-930101').errlev:= '1';
                end if;
            end loop;
        elsif v_source = 'CLIENTVSD' then
            --trung.luu: 26-01-2021 SHBVNEX-1992
            --trung.luu: 25-02-2021  SHBVNEX-2068 doi chieu theo tai khoan me nhung sinh lenh theo tai khoan con
            for r in (
                select vc.custodycd
                from v_compare_CLIENTVSD v,v_sum_client_import vc
                where v.note1 ='Matched'
                and v.isodmast = 'Not confirmed'
                and v.transtype = vc.trans_type
                and v.custodycd = vc.mcustodycd
                and v.symbol = vc.sec_id
                and v.tradedate = vc.trade_date
                and v.vsdmember = vc.shortname
            )
            loop
                select supebank into v_supebank from cfmast where custodycd = r.custodycd;
                if v_supebank = 'Y' then
                    p_txmsg.txWarningException('-930101').value:= cspks_system.fn_get_errmsg('-930101');
                    p_txmsg.txWarningException('-930101').errlev:= '2';
                end if;
            end loop;
        elsif v_source = 'CLIENT' then
            for r in (
                select custodycd
                from v_compare_import_only_client
                where note1 ='Matched'
                AND ISODMAST = 'Not confirmed'
                GROUP BY CUSTODYCD,TRANSTYPE,SYMBOL,TRADEDATE
            )
            loop
                select supebank into v_supebank from cfmast where custodycd = r.custodycd;
                if v_supebank = 'Y' then
                    p_txmsg.txWarningException('-930101').value:= cspks_system.fn_get_errmsg('-930101');
                    p_txmsg.txWarningException('-930101').errlev:= '2';
                end if;
            end loop;
        elsif v_source = 'BROKER' then
            for r in (
                select custodycd
                from v_compare_import_only_broker
                where note1 ='Matched'
                AND ISODMAST = 'Not confirmed'
                GROUP BY CUSTODYCD,TRANSTYPE,SYMBOL,TRADEDATE
            )
            loop
                select supebank into v_supebank from cfmast where custodycd = r.custodycd;
                if v_supebank = 'Y' then
                    p_txmsg.txWarningException('-930101').value:= cspks_system.fn_get_errmsg('-930101');
                    p_txmsg.txWarningException('-930101').errlev:= '2';
                end if;
            end loop;
        end if;
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
    L_COUNT number;
    L_orderid VARCHAR2(20);
    l_prefix  VARCHAR2(20);
    v_txdate DATE;
    codeid_semast varchar2(100);
    v_depomem varchar2(250);
    v_count number;
    rv_orderid varchar2(100);
    rv_count number;
    rv_trade number;
    rv_qtty number;
    V_HOLD NUMBER;
    v_note_MCVSD varchar2(250);
    l_semastcheck_arr txpks_check.semastcheck_arrtype;
    v_count_buf number;
    amount_NB_NS number;
    v_feedaily varchar2(20);
    v_count_semast number;
    v_version varchar2(200);
    v_odtype varchar2(10);
    v_source varchar2(100);
    v_assettype varchar2(100);
    v_depositmembers varchar2(250);
    v_swiftid varchar2(100);
    v_orderid varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    --select NVL(count(*),0) into v_note_MCVSD from compare_trading_result where INSTRC(note, 'VSD matched') = 0 ;
    SELECT to_date(VARVALUE,'dd/mm/RRRR') INTO v_txdate FROM sysvar WHERE VARNAME='CURRDATE';
    v_version := to_char(p_txmsg.txdate,'RRRRMMDD') || p_txmsg.txnum;
    --SELECT NVL(COUNT(*),0) INTO L_COUNT FROM  compare_trading_result WHERE STATUS ='F';

    v_source := p_txmsg.txfields('04').value;
    v_assettype := p_txmsg.txfields('05').value;

    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction

        --dung case loi
        --DBMS_LOCK.Sleep(30);
        -- Log KQ xac anh doi chieu.
        Select count(1) into L_COUNT
        from tblconfirm_compare_import
        where txnum = p_txmsg.TXNUM
        and txdate = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)
        and deltd <> 'Y';

        IF L_COUNT = 0  THEN
            --trung.luu : 17-08-2020 update swift khi sinh lenh tu broker-vsd ngay hom truoc
            for re in (
                select v.custodycd,v.transtype,v.symbol,v.tradedatectck,v.cmpsettledate,v.cmpmember,v.cmpamountnet,fa.depositmember
                From v_compare_import v, odmastcust od, v_sum_client_import VC, --TRUNG.LUU: join qua de so sanh tai khoan me voi view v_compare_import
                (select depositmember, shortname from famembers where roles = 'BRK') fa
                where v.isodmast = 'Confirmed' and notevsbr = 'Matched'
                and v.transtype = od.trans_type
                and v.transtype = vc.trans_type --v_sum_client_import
                and v.tradedatectck = od.trade_date
                and v.tradedatectck = vc.trade_date --v_sum_client_import
                and v.cmpsettledate = od.settle_date
                and v.cmpsettledate = vc.settle_date --v_sum_client_import
                and v.symbol = od.sec_id
                and v.symbol = vc.sec_id --v_sum_client_import
                --and v.custodycd = od.custodycd --odmastcust la custodycd con,
                and v.custodycd = vc.mcustodycd --v_compare_import la custodycd me
                and vc.custodycd = od.custodycd
                and v.cmpmember = vc.shortname
                and v.cmpmember = fa.shortname
                and fa.depositmember = od.broker_code
                and od.isodmast = 'N'
                group by v.custodycd,v.transtype,v.symbol,v.tradedatectck,v.cmpsettledate,v.cmpmember,v.cmpamountnet,fa.depositmember
            )
            loop
                begin
                    select fileid into v_swiftid
                    from odmastcust
                    where trans_type = re.transtype
                    and trade_date = re.tradedatectck
                    and settle_date = re.cmpsettledate
                    and sec_id = re.symbol
                    and custodycd = re.custodycd
                    and broker_code = re.depositmember
                    and deltd <> 'Y'
                    and rownum =1;
                exception when NO_DATA_FOUND then
                    v_swiftid:= '';
                end;

                begin
                    select orderid into v_orderid
                    from odmastcmp
                    where trans_type = re.transtype
                    and trade_date = re.tradedatectck
                    and settle_date = re.cmpsettledate
                    and sec_id = re.symbol
                    and custodycd = re.custodycd
                    and broker_code = re.depositmember
                    and deltd <> 'Y'
                    and rownum =1;
                exception when NO_DATA_FOUND then
                    v_orderid:= '';
                end;

                

                update odmastcust set isodmast = 'Y', orderid = v_orderid
                where trans_type = re.transtype
                and trade_date = re.tradedatectck
                and settle_date = re.cmpsettledate
                and sec_id = re.symbol
                and custodycd = re.custodycd
                and broker_code = re.depositmember
                and deltd <> 'Y';
            end loop;
            IF v_assettype IN ('CKNY', 'ALL') THEN
                if v_source = 'OD8893' then
                    --trung.luu: 25-02-2021  SHBVNEX-2068 doi chieu theo tai khoan me nhung sinh lenh theo tai khoan con
                    insert into tblconfirm_compare_import (autoid,codeid,bondtype,symbol,acctno,custid,ddacctno,seacctno,
                                custodycd,exectype,citad,identity,trade_date,settle_date,price,quantity,fee,tax,txnum,txdate, deltd, lastchange, version, memberid,GROSS_AMOUNT,NET_AMOUNT,source)
                    Select seq_tblconfirm_compare_import.nextval autoid, sb.codeid,sb.bondtype,sb.symbol,vb.custid acctno,vb.custid, dd.acctno ddacctno,
                         vb.custid || sb.codeid  seacctno,
                         vb.custodycd,vb.trans_type exectype,vb.citad,vb.identity,vb.trade_date,vb.settle_date, vb.price, vb.quantity, vb.commission_fee fee,  vb.tax,
                         p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.c_date_format) txdate, 'N' deltd, systimestamp lastchange, v_version,vb.shortname cmpmember,vb.GROSS_AMOUNT,vb.NET_AMOUNT,v_source
                    from cfmast cf, ddmast dd, sbsecurities sb,
                    (select * from v_compare_import where ISODMASTVAL = 'N' and note1 = 'Matched') mst,
                    (select * from v_sum_broker_m where isodmast = 'N') vb
                    where cf.custodycd = dd.custodycd
                    and dd.isdefault ='Y' and dd.status <> 'C'
                    and dd.custodycd = vb.custodycd and sb.symbol = mst.symbol
                    and mst.custodycd = vb.mcustodycd
                    and sb.symbol = vb.sec_id
                    and mst.transtype = vb.trans_type
                    and mst.tradedatectck = vb.trade_date
                    and mst.cmpsettledate = vb.settle_date
                    and mst.cmpmember = vb.shortname
                    AND SB.TRADEPLACE NOT IN ('099');
                elsif v_source = 'BROKERCLIENT' then
                    --trung.luu: 25-02-2021  SHBVNEX-2068 doi chieu theo tai khoan me nhung sinh lenh theo tai khoan con
                    insert into tblconfirm_compare_import (autoid,codeid,bondtype,symbol,acctno,custid,ddacctno,seacctno,
                                custodycd,exectype,citad,identity,trade_date,settle_date,price,quantity,fee,tax,txnum,txdate, deltd, lastchange, version, memberid,GROSS_AMOUNT,NET_AMOUNT,source)
                    Select seq_tblconfirm_compare_import.nextval autoid, sb.codeid,sb.bondtype,sb.symbol,vb.custid acctno,vb.custid, dd.acctno ddacctno,
                         vb.custid || sb.codeid  seacctno,
                         vb.custodycd,vb.trans_type exectype,vb.citad,vb.identity,vb.trade_date,vb.settle_date, vb.price, vb.quantity, vb.commission_fee fee,  vb.tax,
                         p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.c_date_format) txdate, 'N' deltd, systimestamp lastchange, v_version,vb.shortname cmpmember,vb.GROSS_AMOUNT,vb.NET_AMOUNT,v_source
                    from cfmast cf, ddmast dd, sbsecurities sb,
                    (select * from v_compare_import where ISODMASTVAL = 'N' and note1 = 'Matched') mst,
                    (select * from v_sum_broker_m where isodmast = 'N') vb
                    where cf.custodycd = dd.custodycd
                    and dd.isdefault ='Y' and dd.status <> 'C'
                    and dd.custodycd = vb.custodycd and sb.symbol = mst.symbol
                    and mst.custodycd = vb.mcustodycd
                    and sb.symbol = vb.sec_id
                    and mst.transtype = vb.trans_type
                    and mst.tradedatectck = vb.trade_date
                    and mst.cmpsettledate = vb.settle_date
                    and mst.cmpmember = vb.shortname
                    AND SB.TRADEPLACE NOT IN ('099');
                elsif v_source = 'VSDBROKER' then -- sinh lenh tu vsd va broker
                    --trung.luu: 25-02-2021  SHBVNEX-2068 doi chieu theo tai khoan me nhung sinh lenh theo tai khoan con
                    insert into tblconfirm_compare_import (autoid,codeid,bondtype,symbol,acctno,custid,ddacctno,seacctno,
                                custodycd,exectype,citad,identity,trade_date,settle_date,price,quantity,fee,tax,txnum,txdate, deltd, lastchange, version, memberid,GROSS_AMOUNT,NET_AMOUNT,source)
                    Select seq_tblconfirm_compare_import.nextval autoid, sb.codeid,sb.bondtype,sb.symbol,vb.custid acctno,vb.custid, dd.acctno ddacctno,
                         vb.custid || sb.codeid  seacctno,
                         vb.custodycd,vb.trans_type exectype,vb.citad,vb.identity,vb.trade_date,vb.settle_date, vb.price, vb.quantity, vb.commission_fee fee,  vb.tax,
                         p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.c_date_format) txdate, 'N' deltd, systimestamp lastchange, v_version,vb.shortname vsdmember,vb.GROSS_AMOUNT,vb.NET_AMOUNT,v_source
                    from cfmast cf, ddmast dd, sbsecurities sb,
                    (select * from v_compare_VSDBROKER where ISODMASTVAL = 'N' and note1 = 'Matched') mst,
                    (select * from v_sum_broker_m where isodmast = 'N') vb
                    where cf.custodycd = dd.custodycd
                    and dd.isdefault ='Y' and dd.status <> 'C'
                    and dd.custodycd = vb.custodycd and sb.symbol = mst.symbol
                    and mst.custodycd = vb.mcustodycd
                    and sb.symbol = vb.sec_id
                    and mst.transtype = vb.trans_type
                    and mst.tradedatevsd = vb.trade_date
                    and mst.vsdsettledate = vb.settle_date
                    and mst.vsdmember = vb.shortname
                    AND SB.TRADEPLACE NOT IN ('099');

                elsif v_source = 'CLIENTVSD' then -- sinh lenh tu client va vsd
                    --trung.luu: 25-02-2021  SHBVNEX-2068 doi chieu theo tai khoan me nhung sinh lenh theo tai khoan con

                    insert into tblconfirm_compare_import (autoid,codeid,bondtype,symbol,acctno,custid,ddacctno,seacctno,
                                custodycd,exectype,citad,identity,trade_date,settle_date,price,quantity,fee,tax,txnum,txdate, deltd, lastchange, version, memberid,GROSS_AMOUNT,NET_AMOUNT,source)
                    Select seq_tblconfirm_compare_import.nextval autoid, sb.codeid,sb.bondtype,sb.symbol,vc.custid acctno,vc.custid, dd.acctno ddacctno,
                         vc.custid || sb.codeid  seacctno,
                         vc.custodycd,vc.trans_type exectype,vc.citad,vc.identity,vc.trade_date,vc.settle_date, vc.price, vc.quantity, vc.commission_fee_cu fee,  vc.tax_cu tax,
                         p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.c_date_format) txdate, 'N' deltd, systimestamp lastchange, v_version,vc.shortname custmember,vc.gross_amount,vc.NET_AMOUNT,v_source
                    from cfmast cf, ddmast dd, sbsecurities sb,
                    (select * from v_compare_CLIENTVSD where ISODMASTVAL = 'N' and note1 = 'Matched') mst,
                    (select * from v_sum_client_import where isodmast = 'N') vc
                    where cf.custodycd = dd.custodycd
                    and dd.isdefault ='Y' and dd.status <> 'C'
                    and dd.custodycd = vc.custodycd and sb.symbol = mst.symbol
                    and mst.custodycd = vc.mcustodycd
                    and sb.symbol = vc.sec_id
                    and mst.transtype = vc.trans_type
                    and mst.tradedate = vc.trade_date
                    and mst.custsettledate = vc.settle_date
                    and mst.custmember = vc.shortname
                    AND SB.TRADEPLACE NOT IN ('099');

                elsif v_source = 'CLIENT' then -- sinh lenh tu 1 NGUON CLIENT

                    insert into tblconfirm_compare_import (autoid,codeid,bondtype,symbol,acctno,custid,ddacctno,seacctno,
                                custodycd,exectype,citad,identity,trade_date,settle_date,price,quantity,fee,tax,txnum,txdate, deltd, lastchange, version, memberid,GROSS_AMOUNT,NET_AMOUNT,source)
                    Select seq_tblconfirm_compare_import.nextval autoid, sb.codeid,sb.bondtype,sb.symbol,vb.custid acctno,vb.custid, dd.acctno ddacctno,
                         vb.custid || sb.codeid  seacctno,
                         vb.custodycd,vb.trans_type exectype,vb.citad,vb.identity,vb.trade_date,vb.settle_date, vb.price, vb.quantity, vb.commission_fee_cu fee,  vb.tax_cu tax,
                         p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.c_date_format) txdate, 'N' deltd, systimestamp lastchange, v_version,vb.shortname cmpmember,vb.GROSS_AMOUNT,vb.NET_AMOUNT,v_source
                    from cfmast cf, ddmast dd, sbsecurities sb,
                    (select * from v_compare_import_only_client where ISODMASTVAL = 'N' and note1 = 'Matched') mst,
                    (select * from v_sum_client_import where isodmast = 'N') vb
                    where cf.custodycd = dd.custodycd
                    and dd.isdefault ='Y' and dd.status <> 'C'
                    and dd.custodycd = vb.custodycd and sb.symbol = mst.symbol
                    and mst.custodycd = vb.mcustodycd
                    and sb.symbol = vb.sec_id
                    and mst.transtype = vb.trans_type
                    and mst.tradedate = vb.trade_date
                    and mst.custsettledate = vb.settle_date
                    and mst.cmpmember = vb.shortname
                    AND SB.TRADEPLACE NOT IN ('099');
                elsif v_source = 'BROKER' then -- sinh lenh tu 1 NGUON BROKER

                    insert into tblconfirm_compare_import (autoid,codeid,bondtype,symbol,acctno,custid,ddacctno,seacctno,
                                custodycd,exectype,citad,identity,trade_date,settle_date,price,quantity,fee,tax,txnum,txdate, deltd, lastchange, version, memberid,GROSS_AMOUNT,NET_AMOUNT,source)
                    Select seq_tblconfirm_compare_import.nextval autoid, sb.codeid,sb.bondtype,sb.symbol,vb.custid acctno,vb.custid, dd.acctno ddacctno,
                         vb.custid || sb.codeid  seacctno,
                         vb.custodycd,vb.trans_type exectype,vb.citad,vb.identity,vb.trade_date,vb.settle_date, vb.price, vb.quantity, vb.commission_fee fee,  vb.tax,
                         p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.c_date_format) txdate, 'N' deltd, systimestamp lastchange, v_version,vb.shortname cmpmember,vb.GROSS_AMOUNT,vb.NET_AMOUNT,v_source
                    from cfmast cf,  ddmast dd, sbsecurities sb,
                    (select * from v_compare_import_only_broker where ISODMASTVAL = 'N' and note1 = 'Matched') mst,
                    (select * from v_sum_broker_m where isodmast = 'N') vb
                    where cf.custodycd = dd.custodycd
                    and dd.isdefault ='Y' and dd.status <> 'C'
                    and dd.custodycd = vb.custodycd and sb.symbol = mst.symbol
                    and mst.custodycd = vb.mcustodycd
                    and sb.symbol = vb.sec_id
                    and mst.transtype = vb.trans_type
                    and mst.tradedatectck = vb.trade_date
                    and mst.cmpsettledate = vb.settle_date
                    and mst.cmpmember = vb.shortname
                    AND SB.TRADEPLACE NOT IN ('099');
                end if;

                L_PREFIX:=TO_CHAR (GETCURRDATE(), 'YYMMDD');

                FOR rec IN
                (
                    select  mst.*, nvl(fa.autoid,'') membercd
                    from tblconfirm_compare_import mst
                    inner join sbsecurities SB ON mst.symbol = sb.symbol AND SB.TRADEPLACE NOT IN ('099')
                    left join (select * from famembers where ROLES = 'BRK') fa on fa.shortname = mst.memberid
                    where mst.txnum = p_txmsg.txnum
                    and mst.txdate = to_date(p_txmsg.txdate, systemnums.c_date_format)
                    and deltd <> 'Y'
                )
                LOOP
                    --trung.luu: 05-02-2021 khong check bang log
                    --trung.luu: 18/06/2020 check trung truoc khi sinh lenh

                    select count(*) into v_count
                    from odmast od
                    where od.member = rec.memberid
                    and od.custodycd = rec.custodycd
                    and od.exectype = rec.exectype
                    and od.codeid = rec.codeid
                    and od.trade_date = rec.trade_date
                    and od.CLEARDATE = rec.settle_date
                    and od.orstatus not in ('3');

                    if v_count <> 0 then
                        p_err_code := '-930024';
                        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    end if;


                    --ODT Lenh thuong
                    --ODG Lenh G-Bond
                    select (case when sb.BONDTYPE = '001' THEN 'ODG' ELSE 'ODT' END)odtype into v_odtype from SBSECURITIES sb where sb.codeid = rec.codeid;
                    --check feedaily
                    select cf.feedaily into v_feedaily from cfmast cf where cf.custodycd = rec.custodycd;
                    --netamount
                    amount_NB_NS := rec.net_amount;

                    L_orderid:=L_PREFIX|| LPAD(seq_odmast.NEXTVAL,8,'0');

                    codeid_semast := rec.acctno || rec.codeid;

                    
                    INSERT INTO iod (ORDERID,CODEID,SYMBOL,CUSTID,AFACCTNO,DDACCTNO,SEACCTNO,CUSTODYCD,TXNUM,TXDATE,TIMETYPE,EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARDATE,ORSTATUS,PRICETYPE,ORDERPRICE,ORDERQTTY,EXECQTTY, EXECPRICE , EXECAMT,FEEAMT,FEEACR,DELTD,TLID,LASTCHANGE)
                    VALUES(L_orderid,rec.codeid,rec.symbol,rec.custid,rec.acctno ,rec.ddacctno,rec.seacctno,REC.custodycd,NULL,v_txdate,NULL,rec.EXECTYPE,NULL,NULL,NULL,NULL,TO_DATE(rec.settle_date,'dd/MM/RRRR'),'A',NULL,0,0,REC.quantity,REC.PRICE,REC.gross_amount ,REC.FEE,0,'N','0000',SYSDATE);

                    INSERT INTO odmast (ORDERID,CODEID,SYMBOL,CUSTID,AFACCTNO,DDACCTNO,SEACCTNO,CUSTODYCD,TXNUM,TXDATE,TIMETYPE,EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARDATE,ORSTATUS,PRICETYPE,ORDERPRICE,ORDERQTTY,EXECQTTY,EXECAMT,FEEAMT,FEEACR,DELTD,TLID,LASTCHANGE,MEMBER,TAXAMT,NETAMOUNT,CITAD,IDENTITY,trade_date,odtype,source)
                    VALUES(L_orderid,rec.codeid,rec.symbol,rec.custid,rec.acctno ,rec.ddacctno,rec.seacctno,REC.custodycd,p_txmsg.txnum,p_txmsg.txdate,NULL,rec.EXECTYPE,NULL,NULL,NULL,NULL,TO_DATE(rec.settle_date,'dd/MM/RRRR'),'4','LO',REC.PRICE,REC.quantity,REC.quantity,REC.gross_amount ,REC.FEE,0,'N','0000',SYSDATE,REC.membercd,REC.TAX,amount_NB_NS,REC.citad,REC.identity,TO_DATE(rec.trade_date,'dd/MM/RRRR'),v_odtype,v_source);

                    INSERT INTO stschd (AUTOID,DUETYPE,ORDERID,CODEID,SYMBOL,CUSTID,AFACCTNO,DDACCTNO,SEACCTNO,CUSTODYCD,TXDATE,CLEARDAY,CLEARCD,AMT,QTTY,FEEAMT,VAT,STATUS,DELTD,CLEARDATE,LASTCHANGE,fvstatus)
                    VALUES(seq_stschd.NEXTVAL ,DECODE (rec.EXECTYPE,'NS','SS','NB','SM'),L_orderid,REC.CODEID,REC.SYMBOL,REC.CUSTID,REC.ACCTNO,REC.DDACCTNO,REC.SEACCTNO,REC.CUSTODYCD,p_txmsg.txdate,0,'B',REC.gross_amount ,REC.quantity,REC.FEE,REC.TAX,'P','N',TO_DATE(rec.settle_date,'dd/MM/RRRR'),SYSDATE,'P');

                    INSERT INTO stschd (AUTOID,DUETYPE,ORDERID,CODEID,SYMBOL,CUSTID,AFACCTNO,DDACCTNO,SEACCTNO,CUSTODYCD,TXDATE,CLEARDAY,CLEARCD,AMT,QTTY,FEEAMT,VAT,STATUS,DELTD,CLEARDATE,LASTCHANGE,fvstatus)
                    VALUES(seq_stschd.NEXTVAL ,DECODE (rec.EXECTYPE,'NS','RM','NB','RS'),L_orderid,REC.CODEID,REC.SYMBOL,REC.CUSTID,REC.ACCTNO,REC.DDACCTNO,REC.SEACCTNO,REC.CUSTODYCD,p_txmsg.txdate,0,'B',REC.gross_amount ,REC.quantity,REC.FEE,REC.TAX,'P','N',TO_DATE(rec.settle_date,'dd/MM/RRRR'),SYSDATE,'P');

                    --khi sinh lenh thi update cot isodmast trong compare_trading_result = 'Y'
                    begin
                        select depositmember into v_depositmembers from famembers where shortname = rec.memberid and roles = 'BRK';
                    exception when NO_DATA_FOUND then
                        v_depositmembers := '';
                    end;

                    IF V_SOURCE = 'CLIENT' THEN
                        UPDATE ODMASTCUST
                        SET ISODMAST = 'Y', VERSION = V_VERSION, ORDERID = L_ORDERID
                        WHERE TRANS_TYPE = REC.EXECTYPE
                        AND TRADE_DATE = REC.TRADE_DATE
                        AND SETTLE_DATE = REC.SETTLE_DATE
                        --AND QUANTITY  = REC.QUANTITY --NGUON CLIENT TRUNG LENH DUOC
                        AND SEC_ID = REC.SYMBOL
                        AND CUSTODYCD = REC.CUSTODYCD
                        AND BROKER_CODE = V_DEPOSITMEMBERS
                        AND DELTD <> 'Y';
                    ELSE
                        UPDATE ODMASTCUST
                        SET ISODMAST = 'Y', VERSION = V_VERSION, ORDERID = L_ORDERID
                        WHERE TRANS_TYPE = REC.EXECTYPE
                        AND TRADE_DATE = REC.TRADE_DATE
                        AND SETTLE_DATE = REC.SETTLE_DATE
                        --AND QUANTITY  = REC.QUANTITY
                        AND SEC_ID = REC.SYMBOL
                        AND CUSTODYCD = REC.CUSTODYCD
                        AND BROKER_CODE = V_DEPOSITMEMBERS
                        AND DELTD <> 'Y';

                        UPDATE ODMASTCMP
                        SET ISODMAST = 'Y', VERSION = V_VERSION, ORDERID = L_ORDERID
                        WHERE TRANS_TYPE = REC.EXECTYPE
                        AND TRADE_DATE = REC.TRADE_DATE
                        AND SETTLE_DATE = REC.SETTLE_DATE
                        --AND QUANTITY  = REC.QUANTITY
                        AND SEC_ID = REC.SYMBOL
                        AND CUSTODYCD = REC.CUSTODYCD
                        AND BROKER_CODE = V_DEPOSITMEMBERS
                        AND DELTD <> 'Y';

                        UPDATE ODMASTVSD
                        SET ISODMAST = 'Y', VERSION = V_VERSION, ORDERID = L_ORDERID
                        WHERE TRANS_TYPE = REC.EXECTYPE
                        AND TRADE_DATE = REC.TRADE_DATE
                        AND SETTLE_DATE = REC.SETTLE_DATE
                        --AND QUANTITY  = REC.QUANTITY
                        AND SEC_ID = REC.SYMBOL
                        AND CUSTODYCD = REC.CUSTODYCD
                        AND BROKER_CODE = V_DEPOSITMEMBERS
                        AND DELTD <> 'Y';
                    END IF;


                    --update orderid khi sinh lenh thanh cong, dung de revert lai lenh khi da sinh odmast

                    update tblconfirm_compare_import
                    set orderid = L_orderid
                    where autoid  = rec.autoid;


                    IF(rec.EXECTYPE ) = 'NS' THEN
                        --Lenh ban thi thuc cat chung khoan tu trade -> netting
                        SELECT COUNT(*) INTO v_count FROM SEMAST WHERE ACCTNO = codeid_semast and status ='A';
                        IF v_count =0 THEN
                            INSERT INTO semast
                            (actype, custid, acctno,
                            codeid,
                            afacctno, opndate, lastdate,
                            costdt, tbaldt, status, irtied, ircd, costprice, trade,
                            mortage, margin, netting, standing, withdraw, deposit, loan
                            )
                            VALUES ('0000', rec.acctno, codeid_semast,
                            SUBSTR (codeid_semast, 11, 6),
                            SUBSTR (codeid_semast, 1, 10), TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                            TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), 'A', 'Y', '000', 0, 0,
                            0, 0, rec.quantity, 0, 0, 0, 0
                            );
                            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),codeid_semast,'0019',rec.quantity,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');
                        ELSE
                            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),codeid_semast,'0011',rec.quantity,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');

                            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),codeid_semast,'0019',rec.quantity,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');
                            Update semast
                            set trade = trade - rec.quantity,
                            netting = netting + rec.quantity
                            where acctno = codeid_semast;
                        END IF;
                        --tra phi hang ngay thi receiving  = netamount
                        if trim(v_feedaily) = 'Y' then
                            INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),REC.ddacctno,'0009',amount_NB_NS,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');
                            update ddmast
                            set receiving = receiving + amount_NB_NS,LAST_CHANGE = SYSTIMESTAMP
                            where acctno = REC.ddacctno;
                            pr_gen_buf_dd_member(REC.ddacctno ,REC.membercd,0,0,0,amount_NB_NS,0,0);
                        else
                            INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),REC.ddacctno,'0009',REC.gross_amount,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');
                            update ddmast
                            set receiving = receiving + REC.gross_amount,LAST_CHANGE = SYSTIMESTAMP
                            where acctno = REC.ddacctno;
                            pr_gen_buf_dd_member(REC.ddacctno ,REC.membercd,0,0,0,REC.gross_amount,0,0);
                        end if;
                    END IF;
                    --lenh mua
                    IF(rec.EXECTYPE ) = 'NB' THEN
                        SELECT COUNT(*) INTO v_count FROM SEMAST WHERE ACCTNO = codeid_semast and status ='A';
                        IF v_count =0 THEN
                            INSERT INTO semast
                            (actype, custid, acctno,
                            codeid,
                            afacctno, opndate, lastdate,
                            costdt, tbaldt, status, irtied, ircd, costprice, trade,
                            mortage, margin, receiving, standing, withdraw, deposit, loan
                            )
                            VALUES ('0000', rec.acctno, codeid_semast,
                            SUBSTR (codeid_semast, 11, 6),
                            SUBSTR (codeid_semast, 1, 10), TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                            TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), 'A', 'Y', '000', 0, 0,
                            0, 0, rec.quantity, 0, 0, 0,0
                            );
                            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),codeid_semast,'0016',rec.quantity,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');
                        ELSE
                            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),codeid_semast,'0016',rec.quantity,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');
                            Update semast
                            set receiving = receiving + rec.quantity
                            where acctno = codeid_semast;
                        END IF;
                        --tra phi hang ngay netting = netamount
                        if trim(v_feedaily) = 'Y' then
                            INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),REC.ddacctno,'0011',amount_NB_NS,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');
                            update ddmast
                            set netting = netting + amount_NB_NS,LAST_CHANGE = SYSTIMESTAMP
                            where acctno = REC.ddacctno;
                            --trung.luu insert data vao bang buf dd member
                            --pr_gen_buf_dd_member(REC.ddacctno ,REC.membercd,0,0,0,amount_NB_NS,0,0);
                        else
                            INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),REC.ddacctno,'0011',REC.gross_amount,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');
                            update ddmast
                            set netting = netting + REC.gross_amount,LAST_CHANGE = SYSTIMESTAMP
                            where acctno = REC.ddacctno;
                            --trung.luu insert data vao bang buf dd member
                            --pr_gen_buf_dd_member(REC.ddacctno ,REC.membercd,0,0,0,REC.gross_amount,0,0);
                        end if;
                    END IF;

                END LOOP;
            END IF;
            IF v_assettype IN ('TPRL', 'ALL') THEN
                if v_source = 'OD8893' then
                    insert into tblconfirm_compare_import (autoid,codeid,bondtype,symbol,acctno,custid,ddacctno,seacctno,
                                custodycd,exectype,citad,identity,trade_date,settle_date,price,quantity,fee,tax,txnum,txdate, deltd, lastchange, version, memberid,GROSS_AMOUNT,NET_AMOUNT,source)
                    Select seq_tblconfirm_compare_import.nextval autoid, sb.codeid,sb.bondtype,sb.symbol,vb.custid acctno,vb.custid, dd.acctno ddacctno,
                         vb.custid || sb.codeid  seacctno,
                         vb.custodycd,vb.trans_type exectype,vb.citad,vb.identity,vb.trade_date,vb.settle_date, vb.price, vb.quantity, vb.commission_fee fee,  vb.tax,
                         p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.c_date_format) txdate, 'N' deltd, systimestamp lastchange, v_version,vb.shortname cmpmember,vb.GROSS_AMOUNT,vb.NET_AMOUNT,v_source
                    from cfmast cf, ddmast dd, sbsecurities sb,
                    (select * from v_compare_import where ISODMASTVAL = 'N' and note1 = 'Matched') mst,
                    (select * from v_sum_broker_m where isodmast = 'N') vb
                    where cf.custodycd = dd.custodycd
                    and dd.isdefault ='Y' and dd.status <> 'C'
                    and dd.custodycd = vb.custodycd and sb.symbol = mst.symbol
                    and mst.custodycd = vb.mcustodycd
                    and sb.symbol = vb.sec_id
                    and mst.transtype = vb.trans_type
                    and mst.tradedatectck = vb.trade_date
                    and mst.cmpsettledate = vb.settle_date
                    and mst.cmpmember = vb.shortname
                    AND SB.TRADEPLACE = '099';
                elsif v_source = 'VSDBROKER' then -- sinh lenh tu vsd va broker
                    insert into tblconfirm_compare_import (autoid,codeid,bondtype,symbol,acctno,custid,ddacctno,seacctno,
                                custodycd,exectype,citad,identity,trade_date,settle_date,price,quantity,fee,tax,txnum,txdate, deltd, lastchange, version, memberid,GROSS_AMOUNT,NET_AMOUNT,source)
                    Select seq_tblconfirm_compare_import.nextval autoid, sb.codeid,sb.bondtype,sb.symbol,vb.custid acctno,vb.custid, dd.acctno ddacctno,
                         vb.custid || sb.codeid  seacctno,
                         vb.custodycd,vb.trans_type exectype,vb.citad,vb.identity,vb.trade_date,vb.settle_date, vb.price, vb.quantity, vb.commission_fee fee,  vb.tax,
                         p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.c_date_format) txdate, 'N' deltd, systimestamp lastchange, v_version,vb.shortname vsdmember,vb.GROSS_AMOUNT,vb.NET_AMOUNT,v_source
                    from cfmast cf, ddmast dd, sbsecurities sb,
                    (select * from v_compare_VSDBROKER where ISODMASTVAL = 'N' and note1 = 'Matched') mst,
                    (select * from v_sum_broker_m where isodmast = 'N') vb
                    where cf.custodycd = dd.custodycd
                    and dd.isdefault ='Y' and dd.status <> 'C'
                    and dd.custodycd = vb.custodycd and sb.symbol = mst.symbol
                    and mst.custodycd = vb.mcustodycd
                    and sb.symbol = vb.sec_id
                    and mst.transtype = vb.trans_type
                    and mst.tradedatevsd = vb.trade_date
                    and mst.vsdsettledate = vb.settle_date
                    and mst.vsdmember = vb.shortname
                    AND SB.TRADEPLACE = '099';
                elsif v_source = 'CLIENTVSD' then -- sinh lenh tu client va vsd
                    insert into tblconfirm_compare_import (autoid,codeid,bondtype,symbol,acctno,custid,ddacctno,seacctno,
                                custodycd,exectype,citad,identity,trade_date,settle_date,price,quantity,fee,tax,txnum,txdate, deltd, lastchange, version, memberid,GROSS_AMOUNT,NET_AMOUNT,source)
                    Select seq_tblconfirm_compare_import.nextval autoid, sb.codeid,sb.bondtype,sb.symbol,vc.custid acctno,vc.custid, dd.acctno ddacctno,
                         vc.custid || sb.codeid  seacctno,
                         vc.custodycd,vc.trans_type exectype,vc.citad,vc.identity,vc.trade_date,vc.settle_date, vc.price, vc.quantity, vc.commission_fee_cu fee,  vc.tax_cu tax,
                         p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.c_date_format) txdate, 'N' deltd, systimestamp lastchange, v_version,vc.shortname custmember,vc.gross_amount,vc.NET_AMOUNT,v_source
                    from cfmast cf, ddmast dd, sbsecurities sb,
                    (select * from v_compare_CLIENTVSD where ISODMASTVAL = 'N' and note1 = 'Matched') mst,
                    (select * from v_sum_client_import where isodmast = 'N') vc
                    where cf.custodycd = dd.custodycd
                    and dd.isdefault ='Y' and dd.status <> 'C'
                    and dd.custodycd = vc.custodycd and sb.symbol = mst.symbol
                    and mst.custodycd = vc.mcustodycd
                    and sb.symbol = vc.sec_id
                    and mst.transtype = vc.trans_type
                    and mst.tradedate = vc.trade_date
                    and mst.custsettledate = vc.settle_date
                    and mst.custmember = vc.shortname
                    AND SB.TRADEPLACE = '099';
                end if;

                L_PREFIX:=TO_CHAR (GETCURRDATE(), 'YYMMDD');

                FOR rec IN
                (
                    select  mst.*, nvl(fa.autoid,'') membercd
                    from tblconfirm_compare_import mst
                    inner join sbsecurities SB ON mst.symbol = sb.symbol AND SB.TRADEPLACE = '099'
                    left join (select * from famembers where ROLES = 'BRK') fa on fa.shortname = mst.memberid
                    where mst.txnum = p_txmsg.txnum
                    and mst.txdate = to_date(p_txmsg.txdate, systemnums.c_date_format)
                    and deltd <> 'Y'
                )
                LOOP
                    --trung.luu: 05-02-2021 khong check bang log
                    --trung.luu: 18/06/2020 check trung truoc khi sinh lenh

                    select count(*) into v_count
                    from odmast od
                    where od.member = rec.memberid
                    and od.custodycd = rec.custodycd
                    and od.exectype = rec.exectype
                    and od.codeid = rec.codeid
                    and od.trade_date = rec.trade_date
                    and od.CLEARDATE = rec.settle_date
                    and od.orstatus not in ('3');

                    if v_count <> 0 then
                        p_err_code := '-930024';
                        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    end if;


                    --ODT Lenh thuong
                    --ODG Lenh G-Bond
                    v_odtype := 'ODT';
                    --select (case when sb.BONDTYPE = '001' THEN 'ODG' ELSE 'ODT' END)odtype into v_odtype from SBSECURITIES sb where sb.codeid = rec.codeid;
                    --check feedaily
                    select cf.feedaily into v_feedaily from cfmast cf where cf.custodycd = rec.custodycd;
                    --netamount
                    amount_NB_NS := rec.net_amount;

                    L_orderid := L_PREFIX|| LPAD(seq_odmast.NEXTVAL,8,'0');

                    codeid_semast := rec.acctno || rec.codeid;

                    
                    INSERT INTO iod (ORDERID,CODEID,SYMBOL,CUSTID,AFACCTNO,DDACCTNO,SEACCTNO,CUSTODYCD,TXNUM,TXDATE,TIMETYPE,EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARDATE,ORSTATUS,PRICETYPE,ORDERPRICE,ORDERQTTY,EXECQTTY, EXECPRICE , EXECAMT,FEEAMT,FEEACR,DELTD,TLID,LASTCHANGE)
                    VALUES(L_orderid,rec.codeid,rec.symbol,rec.custid,rec.acctno ,rec.ddacctno,rec.seacctno,REC.custodycd,NULL,v_txdate,NULL,rec.EXECTYPE,NULL,NULL,NULL,NULL,TO_DATE(rec.settle_date,'dd/MM/RRRR'),'A',NULL,0,0,REC.quantity,REC.PRICE,REC.gross_amount ,REC.FEE,0,'N','0000',SYSDATE);

                    INSERT INTO odmast (ORDERID,CODEID,SYMBOL,CUSTID,AFACCTNO,DDACCTNO,SEACCTNO,CUSTODYCD,TXNUM,TXDATE,TIMETYPE,EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARDATE,ORSTATUS,PRICETYPE,ORDERPRICE,ORDERQTTY,EXECQTTY,EXECAMT,FEEAMT,FEEACR,DELTD,TLID,LASTCHANGE,MEMBER,TAXAMT,NETAMOUNT,CITAD,IDENTITY,trade_date,odtype,source)
                    VALUES(L_orderid,rec.codeid,rec.symbol,rec.custid,rec.acctno ,rec.ddacctno,rec.seacctno,REC.custodycd,p_txmsg.txnum,p_txmsg.txdate,NULL,rec.EXECTYPE,NULL,NULL,NULL,NULL,TO_DATE(rec.settle_date,'dd/MM/RRRR'),'4','LO',REC.PRICE,REC.quantity,REC.quantity,REC.gross_amount ,REC.FEE,0,'N','0000',SYSDATE,REC.membercd,REC.TAX,amount_NB_NS,REC.citad,REC.identity,TO_DATE(rec.trade_date,'dd/MM/RRRR'),v_odtype,v_source);

                    INSERT INTO stschd (AUTOID,DUETYPE,ORDERID,CODEID,SYMBOL,CUSTID,AFACCTNO,DDACCTNO,SEACCTNO,CUSTODYCD,TXDATE,CLEARDAY,CLEARCD,AMT,QTTY,FEEAMT,VAT,STATUS,DELTD,CLEARDATE,LASTCHANGE,fvstatus)
                    VALUES(seq_stschd.NEXTVAL ,DECODE (rec.EXECTYPE,'NS','SS','NB','SM'),L_orderid,REC.CODEID,REC.SYMBOL,REC.CUSTID,REC.ACCTNO,REC.DDACCTNO,REC.SEACCTNO,REC.CUSTODYCD,p_txmsg.txdate,0,'B',REC.gross_amount ,REC.quantity,REC.FEE,REC.TAX,'P','N',TO_DATE(rec.settle_date,'dd/MM/RRRR'),SYSDATE,'P');

                    INSERT INTO stschd (AUTOID,DUETYPE,ORDERID,CODEID,SYMBOL,CUSTID,AFACCTNO,DDACCTNO,SEACCTNO,CUSTODYCD,TXDATE,CLEARDAY,CLEARCD,AMT,QTTY,FEEAMT,VAT,STATUS,DELTD,CLEARDATE,LASTCHANGE,fvstatus)
                    VALUES(seq_stschd.NEXTVAL ,DECODE (rec.EXECTYPE,'NS','RM','NB','RS'),L_orderid,REC.CODEID,REC.SYMBOL,REC.CUSTID,REC.ACCTNO,REC.DDACCTNO,REC.SEACCTNO,REC.CUSTODYCD,p_txmsg.txdate,0,'B',REC.gross_amount ,REC.quantity,REC.FEE,REC.TAX,'P','N',TO_DATE(rec.settle_date,'dd/MM/RRRR'),SYSDATE,'P');

                    --khi sinh lenh thi update cot isodmast trong compare_trading_result = 'Y'
                    begin
                        select depositmember into v_depositmembers from famembers where shortname = rec.memberid and roles = 'BRK';
                    exception when NO_DATA_FOUND then
                        v_depositmembers := '';
                    end;

                    UPDATE ODMASTCUST
                    SET ISODMAST = 'Y', VERSION = V_VERSION, ORDERID = L_ORDERID
                    WHERE TRANS_TYPE = REC.EXECTYPE
                    AND TRADE_DATE = REC.TRADE_DATE
                    AND SETTLE_DATE = REC.SETTLE_DATE
                    --AND QUANTITY  = REC.QUANTITY
                    AND SEC_ID = REC.SYMBOL
                    AND CUSTODYCD = REC.CUSTODYCD
                    AND BROKER_CODE = V_DEPOSITMEMBERS
                    AND DELTD <> 'Y'
                    AND ISODMAST = 'N';

                    UPDATE ODMASTCMP
                    SET ISODMAST = 'Y', VERSION = V_VERSION, ORDERID = L_ORDERID
                    WHERE TRANS_TYPE = REC.EXECTYPE
                    AND TRADE_DATE = REC.TRADE_DATE
                    AND SETTLE_DATE = REC.SETTLE_DATE
                    --AND QUANTITY  = REC.QUANTITY
                    AND SEC_ID = REC.SYMBOL
                    AND CUSTODYCD = REC.CUSTODYCD
                    AND BROKER_CODE = V_DEPOSITMEMBERS
                    AND DELTD <> 'Y'
                    AND ISODMAST = 'N';

                    UPDATE ODMASTVSD
                    SET ISODMAST = 'Y', VERSION = V_VERSION, ORDERID = L_ORDERID
                    WHERE TRANS_TYPE = REC.EXECTYPE
                    AND TRADE_DATE = REC.TRADE_DATE
                    AND SETTLE_DATE = REC.SETTLE_DATE
                    --AND QUANTITY  = REC.QUANTITY
                    AND SEC_ID = REC.SYMBOL
                    AND CUSTODYCD = REC.CUSTODYCD
                    AND BROKER_CODE = V_DEPOSITMEMBERS
                    AND DELTD <> 'Y'
                    AND ISODMAST = 'N';


                    --update orderid khi sinh lenh thanh cong, dung de revert lai lenh khi da sinh odmast

                    update tblconfirm_compare_import
                    set orderid = L_orderid
                    where autoid  = rec.autoid;

                    IF(rec.EXECTYPE ) = 'NS' THEN
                        --Lenh ban thi thuc cat chung khoan tu trade -> netting
                        SELECT COUNT(*) INTO v_count FROM SEMAST WHERE ACCTNO = codeid_semast and status ='A';
                        IF v_count =0 THEN
                            INSERT INTO semast
                            (actype, custid, acctno,
                            codeid,
                            afacctno, opndate, lastdate,
                            costdt, tbaldt, status, irtied, ircd, costprice, trade,
                            mortage, margin, netting, standing, withdraw, deposit, loan
                            )
                            VALUES ('0000', rec.acctno, codeid_semast,
                            SUBSTR (codeid_semast, 11, 6),
                            SUBSTR (codeid_semast, 1, 10), TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                            TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), 'A', 'Y', '000', 0, 0,
                            0, 0, rec.quantity, 0, 0, 0, 0
                            );
                            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),codeid_semast,'0019',rec.quantity,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');
                        ELSE
                            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),codeid_semast,'0011',rec.quantity,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');

                            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),codeid_semast,'0019',rec.quantity,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');
                            Update semast
                            set trade = trade - rec.quantity,
                            netting = netting + rec.quantity
                            where acctno = codeid_semast;
                        END IF;
                        --tra phi hang ngay thi receiving  = netamount
                        if trim(v_feedaily) = 'Y' then
                            INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),REC.ddacctno,'0009',amount_NB_NS,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');
                            update ddmast
                            set receiving = receiving + amount_NB_NS,LAST_CHANGE = SYSTIMESTAMP
                            where acctno = REC.ddacctno;
                            pr_gen_buf_dd_member(REC.ddacctno ,REC.membercd,0,0,0,amount_NB_NS,0,0);
                        else
                            INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),REC.ddacctno,'0009',REC.gross_amount,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');
                            update ddmast
                            set receiving = receiving + REC.gross_amount,LAST_CHANGE = SYSTIMESTAMP
                            where acctno = REC.ddacctno;
                            pr_gen_buf_dd_member(REC.ddacctno ,REC.membercd,0,0,0,REC.gross_amount,0,0);
                        end if;
                    END IF;
                    --lenh mua
                    IF(rec.EXECTYPE ) = 'NB' THEN
                        SELECT COUNT(*) INTO v_count FROM SEMAST WHERE ACCTNO = codeid_semast and status ='A';
                        IF v_count =0 THEN
                            INSERT INTO semast
                            (actype, custid, acctno,
                            codeid,
                            afacctno, opndate, lastdate,
                            costdt, tbaldt, status, irtied, ircd, costprice, trade,
                            mortage, margin, receiving, standing, withdraw, deposit, loan
                            )
                            VALUES ('0000', rec.acctno, codeid_semast,
                            SUBSTR (codeid_semast, 11, 6),
                            SUBSTR (codeid_semast, 1, 10), TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),
                            TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT), 'A', 'Y', '000', 0, 0,
                            0, 0, rec.quantity, 0, 0, 0,0
                            );
                            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),codeid_semast,'0016',rec.quantity,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');
                        ELSE
                            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),codeid_semast,'0016',rec.quantity,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');
                            Update semast
                            set receiving = receiving + rec.quantity
                            where acctno = codeid_semast;
                        END IF;
                        --tra phi hang ngay netting = netamount
                        if trim(v_feedaily) = 'Y' then
                            INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),REC.ddacctno,'0011',amount_NB_NS,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');
                            update ddmast
                            set netting = netting + amount_NB_NS,LAST_CHANGE = SYSTIMESTAMP
                            where acctno = REC.ddacctno;
                            --trung.luu insert data vao bang buf dd member
                            --pr_gen_buf_dd_member(REC.ddacctno ,REC.membercd,0,0,0,amount_NB_NS,0,0);
                        else
                            INSERT INTO DDTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),REC.ddacctno,'0011',REC.gross_amount,NULL,'',p_txmsg.deltd,'',seq_DDTRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE(rec.trade_date,'dd/MM/RRRR'),'' || '' || '');
                            update ddmast
                            set netting = netting + REC.gross_amount,LAST_CHANGE = SYSTIMESTAMP
                            where acctno = REC.ddacctno;
                            --trung.luu insert data vao bang buf dd member
                            --pr_gen_buf_dd_member(REC.ddacctno ,REC.membercd,0,0,0,REC.gross_amount,0,0);
                        end if;
                    END IF;
                END LOOP;
            END IF;
        End If;

    ELSE -- Reversal
        UPDATE TLLOG
        SET DELTD = 'Y'
        WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
        -- Xu ly doi voi tien

        for rDD in
        (
            Select tr.acctno, tx.field, tr.namt, tx.txtype
            from DDTRAN tr, apptx tx
            where tr.txcd = tx.txcd and tx.apptype='DD'
            and TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)
            and deltd <> 'Y'
        )Loop
            If rDD.field = 'NETTING' and rDD.txtype='C' then
                update ddmast set NETTING=NETTING-rDD.namt where acctno = rDD.acctno;
            Elsif rDD.field = 'NETTING' and rDD.txtype='D' then
                update ddmast set NETTING=NETTING+rDD.namt where acctno = rDD.acctno;
            End If;

            If rDD.field = 'RECEIVING' and rDD.txtype='C' then
                update ddmast set receiving=receiving-rDD.namt where acctno = rDD.acctno;
            Elsif rDD.field = 'RECEIVING' and rDD.txtype='D' then
                update ddmast set receiving=receiving+rDD.namt where acctno = rDD.acctno;
            End If;
        End Loop;

        -- Xu ly doi voi CK
        for rSE in
        (
            Select tr.acctno, tx.field, tr.namt, tx.txtype
            from setran tr, apptx tx
            where tr.txcd = tx.txcd and tx.apptype='SE'
            and TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT)
            and deltd <> 'Y'
        )Loop
            If rSE.field = 'TRADE' and rSE.txtype='C' then
                update semast set trade=trade-rSE.namt where acctno = rse.acctno;
            Elsif rSE.field = 'TRADE' and rSE.txtype='D' then
                update semast set trade=trade+rSE.namt where acctno = rse.acctno;
            End If;

            If rSE.field = 'NETTING' and rSE.txtype='C' then
                update semast set netting=netting-rse.namt where acctno = rse.acctno;
            Elsif rSE.field = 'NETTING' and rSE.txtype='D' then
                update semast set netting=netting+rSE.namt where acctno = rse.acctno;
            End If;

            If rSE.field = 'RECEIVING' and rSE.txtype='C' then
                update semast set receiving=receiving-rSE.namt where acctno = rse.acctno;
            Elsif rSE.field = 'RECEIVING' and rSE.txtype='D' then
                update semast set receiving=receiving+rSE.namt where acctno = rse.acctno;
            End If;
        End Loop;

        UPDATE DDTRAN
        SET DELTD = 'Y'
        WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);

        UPDATE SETRAN
        SET DELTD = 'Y'
        WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);

        For r in
        (
            select orderid
            from odmast
            where txnum = p_txmsg.txnum
            and txdate = to_date(p_txmsg.txdate, systemnums.c_date_format)
        )
        loop
            update odmast
            set orstatus = '3', deltd ='Y'
            where orderid = r.orderid;

            update stschd
            set status = 'C', deltd='Y'
            where orderid = r.orderid;

            update iod
            set orstatus = 'C', deltd='Y'
            where orderid = r.orderid;
        end loop;

        Update tblconfirm_compare_import  set deltd ='Y' where version = v_version;
        update odmastcmp set ISODMAST = 'N' where version = v_version;
        update odmastcust set ISODMAST = 'N' where version = v_version;
        update odmastvsd set ISODMAST = 'N' where version = v_version;

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
         plog.init ('TXPKS_#8893EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8893EX;
/
