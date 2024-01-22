SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE HoldUnhold (
v_type varchar2)
is
p_err_code varchar2(250);
v_money number;
v_trfcode varchar2(100);
v_desc varchar2(100);
pkgctx   plog.log_ctx;
begin

   for r in (
                   select  cf.custid,af.acctno, dd.acctno ddacctno,dd.refcasaacct refc , cf.custodycd,
                                od.trans_type EXECTYPE,
                                od.trade_date,od.settle_date_cmp settle_date,
                                NVL(od.price_cmp,od.price_cust) price, NVL(od.qtty_cmp,od.qtty_cust) quantity
                            from compare_trading_result od , ddmast dd, afmast af, cfmast cf
                            where   od.custodycd = cf.custodycd
                                and af.custid = cf.custid
                                and af.acctno = dd.afacctno
                                and dd.CCYCD = 'VND'
                                and od.trans_type = 'NB'
             )
    Loop
        IF v_type = '1' then
            select holdbalance into v_money from ddmast dd where dd.refcasaacct = r.refc;
            select trfcode,description into v_trfcode,v_desc from CRBTRFCODE where objname = '6695';
             pck_bankapi.Bank_UNholdbalance('txnum',r.ddacctno,v_money,v_trfcode,to_char(getcurrdate)||'txnum',v_desc,'0001',P_ERR_CODE);
             if P_ERR_CODE <> systemnums.C_SUCCESS then
                 plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
             end if;
        else
            select trfcode,description into v_trfcode,v_desc from CRBTRFCODE where objname = '6690';
                pck_bankapi.bank_holdbalance(r.refc,'','','',NVL((r.price * r.quantity),0),v_trfcode,'txnum',v_desc,'0001',p_err_code);
                 if p_err_code <> systemnums.C_SUCCESS then
                     plog.error('ERROR: ' || SQLERRM || dbms_utility.format_error_backtrace);
                 END IF;
        end if;
    end loop;
EXCEPTION
  WHEN others THEN -- caution handles all exceptions
   plog.error('ERROR: ' || SQLERRM || dbms_utility.format_error_backtrace);
end;
/
