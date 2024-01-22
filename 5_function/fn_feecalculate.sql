SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_feecalculate( pv_custodycd IN VARCHAR2, pv_amt NUMBER,pv_feetype IN VARCHAR2, pv_subtype IN VARCHAR2,pv_tltxcd IN VARCHAR2)
    RETURN VARCHAR2 IS
    l_Result  NUMBER;
    l_feemfeecalc VARCHAR2(100);
    l_feemforp VARCHAR2(100);
    l_feemfeeamt NUMBER ;
    l_feemfeerate NUMBER ;
    l_feemminval NUMBER ;
    l_feemmaxval NUMBER ;
    l_feemvatrate NUMBER ;
    l_feemccycd VARCHAR2(100);
    l_feemfeecd VARCHAR2(100);
    l_expfeeval NUMBER ;
    l_expminval NUMBER ;
    l_expmaxval NUMBER ;
    l_count NUMBER ;
    l_feeamt NUMBER ;
    l_feetierfeeval NUMBER ;
    l_amcid         NUMBER;
    v_taxrate  NUMBER(20,4);
    v_ccycd    VARCHAR2(20);
    l_gcbid    VARCHAR2(20);
    v_currdate DATE;
    l_refcode varchar2(10);
    l_subtype varchar2(10);
    l_tltx varchar2(5);
   BEGIN

    IF pv_tltxcd='6621' THEN
         V_CURRDATE:=GETCURRDATE;
        l_refcode:='OTHER';
        l_subtype:='014';
         --
         BEGIN
             SELECT AMCID, GCBID INTO l_amcid,l_gcbid FROM CFMAST WHERE CUSTODYCD = PV_CUSTODYCD;
         EXCEPTION
         WHEN OTHERS THEN
               l_amcid :=NULL;
               l_gcbid :=NULL;
         END;
         --
         SELECT COUNT(*)
         INTO l_count
         FROM CFFEEEXP CF, FEEMASTER MST
         WHERE CUSTODYCD = PV_CUSTODYCD
           AND CF.FEECD = MST.FEECD
           AND MST.STATUS ='Y'
           AND MST.SUBTYPE =  l_subtype
           AND MST.REFCODE = l_refcode
           AND CF.EFFDATE <= TO_DATE(V_CURRDATE)
           AND CF.EXPDATE  >= TO_DATE(V_CURRDATE);
         --
         IF l_count > 0 THEN --THEO FUND
            BEGIN
                SELECT CF.FEEVAL, MST.VATRATE, MST.CCYCD,CF.FEECD
                INTO l_feeamt, v_taxrate, v_ccycd,l_feemccycd
                FROM CFFEEEXP CF, FEEMASTER MST
                WHERE CF.FEECD = MST.FEECD
                  AND MST.STATUS ='Y'
                  AND CF.CUSTODYCD = PV_CUSTODYCD
                  AND MST.REFCODE = l_refcode
                  AND MST.SUBTYPE = l_subtype
                  AND CF.EFFDATE <= TO_DATE(V_CURRDATE)
                  AND CF.EXPDATE  >= TO_DATE(V_CURRDATE);
            EXCEPTION
            WHEN OTHERS THEN
                l_feeamt := 0;
            END;
            RETURN l_feeamt || '_' || l_feemccycd;
         ELSE
           l_count := 0;
           SELECT COUNT(AMCID)
           INTO l_count
           FROM CFFEEEXP CF, FEEMASTER MST
           WHERE AMCID = l_amcid
             AND CF.FEECD = MST.FEECD
             AND MST.STATUS = 'Y'
             AND MST.SUBTYPE = l_subtype
             AND MST.REFCODE = l_refcode
             AND CF.EFFDATE <= TO_DATE(V_CURRDATE);
           IF l_count > 0 THEN --THEO AMC
              BEGIN
                    SELECT CF.FEEVAL, MST.VATRATE, MST.CCYCD,CF.FEECD
                    INTO l_feeamt, v_taxrate, v_ccycd,l_feemccycd
                    FROM CFFEEEXP CF, FEEMASTER MST
                    WHERE CF.FEECD = MST.FEECD
                      AND MST.STATUS = 'Y'
                      AND CF.AMCID = l_amcid
                      AND MST.REFCODE = l_refcode
                      AND MST.SUBTYPE = l_subtype
                      AND CF.EFFDATE <= TO_DATE(V_CURRDATE);
              EXCEPTION
              WHEN OTHERS THEN
                l_feeamt := 0;
              END;
              RETURN l_feeamt || '_' || l_feemccycd;
           ELSE
                 l_count := 0;
                 SELECT COUNT(AMCID)
                 INTO l_count
                 FROM CFFEEEXP CF, FEEMASTER MST
                 WHERE AMCID = l_gcbid
                   AND MST.FEECD = MST.FEECD
                   AND MST.STATUS = 'Y'
                   AND MST.SUBTYPE = l_subtype
                   AND MST.REFCODE = l_refcode
                   AND CF.EFFDATE <= TO_DATE(V_CURRDATE);
             IF l_count > 0 THEN --THEO GCB
                     BEGIN
                        SELECT CF.FEEVAL, MST.VATRATE, MST.CCYCD,CF.FEECD
                        INTO l_feeamt, v_taxrate, v_ccycd,l_feemccycd
                        FROM CFFEEEXP CF, FEEMASTER MST
                        WHERE CF.FEECD = MST.FEECD
                          AND CF.AMCID = l_gcbid
                          AND MST.STATUS = 'Y'
                          AND MST.REFCODE = l_refcode
                          AND MST.SUBTYPE = l_subtype
                          AND CF.EFFDATE <= TO_DATE(V_CURRDATE);
                     EXCEPTION
                     WHEN OTHERS THEN
                        l_feeamt :=0;
                     END;
                     RETURN l_feeamt || '_' || l_feemccycd;
             ELSE --THEO MASTER
                     BEGIN
                          SELECT (CASE WHEN MST.FORP = 'F' THEN MST.FEEAMT ELSE MST.FEERATE END) FEEVAL, MST.VATRATE, MST.CCYCD ,MST.FEECD
                          INTO l_feeamt, v_taxrate, v_ccycd,l_feemccycd
                          FROM FEEMASTER MST
                          WHERE MST.STATUS ='Y'
                            AND MST.REFCODE = l_refcode
                            AND MST.SUBTYPE = l_subtype;
                     EXCEPTION
                     WHEN OTHERS THEN
                        l_feeamt :=0;
                     END;
                     RETURN l_feeamt || '_' || l_feemccycd;
             END IF;
           END IF;
         END IF;
    ELSE
        BEGIN
          SELECT  fee.feecd, feeval_cff, minval, maxval, count(1)
          into l_feemfeecd, l_expfeeval, l_feemminval,l_feemmaxval, l_count
          from
          (SELECT cf.autoid,cf.feecd,
            nvl(ti.frval,0) frval,nvl(ti.toval,0) toval,
            t.min_frval, t.max_toval,
            case
             WHEN pv_amt < min_frval then (select t2.feeval from cffeeexptier t2
                                              where t2.frval = t.min_frval and t2.refautoid = t.refautoid)
             WHEN (frval <= pv_amt and pv_amt < toval) then ti.feeval
             WHEN (pv_amt >= max_toval) then (select t2.feeval from cffeeexptier t2
                                              where t2.toval = t.max_toval and t2.refautoid = t.refautoid)
             WHEN (ti.refautoid is null) then cf.feeval
           end feeval_cff,
           cf.minval,cf.maxval
            FROM CFFEEEXP  cf, feemaster mst, cffeeexptier ti,
            (select max(ex.toval) max_toval, min(ex.frval) min_frval, ex.refautoid
             from cffeeexptier ex, CFFEEEXP cf
             where cf.autoid = ex.refautoid
                   and cf.custodycd = pv_custodycd
             group by ex.refautoid) t,
            (select to_date(varvalue,'dd/mm/yyyy') currdate from sysvar
                   where grname = 'SYSTEM' and varname ='CURRDATE') sy
            WHERE cf.custodycd = pv_custodycd
                  and cf.feecd = mst.feecd
                  --trung.luu: 09/06/2020 SHBVNEX-893
                  and mst.status = 'Y'
                  and mst.refcode = pv_feetype
                  and mst.subtype = pv_subtype
                  and cf.effdate <= sy.currdate
                  and cf.expdate > sy.currdate
                  and cf.autoid = ti.refautoid(+)
                  and cf.autoid = t.refautoid(+)
                  ) fee
        where feeval_cff is not null
              and ROWNUM = 1
        order by fee.feeval_cff;
        EXCEPTION
        WHEN OTHERS THEN
            l_feemfeecd:=0;
            l_expfeeval:=0;
            l_expminval:=0;
            l_expmaxval:=0;
        END ;
        IF l_count>0 THEN
            SELECT f.FORP into l_feemforp from feemaster f where f.feecd = l_feemfeecd;
            IF l_feemforp ='F' THEN
            l_feeamt:= GREATEST(LEAST(l_expfeeval,l_expmaxval ),l_expminval);
            ELSIF l_feemforp ='P' THEN
            l_feeamt:= GREATEST(LEAST( l_expfeeval*pv_amt/100,l_expmaxval ),l_expminval);
            END IF;
            RETURN l_feeamt || '_' || l_feemccycd;
        END IF ;

        --AMC
        BEGIN
            SELECT amcid INTO l_amcid FROM faacctmain WHERE custodycd = pv_custodycd;
             --AND amcid = CFFEEEXP.amcid
            SELECT  fee.feecd, feeval_cff, minval, maxval, count(1)
                  into l_feemfeecd, l_expfeeval, l_feemminval,l_feemmaxval, l_count
            from
            (SELECT cf.autoid,cf.feecd,
            nvl(ti.frval,0) frval,nvl(ti.toval,0) toval,
            t.min_frval, t.max_toval,
            case
             WHEN pv_amt < min_frval then (select t2.feeval from cffeeexptier t2
                                              where t2.frval = t.min_frval and t2.refautoid = t.refautoid)
             WHEN (frval <= pv_amt and pv_amt < toval) then ti.feeval
             WHEN (pv_amt >= max_toval) then (select t2.feeval from cffeeexptier t2
                                              where t2.toval = t.max_toval and t2.refautoid = t.refautoid)
             WHEN (ti.refautoid is null) then cf.feeval
           end feeval_cff,
           cf.minval,cf.maxval
            FROM CFFEEEXP  cf, feemaster mst, cffeeexptier ti,
            (select max(ex.toval) max_toval, min(ex.frval) min_frval, ex.refautoid
             from cffeeexptier ex, CFFEEEXP cf
             where cf.autoid = ex.refautoid
                   and cf.amcid = l_amcid
             group by ex.refautoid) t,
            (select to_date(varvalue,'dd/mm/yyyy') currdate from sysvar
                   where grname = 'SYSTEM' and varname ='CURRDATE') sy
            WHERE cf.amcid = l_amcid
                  and cf.feecd = mst.feecd
                  --trung.luu: 09/06/2020 SHBVNEX-893
                  and mst.status = 'Y'
                  and mst.refcode = 'SEDEPO'
                  and mst.subtype = '001'
                  and cf.effdate <= sy.currdate
                  and cf.expdate > sy.currdate
                  and cf.autoid = ti.refautoid(+)
                  and cf.autoid = t.refautoid(+)
                  ) fee
        where feeval_cff is not null
              and ROWNUM = 1
        order by fee.feeval_cff;
        EXCEPTION
        WHEN OTHERS THEN
            l_feemfeecd:=0;
            l_expfeeval:=0;
            l_expminval:=0;
            l_expmaxval:=0;
        END ;
        IF l_count>0 THEN
            SELECT f.FORP into l_feemforp from feemaster f where f.feecd = l_feemfeecd;
            IF l_feemforp ='F' THEN
            l_feeamt:= GREATEST(LEAST(l_expfeeval,l_expmaxval ),l_expminval);
            ELSIF l_feemforp ='P' THEN
            l_feeamt:= GREATEST(LEAST( l_expfeeval*pv_amt/100,l_expmaxval ),l_expminval);
            END IF;
            RETURN l_feeamt || '_' || l_feemccycd;
            -- RETURN l_feeamt || '_' || l_feemccycd;
        END IF ;
    END IF;

    RETURN l_feeamt || '_' || l_feemccycd;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
