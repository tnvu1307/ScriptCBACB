SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_feeamt(
      pv_custodycd IN VARCHAR2,
      pv_amt IN number,
      pv_qtty  IN number,
      pv_type IN number
) return number is
    v_Result number(20,4);
    v_ccycd varchar2(10);
    v_feecd varchar2(10);
    v_feerate number(20,4);
    v_feeamt number(20,4);
    v_cfdesc varchar(20);
    l_count number;
    l_countamc number;
    l_countgcb number;
    l_amcid varchar2(20);
    l_gcbid varchar2(20);
    v_feecode varchar2(30);
begin
/*================================================================================*/
     begin
     select amcid, gcbid INTO l_amcid,l_gcbid FROM cfmast WHERE custodycd = pv_custodycd;
     exception when others then
       l_amcid :=null;
       l_gcbid :=null;
     end;

    select count(*) into l_count from cffeeexp cf, feemaster fe
    where custodycd = pv_custodycd and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'TRANREPAIR'
       and fe.status = 'Y'
       and cf.effdate <= to_date(getcurrdate) and cf.expdate  >= to_date(getcurrdate);
    select count(amcid) INTO l_countamc FROM cffeeexp cf, feemaster fe
    where amcid = l_amcid and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'TRANREPAIR'
         and fe.status = 'Y'
         and cf.effdate <= to_date(getcurrdate);
    select count(amcid) INTO l_countgcb FROM cffeeexp cf, feemaster fe
    where amcid = l_gcbid and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'TRANREPAIR'
           and fe.status = 'Y'
           and cf.effdate <= to_date(getcurrdate);
/*================================================================================*/
    IF l_count > 0 THEN
        v_cfdesc:='FUND';
    ELSIF l_countamc > 0 THEN
        v_cfdesc:='AMC';
    ELSIF l_countgcb > 0 THEN
        v_cfdesc:='GCB';
    ELSE
        v_cfdesc:='MASTER';
    END IF;
  if pv_type = 1 then
      v_Result := cspks_feecalc.fn_sedepo_calc(pv_custodycd, pv_amt, pv_qtty, v_feecd, v_feeamt, v_feerate, v_ccycd, v_feecode);
  else
      v_result := cspks_feecalc.fn_order_calc(pv_custodycd, l_amcid, l_gcbid, pv_amt, pv_qtty , v_feecd, v_feeamt, v_feerate, v_ccycd, v_cfdesc, v_feecode);
  end if;
  return(v_feeamt);
end fn_get_feeamt;
/
