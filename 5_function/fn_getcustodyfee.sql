SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getcustodyfee(P_CUSTODYCD IN VARCHAR2)
    RETURN NUMBER IS

    V_RESULT NUMBER;
    v_custodycd varchar2(20);
    v_asset number(20,4);
    v_balance number(20,4);
    v_feecd number(20,4);
    v_feeamt number(20,4);
    v_feerate number(20,4);
    v_ccycd varchar(20);
    v_feecode varchar(30);
BEGIN
    v_custodycd := P_CUSTODYCD;
    BEGIN
        select sum(vw.SEBAL), sum(vw.ASSET) into v_balance, v_asset
        from VW_SEDEPO_DAILY vw
        where vw.CUSTODYCD = v_custodycd
        group by vw.CUSTODYCD;
    EXCEPTION WHEN OTHERS THEN
      v_balance:=0;
      v_asset :=0;
    END;
    V_RESULT:= cspks_feecalc.fn_sedepo_calc(v_custodycd, v_asset, v_balance, v_feecd, v_feeamt, v_feerate, v_ccycd, v_feecode);

    IF V_RESULT = 0 THEN
        RETURN NVL(v_feeamt, 0);
    ELSE
        RETURN 0;
    END IF;
EXCEPTION WHEN OTHERS THEN
    RETURN 0;
END;
/
