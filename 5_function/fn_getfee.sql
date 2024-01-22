SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getfee(P_CUSTODYCD IN VARCHAR2)
RETURN number IS
    V_RESULT number(20,2);
    v_debtfee number(20,2);
    v_feecd number(20,4);
    v_feeamt number(20,4);
    v_feerate number(20,4);
    v_ccycd varchar(20);
    v_trannum number(20,2);
    v_tranamt number(20,2);
    v_cfdesc varchar(20);
    l_count number;
    l_countamc number;
    l_countgcb number;
    l_amcid varchar2(20);
    l_gcbid varchar2(20);
    v_feecode varchar2(20);
BEGIN

    V_RESULT := 0;
/*================================================================================*/
     begin
     select amcid, gcbid INTO l_amcid,l_gcbid FROM cfmast WHERE custodycd = P_CUSTODYCD;
     exception when others then
       l_amcid :=null;
       l_gcbid :=null;
     end;

    select count(*) into l_count from cffeeexp cf, feemaster fe
    where custodycd = P_CUSTODYCD and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'TRANREPAIR'
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
    BEGIN
      select sum(feeamt) into v_debtfee from feetran where custodycd = P_CUSTODYCD and STATUS = 'N'
      group by custodycd;
    EXCEPTION WHEN NO_DATA_FOUND THEN v_debtfee :=0;
    END;

    BEGIN
    SELECT COUNT(*), SUM(FE.AMOUNT) INTO v_trannum, v_tranamt
      FROM (
          SELECT *
          FROM FEETRANREPAIR FE
          WHERE FE.Deltd <> 'Y'
          ) FE, CFMAST cf
      WHERE FE.CUSTID = CF.CUSTID
            AND CF.CUSTODYCD = P_CUSTODYCD
      GROUP BY CF.CUSTODYCD, CF.CUSTID;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      v_trannum :=0;
      v_tranamt :=0;
    END;

    V_RESULT:= cspks_feecalc.fn_order_calc(P_CUSTODYCD, l_amcid, l_gcbid, v_tranamt, v_trannum, v_feecd, v_feeamt, v_feerate, v_ccycd, v_cfdesc, v_feecode);

    IF V_RESULT = 0 THEN
        RETURN ROUND(nvl(v_debtfee,0) + nvl(v_feeamt,0),4);
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
   WHEN OTHERS THEN
   plog.error('fn_getFEE'||SQLERRM || dbms_utility.format_error_backtrace);
    RETURN 0;
END;
/
