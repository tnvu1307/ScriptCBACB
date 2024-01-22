SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_feecalc IS

  -- Author  : USER
  -- Created : 11/10/2019 08:55:14
  -- Purpose :

   type rec_fee_type IS RECORD(
       FEECD feemaster.feecd%TYPE,
       FORP  feemaster.forp%TYPE,
       FEEVAL feemaster.feeamt%TYPE,
       MINVAL feemaster.Minval%TYPE,
       MAXVAL feemaster.Maxval%TYPE,
       CCYCD feemaster.ccycd%TYPE,
       FEEAMT NUMBER,
       FERATE feemaster.feerate%TYPE,
       FEE_AMT NUMBER);

  TYPE rec_fee_arrtype IS TABLE OF rec_fee_type
  INDEX BY PLS_INTEGER;

  FUNCTION fn_sedepo_calc (
    pv_custodycd   IN   VARCHAR2,
      pv_amt  IN number,
      pv_qtty  IN number,
      pv_feecd OUT VARCHAR2,
      pv_feeamt OUT number,
      pv_feerate OUT number,
      pv_ccycd OUT VARCHAR2,
      pv_feecode OUT VARCHAR2
   )
   RETURN NUMBER;

   FUNCTION fn_sedepo_calc2 (
    pv_custodycd   IN   VARCHAR2,
      pv_amt  IN number,
      pv_qtty  IN number,
      pv_txdate IN DATE,
      pv_feecd OUT VARCHAR2,
      pv_feeamt OUT number,
      pv_feerate OUT number,
      pv_ccycd OUT VARCHAR2,
      pv_feecode OUT VARCHAR2
   )
   RETURN NUMBER;

   FUNCTION fn_sedepo_manual_calc
     (
        pv_custodycd   IN   VARCHAR2,
          pv_amt  IN number,
          pv_qtty  IN number,
          pv_day  IN number,
          pv_feecd OUT VARCHAR2,
          pv_feeamt OUT number,
          pv_feerate OUT number,
          pv_ccycd OUT VARCHAR2,
          pv_feecode OUT VARCHAR2
       )
       RETURN NUMBER;


 FUNCTION FN_CB_CITAD_CALC (
      pv_custodycd   IN   VARCHAR2,
      pv_amt  IN number,
      pv_qtty  IN number,
      pv_feecd OUT VARCHAR2,
      pv_feeamt OUT number,
      pv_feerate OUT number,
      pv_ccycd OUT VARCHAR2
   )
   RETURN NUMBER;

   FUNCTION fn_order_calc (
      pv_custodycd IN VARCHAR2,
      pv_amcid   IN   VARCHAR2,
      pv_gcbid   IN   VARCHAR2,
      pv_amt IN number,
      pv_qtty  IN number,
      pv_feecd OUT VARCHAR2,
      pv_feeamt OUT number,
      pv_feerate OUT number,
      pv_ccycd OUT VARCHAR2,
      pv_cfdesc IN VARCHAR2,
      pv_feecode OUT VARCHAR2
   )
   RETURN NUMBER;

      FUNCTION fn_order_calc2 (
      pv_custodycd IN VARCHAR2,
      pv_amcid   IN   VARCHAR2,
      pv_gcbid   IN   VARCHAR2,
      pv_amt IN number,
      pv_qtty  IN number,
      pv_txdate IN DATE,
      pv_feecd OUT VARCHAR2,
      pv_feeamt OUT number,
      pv_feerate OUT number,
      pv_ccycd OUT VARCHAR2,
      pv_cfdesc IN VARCHAR2,
      pv_feecode OUT VARCHAR2
   )
   RETURN NUMBER;

   FUNCTION fn_transfer_calc (
      pv_custodycd IN VARCHAR2,
      pv_amt IN number,
      pv_qtty  IN number,
      pv_feecd OUT VARCHAR2,
      pv_feeamt OUT number,
      pv_feerate OUT number,
      pv_ccycd OUT VARCHAR2
   )
   RETURN NUMBER;

   FUNCTION FN_GET_FEEAMT_WITHOUT_TIER (
      PV_CUSTODYCD   IN   VARCHAR2,
      PV_REFCODE     IN   VARCHAR2,
      PV_SUBTYPE     IN   VARCHAR2,
      PV_TAXRATE     OUT  NUMBER,
      PV_CCYCD       OUT  VARCHAR2,
      PV_FEECODE     OUT  VARCHAR2,
      PV_FEECD       OUT  VARCHAR2
   ) --NAM.LY 23/03/2020
   RETURN NUMBER;

   FUNCTION fn_tax_calc (
      pv_custodycd IN VARCHAR2,
      pv_feeamt IN number,
       pv_ccycd IN VARCHAR2,
      pv_feecd in VARCHAR2,
      pv_round in number,
      pv_taxamt OUT number,
      pv_taxrate OUT number

   )
   RETURN NUMBER;

   FUNCTION fn_tax_calc2 (
      pv_custodycd IN VARCHAR2,
      pv_feeamt IN number,
      pv_ccycd IN VARCHAR2,
      pv_feecd in VARCHAR2,
      pv_round in number,
      pv_txdate in date,
      pv_taxamt OUT number,
      pv_taxrate OUT number

   )
   RETURN NUMBER;

FUNCTION FN_CB_OVERSEAS_CALC (
      pv_custodycd   IN   VARCHAR2,
      pv_amt  IN number,
      pv_qtty  IN number,
      pv_subfee in varchar2,
      pv_feecd OUT VARCHAR2,
      pv_feeamt OUT number,
      pv_feerate OUT number,
      pv_ccycd OUT VARCHAR2,
      pv_forp OUT varchar2
   )
   RETURN NUMBER;

END;
/


CREATE OR REPLACE PACKAGE BODY cspks_feecalc is
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

-------------------------------------SEDEPO-------------------------------------
  FUNCTION fn_sedepo_calc (
      pv_custodycd   IN   VARCHAR2,
      pv_amt  IN number,
      pv_qtty  IN number,
      pv_feecd OUT VARCHAR2,
      pv_feeamt OUT number,
      pv_feerate OUT number,
      pv_ccycd OUT VARCHAR2,
      pv_feecode OUT VARCHAR2
   )
   RETURN NUMBER
   IS
   fee_amt number(20,4);

   v_feeval number(20,4);
   v_tierval number(20,4);

   v_min number(20,4);
   l_min number(20,4);

   v_daybase number(20,4);
   v_daynum number(20,4);

   l_count number;
   v_sqlStr varchar2(1000);

   l_amcid varchar2(20);
   l_gcbid varchar2(20);
   v_currdate varchar2(50);
   l_BOMDATE    date;
   l_EOMDATE    date;
   v_forp varchar2(10);
  Type ref_cursor is ref cursor;
  type fee_record is record(
      autoid       cffeeexp.autoid%type,
      feecd        cffeeexp.feecd%type,
      custodycd    cffeeexp.custodycd%type,
      effdate      cffeeexp.effdate%type,
      expdate      cffeeexp.expdate%type,
      minval       cffeeexp.minval%type,
      maxval       cffeeexp.maxval%type,
      feeval       cffeeexp.feeval%type,
      forp         feemaster.forp%type,
      ccycd        feemaster.ccycd%type,
      feecalc      feemaster.feecalc%type,
      feecode      feemaster.feecode%type
  );

    cur   ref_cursor;
    fee_row fee_record;

    type ty_fee is table of fee_record index by binary_integer;

    fee_list         ty_fee;
    l_ca_cache_size number(23) := 100000;
    l_row           pls_integer;

   BEGIN
   pv_feeamt:=0;
pv_feerate:=0;
      SELECT VARVALUE CURRDATE INTO v_currdate
FROM SYSVAR
WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE';
     begin
     select amcid, gcbid INTO l_amcid,l_gcbid FROM cfmast WHERE custodycd = pv_custodycd;
     exception when others then
       l_amcid :=null;
       l_gcbid :=null;
     end;
     select to_number(cdval) into v_daybase from allcode where cdname = 'DAYBASE' and cdtype = 'SY';
    -- Ngay dau thang
    SELECT TRUNC(getcurrdate,'MM') INTO l_BOMDATE FROM DUAL;
    -- Ngay cuoi thang
    SELECT ADD_MONTHS(l_BOMDATE, 1) -1 INTO l_EOMDATE FROM DUAL;
    v_daynum := (l_EOMDATE - l_BOMDATE)+1 ;

    --SELECT to_number(to_char(getcurrdate, 'DD')) into v_daynum from dual;

     select count(*) into l_count from cffeeexp cf, feemaster fe
     where custodycd = pv_custodycd and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'SEDEPO'
           and fe.status ='Y'
           and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR') and cf.expdate  >= to_date(v_currdate,'DD/MM/RRRR');
    --trung.luu : 26/06/2020 SHBVNEX-825 neu khai bieu phi rieng thi lay ccycd theo bieu phi rieng
     if l_count > 0 then --theo fund
       v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd)ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.CUSTODYCD = ''' || pv_custodycd || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'SEDEPO' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                ;
     else
       l_count := 0;

       select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
       where amcid = l_amcid and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'SEDEPO'
             and fe.status ='Y'
             and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
             and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR');

       if l_count > 0 then --theo amc
         v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_amcid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'SEDEPO' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                ;
         --return l_result;
       else
         l_count := 0;

         select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
         where amcid = l_gcbid and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'SEDEPO'
               and fe.status ='Y'
               and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
               and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR');

         if l_count > 0 then --theo gcb
           v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_gcbid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'SEDEPO' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                ;
         else --theo master
           v_sqlStr := 'select null autoid, cf.feecd, null custodycd, null effdate, null expdate,
                    cf.minval, cf.maxval,
                    case when cf.forp = ''F'' then cf.feeamt
                         else cf.feerate
                    end feeval, cf.forp, cf.ccycd, cf.feecalc, cf.feecode
                from feemaster cf
                where cf.refcode = ''' || 'SEDEPO' || ''''
                || ' and cf.subtype = ''' || '001' || ''''
                || ' and cf.status = ''Y'''
                ;
         end if;
       end if;
     end if;
 
    OPEN cur FOR v_sqlStr;
    BEGIN
    LOOP
    fetch cur bulk collect
        into fee_list limit l_ca_cache_size;
    exit when fee_list.count = 0;

    l_row := fee_list.first;
    l_min := fee_list.first;

    while (l_row is not null)
    loop
     fee_row := fee_list(l_row);
     --trung.luu: 05-10-2020 SHBVNEX-1673
     v_forp := fee_row.FORP;
     if fee_row.autoid is null then--bac thang feetier

       if fee_row.feecalc = '1' then
           begin
                select feeval into v_tierval from feetier
                where frval <= pv_amt and pv_amt < toval and fee_row.feecd = feecd;
           exception when others then v_tierval:=0;
           end;
           v_feeval := fee_row.feeval +nvl(v_tierval,0);
        else
           v_feeval := fee_row.feeval;
        end if;

     elsif

       fee_row.autoid is not null then --bac thang rieng
        if fee_row.feecalc = '1' then
           begin
               select feeval into v_tierval from cffeeexptier
               where frval <= pv_amt and pv_amt < toval and fee_row.autoid = refautoid;
           exception when others then v_tierval:=0;
           end;
           v_feeval := fee_row.feeval +nvl(v_tierval,0);
        else
           v_feeval := fee_row.feeval;
        end if;

     end if;

    fee_row.feeval := v_feeval;

     if fee_row.FORP = 'P' then
        fee_amt := v_feeval * pv_amt/100;
     else
--        fee_amt := v_feeval * pv_qtty; trung.luu: 02-10-2020 SHBVNEX-1673
        fee_amt := v_feeval;
     end if;

     if l_row = fee_list.first then
       v_min := fee_amt;
     end if;

     if fee_amt < v_min then
       v_min := fee_amt;
       l_min := l_row;
     end if;
     l_row := fee_list.next(l_row);
    end loop;
    if v_forp = 'P' then
        pv_feeamt := GREATEST(LEAST(fee_amt * v_daynum/v_daybase ,fee_list(l_min).maxval),fee_list(l_min).minval);
    else --trung.luu: 05-10-2020 SHBVNEX-1673
        pv_feeamt := GREATEST(LEAST(fee_amt ,fee_list(l_min).maxval),fee_list(l_min).minval);
    end if;

    --trung.luu: Tat ca cac loai phi tinh VND round,0 (USD round,2)
    if fee_list(l_min).ccycd = 'VND' then
        pv_feeamt := round(pv_feeamt,0);
    else
        pv_feeamt := round(pv_feeamt,2);
    end if;
    pv_feecd := fee_list(l_min).feecd;
    pv_ccycd := fee_list(l_min).ccycd;
    pv_feerate := fee_list(l_min).feeval;
    pv_feecode:=fee_list(l_min).feecode;
    END LOOP;
    RETURN 0;
    EXCEPTION WHEN OTHERS THEN RETURN -1;
    END;
   END FN_SEDEPO_CALC;
--------------------------------------END---------------------------------------

FUNCTION fn_sedepo_calc2 (
      pv_custodycd   IN   VARCHAR2,
      pv_amt  IN number,
      pv_qtty  IN number,
      pv_txdate IN DATE,
      pv_feecd OUT VARCHAR2,
      pv_feeamt OUT number,
      pv_feerate OUT number,
      pv_ccycd OUT VARCHAR2,
      pv_feecode OUT VARCHAR2
   )
   RETURN NUMBER
   IS
   fee_amt number(20,4);

   v_feeval number(20,4);
   v_tierval number(20,4);

   v_min number(20,4);
   l_min number(20,4);

   v_daybase number(20,4);
   v_daynum number(20,4);

   l_count number;
   v_sqlStr varchar2(1000);

   l_amcid varchar2(20);
   l_gcbid varchar2(20);
   v_currdate varchar2(50);
   l_BOMDATE    date;
   l_EOMDATE    date;
   v_forp varchar2(10);
  Type ref_cursor is ref cursor;
  type fee_record is record(
      autoid       cffeeexp.autoid%type,
      feecd        cffeeexp.feecd%type,
      custodycd    cffeeexp.custodycd%type,
      effdate      cffeeexp.effdate%type,
      expdate      cffeeexp.expdate%type,
      minval       cffeeexp.minval%type,
      maxval       cffeeexp.maxval%type,
      feeval       cffeeexp.feeval%type,
      forp         feemaster.forp%type,
      ccycd        feemaster.ccycd%type,
      feecalc      feemaster.feecalc%type,
      feecode      feemaster.feecode%type
  );

    cur   ref_cursor;
    fee_row fee_record;

    type ty_fee is table of fee_record index by binary_integer;

    fee_list         ty_fee;
    l_ca_cache_size number(23) := 100000;
    l_row           pls_integer;

   BEGIN
    pv_feeamt:=0;
    pv_feerate:=0;
    v_currdate := TO_CHAR(pv_txdate, SYSTEMNUMS.C_DATE_FORMAT);
    begin
        select amcid, gcbid INTO l_amcid,l_gcbid FROM cfmast WHERE custodycd = pv_custodycd;
    exception when others then
        l_amcid := null;
        l_gcbid := null;
    end;
    select to_number(cdval) into v_daybase from allcode where cdname = 'DAYBASE' and cdtype = 'SY';
    -- Ngay dau thang
    SELECT TRUNC(pv_txdate,'MM') INTO l_BOMDATE FROM DUAL;
    -- Ngay cuoi thang
    SELECT ADD_MONTHS(l_BOMDATE, 1) -1 INTO l_EOMDATE FROM DUAL;
    v_daynum := (l_EOMDATE - l_BOMDATE)+1 ;

    select count(*) into l_count from cffeeexp cf, feemaster fe
    where custodycd = pv_custodycd and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'SEDEPO'
    and fe.status ='Y'
    and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR') and cf.expdate  >= to_date(v_currdate,'DD/MM/RRRR');
    --trung.luu : 26/06/2020 SHBVNEX-825 neu khai bieu phi rieng thi lay ccycd theo bieu phi rieng
     if l_count > 0 then --theo fund
       v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd)ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.CUSTODYCD = ''' || pv_custodycd || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'SEDEPO' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                ;
     else
       l_count := 0;

       select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
       where amcid = l_amcid and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'SEDEPO'
             and fe.status ='Y'
             and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
             and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR');

       if l_count > 0 then --theo amc
         v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_amcid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'SEDEPO' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                ;
         --return l_result;
       else
         l_count := 0;

         select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
         where amcid = l_gcbid and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'SEDEPO'
               and fe.status ='Y'
               and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
               and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR');

         if l_count > 0 then --theo gcb
           v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_gcbid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'SEDEPO' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                ;
         else --theo master
           v_sqlStr := 'select null autoid, cf.feecd, null custodycd, null effdate, null expdate,
                    cf.minval, cf.maxval,
                    case when cf.forp = ''F'' then cf.feeamt
                         else cf.feerate
                    end feeval, cf.forp, cf.ccycd, cf.feecalc, cf.feecode
                from feemaster cf
                where cf.refcode = ''' || 'SEDEPO' || ''''
                || ' and cf.subtype = ''' || '001' || ''''
                || ' and cf.status = ''Y'''
                ;
         end if;
       end if;
     end if;
    OPEN cur FOR v_sqlStr;
    BEGIN
    LOOP
    fetch cur bulk collect
        into fee_list limit l_ca_cache_size;
    exit when fee_list.count = 0;

    l_row := fee_list.first;
    l_min := fee_list.first;

    while (l_row is not null)
    loop
     fee_row := fee_list(l_row);
     --trung.luu: 05-10-2020 SHBVNEX-1673
     v_forp := fee_row.FORP;
     if fee_row.autoid is null then--bac thang feetier

       if fee_row.feecalc = '1' then
           begin
                select feeval into v_tierval from feetier
                where frval <= pv_amt and pv_amt < toval and fee_row.feecd = feecd;
           exception when others then v_tierval:=0;
           end;
           v_feeval := fee_row.feeval +nvl(v_tierval,0);
        else
           v_feeval := fee_row.feeval;
        end if;

     elsif

       fee_row.autoid is not null then --bac thang rieng
        if fee_row.feecalc = '1' then
           begin
               select feeval into v_tierval from cffeeexptier
               where frval <= pv_amt and pv_amt < toval and fee_row.autoid = refautoid;
           exception when others then v_tierval:=0;
           end;
           v_feeval := fee_row.feeval +nvl(v_tierval,0);
        else
           v_feeval := fee_row.feeval;
        end if;

     end if;

    fee_row.feeval := v_feeval;

     if fee_row.FORP = 'P' then
        fee_amt := v_feeval * pv_amt/100;
     else
--        fee_amt := v_feeval * pv_qtty; trung.luu: 02-10-2020 SHBVNEX-1673
        fee_amt := v_feeval;
     end if;

     if l_row = fee_list.first then
       v_min := fee_amt;
     end if;

     if fee_amt < v_min then
       v_min := fee_amt;
       l_min := l_row;
     end if;
     l_row := fee_list.next(l_row);
    end loop;
    if v_forp = 'P' then
        pv_feeamt := GREATEST(LEAST(fee_amt * v_daynum/v_daybase ,fee_list(l_min).maxval),fee_list(l_min).minval);
    else --trung.luu: 05-10-2020 SHBVNEX-1673
        pv_feeamt := GREATEST(LEAST(fee_amt ,fee_list(l_min).maxval),fee_list(l_min).minval);
    end if;

    --trung.luu: Tat ca cac loai phi tinh VND round,0 (USD round,2)
    if fee_list(l_min).ccycd = 'VND' then
        pv_feeamt := round(pv_feeamt,0);
    else
        pv_feeamt := round(pv_feeamt,2);
    end if;
    pv_feecd := fee_list(l_min).feecd;
    pv_ccycd := fee_list(l_min).ccycd;
    pv_feerate := fee_list(l_min).feeval;
    pv_feecode:=fee_list(l_min).feecode;
    END LOOP;
    RETURN 0;
    EXCEPTION WHEN OTHERS THEN RETURN -1;
    END;
   END FN_SEDEPO_CALC2;

  FUNCTION FN_CB_CITAD_CALC (
      pv_custodycd   IN   VARCHAR2,
      pv_amt  IN number,
      pv_qtty  IN number,
      pv_feecd OUT VARCHAR2,
      pv_feeamt OUT number,
      pv_feerate OUT number,
      pv_ccycd OUT VARCHAR2
   )
   RETURN NUMBER
   IS
   fee_amt number(20,4);

   v_feeval number(20,4);
   v_tierval number(20,4);

   v_min number(20,4);
   l_min number(20,4);

   l_count number;
   v_sqlStr varchar2(1000);

   l_amcid varchar2(20);
   l_gcbid varchar2(20);
   v_currdate varchar2(50);
  Type ref_cursor is ref cursor;
  type fee_record is record(
      autoid       cffeeexp.autoid%type,
      feecd        cffeeexp.feecd%type,
      custodycd    cffeeexp.custodycd%type,
      effdate      cffeeexp.effdate%type,
      expdate      cffeeexp.expdate%type,
      minval       cffeeexp.minval%type,
      maxval       cffeeexp.maxval%type,
      feeval       cffeeexp.feeval%type,
      forp         feemaster.forp%type,
      ccycd        feemaster.ccycd%type,
      feecalc      feemaster.feecalc%type
  );

    cur   ref_cursor;
    fee_row fee_record;

    type ty_fee is table of fee_record index by binary_integer;

    fee_list         ty_fee;
    l_ca_cache_size number(23) := 100000;
    l_row           pls_integer;

   BEGIN
   pv_feeamt:=0;
    pv_feerate:=0;
     SELECT VARVALUE CURRDATE INTO v_currdate
FROM SYSVAR
WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE';
     pv_ccycd:='VND';
     begin
     select amcid, gcbid INTO l_amcid,l_gcbid FROM cfmast WHERE custodycd = pv_custodycd;
     exception when others then
       l_amcid :=null;
       l_gcbid :=null;
     end;

     select count(*) into l_count from cffeeexp cf, feemaster fe
     where custodycd = pv_custodycd and cf.feecd = fe.feecd and fe.subtype = '014' and fe.refcode = 'OTHER'
           and fe.status = 'Y'
           and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR') and cf.expdate  >= to_date(v_currdate,'DD/MM/RRRR') ;
--trung.luu : 26/06/2020 SHBVNEX-825 neu khai bieu phi rieng thi lay ccycd theo bieu phi rieng
     if l_count > 0 then --theo fund
       v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd)ccycd, mst.feecalc
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.CUSTODYCD = ''' || pv_custodycd || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'OTHER' || ''''
                || ' and mst.subtype = ''' || '014' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')' ;

     else
       l_count := 0;

       select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
       where amcid = l_amcid and cf.feecd = fe.feecd and fe.subtype = '014' and fe.refcode = 'OTHER'
             and fe.status = 'Y'
             and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
             and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR');

       if l_count > 0 then --theo amc
         v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd)ccycd, mst.feecalc
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_amcid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'OTHER' || ''''
                || ' and mst.subtype = ''' || '014' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')';


         --return l_result;
       else
         l_count := 0;

         select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
         where amcid = l_gcbid and cf.feecd = fe.feecd and fe.subtype = '014' and fe.refcode = 'OTHER'
               and fe.status = 'Y'
               and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
               and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR');

         if l_count > 0 then --theo gcb
           v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd)ccycd, mst.feecalc
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_gcbid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'OTHER' || ''''
                || ' and mst.subtype = ''' || '014' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')';


         else --theo master
           v_sqlStr := 'select null autoid, cf.feecd, null custodycd, null effdate, null expdate,
                    cf.minval, cf.maxval,
                    case when cf.forp = ''F'' then cf.feeamt
                         else cf.feerate
                    end feeval, cf.forp, cf.ccycd, cf.feecalc
                from feemaster cf
                where cf.refcode = ''' || 'OTHER' || ''''
                || ' and cf.subtype = ''' || '014' || ''''
                || ' and cf.status = ''Y''';
         end if;
       end if;
     end if;

 
    OPEN cur FOR v_sqlStr;
    BEGIN
    LOOP
    fetch cur bulk collect
        into fee_list limit l_ca_cache_size;
    exit when fee_list.count = 0;

    l_row := fee_list.first;
    l_min := fee_list.first;

    while (l_row is not null)
    loop
     fee_row := fee_list(l_row);

     if fee_row.autoid is null then--bac thang feetier
       if fee_row.feecalc = '1' then
           begin
                select feeval into v_tierval from feetier
                where frval <= pv_amt and pv_amt < toval and fee_row.feecd = feecd;
           exception when others then v_tierval:=0;
           end;
           v_feeval := fee_row.feeval +nvl(v_tierval,0);
        else
           v_feeval := fee_row.feeval;
        end if;
     elsif
       fee_row.autoid is not null then --bac thang rieng
        if fee_row.feecalc = '1' then
           begin
               select feeval into v_tierval from cffeeexptier
               where frval <= pv_amt and pv_amt < toval and fee_row.autoid = refautoid;
           exception when others then v_tierval:=0;
           end;
           v_feeval := fee_row.feeval +nvl(v_tierval,0);
        else
           v_feeval := fee_row.feeval;
        end if;
     end if;
     fee_row.feeval := v_feeval;
     if fee_row.FORP = 'P' then
        fee_amt := v_feeval * pv_amt/100;
     else
        fee_amt := v_feeval ;
     end if;

     if l_row = fee_list.first then
       v_min := fee_amt;
     end if;

     if fee_amt < v_min then
       v_min := fee_amt;
       l_min := l_row;
     end if;
     l_row := fee_list.next(l_row);
    end loop;
    --pv_feeamt := round(GREATEST(LEAST(fee_amt,fee_list(l_min).maxval),fee_list(l_min).minval),0);
    --trung.luu: Tat ca cac loai phi tinh VND round,0 (USD round,2)
    if fee_list(l_min).ccycd = 'VND' then
        pv_feeamt := round(GREATEST(LEAST(fee_amt,fee_list(l_min).maxval),fee_list(l_min).minval),0);
    else
        pv_feeamt := round(GREATEST(LEAST(fee_amt,fee_list(l_min).maxval),fee_list(l_min).minval),2);
    end if;

    plog.error('maxval: '||fee_list(l_min).maxval||',minval: '||fee_list(l_min).minval||',feeamt: '||fee_amt);
    pv_feecd := fee_list(l_min).feecd;
    pv_ccycd := fee_list(l_min).ccycd;
    pv_feerate := fee_list(l_min).feeval;
    END LOOP;
    RETURN 0;
    EXCEPTION WHEN OTHERS THEN RETURN -1;
    END;
   END FN_CB_CITAD_CALC;

FUNCTION fn_order_calc (
    pv_custodycd   IN   VARCHAR2,
    pv_amcid   IN   VARCHAR2,
    pv_gcbid   IN   VARCHAR2,
    pv_amt IN number,
    pv_qtty  IN number,
    pv_feecd OUT VARCHAR2,
    pv_feeamt OUT number,
    pv_feerate OUT number,
    pv_ccycd OUT VARCHAR2,
    pv_cfdesc IN VARCHAR2,
    pv_feecode OUT VARCHAR2
   )
   RETURN NUMBER
   IS
   fee_amt number(20,4);

   v_feeval number(20,4);
   v_tierval number(20,4);

   v_min number(20,4);
   l_min number(20,4);

   v_daybase number(20,4);
   v_daynum number(20,4);

   l_count number;
   v_sqlStr varchar2(1000);

   l_amcid varchar2(20);
   l_gcbid varchar2(20);
   v_currdate varchar2(50);
  Type ref_cursor is ref cursor;
  type fee_record is record(
      autoid       cffeeexp.autoid%type,
      feecd        cffeeexp.feecd%type,
      custodycd    cffeeexp.custodycd%type,
      effdate      cffeeexp.effdate%type,
      expdate      cffeeexp.expdate%type,
      minval       cffeeexp.minval%type,
      maxval       cffeeexp.maxval%type,
      feeval       cffeeexp.feeval%type,
      forp         feemaster.forp%type,
      ccycd        feemaster.ccycd%type,
      feecalc      feemaster.feecalc%type,
      feecode      feemaster.feecode%type
  );
--thunt
    cur   ref_cursor;
    fee_row fee_record;

    type ty_fee is table of fee_record index by binary_integer;

    fee_list         ty_fee;
    l_ca_cache_size number(23) := 100000;
    l_row           pls_integer;

   BEGIN
   pv_feeamt:=0;
pv_feerate:=0;
     SELECT VARVALUE CURRDATE INTO v_currdate
FROM SYSVAR
WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE';
    l_amcid:=pv_amcid;
    l_gcbid:=pv_gcbid;
     IF pv_cfdesc = 'FUND' THEN --theo fund
     --trung.luu : 26/06/2020 SHBVNEX-825 neu khai bieu phi rieng thi lay ccycd theo bieu phi rieng
       v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.CUSTODYCD = ''' || pv_custodycd || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'TRANREPAIR' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                ;
     ELSIF pv_cfdesc = 'AMC' THEN--theo amc
         v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_amcid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'TRANREPAIR' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                ;
    ELSIF pv_cfdesc = 'GCB' THEN--theo gcb
           v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_gcbid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'TRANREPAIR' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                ;
    ELSE --theo master
           v_sqlStr := 'select null autoid, cf.feecd, null custodycd, null effdate, null expdate,
                    cf.minval, cf.maxval,
                    case when cf.forp = ''F'' then cf.feeamt
                         else cf.feerate
                    end feeval, cf.forp, cf.ccycd, cf.feecalc, cf.feecode
                from feemaster cf
                where cf.status = ''Y'''
                || ' and cf.refcode = ''' || 'TRANREPAIR' || ''''
                || ' and cf.subtype = ''' || '001' || '''';
     END IF;

 
    OPEN cur FOR v_sqlStr;
    BEGIN
    LOOP
    fetch cur bulk collect
        into fee_list limit l_ca_cache_size;
    exit when fee_list.count = 0;

    l_row := fee_list.first;
    l_min := fee_list.first;

    while (l_row is not null)
    loop
     fee_row := fee_list(l_row);

     if fee_row.autoid is null then--bac thang feetier
       if fee_row.feecalc = '1' then
           begin
                select feeval into v_tierval from feetier
                where frval <= pv_amt and pv_amt < toval and fee_row.feecd = feecd;
           exception when others then v_tierval:=0;
           end;
           v_feeval := fee_row.feeval +nvl(v_tierval,0);
        else
           v_feeval := fee_row.feeval;
        end if;
     elsif
       fee_row.autoid is not null then --bac thang rieng
        if fee_row.feecalc = '1' then
           begin
               select feeval into v_tierval from cffeeexptier
               where frval <= pv_amt and pv_amt < toval and fee_row.autoid = refautoid;
           exception when others then v_tierval:=0;
           end;
           v_feeval := fee_row.feeval +nvl(v_tierval,0);
        else
           v_feeval := fee_row.feeval;
        end if;
     end if;
     fee_row.feeval := v_feeval;
     if fee_row.FORP = 'P' then
        fee_amt := v_feeval * pv_amt/100;
     else
        fee_amt := v_feeval * pv_qtty;
     end if;

     if l_row = fee_list.first then
       v_min := fee_amt;
     end if;

     if fee_amt < v_min then
       v_min := fee_amt;
       l_min := l_row;
     end if;
     l_row := fee_list.next(l_row);
    end loop;
    --trung.luu: Tat ca cac loai phi tinh VND round,0 (USD round,2)
    if fee_list(l_min).ccycd = 'VND' then
        pv_feeamt := round(GREATEST(LEAST(fee_amt,fee_list(l_min).maxval),fee_list(l_min).minval),0);
    else
        pv_feeamt := round(GREATEST(LEAST(fee_amt,fee_list(l_min).maxval),fee_list(l_min).minval),2);
    end if;
    pv_feecd := fee_list(l_min).feecd;
    pv_ccycd := fee_list(l_min).ccycd;
    pv_feerate := fee_list(l_min).feeval;
    pv_feecode := fee_list(l_min).feecode;
    END LOOP;
    
    RETURN 0;
    EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, 'fn_order_calc:'||v_sqlStr);
    RETURN 0;
    END;
   END fn_order_calc;

FUNCTION fn_order_calc2 (
    pv_custodycd   IN   VARCHAR2,
    pv_amcid   IN   VARCHAR2,
    pv_gcbid   IN   VARCHAR2,
    pv_amt IN number,
    pv_qtty  IN number,
    pv_txdate IN DATE,
    pv_feecd OUT VARCHAR2,
    pv_feeamt OUT number,
    pv_feerate OUT number,
    pv_ccycd OUT VARCHAR2,
    pv_cfdesc IN VARCHAR2,
    pv_feecode OUT VARCHAR2
   )
   RETURN NUMBER
   IS
   fee_amt number(20,4);

   v_feeval number(20,4);
   v_tierval number(20,4);

   v_min number(20,4);
   l_min number(20,4);

   v_daybase number(20,4);
   v_daynum number(20,4);

   l_count number;
   v_sqlStr varchar2(1000);

   l_amcid varchar2(20);
   l_gcbid varchar2(20);
   v_currdate varchar2(50);
  Type ref_cursor is ref cursor;
  type fee_record is record(
      autoid       cffeeexp.autoid%type,
      feecd        cffeeexp.feecd%type,
      custodycd    cffeeexp.custodycd%type,
      effdate      cffeeexp.effdate%type,
      expdate      cffeeexp.expdate%type,
      minval       cffeeexp.minval%type,
      maxval       cffeeexp.maxval%type,
      feeval       cffeeexp.feeval%type,
      forp         feemaster.forp%type,
      ccycd        feemaster.ccycd%type,
      feecalc      feemaster.feecalc%type,
      feecode      feemaster.feecode%type
  );
--thunt
    cur   ref_cursor;
    fee_row fee_record;

    type ty_fee is table of fee_record index by binary_integer;

    fee_list         ty_fee;
    l_ca_cache_size number(23) := 100000;
    l_row           pls_integer;

   BEGIN
    pv_feeamt:=0;
    pv_feerate:=0;
    v_currdate := TO_CHAR(pv_txdate, SYSTEMNUMS.C_DATE_FORMAT);
    l_amcid:=pv_amcid;
    l_gcbid:=pv_gcbid;
     IF pv_cfdesc = 'FUND' THEN --theo fund
     --trung.luu : 26/06/2020 SHBVNEX-825 neu khai bieu phi rieng thi lay ccycd theo bieu phi rieng
       v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.CUSTODYCD = ''' || pv_custodycd || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'TRANREPAIR' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                ;
     ELSIF pv_cfdesc = 'AMC' THEN--theo amc
         v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_amcid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'TRANREPAIR' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                ;
    ELSIF pv_cfdesc = 'GCB' THEN--theo gcb
           v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_gcbid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'TRANREPAIR' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                ;
    ELSE --theo master
           v_sqlStr := 'select null autoid, cf.feecd, null custodycd, null effdate, null expdate,
                    cf.minval, cf.maxval,
                    case when cf.forp = ''F'' then cf.feeamt
                         else cf.feerate
                    end feeval, cf.forp, cf.ccycd, cf.feecalc, cf.feecode
                from feemaster cf
                where cf.status = ''Y'''
                || ' and cf.refcode = ''' || 'TRANREPAIR' || ''''
                || ' and cf.subtype = ''' || '001' || '''';
     END IF;

    OPEN cur FOR v_sqlStr;
    BEGIN
    LOOP
    fetch cur bulk collect
        into fee_list limit l_ca_cache_size;
    exit when fee_list.count = 0;

    l_row := fee_list.first;
    l_min := fee_list.first;

    while (l_row is not null)
    loop
     fee_row := fee_list(l_row);

     if fee_row.autoid is null then--bac thang feetier
       if fee_row.feecalc = '1' then
           begin
                select feeval into v_tierval from feetier
                where frval <= pv_amt and pv_amt < toval and fee_row.feecd = feecd;
           exception when others then v_tierval:=0;
           end;
           v_feeval := fee_row.feeval +nvl(v_tierval,0);
        else
           v_feeval := fee_row.feeval;
        end if;
     elsif
       fee_row.autoid is not null then --bac thang rieng
        if fee_row.feecalc = '1' then
           begin
               select feeval into v_tierval from cffeeexptier
               where frval <= pv_amt and pv_amt < toval and fee_row.autoid = refautoid;
           exception when others then v_tierval:=0;
           end;
           v_feeval := fee_row.feeval +nvl(v_tierval,0);
        else
           v_feeval := fee_row.feeval;
        end if;
     end if;
     fee_row.feeval := v_feeval;
     if fee_row.FORP = 'P' then
        fee_amt := v_feeval * pv_amt/100;
     else
        fee_amt := v_feeval * pv_qtty;
     end if;

     if l_row = fee_list.first then
       v_min := fee_amt;
     end if;

     if fee_amt < v_min then
       v_min := fee_amt;
       l_min := l_row;
     end if;
     l_row := fee_list.next(l_row);
    end loop;
    --trung.luu: Tat ca cac loai phi tinh VND round,0 (USD round,2)
    if fee_list(l_min).ccycd = 'VND' then
        pv_feeamt := round(GREATEST(LEAST(fee_amt,fee_list(l_min).maxval),fee_list(l_min).minval),0);
    else
        pv_feeamt := round(GREATEST(LEAST(fee_amt,fee_list(l_min).maxval),fee_list(l_min).minval),2);
    end if;
    pv_feecd := fee_list(l_min).feecd;
    pv_ccycd := fee_list(l_min).ccycd;
    pv_feerate := fee_list(l_min).feeval;
    pv_feecode := fee_list(l_min).feecode;
    END LOOP;
    
    RETURN 0;
    EXCEPTION WHEN OTHERS THEN
    plog.error(pkgctx, 'fn_order_calc2:'||v_sqlStr);
    RETURN 0;
    END;
END fn_order_calc2;

FUNCTION fn_transfer_calc (
      pv_custodycd   IN   VARCHAR2,
      pv_amt  IN number,
      pv_qtty  IN number,
      pv_feecd OUT VARCHAR2,
      pv_feeamt OUT number,
      pv_feerate OUT number,
      pv_ccycd OUT VARCHAR2
   )
   RETURN NUMBER
   IS
   fee_amt number(20,4);

   v_feeval number(20,4);
   v_tierval number(20,4);

   v_min number(20,4);
   l_min number(20,4);

   l_count number;
   v_sqlStr varchar2(1000);

   l_amcid varchar2(20);
   l_gcbid varchar2(20);
   v_currdate varchar2(50);
  Type ref_cursor is ref cursor;
  type fee_record is record(
      autoid       cffeeexp.autoid%type,
      feecd        cffeeexp.feecd%type,
      custodycd    cffeeexp.custodycd%type,
      effdate      cffeeexp.effdate%type,
      expdate      cffeeexp.expdate%type,
      minval       cffeeexp.minval%type,
      maxval       cffeeexp.maxval%type,
      feeval       cffeeexp.feeval%type,
      forp         feemaster.forp%type,
      ccycd        feemaster.ccycd%type,
      feecalc      feemaster.feecalc%type
  );

    cur   ref_cursor;
    fee_row fee_record;

    type ty_fee is table of fee_record index by binary_integer;

    fee_list         ty_fee;
    l_ca_cache_size number(23) := 100000;
    l_row           pls_integer;

   BEGIN
   pv_feeamt:=0;
pv_feerate:=0;
      SELECT VARVALUE CURRDATE INTO v_currdate
FROM SYSVAR
WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE';
     pv_ccycd:='VND';
     begin
     select amcid, gcbid INTO l_amcid,l_gcbid FROM cfmast WHERE custodycd = pv_custodycd;
     exception when others then
       l_amcid :=null;
       l_gcbid :=null;
     end;

     select count(*) into l_count from cffeeexp cf, feemaster fe
     where custodycd = pv_custodycd and cf.feecd = fe.feecd and fe.subtype = '004' and fe.refcode = 'OTHER'
           and fe.status = 'Y'
           and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR') and cf.expdate  >= to_date(v_currdate,'DD/MM/RRRR') and fe.ccycd = pv_ccycd;

     if l_count > 0 then --theo fund
       v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, mst.ccycd, mst.feecalc
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.CUSTODYCD = ''' || pv_custodycd || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'OTHER' || ''''
                || ' and mst.subtype = ''' || '004' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''') and mst.ccycd ='''||  pv_ccycd|| ''''
                ;
     else
       l_count := 0;

       select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
       where amcid = l_amcid and cf.feecd = fe.feecd and fe.subtype = '004' and fe.refcode = 'OTHER'
             and fe.status = 'Y'
             and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
             and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR')
             and fe.ccycd = pv_ccycd;

       if l_count > 0 then --theo amc
         v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval,(case when cf.forp  = ''F'' then cf.feeval else cf.feerate end)feeval, cf.forp, mst.ccycd, mst.feecalc
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_amcid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'OTHER' || ''''
                || ' and mst.subtype = ''' || '004' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and mst.ccycd = '''||  pv_ccycd|| ''''
                ;
         --return l_result;
       else
         l_count := 0;

         select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
         where amcid = l_gcbid and cf.feecd = fe.feecd and fe.subtype = '004' and fe.refcode = 'OTHER'
               and fe.status = 'Y'
               and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
               and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR')
               and fe.ccycd = pv_ccycd;

         if l_count > 0 then --theo gcb
           v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, mst.ccycd, mst.feecalc
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_gcbid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'OTHER' || ''''
                || ' and mst.subtype = ''' || '004' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and mst.ccycd = '''||  pv_ccycd|| ''''
                ;
         else --theo master
           v_sqlStr := 'select null autoid, cf.feecd, null custodycd, null effdate, null expdate,
                    cf.minval, cf.maxval,
                    case when cf.forp = ''F'' then cf.feeamt
                         else cf.feerate
                    end feeval, cf.forp, cf.ccycd, cf.feecalc
                from feemaster cf
                where ccycd ='''||  pv_ccycd|| ''' and cf.refcode = ''' || 'OTHER' || ''''
                || ' and cf.subtype = ''' || '004' || ''''
                || ' and cf.status = ''Y''';
         end if;
       end if;
     end if;

 
    OPEN cur FOR v_sqlStr;
    BEGIN
    LOOP
    fetch cur bulk collect
        into fee_list limit l_ca_cache_size;
    exit when fee_list.count = 0;

    l_row := fee_list.first;
    l_min := fee_list.first;

    while (l_row is not null)
    loop
     fee_row := fee_list(l_row);

     if fee_row.autoid is null then--bac thang feetier
       if fee_row.feecalc = '1' then
           begin
                select feeval into v_tierval from feetier
                where frval <= pv_amt and pv_amt < toval and fee_row.feecd = feecd;
           exception when others then v_tierval:=0;
           end;
           v_feeval := fee_row.feeval +nvl(v_tierval,0);
        else
           v_feeval := fee_row.feeval;
        end if;
     elsif
       fee_row.autoid is not null then --bac thang rieng
        if fee_row.feecalc = '1' then
           begin

               select feeval into v_tierval from cffeeexptier
               where frval <= pv_amt and pv_amt < toval and fee_row.autoid = refautoid;
           exception when others then v_tierval:=0;
           end;
           v_feeval := fee_row.feeval +nvl(v_tierval,0);
        else
           v_feeval := fee_row.feeval;
        end if;
     end if;
     fee_row.feeval := v_feeval;
     if fee_row.FORP = 'P' then
        fee_amt := v_feeval * pv_amt/100;
     else
        fee_amt := v_feeval ;
     end if;

     if l_row = fee_list.first then
       v_min := fee_amt;
     end if;

     if fee_amt < v_min then
       v_min := fee_amt;
       l_min := l_row;
     end if;
     l_row := fee_list.next(l_row);
    end loop;
    --trung.luu: Tat ca cac loai phi tinh VND round,0 (USD round,2)
    if fee_list(l_min).ccycd = 'VND' then
        pv_feeamt := round(GREATEST(LEAST(fee_amt,fee_list(l_min).maxval),fee_list(l_min).minval),0);
    else
        pv_feeamt := round(GREATEST(LEAST(fee_amt,fee_list(l_min).maxval),fee_list(l_min).minval),2);
    end if;
    pv_feecd := fee_list(l_min).feecd;
    pv_ccycd := fee_list(l_min).ccycd;
    pv_feerate := fee_list(l_min).feeval;
    END LOOP;
    RETURN 0;
    EXCEPTION WHEN OTHERS THEN RETURN -1;
    END;
   END fn_transfer_calc;

 FUNCTION FN_GET_FEEAMT_WITHOUT_TIER (
      PV_CUSTODYCD   IN   VARCHAR2,
      PV_REFCODE     IN   VARCHAR2,
      PV_SUBTYPE     IN   VARCHAR2,
      PV_TAXRATE     OUT  NUMBER,
      PV_CCYCD       OUT  VARCHAR2,
      PV_FEECODE     OUT  VARCHAR2,
      PV_FEECD       OUT  VARCHAR2
   ) --NAM.LY 23/03/2020
   RETURN NUMBER
   IS
   V_FEE_AMT  NUMBER(20,4);
   V_TAXRATE  NUMBER(20,4);
   V_CCYCD    VARCHAR2(20);
   V_FEECODE  VARCHAR2(20);
   V_FEECD    VARCHAR2(20);
   L_COUNT    NUMBER;
   L_AMCID    VARCHAR2(20);
   L_GCBID    VARCHAR2(20);
   V_CURRDATE varchar2(50);
   BEGIN
          SELECT VARVALUE CURRDATE INTO v_currdate
FROM SYSVAR
WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE';
V_FEE_AMT:=0;
PV_TAXRATE:=0;
         --
         BEGIN
             SELECT AMCID, GCBID INTO L_AMCID,L_GCBID FROM CFMAST WHERE CUSTODYCD = PV_CUSTODYCD;
             EXCEPTION WHEN OTHERS THEN
               L_AMCID :=NULL;
               L_GCBID :=NULL;
         END;
         --
         SELECT COUNT(*)
         INTO L_COUNT
         FROM CFFEEEXP CF, FEEMASTER MST
         WHERE CUSTODYCD = PV_CUSTODYCD AND
               CF.FEECD = MST.FEECD AND
               MST.STATUS ='Y' AND
               MST.SUBTYPE =  PV_SUBTYPE AND
               MST.REFCODE = PV_REFCODE AND
               CF.EFFDATE <= TO_DATE(V_CURRDATE,'DD/MM/RRRR') AND
               CF.EXPDATE >= TO_DATE(V_CURRDATE,'DD/MM/RRRR');
         --
         --trung.luu : 26/06/2020 SHBVNEX-825 neu khai bieu phi rieng thi lay ccycd theo bieu phi rieng
         IF L_COUNT > 0 THEN --THEO FUND
            BEGIN
                SELECT (case when cf.forp  = 'F' then cf.feeval else cf.feerate end) FEEVAL, cf.VATRATE, nvl(cf.CCYCD,MST.CCYCD)CCYCD, MST.FEECODE, MST.FEECD
                INTO V_FEE_AMT, V_TAXRATE, V_CCYCD, V_FEECODE, V_FEECD
                FROM CFFEEEXP CF, FEEMASTER MST
                WHERE CF.FEECD = MST.FEECD AND
                      MST.STATUS ='Y' AND
                      CF.CUSTODYCD = PV_CUSTODYCD AND
                      MST.REFCODE = PV_REFCODE AND
                      MST.SUBTYPE = PV_SUBTYPE AND
                      CF.EFFDATE <= TO_DATE(V_CURRDATE,'DD/MM/RRRR') AND
                      CF.EXPDATE >= TO_DATE(V_CURRDATE,'DD/MM/RRRR');
                EXCEPTION WHEN OTHERS THEN V_FEE_AMT := 0;
            END;
         ELSE
           L_COUNT := 0;
           SELECT COUNT(AMCID)
           INTO L_COUNT
           FROM CFFEEEXP CF, FEEMASTER MST
           WHERE AMCID = L_AMCID AND
                 CF.FEECD = MST.FEECD AND
                 MST.STATUS = 'Y' AND
                 MST.SUBTYPE = PV_SUBTYPE AND
                 MST.REFCODE = PV_REFCODE AND
                 CF.EFFDATE <= TO_DATE(V_CURRDATE,'DD/MM/RRRR') AND
                 CF.EXPDATE >= TO_DATE(V_CURRDATE,'DD/MM/RRRR');
           IF L_COUNT > 0 THEN --THEO AMC
              BEGIN
                    SELECT (case when cf.forp  = 'F' then cf.feeval else cf.feerate end) FEEVAL, cf.VATRATE, nvl(cf.CCYCD,MST.CCYCD)CCYCD, MST.FEECODE, MST.FEECD
                    INTO V_FEE_AMT, V_TAXRATE, V_CCYCD, V_FEECODE, V_FEECD
                    FROM CFFEEEXP CF, FEEMASTER MST
                    WHERE CF.FEECD = MST.FEECD AND
                          MST.STATUS = 'Y' AND
                          CF.AMCID = L_AMCID AND
                          MST.REFCODE = PV_REFCODE AND
                          MST.SUBTYPE = PV_SUBTYPE AND
                          CF.EFFDATE <= TO_DATE(V_CURRDATE,'DD/MM/RRRR') AND
                          CF.EXPDATE >= TO_DATE(V_CURRDATE,'DD/MM/RRRR');
                    EXCEPTION WHEN OTHERS THEN V_FEE_AMT := 0;
              END;
           ELSE
             L_COUNT := 0;
             SELECT COUNT(AMCID)
             INTO L_COUNT
             FROM CFFEEEXP CF, FEEMASTER MST
             WHERE AMCID = L_GCBID AND
                   CF.FEECD = MST.FEECD AND
                   MST.STATUS = 'Y' AND
                   MST.SUBTYPE = PV_SUBTYPE AND
                   MST.REFCODE = PV_REFCODE AND
                   CF.EFFDATE <= TO_DATE(V_CURRDATE,'DD/MM/RRRR') AND
                   CF.EXPDATE >= TO_DATE(V_CURRDATE,'DD/MM/RRRR');
             IF L_COUNT > 0 THEN --THEO GCB
                 BEGIN
                       SELECT (case when cf.forp  = 'F' then cf.feeval else cf.feerate end) FEEVAL, cf.VATRATE, nvl(cf.CCYCD,MST.CCYCD)CCYCD, MST.FEECODE, MST.FEECD
                       INTO V_FEE_AMT, V_TAXRATE, V_CCYCD, V_FEECODE, V_FEECD
                       FROM CFFEEEXP CF, FEEMASTER MST
                       WHERE CF.FEECD = MST.FEECD AND
                             CF.AMCID = L_GCBID AND
                             MST.STATUS = 'Y' AND
                             MST.REFCODE = PV_REFCODE AND
                             MST.SUBTYPE = PV_SUBTYPE AND
                             CF.EFFDATE <= TO_DATE(V_CURRDATE,'DD/MM/RRRR') AND
                             CF.EXPDATE >= TO_DATE(V_CURRDATE,'DD/MM/RRRR');
                     EXCEPTION WHEN OTHERS THEN V_FEE_AMT :=0;
                 END;
             ELSE --THEO MASTER
                 BEGIN
                      SELECT (CASE WHEN MST.FORP = 'F' THEN MST.FEEAMT ELSE MST.FEERATE END) FEEVAL,
                             MST.VATRATE, MST.CCYCD, MST.FEECODE, MST.FEECD
                      INTO V_FEE_AMT, V_TAXRATE, V_CCYCD, V_FEECODE, V_FEECD
                      FROM FEEMASTER MST
                      WHERE MST.STATUS ='Y' AND
                            MST.REFCODE = PV_REFCODE AND
                            MST.SUBTYPE = PV_SUBTYPE;
                      EXCEPTION WHEN OTHERS THEN V_FEE_AMT :=0;
                 END;
             END IF;
           END IF;
         END IF;
        PV_TAXRATE := TO_NUMBER(V_TAXRATE);
        PV_CCYCD   := V_CCYCD;
        --trung.luu: Tat ca cac loai phi tinh VND round,0 (USD round,2)
        if V_CCYCD = 'VND' then
            V_FEE_AMT := round(V_FEE_AMT,0);
        else
            V_FEE_AMT := round(V_FEE_AMT,2);
        end if;
        PV_FEECODE := V_FEECODE;
        PV_FEECD   := V_FEECD;
        RETURN V_FEE_AMT;
        EXCEPTION WHEN OTHERS THEN RETURN 0;
    END FN_GET_FEEAMT_WITHOUT_TIER;



FUNCTION fn_tax_calc (
      pv_custodycd   IN   VARCHAR2,
      pv_feeamt IN number,
      pv_ccycd in VARCHAR2,
      pv_feecd in VARCHAR2,
      pv_round in number,
      pv_taxamt OUT number,
      pv_taxrate OUT number

   )
   RETURN NUMBER
   IS
   tax_amt number(20,4);
   tax_rate number(20,4);
   v_min number(20,4);
   l_min number(20,4);
   l_count number;
   v_sqlStr varchar2(1000);
   l_amcid varchar2(20);
   l_gcbid varchar2(20);
   v_currdate varchar2(20);
  Type ref_cursor is ref cursor;
  type fee_record is record(
      autoid       cffeeexp.autoid%type,
      vatrate      cffeeexp.vatrate%type

  );

    cur   ref_cursor;
    fee_row fee_record;
    type ty_fee is table of fee_record index by binary_integer;
    tax_list         ty_fee;
    l_ca_cache_size number(23) := 100000;
    l_row           pls_integer;
   BEGIN
pv_taxamt:=0;
pv_taxrate:=0;
SELECT VARVALUE CURRDATE INTO v_currdate
FROM SYSVAR
WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE';

     begin
     select amcid, gcbid INTO l_amcid,l_gcbid FROM cfmast WHERE custodycd = pv_custodycd;
     exception when others then
       l_amcid :=null;
       l_gcbid :=null;
     end;

     select count(*) into l_count from cffeeexp cf
     where custodycd = pv_custodycd and cf.feecd = pv_feecd
           and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR') and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR') and cf.ccycd = pv_ccycd;

     if l_count > 0 then --theo fund
       v_sqlStr := 'select cf.autoid, cf.vatrate  from cffeeexp cf where cf.feecd = ''' || pv_feecd || '''  and cf.CUSTODYCD = ''' || pv_custodycd || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''', ''DD/MM/RRRR'') and cf.expdate >= to_date(''' || v_currdate || ''', ''DD/MM/RRRR'') and cf.ccycd ='''||  pv_ccycd|| ''''
       ;
     else
       l_count := 0;

       select count(amcid) INTO l_count FROM cffeeexp cf
       where amcid = l_amcid and cf.feecd = pv_feecd
             and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
             and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR')
             and cf.ccycd = pv_ccycd;

       if l_count > 0 then --theo amc
         v_sqlStr := 'select cf.autoid, cf.vatrate  from cffeeexp cf where cf.feecd = ''' || pv_feecd || '''  and cf.AMCID = ''' || l_amcid || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''', ''DD/MM/RRRR'') and cf.expdate >= to_date(''' || v_currdate || ''', ''DD/MM/RRRR'') and cf.ccycd ='''||  pv_ccycd|| ''''
         ;
       else
         l_count := 0;

         select count(amcid) INTO l_count FROM cffeeexp cf
         where amcid = l_gcbid and cf.feecd = v_currdate
               and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
               and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR')
               and cf.ccycd = pv_ccycd;

         if l_count > 0 then --theo gcb
           v_sqlStr := 'select cf.autoid, cf.vatrate from cffeeexp cf    where cf.feecd = ''' || pv_feecd || ''' and cf.AMCID = ''' || l_gcbid || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''', ''DD/MM/RRRR'') and cf.expdate >= to_date(''' || v_currdate || ''', ''DD/MM/RRRR'') and cf.ccycd ='''||  pv_ccycd|| ''''
           ;
         else --theo master
           v_sqlStr := 'select  fe.feecd,fe.vatrate
                from feemaster fe
                where fe.ccycd ='''||  pv_ccycd|| ''' and fe.feecd = ''' || pv_feecd || '''' || ' and fe.status = ''Y'''
            ;
         end if;
       end if;
     end if;
    OPEN cur FOR v_sqlStr;
    BEGIN
        LOOP
            fetch cur bulk collect
                into tax_list limit l_ca_cache_size;
            exit when tax_list.count = 0;
            l_row := tax_list.first;
            l_min := tax_list.first;

            while (l_row is not null)
            loop
                 fee_row := tax_list(l_row);
                 tax_amt := (fee_row.vatrate/100)*pv_feeamt;
                 tax_rate := fee_row.vatrate;
                 l_row := tax_list.next(l_row);
            end loop;
   --trung.luu: SHBVNEX-1707 --luon lam tron 2
        --trung.luu: SHBVNEX-825 Tat ca cac loai phi tinh VND round,0 (USD round,2)
        if pv_ccycd = 'VND' then
            pv_taxamt := round(tax_amt,0);
        else
            pv_taxamt := round(tax_amt,2);
        end if;
        pv_taxrate := tax_rate;
        end loop;
    RETURN 0;
    EXCEPTION WHEN OTHERS THEN RETURN -1;
    END;
   END fn_tax_calc;

FUNCTION fn_tax_calc2(
        pv_custodycd   IN   VARCHAR2,
        pv_feeamt IN number,
        pv_ccycd in VARCHAR2,
        pv_feecd in VARCHAR2,
        pv_round in number,
        pv_txdate in date,
        pv_taxamt OUT number,
        pv_taxrate OUT number
    )
    RETURN NUMBER
    IS
    tax_amt number(20,4);
    tax_rate number(20,4);
    v_min number(20,4);
    l_min number(20,4);
    l_count number;
    v_sqlStr varchar2(1000);
    l_amcid varchar2(20);
    l_gcbid varchar2(20);
    v_currdate varchar2(20);
    Type ref_cursor is ref cursor;
    type fee_record is record(
        autoid       cffeeexp.autoid%type,
        vatrate      cffeeexp.vatrate%type
    );

    cur ref_cursor;
    fee_row fee_record;
    type ty_fee is table of fee_record index by binary_integer;
    tax_list         ty_fee;
    l_ca_cache_size number(23) := 100000;
    l_row           pls_integer;
    BEGIN
    pv_taxamt:=0;
    pv_taxrate:=0;

    v_currdate := to_char(pv_txdate, SYSTEMNUMS.C_DATE_FORMAT);

    begin
        select amcid, gcbid INTO l_amcid,l_gcbid FROM cfmast WHERE custodycd = pv_custodycd;
    exception when others then
        l_amcid :=null;
        l_gcbid :=null;
    end;

    select count(*) into l_count from cffeeexp cf
    where custodycd = pv_custodycd and cf.feecd = pv_feecd
    and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR') and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR') and cf.ccycd = pv_ccycd;

    if l_count > 0 then --theo fund
        v_sqlStr := 'select cf.autoid, cf.vatrate  from cffeeexp cf where cf.feecd = ''' || pv_feecd || '''  and cf.CUSTODYCD = ''' || pv_custodycd || ''''
        || ' and cf.effdate <= to_date(''' || v_currdate || ''', ''DD/MM/RRRR'') and cf.expdate >= to_date(''' || v_currdate || ''', ''DD/MM/RRRR'') and cf.ccycd ='''||  pv_ccycd|| '''';
    else
        l_count := 0;

        select count(amcid) INTO l_count FROM cffeeexp cf
        where amcid = l_amcid and cf.feecd = pv_feecd
        and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
        and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR')
        and cf.ccycd = pv_ccycd;

        if l_count > 0 then --theo amc
            v_sqlStr := 'select cf.autoid, cf.vatrate  from cffeeexp cf where cf.feecd = ''' || pv_feecd || '''  and cf.AMCID = ''' || l_amcid || ''''
            || ' and cf.effdate <= to_date(''' || v_currdate || ''', ''DD/MM/RRRR'') and cf.expdate >= to_date(''' || v_currdate || ''', ''DD/MM/RRRR'') and cf.ccycd ='''||  pv_ccycd|| '''';
        else
            l_count := 0;

            select count(amcid) INTO l_count FROM cffeeexp cf
            where amcid = l_gcbid and cf.feecd = v_currdate
            and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
            and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR')
            and cf.ccycd = pv_ccycd;

            if l_count > 0 then --theo gcb
                v_sqlStr := 'select cf.autoid, cf.vatrate from cffeeexp cf    where cf.feecd = ''' || pv_feecd || ''' and cf.AMCID = ''' || l_gcbid || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''', ''DD/MM/RRRR'') and cf.expdate >= to_date(''' || v_currdate || ''', ''DD/MM/RRRR'') and cf.ccycd ='''||  pv_ccycd|| '''';
            else --theo master
                v_sqlStr := 'select  fe.feecd,fe.vatrate
                from feemaster fe
                where fe.ccycd ='''||  pv_ccycd|| ''' and fe.feecd = ''' || pv_feecd || '''' || ' and fe.status = ''Y''';
            end if;
        end if;
    end if;
    OPEN cur FOR v_sqlStr;
    BEGIN
        LOOP
            fetch cur bulk collect
            into tax_list limit l_ca_cache_size;
            exit when tax_list.count = 0;
            l_row := tax_list.first;
            l_min := tax_list.first;

            while (l_row is not null)
            loop
                 fee_row := tax_list(l_row);
                 tax_amt := (fee_row.vatrate/100)*pv_feeamt;
                 tax_rate := fee_row.vatrate;
                 l_row := tax_list.next(l_row);
            end loop;
   --trung.luu: SHBVNEX-1707 --luon lam tron 2
        --trung.luu: SHBVNEX-825 Tat ca cac loai phi tinh VND round,0 (USD round,2)
        if pv_ccycd = 'VND' then
            pv_taxamt := round(tax_amt,0);
        else
            pv_taxamt := round(tax_amt,2);
        end if;
        pv_taxrate := tax_rate;
        end loop;
    RETURN 0;
    EXCEPTION WHEN OTHERS THEN RETURN -1;
    END;
   END fn_tax_calc2;

FUNCTION FN_CB_OVERSEAS_CALC (
      pv_custodycd   IN   VARCHAR2,
      pv_amt  IN number,
      pv_qtty  IN number,
      pv_subfee in varchar2,
      pv_feecd OUT VARCHAR2,
      pv_feeamt OUT number,
      pv_feerate OUT number,
      pv_ccycd OUT VARCHAR2,
      pv_forp OUT varchar2
   )
   RETURN NUMBER
   IS
   fee_amt number(20,4);

   v_feeval number(20,4);
   v_tierval number(20,4);

   v_min number(20,4);
   l_min number(20,4);

   l_count number;
   v_sqlStr varchar2(1000);

   l_amcid varchar2(20);
   l_gcbid varchar2(20);
   v_currdate varchar2(50);
  Type ref_cursor is ref cursor;
  type fee_record is record(
      autoid       cffeeexp.autoid%type,
      feecd        cffeeexp.feecd%type,
      custodycd    cffeeexp.custodycd%type,
      effdate      cffeeexp.effdate%type,
      expdate      cffeeexp.expdate%type,
      minval       cffeeexp.minval%type,
      maxval       cffeeexp.maxval%type,
      feeval       cffeeexp.feeval%type,
      forp         feemaster.forp%type,
      ccycd        feemaster.ccycd%type,
      feecalc      feemaster.feecalc%type
  );

    cur   ref_cursor;
    fee_row fee_record;

    type ty_fee is table of fee_record index by binary_integer;

    fee_list         ty_fee;
    l_ca_cache_size number(23) := 100000;
    l_row           pls_integer;

   BEGIN
   pv_feeamt:=0;
    pv_feerate:=0;
      SELECT VARVALUE CURRDATE INTO v_currdate
FROM SYSVAR
WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE';
     pv_ccycd:='VND';
     begin
     select amcid, gcbid INTO l_amcid,l_gcbid FROM cfmast WHERE custodycd = pv_custodycd;
     exception when others then
       l_amcid :=null;
       l_gcbid :=null;
     end;

     select count(*) into l_count from cffeeexp cf, feemaster fe
     where custodycd = pv_custodycd and cf.feecd = fe.feecd and fe.subtype = pv_subfee and fe.refcode = 'OTHER'
           and fe.status = 'Y'
           and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR') and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR') ;
--trung.luu : 26/06/2020 SHBVNEX-825 neu khai bieu phi rieng thi lay ccycd theo bieu phi rieng
     if l_count > 0 then --theo fund
       v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd)ccycd, mst.feecalc
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.CUSTODYCD = ''' || pv_custodycd || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'OTHER' || ''''
                || ' and mst.subtype = ''' || pv_subfee || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')' ;

     else
       l_count := 0;

       select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
       where amcid = l_amcid and cf.feecd = fe.feecd and fe.subtype = pv_subfee and fe.refcode = 'OTHER'
             and fe.status = 'Y'
             and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
             and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR');

       if l_count > 0 then --theo amc
         v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd)ccycd, mst.feecalc
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_amcid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'OTHER' || ''''
                || ' and mst.subtype = ''' || pv_subfee || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')';


         --return l_result;
       else
         l_count := 0;

         select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
         where amcid = l_gcbid and cf.feecd = fe.feecd and fe.subtype = pv_subfee and fe.refcode = 'OTHER'
               and fe.status = 'Y'
               and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
               and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR');

         if l_count > 0 then --theo gcb
           v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd)ccycd, mst.feecalc
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_gcbid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'OTHER' || ''''
                || ' and mst.subtype = ''' || pv_subfee || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')';


         else --theo master
           v_sqlStr := 'select null autoid, cf.feecd, null custodycd, null effdate, null expdate,
                    cf.minval, cf.maxval,
                    case when cf.forp = ''F'' then cf.feeamt
                         else cf.feerate
                    end feeval, cf.forp, cf.ccycd, cf.feecalc
                from feemaster cf
                where cf.refcode = ''' || 'OTHER' || ''''
                || ' and cf.subtype = ''' || pv_subfee || ''''
                || ' and cf.status = ''Y''';
         end if;
       end if;
     end if;

 
    OPEN cur FOR v_sqlStr;
    BEGIN
    LOOP
    fetch cur bulk collect
        into fee_list limit l_ca_cache_size;
    exit when fee_list.count = 0;

    l_row := fee_list.first;
    l_min := fee_list.first;

    while (l_row is not null)
    loop
     fee_row := fee_list(l_row);

     if fee_row.autoid is null then--bac thang feetier
       if fee_row.feecalc = '1' then
           begin
                select feeval into v_tierval from feetier
                where frval <= pv_amt and pv_amt < toval and fee_row.feecd = feecd;
           exception when others then v_tierval:=0;
           end;
           v_feeval := fee_row.feeval +nvl(v_tierval,0);
        else
           v_feeval := fee_row.feeval;
        end if;
     elsif
       fee_row.autoid is not null then --bac thang rieng
        if fee_row.feecalc = '1' then
           begin
               select feeval into v_tierval from cffeeexptier
               where frval <= pv_amt and pv_amt < toval and fee_row.autoid = refautoid;
           exception when others then v_tierval:=0;
           end;
           v_feeval := fee_row.feeval +nvl(v_tierval,0);
        else
           v_feeval := fee_row.feeval;
        end if;
     end if;
     fee_row.feeval := v_feeval;
     if fee_row.FORP = 'P' then
        fee_amt := v_feeval * pv_amt/100;
     else
        fee_amt := v_feeval ;
     end if;

     if l_row = fee_list.first then
       v_min := fee_amt;
     end if;

     if fee_amt < v_min then
       v_min := fee_amt;
       l_min := l_row;
     end if;
     l_row := fee_list.next(l_row);
    end loop;
    --trung.luu 02-12-2020 SHBVNEX-1303 khong lam tron buoc nay
    pv_feeamt := round(GREATEST(LEAST(fee_amt,fee_list(l_min).maxval),fee_list(l_min).minval),2);
     --trung.luu: Tat ca cac loai phi tinh VND round,0 (USD round,2)
    /*if fee_list(l_min).ccycd = 'VND' then
        pv_feeamt := round(GREATEST(LEAST(fee_amt,fee_list(l_min).maxval),fee_list(l_min).minval),0);
    else
        pv_feeamt := round(GREATEST(LEAST(fee_amt,fee_list(l_min).maxval),fee_list(l_min).minval),2);
    end if;*/

    plog.error('maxval: '||fee_list(l_min).maxval||',minval: '||fee_list(l_min).minval||',feeamt: '||fee_amt);
    pv_feecd := fee_list(l_min).feecd;
    pv_ccycd := fee_list(l_min).ccycd;
    pv_feerate := fee_list(l_min).feeval;
    pv_forp := fee_list(l_min).forp;
    END LOOP;
    RETURN 0;
    EXCEPTION WHEN OTHERS THEN
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        RETURN -1;
    END;
   END FN_CB_OVERSEAS_CALC;


   FUNCTION fn_sedepo_manual_calc (
      pv_custodycd   IN   VARCHAR2,
      pv_amt  IN number,
      pv_qtty  IN number,
      pv_day  IN number,
      pv_feecd OUT VARCHAR2,
      pv_feeamt OUT number,
      pv_feerate OUT number,
      pv_ccycd OUT VARCHAR2,
      pv_feecode OUT VARCHAR2
   )
   RETURN NUMBER
   IS
   fee_amt number(20,4);

   v_feeval number(20,4);
   v_tierval number(20,4);

   v_min number(20,4);
   l_min number(20,4);

   v_daybase number(20,4);
   v_monbase number(20,4);
   v_daynum number(20,4);

   l_count number;
   v_sqlStr varchar2(1000);

   l_amcid varchar2(20);
   l_gcbid varchar2(20);
   v_currdate varchar2(50);
   l_BOMDATE    date;
   l_EOMDATE    date;
   v_forp varchar2(10);
  Type ref_cursor is ref cursor;
  type fee_record is record(
      autoid       cffeeexp.autoid%type,
      feecd        cffeeexp.feecd%type,
      custodycd    cffeeexp.custodycd%type,
      effdate      cffeeexp.effdate%type,
      expdate      cffeeexp.expdate%type,
      minval       cffeeexp.minval%type,
      maxval       cffeeexp.maxval%type,
      feeval       cffeeexp.feeval%type,
      forp         feemaster.forp%type,
      ccycd        feemaster.ccycd%type,
      feecalc      feemaster.feecalc%type,
      feecode      feemaster.feecode%type
  );

    cur   ref_cursor;
    fee_row fee_record;

    type ty_fee is table of fee_record index by binary_integer;

    fee_list         ty_fee;
    l_ca_cache_size number(23) := 100000;
    l_row           pls_integer;

   BEGIN
   pv_feeamt:=0;
pv_feerate:=0;
      SELECT VARVALUE CURRDATE INTO v_currdate
FROM SYSVAR
WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE';
     begin
     select amcid, gcbid INTO l_amcid,l_gcbid FROM cfmast WHERE custodycd = pv_custodycd;
     exception when others then
       l_amcid :=null;
       l_gcbid :=null;
     end;
     select to_number(cdval) into v_daybase from allcode where cdname = 'DAYBASE' and cdtype = 'SY';
     select to_number(varvalue) into v_monbase from sysvar where varname = 'CSMON';
    -- Ngay dau thang
    SELECT TRUNC(getcurrdate,'MM') INTO l_BOMDATE FROM DUAL;
    -- Ngay cuoi thang
    SELECT ADD_MONTHS(l_BOMDATE, 1) -1 INTO l_EOMDATE FROM DUAL;
    v_daynum := (l_EOMDATE - l_BOMDATE)+1 ;

    --SELECT to_number(to_char(getcurrdate, 'DD')) into v_daynum from dual;

     select count(*) into l_count from cffeeexp cf, feemaster fe
     where custodycd = pv_custodycd and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'SEDEPO'
           and fe.status ='Y'
           and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
           and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR');
    --trung.luu : 26/06/2020 SHBVNEX-825 neu khai bieu phi rieng thi lay ccycd theo bieu phi rieng
     if l_count > 0 then --theo fund
       v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd)ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.CUSTODYCD = ''' || pv_custodycd || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'SEDEPO' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                ;
     else
       l_count := 0;

       select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
       where amcid = l_amcid and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'SEDEPO'
             and fe.status ='Y'
             and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
             and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR');

       if l_count > 0 then --theo amc
         v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_amcid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'SEDEPO' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                ;
         --return l_result;
       else
         l_count := 0;

         select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
         where amcid = l_gcbid and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'SEDEPO'
               and fe.status ='Y'
               and cf.effdate <= to_date(v_currdate,'DD/MM/RRRR')
               and cf.expdate >= to_date(v_currdate,'DD/MM/RRRR');

         if l_count > 0 then --theo gcb
           v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_gcbid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'SEDEPO' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                || ' and cf.expdate >= to_date(''' || v_currdate || ''',''DD/MM/RRRR'')'
                ;
         else --theo master
           v_sqlStr := 'select null autoid, cf.feecd, null custodycd, null effdate, null expdate,
                    cf.minval, cf.maxval,
                    case when cf.forp = ''F'' then cf.feeamt
                         else cf.feerate
                    end feeval, cf.forp, cf.ccycd, cf.feecalc, cf.feecode
                from feemaster cf
                where cf.refcode = ''' || 'SEDEPO' || ''''
                || ' and cf.subtype = ''' || '001' || ''''
                || ' and cf.status = ''Y'''
                ;
         end if;
       end if;
     end if;
 
    OPEN cur FOR v_sqlStr;
    BEGIN
    LOOP
    fetch cur bulk collect
        into fee_list limit l_ca_cache_size;
    exit when fee_list.count = 0;

    l_row := fee_list.first;
    l_min := fee_list.first;

    while (l_row is not null)
    loop
     fee_row := fee_list(l_row);
     --trung.luu: 05-10-2020 SHBVNEX-1673
     v_forp := fee_row.FORP;
     if fee_row.autoid is null then--bac thang feetier

       if fee_row.feecalc = '1' then
           begin
                select feeval into v_tierval from feetier
                where frval <= pv_amt and pv_amt < toval and fee_row.feecd = feecd;
           exception when others then v_tierval:=0;
           end;
           v_feeval := fee_row.feeval +nvl(v_tierval,0);
        else
           v_feeval := fee_row.feeval;
        end if;

     elsif

       fee_row.autoid is not null then --bac thang rieng
        if fee_row.feecalc = '1' then
           begin
               select feeval into v_tierval from cffeeexptier
               where frval <= pv_amt and pv_amt < toval and fee_row.autoid = refautoid;
           exception when others then v_tierval:=0;
           end;
           v_feeval := fee_row.feeval +nvl(v_tierval,0);
        else
           v_feeval := fee_row.feeval;
        end if;

     end if;

    fee_row.feeval := v_feeval;

     if fee_row.FORP = 'P' then
        fee_amt := v_feeval * pv_amt/100;
     else
--        fee_amt := v_feeval * pv_qtty; trung.luu: 02-10-2020 SHBVNEX-1673
        fee_amt := v_feeval;
     end if;

     if l_row = fee_list.first then
       v_min := fee_amt;
     end if;

     if fee_amt < v_min then
       v_min := fee_amt;
       l_min := l_row;
     end if;
     l_row := fee_list.next(l_row);
    end loop;
    if v_forp = 'P' then
        plog.error('fee_amt:'||fee_amt||'pv_day:'||pv_day||'v_daybase:'||v_daybase||'fee_list(l_min).minval:'||fee_list(l_min).minval||'fee_list(l_min).maxval:'||fee_list(l_min).maxval);
        pv_feeamt := GREATEST(LEAST(fee_amt * pv_day/v_daybase ,fee_list(l_min).maxval),fee_list(l_min).minval);
    else --trung.luu: 05-10-2020 SHBVNEX-1673
        pv_feeamt := GREATEST(LEAST(fee_amt *pv_day/v_monbase ,fee_list(l_min).maxval),fee_list(l_min).minval);
    end if;

    --trung.luu: Tat ca cac loai phi tinh VND round,0 (USD round,2)
    if fee_list(l_min).ccycd = 'VND' then
        pv_feeamt := round(pv_feeamt,0);
    else
        pv_feeamt := round(pv_feeamt,2);
    end if;
    pv_feecd := fee_list(l_min).feecd;
    pv_ccycd := fee_list(l_min).ccycd;
    pv_feerate := fee_list(l_min).feeval;
    pv_feecode:=fee_list(l_min).feecode;
    END LOOP;
    RETURN 0;
    EXCEPTION WHEN OTHERS THEN RETURN -1;
    END;
   END fn_sedepo_manual_calc;

END cspks_feecalc;
/
