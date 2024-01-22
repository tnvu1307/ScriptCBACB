SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_allocate_IOD_fee (pv_orderid varchar2)
is
    v_dblrate number;
    v_dblfeeacr number;
    v_dbliodfeeacr number;
    v_dblGapamt number;
begin
    select case when od.execamt>0 then od.feeacr/od.execamt else 0 end
            into v_dblrate
    from odmast od where od.orderid = pv_orderid;

    if v_dblrate>0 then
        update iod set iodfeeacr = floor(v_dblrate * iod.execprice * iod.execqtty) where iod.orderid=pv_orderid;
    end if;

    select max(od.feeacr), sum(iod.iodfeeacr) iodfeeacr
        into v_dblfeeacr, v_dbliodfeeacr
    from odmast od, iod
    where od.orderid = iod.orderid
    and od.orderid = pv_orderid and iod.deltd <> 'Y'
    group by od.orderid;

    if v_dblfeeacr>v_dbliodfeeacr then
        v_dblGapamt:=v_dblfeeacr-v_dbliodfeeacr;
        for rec in (
            select  iod.* from iod, odmast od
            where od.orderid = pv_orderid
            and iod.deltd <> 'Y'
            and iod.orderid= od.orderid
            and od.feeacr>0 and od.execamt>0
            order by (iod.execamt * od.feeacr/od.execamt - floor(iod.execqtty* iod.execprice * od.feeacr/od.execamt)) desc, iod.orderid
        )
        loop
            update iod set iodfeeacr= iodfeeacr+1 where txnum = rec.txnum and txdate = rec.txdate and orderid =rec.orderid;
            v_dblGapamt:=v_dblGapamt-1;
            EXIT when v_dblGapamt<=0;
        end loop;
    end if;
exception when others then
    return;
end;
/
