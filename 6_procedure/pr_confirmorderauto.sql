SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_ConfirmOrderAuto(p_err_code  OUT varchar2)
IS
    v_currdate date;
BEGIN
    v_currdate  := getcurrdate;
    FOR rec IN
        (
            SELECT OD.ORDERID,OD.TXDATE,OD.REFORDERID,
                   od.afacctno, cf.custodycd, cf.fullname,cf.custid --,
                   --cspks_odproc.fn_OD_GetRootOrderID(od.orderid) ROOTORDERID
            FROM CONFIRMODRSTS CFMSTS,
                    --(select * from ODMAST union all select * from odmasthist) OD,
                    vw_odmast_all OD,
                    SBSECURITIES SE,ALLCODE A0, ALLCODE A1, ALLCODE A2, ALLCODE A3,aLLCODE A4,
                    afmast af, cfmast cf
            WHERE CFMSTS.ORDERID(+)=OD.ORDERID
                    AND OD.CODEID=SE.CODEID
                    AND a0.cdtype = 'OD' AND a0.cdname = 'TRADEPLACE' AND a0.cdval = se.tradeplace
                    AND A1.cdtype = 'OD' AND A1.cdname = 'EXECTYPE'
                    AND A1.cdval =(case when nvl(od.reforderid,'a') <>'a' and OD.EXECTYPE = 'NB' then 'AB'
                    when  nvl(od.reforderid,'a') <>'a' and OD.EXECTYPE in ( 'NS','MS') then 'AS'
                      else od.EXECTYPE end)
                    AND A2.cdtype = 'OD' AND A2.cdname = 'PRICETYPE' AND A2.cdval = OD.PRICETYPE
                    AND A3.cdtype = 'OD' AND A3.cdname = 'VIA' AND A3.cdval = OD.VIA
                    AND a4.cdtype = 'SY' AND a4.cdname = 'YESNO' AND a4.cdval = nvl(CFMSTS.CONFIRMED,'N')
                    and ( (od.exectype in ('NB','NS','MS') AND od.via in ('F','T','H')) or (od.exectype  not in ('NB','NS','MS')))
                    and od.exectype not in ('AB','AS')
                    AND (od.via NOT IN ('O','M') OR (od.via = 'H' and od.tlid <> '6868'))
                    AND od.txdate >=to_date('01/01/2013','DD/MM/YYYY')
                    AND od.afacctno=af.acctno and af.custid=cf.custid
                    AND v_currdate - OD.txdate > 3
                    --and od.orderid not in (select orderid from CONFIRMODRSTS)
                    and not EXISTS (select orderid from CONFIRMODRSTS where orderid=od.orderid)
                    ORDER BY OD.TXDATE DESC
       )
    LOOP
        cspks_odproc.pr_ConfirmOrder(rec.ORDERID, '0001', rec.Custid, '127.0.0.1', p_err_code);
    END LOOP;

EXCEPTION
WHEN OTHERS
THEN
  plog.error (SQLERRM || dbms_utility.format_error_backtrace);
  return;
END pr_ConfirmOrderAuto;
 
 
/
