SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_allocate_IOD_tax (pv_orderid varchar2)
is
    v_dblrate number;
    v_dbltaxsellamt number;
    v_dbliodtaxsellamt number;
    v_dblGapamt number;
begin
    select od.taxrate/100 into v_dblrate
    from odmast od where od.orderid = pv_orderid;

    if v_dblrate>0 then
        update iod set iodtaxsellamt = floor(v_dblrate * iod.execprice * iod.execqtty) where iod.orderid=pv_orderid;
    end if;

    select max(od.taxsellamt), sum(iod.iodtaxsellamt) iodtaxsellamt
        into v_dbltaxsellamt, v_dbliodtaxsellamt
    from odmast od, iod
    where od.orderid = iod.orderid
    and iod.deltd <> 'Y'
    and od.orderid = pv_orderid
    group by od.orderid;

    if v_dbltaxsellamt>v_dbliodtaxsellamt then
        v_dblGapamt:=v_dbltaxsellamt-v_dbliodtaxsellamt;
        for rec in (
            select  iod.* from iod, odmast od
            where od.orderid = pv_orderid
            and iod.deltd <> 'Y'
            and iod.orderid= od.orderid
            and od.taxsellamt>0 and od.execamt>0
            order by (iod.execqtty* iod.execprice * od.taxrate/100 - floor(iod.execqtty* iod.execprice * od.taxrate/100)) desc, iod.orderid
        )
        loop
            update iod set iodtaxsellamt= iodtaxsellamt+1 where txnum = rec.txnum and txdate = rec.txdate and orderid =rec.orderid;
            v_dblGapamt:=v_dblGapamt-1;
            EXIT when v_dblGapamt<=0;
        end loop;
    end if;
exception when others then
    return;
end;
/
