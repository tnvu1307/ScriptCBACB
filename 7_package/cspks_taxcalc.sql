SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_taxcalc IS

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

END;
/


CREATE OR REPLACE PACKAGE BODY cspks_taxcalc is
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
   v_currdate date;
   l_BOMDATE    date;
   l_EOMDATE    date;
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
     v_currdate:=getcurrdate;
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
           and cf.effdate <= to_date(v_currdate) and cf.expdate  >= to_date(v_currdate);
    --trung.luu : 26/06/2020 SHBVNEX-825 neu khai bieu phi rieng thi lay ccycd theo bieu phi rieng
     if l_count > 0 then --theo fund
       v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, cf.feeval, mst.forp, nvl(cf.ccycd,mst.ccycd)ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.CUSTODYCD = ''' || pv_custodycd || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'SEDEPO' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''')'
                || ' and cf.expdate  >= to_date(''' || v_currdate || ''')'
                ;
     else
       l_count := 0;

       select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
       where amcid = l_amcid and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'SEDEPO'
             and fe.status ='Y'
             and cf.effdate <= to_date(v_currdate);
             --and cf.expdate  > to_date(v_currdate);

       if l_count > 0 then --theo amc
         v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, cf.feeval, mst.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_amcid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'SEDEPO' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''')'
                --|| ' and cf.expdate  > to_date(''' || v_currdate || ''')'
                ;
         --return l_result;
       else
         l_count := 0;

         select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
         where amcid = l_gcbid and cf.feecd = fe.feecd and fe.subtype = '001' and fe.refcode = 'SEDEPO'
               and fe.status ='Y'
               and cf.effdate <= to_date(v_currdate);
               --and cf.expdate  > to_date(v_currdate);

         if l_count > 0 then --theo gcb
           v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, cf.feeval, mst.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_gcbid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'SEDEPO' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''')'
                --|| ' and cf.expdate  > to_date(''' || v_currdate || ''')'
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
    pv_feeamt := round(GREATEST(LEAST(fee_amt * v_daynum/v_daybase ,fee_list(l_min).maxval),fee_list(l_min).minval),2);
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
   v_currdate date;
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
     v_currdate:=getcurrdate;
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
           and cf.effdate <= to_date(v_currdate) and cf.expdate  >= to_date(v_currdate) ;
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
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''dd/MM/RRRR'')'
                || ' and cf.expdate  >= to_date(''' || v_currdate || ''',''dd/MM/RRRR'')' ;

     else
       l_count := 0;

       select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
       where amcid = l_amcid and cf.feecd = fe.feecd and fe.subtype = '014' and fe.refcode = 'OTHER'
             and fe.status = 'Y'
             and cf.effdate <= to_date(v_currdate);
             --and cf.expdate  > to_date(v_currdate);

       if l_count > 0 then --theo amc
         v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd)ccycd, mst.feecalc
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_amcid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'OTHER' || ''''
                || ' and mst.subtype = ''' || '014' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''dd/MM/RRRR'')'  ;
                --|| ' and cf.expdate  > to_date(''' || v_currdate || ''')'


         --return l_result;
       else
         l_count := 0;

         select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
         where amcid = l_gcbid and cf.feecd = fe.feecd and fe.subtype = '014' and fe.refcode = 'OTHER'
               and fe.status = 'Y'
               and cf.effdate <= to_date(v_currdate);
               --and cf.expdate  > to_date(v_currdate);

         if l_count > 0 then --theo gcb
           v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, nvl(cf.ccycd,mst.ccycd)ccycd, mst.feecalc
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_gcbid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'OTHER' || ''''
                || ' and mst.subtype = ''' || '014' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''',''dd/MM/RRRR'')' ;
                --|| ' and cf.expdate  > to_date(''' || v_currdate || ''')'


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
    pv_feeamt := GREATEST(LEAST(fee_amt,fee_list(l_min).maxval),fee_list(l_min).minval);
    
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
   v_currdate date;
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
    v_currdate:=getcurrdate;
    l_amcid:=pv_amcid;
    l_gcbid:=pv_gcbid;
     IF pv_cfdesc = 'FUND' THEN --theo fund
     --trung.luu : 26/06/2020 SHBVNEX-825 neu khai bieu phi rieng thi lay ccycd theo bieu phi rieng
       v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, cf.feeval, mst.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.CUSTODYCD = ''' || pv_custodycd || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'TRANREPAIR' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''')'
                || ' and cf.expdate  >= to_date(''' || v_currdate || ''')'
                ;
     ELSIF pv_cfdesc = 'AMC' THEN--theo amc
         v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, cf.feeval, mst.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_amcid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'TRANREPAIR' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''')'
                --|| ' and cf.expdate  > to_date(''' || v_currdate || ''')'
                ;
    ELSIF pv_cfdesc = 'GCB' THEN--theo gcb
           v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, cf.feeval, mst.forp, nvl(cf.ccycd,mst.ccycd) ccycd, mst.feecalc, mst.feecode
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_gcbid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'TRANREPAIR' || ''''
                || ' and mst.subtype = ''' || '001' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''')'
                --|| ' and cf.expdate  > to_date(''' || v_currdate || ''')'
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
    pv_feeamt := round(GREATEST(LEAST(fee_amt,fee_list(l_min).maxval),fee_list(l_min).minval),0);
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
   v_currdate date;
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
     v_currdate:=getcurrdate;
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
           and cf.effdate <= to_date(v_currdate) and cf.expdate  >= to_date(v_currdate) and fe.ccycd = pv_ccycd;

     if l_count > 0 then --theo fund
       v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end) feeval, cf.forp, mst.ccycd, mst.feecalc
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.CUSTODYCD = ''' || pv_custodycd || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'OTHER' || ''''
                || ' and mst.subtype = ''' || '004' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''')'
                || ' and cf.expdate  >= to_date(''' || v_currdate || ''') and mst.ccycd ='''||  pv_ccycd|| ''''
                ;
     else
       l_count := 0;

       select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
       where amcid = l_amcid and cf.feecd = fe.feecd and fe.subtype = '004' and fe.refcode = 'OTHER'
             and fe.status = 'Y'
             and cf.effdate <= to_date(v_currdate)
             --and cf.expdate  > to_date(v_currdate)
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
                || ' and cf.effdate <= to_date(''' || v_currdate || ''')'
                --|| ' and cf.expdate  > to_date(''' || v_currdate || ''')'
                || ' and mst.ccycd ='''||  pv_ccycd|| ''''
                ;
         --return l_result;
       else
         l_count := 0;

         select count(amcid) INTO l_count FROM cffeeexp cf, feemaster fe
         where amcid = l_gcbid and cf.feecd = fe.feecd and fe.subtype = '004' and fe.refcode = 'OTHER'
               and fe.status = 'Y'
               and cf.effdate <= to_date(v_currdate)
               --and cf.expdate  > to_date(v_currdate)
               and fe.ccycd = pv_ccycd;

         if l_count > 0 then --theo gcb
           v_sqlStr := 'select cf.autoid, cf.feecd, cf.custodycd, cf.effdate, cf.expdate,
                    cf.minval, cf.maxval, (case when cf.forp  = ''F'' then cf.feeval else cf.feerate end)feeval, cf.forp, mst.ccycd, mst.feecalc
                from cffeeexp cf, feemaster mst
                where cf.feecd = mst.feecd
                and cf.AMCID = ''' || l_gcbid || ''''
                || ' and mst.status = ''Y'''
                || ' and mst.refcode = ''' || 'OTHER' || ''''
                || ' and mst.subtype = ''' || '004' || ''''
                || ' and cf.effdate <= to_date(''' || v_currdate || ''')'
                --|| ' and cf.expdate  > to_date(''' || v_currdate || ''')'
                || ' and mst.ccycd ='''||  pv_ccycd|| ''''
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
    pv_feeamt := round(GREATEST(LEAST(fee_amt,fee_list(l_min).maxval),fee_list(l_min).minval),0);
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
   V_CURRDATE DATE;
   BEGIN
         V_CURRDATE:=GETCURRDATE;
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
               CF.EFFDATE <= TO_DATE(V_CURRDATE) AND
               CF.EXPDATE  >= TO_DATE(V_CURRDATE);
         --
         --trung.luu : 26/06/2020 SHBVNEX-825 neu khai bieu phi rieng thi lay ccycd theo bieu phi rieng
         IF L_COUNT > 0 THEN --THEO FUND
            BEGIN
                SELECT CF.FEEVAL, MST.VATRATE, nvl(cf.CCYCD,MST.CCYCD)CCYCD, MST.FEECODE, MST.FEECD
                INTO V_FEE_AMT, V_TAXRATE, V_CCYCD, V_FEECODE, V_FEECD
                FROM CFFEEEXP CF, FEEMASTER MST
                WHERE CF.FEECD = MST.FEECD AND
                      MST.STATUS ='Y' AND
                      CF.CUSTODYCD = PV_CUSTODYCD AND
                      MST.REFCODE = PV_REFCODE AND
                      MST.SUBTYPE = PV_SUBTYPE AND
                      CF.EFFDATE <= TO_DATE(V_CURRDATE) AND
                      CF.EXPDATE  >= TO_DATE(V_CURRDATE);
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
                 CF.EFFDATE <= TO_DATE(V_CURRDATE);
           IF L_COUNT > 0 THEN --THEO AMC
              BEGIN
                    SELECT CF.FEEVAL, MST.VATRATE, nvl(cf.CCYCD,MST.CCYCD)CCYCD, MST.FEECODE, MST.FEECD
                    INTO V_FEE_AMT, V_TAXRATE, V_CCYCD, V_FEECODE, V_FEECD
                    FROM CFFEEEXP CF, FEEMASTER MST
                    WHERE CF.FEECD = MST.FEECD AND
                          MST.STATUS = 'Y' AND
                          CF.AMCID = L_AMCID AND
                          MST.REFCODE = PV_REFCODE AND
                          MST.SUBTYPE = PV_SUBTYPE AND
                          CF.EFFDATE <= TO_DATE(V_CURRDATE);
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
                   CF.EFFDATE <= TO_DATE(V_CURRDATE);
             IF L_COUNT > 0 THEN --THEO GCB
                 BEGIN
                       SELECT CF.FEEVAL, MST.VATRATE, nvl(cf.CCYCD,MST.CCYCD)CCYCD, MST.FEECODE, MST.FEECD
                       INTO V_FEE_AMT, V_TAXRATE, V_CCYCD, V_FEECODE, V_FEECD
                       FROM CFFEEEXP CF, FEEMASTER MST
                       WHERE CF.FEECD = MST.FEECD AND
                             CF.AMCID = L_GCBID AND
                             MST.STATUS = 'Y' AND
                             MST.REFCODE = PV_REFCODE AND
                             MST.SUBTYPE = PV_SUBTYPE AND
                             CF.EFFDATE <= TO_DATE(V_CURRDATE);
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
        PV_FEECODE := V_FEECODE;
        PV_FEECD   := V_FEECD;
        RETURN V_FEE_AMT;
        EXCEPTION WHEN OTHERS THEN RETURN 0;
    END FN_GET_FEEAMT_WITHOUT_TIER;

END cspks_taxcalc;
/
