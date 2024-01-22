SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE delete_temp(l_type varchar2,l_objname varchar2)
is
l_datasource varchar(4000);
l_title varchar(4000);
l_detail1 varchar(4000);
l_amt number;
l_fee number;
l_vat number;
begin
        l_amt :=200000;
        while l_amt >0
LOOP
            for rec in
            (
                select fe.cleardate, fe.orderid,fe.feeamt,fe.vat,nvl(fe.paidfeeamt,0) paidfeeamt,nvl(fe.paidvat,0) paidvat from vw_stschd_all fe,
                famembers fa,crbbanklist crb,odmast od,CFMAST CF
                where fa.autoid = od.member
                and od.orderid = FE.orderid
                and crb.bankbiccode = fa.bankbiccode
                AND FE.CUSTODYCD = CF.custodycd
                and fe.DUETYPE IN ('SM','RM') and fe.DELTD = 'N'
                and fa.shortname like 'BMSC'
               and greatest(fe.feeamt-nvl(fe.paidfeeamt,0),0) + greatest(fe.vat-nvl(fe.paidvat,0),0) <> 0
                order by cleardate
            )
            loop
                if l_amt > (greatest(rec.feeamt-rec.paidfeeamt,0) + greatest(rec.vat-rec.paidvat,0)) then
                    update stschd fe
                     set fe.paidfeeamt = feeamt,
                     fe.paidvat=vat
                    where  fe.orderid =rec.orderid;
                     l_amt    := l_amt - rec.feeamt - rec.vat;
                    l_amt:= l_amt - l_fee;
                    elsif l_amt > 0 then
                        l_fee := greatest(LEAST(l_amt,greatest(rec.feeamt-rec.paidfeeamt,0)),0);
                       l_amt:=l_amt- l_fee;
                       l_vat := greatest(LEAST(l_amt, greatest(rec.vat-rec.paidvat,0)),0);
                       update stschd fe
                        set fe.paidfeeamt=rec.paidfeeamt+l_fee,
                       fe.paidvat=rec.paidvat + l_vat
                       where  fe.orderid =rec.orderid;
                    end  if;
            end loop;
end loop;
end;
/
