SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fnc_get_holdsell_etf
(
pv_custodycd IN Varchar2,
pv_afacctno IN Varchar2,
pv_camastid IN Varchar2
)

RETURN  NUMBER IS
v_codeid varchar2(10);
v_refsymbol varchar2(50);
v_reportdate date;
v_exdividend date;
v_hold number;
v_sell number;
v_return number;
BEGIN

 select ca.codeid, sb.symbol, ca.reportdate, getprevworkingdate(ca.reportdate)
 into v_codeid, v_refsymbol, v_reportdate, v_exdividend
 from camast ca, sbsecurities sb
 where ca.camastid = pv_camastid and ca.codeid = sb.codeid;

 -- tính s? lu?ng hold c?a qu? d?n ngày record day
   select COALESCE (sum(holdfs),0) nohold into v_hold
   from etfwsap e, camast ca,
     (select orderid,cleardate,codeid,deltd from odmast union select orderid,cleardate,codeid,deltd from odmasthist) od
   where e.holdfs >0 and od.orderid = e.orderid and ca.reportdate >= od.cleardate
      and ca.codeid = e.codeid and e.deltd <>'Y' and od.deltd<>'Y'
      and ca.camastid = pv_camastid
      and e.codeid = v_codeid
      and e.custodycd = pv_custodycd
      and e.afacctno = pv_afacctno;
 -- tính s? lu?ng dã bán c?a qu? d?n ngày exdividend
   select COALESCE(sum(quantity),0) sell into v_sell from
   (select autoid, trans_type, custodycd, sec_id, trade_date, quantity from odmastcust
   where trans_type = 'NS' and TRANSACTIONTYPE = 'A' and isodmast = 'Y' and deltd <>'Y'
         and trade_date < v_exdividend and sec_id = v_refsymbol and custodycd = pv_custodycd
   union
   select autoid, trans_type, custodycd, sec_id, trade_date, quantity from odmastcusthist
   where trans_type = 'NS' and TRANSACTIONTYPE = 'A' and isodmast = 'Y' and deltd <>'Y'
         and trade_date < v_exdividend and sec_id = v_refsymbol and custodycd = pv_custodycd);

 RETURN v_hold - v_sell;
EXCEPTION WHEN OTHERS THEN
  Return 0;
END;
/
