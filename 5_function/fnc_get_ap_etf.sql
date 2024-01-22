SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fnc_get_ap_etf
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
v_ap number;
v_sell number;
v_return number;
BEGIN

 select ca.codeid, sb.symbol, ca.reportdate, getprevworkingdate(ca.reportdate)
 into v_codeid, v_refsymbol, v_reportdate, v_exdividend
 from camast ca, sbsecurities sb
 where ca.camastid = pv_camastid and ca.codeid = sb.codeid;

 -- tính s? lu?ng ap c?a qu? d?n ngày record day
   select COALESCE (sum(e.apqtty),0)- COALESCE (max(QTTY8864),0) ap into v_ap
   from etfwsap e, camast ca,sbsecurities sb,
        (SELECT custodycd,sec_id, sum(quantity) QTTY8864 FROM odmastcust
        WHERE TRANSACTIONTYPE='A' and isodmast ='Y' and deltd <> 'Y'
        and custodycd=pv_custodycd
        and sec_id=v_refsymbol
        and to_date(trade_date,'dd/mm/rrrr') < v_exdividend
        group by custodycd,sec_id) odc,
     (select orderid,cleardate,codeid,deltd from odmast union select orderid,cleardate,codeid,deltd from odmasthist) od
   where e.apqtty >0 and od.orderid = e.orderid and ca.reportdate >= od.cleardate
      and ca.codeid = e.codeid and e.deltd <>'Y' and od.deltd<>'Y'
      and sb.codeid=e.codeid and odc.custodycd (+)=e.custodycd
      and odc.sec_id (+)= sb.symbol
      and ca.camastid = pv_camastid
      and e.codeid = v_codeid
      and e.custodycd = pv_custodycd
      and e.afacctno = pv_afacctno;

   -- SHBVNEX-1929 neu AP < 0 thi dong bo skq sang voi sl ap = 0
   if v_ap < 0 then
      v_ap := 0;
   end if;
 RETURN v_ap;
EXCEPTION WHEN OTHERS THEN
  Return 0;
END;
/
