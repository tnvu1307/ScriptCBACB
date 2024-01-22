SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE od6050 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Ngay tao bao cao*/
   T_DATE                 IN       VARCHAR2,
   PV_CIFID           IN       VARCHAR2
   )
IS
    V_STROPTION    VARCHAR2 (5);
    V_STRBRID      VARCHAR2 (4);
    V_cifid     VARCHAR2 (100);
    v_FromDate          date;
    v_ToDate            date;
BEGIN

    V_STROPTION := OPT;

    if v_stroption = 'A' then
        v_strbrid := '%';
    elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
    else
        v_strbrid:=brid;
    end if;
    V_cifid := PV_CIFID;
     v_FromDate  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

OPEN PV_REFCURSOR FOR
SELECT distinct cf.fullname,cf.cifid,cf.custid,cf.custodycd,tltxcd,TL.typefx,txnum,txdate,
        CASE WHEN tltxcd IN ('6701','6704') THEN
            CASE WHEN sccycd <> 'VND' THEN UTILS.SO_THANH_CHU2(to_char(AMT))
            WHEN rccycd <> 'VND' THEN UTILS.SO_THANH_CHU2(to_char(EXCHANGEAMT)) ELSE '' END
        WHEN tltxcd ='6703' THEN
            CASE WHEN RCCYCD <> 'VND' THEN UTILS.SO_THANH_CHU2(to_char(AMT)) ELSE DECODE(sccycd,'VND','',UTILS.SO_THANH_CHU2(to_char(AMT))) END
        WHEN tltxcd ='6702' THEN
            CASE WHEN RCCYCD <> 'VND' THEN UTILS.SO_THANH_CHU2(to_char(AMT)) ELSE DECODE(sccycd,'VND','',UTILS.SO_THANH_CHU2(to_char(AMT))) END
        ELSE UTILS.SO_THANH_CHU2(to_char(AMT)) END amt,
        CASE WHEN tltxcd = '6701' AND sccycd = rccycd THEN ''
            WHEN tltxcd = '6702' THEN CASE WHEN RCCYCD <> 'VND' THEN '' ELSE DECODE(sccycd,'VND','',UTILS.SO_THANH_CHU2(TO_CHAR(exchangerate))) END
            WHEN tltxcd = '6703' THEN CASE WHEN RCCYCD <> 'VND' THEN '' ELSE DECODE(sccycd,'VND','',UTILS.SO_THANH_CHU2(TO_CHAR(exchangerate))) END
        ELSE UTILS.SO_THANH_CHU2(TO_CHAR(exchangerate)) END exchangerate,
        CASE WHEN (tltxcd = '6702' AND rccycd ='VND') OR (tltxcd = '6703' AND rccycd ='VND' AND sccycd <> 'VND' ) THEN UTILS.SO_THANH_CHU2(TO_CHAR(EXCHANGEAMT))
        WHEN (tltxcd IN ('6701','6704') AND sccycd = 'VND') OR (tltxcd = '6703' AND rccycd ='VND' AND sccycd = 'VND' ) THEN UTILS.SO_THANH_CHU2(TO_CHAR(AMT))
        WHEN tltxcd IN ('6701','6704') AND rccycd = 'VND' THEN UTILS.SO_THANH_CHU2(TO_CHAR(EXCHANGEAMT))
        ELSE '' END exchangeamt,
        CASE WHEN tltxcd = '6701' THEN
            (CASE WHEN sccycd <> 'VND' AND rccycd = 'VND' THEN decode(typefx,'D','(Debit ','(Credit ')|| decode(typefx,'D',sccycd,rccycd)|| ' '|| utils.so_thanh_chu2 (decode(decode(typefx,'D',sccycd,rccycd),'VND',exchangeamt,amt))|| ')'
                  WHEN sccycd = 'VND' AND rccycd <> 'VND' THEN decode(typefx,'D','(Debit ','(Credit ')|| decode(typefx,'D',sccycd,rccycd)|| ' '|| utils.so_thanh_chu2 (decode(decode(typefx,'D',sccycd,rccycd),'VND',amt,exchangeamt))|| ')'
                  ELSE ''END)
        WHEN tltxcd = '6704' THEN
            (CASE WHEN sccycd <> 'VND' AND rccycd = 'VND' THEN decode(typefx,'D','(Debit ','(Credit ')|| decode(typefx,'D',sccycd,rccycd)|| ' '|| utils.so_thanh_chu2 (decode(decode(typefx,'D',sccycd,rccycd),'VND',exchangeamt,amt))|| ')'
                  WHEN sccycd = 'VND' AND rccycd <> 'VND' THEN decode(typefx,'D','(Debit ','(Credit ')|| decode(typefx,'D',sccycd,rccycd)|| ' '|| utils.so_thanh_chu2 (decode(decode(typefx,'D',sccycd,rccycd),'VND',amt,exchangeamt))|| ')'
                  ELSE ''END)
        WHEN tltxcd = '6702' AND rccycd = 'VND' THEN decode(typefx,'D','(Debit ','(Credit ')|| rccycd|| ' '|| utils.so_thanh_chu2 (exchangeamt)|| ')'
        WHEN tltxcd = '6703' AND rccycd = 'VND' THEN
            decode(typefx,'D','(Debit ','(Credit ')|| rccycd|| ' '|| utils.so_thanh_chu2 (decode(sccycd,'VND',amt,exchangeamt))|| ')'
        ELSE '( '||memo||' )' END memo,

        CASE WHEN tltxcd = '6701' THEN
            (CASE WHEN (sccycd <> 'VND' AND rccycd = 'VND') OR (sccycd = 'VND' AND rccycd <> 'VND') THEN 'FX Trade'
                  ELSE 'Internal Transfer'||decode(typefx,'D','(debit)','(credit)') END)
        WHEN tltxcd = '6702' THEN
            (CASE WHEN rccycd <> 'VND' THEN 'Oversea outward remittance'
                  ELSE 'FX  & Oversea outward remittance' END)
        WHEN tltxcd = '6703' THEN
            (CASE WHEN rccycd <> 'VND' THEN 'Oversea inward remittance'
                  ELSE 'Oversea inward remittance & FX' END)
        ELSE 'FX Trade' END rmk,
        CASE WHEN tltxcd = '6701' OR tltxcd = '6704' OR (tltxcd = '6702' AND rccycd='VND') OR (tltxcd = '6703' AND rccycd='VND') THEN '( '||memo||' )' ELSE '' END DESCRIP,
        tl.custodycd refcasaacct,sddacctno,rddacctno,sccycd,rccycd
    FROM (
    --tltx 6701
        select typefx,tltxcd,txnum,txdate,sddacctno,rddacctno,amt,sccycd,rccycd,exchangerate,exchangeamt,memo,B.cifid custodycd
        from (
            SELECT 'D' typefx,'6701' tltxcd,txnum,txdate,sddacctno_cvalue sddacctno,rddacctno_cvalue rddacctno,amt_nvalue amt,
            sccycd_cvalue sccycd,rccycd_cvalue rccycd,exchangerate_nvalue exchangerate,exchangeamt_nvalue exchangeamt,
            description_cvalue memo,custodycd_cvalue custodycd
            FROM (  SELECT tf.txnum,tf.txdate,tf.nvalue,tf.cvalue,tf.fldcd
                    FROM vw_tllog_all tl,vw_tllogfld_all tf,(SELECT * FROM fldmaster WHERE objname = '6701') fl
                    WHERE tl.txnum = tf.txnum AND tl.txdate = tf.txdate AND tl.txdate between v_FromDate and v_ToDate
                        AND tl.tltxcd = '6701' AND tf.fldcd = fl.fldname)
                        PIVOT (MAX (nvalue) nvalue,MAX (cvalue) cvalue
                        FOR fldcd IN  ('06' sddacctno,'08' rddacctno,'10' amt,'02' txdate,
                                      '07' sccycd,'09' rccycd,'11' exchangerate,'12' exchangeamt,
                                      '30' description,'05' custodycd))
          )A,(select cf.cifid, dd.refcasaacct from cfmast cf, ddmast dd where cf.custodycd=dd.custodycd) b
    WHERE a.sddacctno=b.refcasaacct
    UNION ALL
    SELECT typefx,tltxcd,txnum,txdate,sddacctno,rddacctno,amt,sccycd,rccycd,exchangerate,exchangeamt,memo,B.cifid custodycd
    FROM (SELECT 'C' typefx,'6701' tltxcd,txnum,txdate,sddacctno_cvalue sddacctno,rddacctno_cvalue rddacctno,amt_nvalue amt,
            sccycd_cvalue sccycd,rccycd_cvalue rccycd,exchangerate_nvalue exchangerate,exchangeamt_nvalue exchangeamt,
            description_cvalue memo,custodycd_cvalue custodycd
          FROM (SELECT tf.txnum,tf.txdate,tf.nvalue,tf.cvalue,tf.fldcd
                    FROM vw_tllog_all tl,vw_tllogfld_all tf,(SELECT * FROM fldmaster WHERE objname = '6701') fl
                    WHERE tl.txnum = tf.txnum AND tl.txdate = tf.txdate AND tl.txdate between v_FromDate and v_ToDate
                       AND tl.tltxcd = '6701' AND tf.fldcd = fl.fldname)
                       PIVOT (MAX (nvalue) nvalue,MAX (cvalue) cvalue
                       FOR fldcd IN  ('06' sddacctno,'08' rddacctno,'10' amt,'02' txdate,
                                      '07' sccycd,'09' rccycd,'11' exchangerate,'12' exchangeamt,
                                      '30' description,'05' custodycd))
          )A,(select cf.cifid, dd.refcasaacct from cfmast cf, ddmast dd where cf.custodycd=dd.custodycd) b
    WHERE a.rddacctno=b.refcasaacct
    --end tltx 6701
    UNION ALL
    -- 6702
    SELECT A.typefx,A.tltxcd,A.txnum,A.txdate,A.sddacctno,A.rddacctno,case when a.sccycd='VND' and b.ccycd <> 'VND' THEN A.exchangeamt ELSE A.amt END amt,
    a.sccycd,b.ccycd rccycd,A.exchangerate,CASE WHEN (a.sccycd = b.ccycd AND a.sccycd='VND') OR (a.sccycd='VND' and b.ccycd <> 'VND') THEN  A.amt ELSE A.exchangeamt END exchangeamt,A.memo,A.custodycd
    FROM (SELECT 'D' typefx,'6702' tltxcd,txnum,txdate,sddacctno_cvalue sddacctno,rddacctno_cvalue rddacctno,amt_nvalue amt,sccycd_cvalue sccycd,
            rccycd_cvalue rccycd,exchangerate_nvalue exchangerate,exchangeamt_nvalue exchangeamt,description_cvalue memo,custodycd_cvalue custodycd
            FROM (SELECT tf.txnum,
                       tf.txdate,
                       tf.nvalue,
                       tf.cvalue,
                       tf.fldcd
                  FROM vw_tllog_all tl,
                       vw_tllogfld_all tf,
                       (SELECT *
                          FROM fldmaster
                         WHERE objname = '6702') fl
                 WHERE     tl.txnum = tf.txnum
                       AND tl.txdate = tf.txdate
                       AND tl.txdate between v_FromDate and v_ToDate
                       AND tl.tltxcd = '6702'
                       AND tf.fldcd = fl.fldname) PIVOT (MAX (nvalue) nvalue,
                                                        MAX (cvalue) cvalue
                                                  FOR fldcd
                                                  IN  ('11' sddacctno,
                                                      '06' rddacctno,
                                                      '04' amt,
                                                      '01' txdate,
                                                      '05' sccycd,
                                                      '' rccycd,
                                                      '09' exchangerate,
                                                      '08' exchangeamt,
                                                      '10' description,
                                                      '11' custodycd))
            )A,( select cf.cifid, dd.refcasaacct,dd.ccycd from cfmast cf, ddmast dd where cf.custodycd=dd.custodycd) b
    WHERE a.CUSTODYCD=b.refcasaacct
    --end 6702
    UNION ALL
    --6703
    SELECT A.typefx,A.tltxcd,A.txnum,A.txdate,A.sddacctno,A.rddacctno,A.amt,
         A.sccycd,B.CCYCD rccycd,A.exchangerate,a.exchangeamt,A.memo,A.custodycd
    FROM (SELECT 'C' typefx,'6703' tltxcd,
               txnum,
               txdate,
               sddacctno_cvalue sddacctno,
               rddacctno_cvalue rddacctno,
               amt_nvalue amt,
               sccycd_cvalue sccycd,
               rccycd_cvalue rccycd,
               exchangerate_nvalue exchangerate,
               exchangeamt_nvalue exchangeamt,
               description_cvalue memo,
               custodycd_cvalue custodycd
          FROM (SELECT tf.txnum,
                       tf.txdate,
                       tf.nvalue,
                       tf.cvalue,
                       tf.fldcd
                  FROM vw_tllog_all tl,
                       vw_tllogfld_all tf,
                       (SELECT *
                          FROM fldmaster
                         WHERE objname = '6703') fl
                 WHERE     tl.txnum = tf.txnum
                       AND tl.txdate = tf.txdate
                       AND tl.txdate between v_FromDate and v_ToDate
                       AND tl.tltxcd = '6703'
                       AND tf.fldcd = fl.fldname) PIVOT (MAX (nvalue) nvalue,
                                                        MAX (cvalue) cvalue
                                                  FOR fldcd
                                                  IN  ('06' sddacctno,
                                                      '08' rddacctno,
                                                      '04' amt,
                                                      '01' txdate,
                                                      '05' sccycd,
                                                      '' rccycd,
                                                      '09' exchangerate,
                                                      '10' exchangeamt,
                                                      '11' description,
                                                      '08' custodycd))
          )A,( select cf.cifid, dd.refcasaacct,dd.ccycd from cfmast cf, ddmast dd where cf.custodycd=dd.custodycd) b
    WHERE a.CUSTODYCD=b.refcasaacct
    --end 6703
    UNION ALL
    --6704
    SELECT typefx,tltxcd,txnum,txdate,sddacctno,rddacctno,amt,sccycd,rccycd,exchangerate,exchangeamt,memo,B.cifid custodycd
    FROM (SELECT 'D' typefx,'6704' tltxcd,txnum,txdate,sddacctno_cvalue sddacctno,rddacctno_cvalue rddacctno,
            samt_nvalue amt,sccycd_cvalue sccycd,rccycd_cvalue rccycd,exchangerate_nvalue exchangerate,
            ramt_nvalue exchangeamt,description_cvalue memo,custodycd_cvalue custodycd
            FROM (SELECT tf.txnum,tf.txdate,tf.nvalue,tf.cvalue,tf.fldcd
                    FROM vw_tllog_all tl,vw_tllogfld_all tf,(SELECT * FROM fldmaster WHERE objname = '6704') fl
                    WHERE tl.txnum = tf.txnum AND tl.txdate = tf.txdate AND tl.txdate between v_FromDate and v_ToDate
                    AND tl.tltxcd = '6704' AND tf.fldcd = fl.fldname)
                    PIVOT (MAX (nvalue) nvalue, MAX (cvalue) cvalue
                    FOR fldcd IN  ('10' sddacctno,'11' rddacctno,'05' samt,'07' ramt,'01' txdate,
                    '06' sccycd,'08' rccycd,'09' exchangerate,'' exchangeamt,'30' description,'04' custodycd))
        )A,(select cf.cifid, dd.refcasaacct from cfmast cf, ddmast dd where cf.custodycd=dd.custodycd) b
    WHERE a.sddacctno=b.refcasaacct
    UNION ALL
    SELECT typefx,tltxcd,txnum,txdate,sddacctno,rddacctno,amt,sccycd,rccycd,exchangerate,exchangeamt,memo,B.cifid custodycd
    FROM (SELECT 'C' typefx,'6704' tltxcd,txnum,txdate,sddacctno_cvalue sddacctno,rddacctno_cvalue rddacctno,
            samt_nvalue amt,sccycd_cvalue sccycd,rccycd_cvalue rccycd,exchangerate_nvalue exchangerate,
            ramt_nvalue exchangeamt,description_cvalue memo,custodycd_cvalue custodycd
            FROM (SELECT tf.txnum,tf.txdate,tf.nvalue,tf.cvalue,tf.fldcd
                    FROM vw_tllog_all tl,vw_tllogfld_all tf,(SELECT * FROM fldmaster WHERE objname = '6704') fl
                    WHERE tl.txnum = tf.txnum AND tl.txdate = tf.txdate AND tl.txdate between v_FromDate and v_ToDate
                    AND tl.tltxcd = '6704' AND tf.fldcd = fl.fldname)
                    PIVOT (MAX (nvalue) nvalue, MAX (cvalue) cvalue
                    FOR fldcd IN  ('10' sddacctno,'11' rddacctno,'05' samt,'07' ramt,'01' txdate,
                    '06' sccycd,'08' rccycd,'09' exchangerate,'' exchangeamt,'30' description,'04' custodycd))
        )A,(select cf.cifid, dd.refcasaacct from cfmast cf, ddmast dd where cf.custodycd=dd.custodycd) b
    WHERE a.rddacctno=b.refcasaacct
    -- End 6704
    --End all
    ) tl,ddmast dd,
       --afmast af,
       cfmast cf
    WHERE (case when tl.tltxcd in ('6701','6704') and  tl.custodycd=cf.cifid then 1
    when tl.tltxcd in ('6702','6703') and tl.custodycd = dd.refcasaacct then 1
    else 0 end ) =1
    AND dd.custodycd = cf.custodycd
    --AND cf.custid = af.custid
    AND cf.cifid=v_cifid
    ORDER BY tl.tltxcd,TL.typefx DESC;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('OD6050: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
