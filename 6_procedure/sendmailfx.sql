SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sendmailfx (
p_txnum varchar2,p_tltxcd varchar2)
IS
    pkgctx plog.log_ctx;
    logrow tlogdebug%rowtype;
    l_data_source varchar2(4000);
    l_tltxcd    varchar2(10);
    l_txcdindex number;
    l_template  varchar2(5);
    l_STATUS varchar2(1);
    l_voting varchar2(4000);
    l_catype varchar2(5);
    l_isexec varchar2(2);
    l_isci varchar(2);
    l_isse varchar2(2);
    l_taxvatamount number;
    l_vat varchar(1);
    l_iscancel varchar(1);
    l_count number;
    l_emailSubject   VARCHAR2(1000);
BEGIN
    --thoai.tran 25/11/2020
    --send mail fx
    l_tltxcd:=p_tltxcd;

    plog.setBeginSection(pkgctx, 'sendmailfx');
    for rec in (
        SELECT distinct cf.fullname,cf.cifid,cf.custid,cf.custodycd,tltxcd,TL.typefx,txnum,txdate,
        CASE WHEN tltxcd IN ('6701','6704') THEN
            CASE WHEN sccycd <> 'VND' THEN AMT
            WHEN rccycd <> 'VND' THEN EXCHANGEAMT ELSE -1 END
        WHEN tltxcd ='6703' THEN
            CASE WHEN RCCYCD <> 'VND' THEN AMT ELSE DECODE(sccycd,'VND',0,AMT) END
        WHEN tltxcd ='6702' THEN
            CASE WHEN RCCYCD <> 'VND' THEN AMT ELSE DECODE(sccycd,'VND',0,AMT) END
        ELSE AMT END amt,
        CASE WHEN tltxcd = '6701' AND sccycd = rccycd THEN -1
            WHEN tltxcd = '6702' THEN CASE WHEN RCCYCD <> 'VND' THEN -1 ELSE DECODE(sccycd,'VND',0,exchangerate) END
            WHEN tltxcd = '6703' THEN CASE WHEN RCCYCD <> 'VND' THEN -1 ELSE DECODE(sccycd,'VND',0,exchangerate) END
        ELSE exchangerate END exchangerate,
        CASE WHEN (tltxcd = '6702' AND rccycd ='VND') OR (tltxcd = '6703' AND rccycd ='VND' AND sccycd <> 'VND' ) THEN EXCHANGEAMT
        WHEN (tltxcd IN ('6701','6704') AND sccycd = 'VND') OR (tltxcd = '6703' AND rccycd ='VND' AND sccycd = 'VND' ) THEN AMT
        WHEN tltxcd IN ('6701','6704') AND rccycd = 'VND' THEN EXCHANGEAMT
        ELSE -1 END exchangeamt,
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
            SELECT 'D' typefx,'6701' tltxcd,txnum,txdate_cvalue txdate,sddacctno_cvalue sddacctno,rddacctno_cvalue rddacctno,amt_nvalue amt,
            sccycd_cvalue sccycd,rccycd_cvalue rccycd,exchangerate_nvalue exchangerate,exchangeamt_nvalue exchangeamt,
            description_cvalue memo,custodycd_cvalue custodycd
            FROM (  SELECT tf.txnum,tf.txdate,tf.nvalue,tf.cvalue,tf.fldcd
                    FROM TLLOG tl,TLLOGFLD tf,(SELECT * FROM fldmaster WHERE objname = '6701') fl
                    WHERE tl.txnum = tf.txnum AND tl.txdate = tf.txdate AND TL.TXNUM = P_TXNUM
                        AND tl.tltxcd = '6701' AND tf.fldcd = fl.fldname)
                        PIVOT (MAX (nvalue) nvalue,MAX (cvalue) cvalue
                        FOR fldcd IN  ('06' sddacctno,'08' rddacctno,'10' amt,'02' txdate,
                                      '07' sccycd,'09' rccycd,'11' exchangerate,'12' exchangeamt,
                                      '30' description,'05' custodycd))
          )A,(select cf.cifid, dd.refcasaacct from cfmast cf, ddmast dd where cf.custodycd=dd.custodycd AND CF.STATUS <> 'C' and dd.status <> 'C') b
    WHERE a.sddacctno=b.refcasaacct
    UNION ALL
    SELECT typefx,tltxcd,txnum,txdate,sddacctno,rddacctno,amt,sccycd,rccycd,exchangerate,exchangeamt,memo,B.cifid custodycd
    FROM (SELECT 'C' typefx,'6701' tltxcd,txnum,txdate_cvalue txdate,sddacctno_cvalue sddacctno,rddacctno_cvalue rddacctno,amt_nvalue amt,
            sccycd_cvalue sccycd,rccycd_cvalue rccycd,exchangerate_nvalue exchangerate,exchangeamt_nvalue exchangeamt,
            description_cvalue memo,custodycd_cvalue custodycd
          FROM (SELECT tf.txnum,tf.txdate,tf.nvalue,tf.cvalue,tf.fldcd
                    FROM TLLOG tl,TLLOGFLD tf,(SELECT * FROM fldmaster WHERE objname = '6701') fl
                    WHERE tl.txnum = tf.txnum AND tl.txdate = tf.txdate AND TL.TXNUM = P_TXNUM
                       AND tl.tltxcd = '6701' AND tf.fldcd = fl.fldname)
                       PIVOT (MAX (nvalue) nvalue,MAX (cvalue) cvalue
                       FOR fldcd IN  ('06' sddacctno,'08' rddacctno,'10' amt,'02' txdate,
                                      '07' sccycd,'09' rccycd,'11' exchangerate,'12' exchangeamt,
                                      '30' description,'05' custodycd))
          )A,(select cf.cifid, dd.refcasaacct from cfmast cf, ddmast dd where cf.custodycd=dd.custodycd AND CF.STATUS <> 'C' and dd.status <> 'C') b
    WHERE a.rddacctno=b.refcasaacct
    --end tltx 6701
    UNION ALL
    -- 6702
    SELECT A.typefx,A.tltxcd,A.txnum,A.txdate,A.sddacctno,A.rddacctno,case when a.sccycd='VND' and b.ccycd <> 'VND' THEN A.exchangeamt ELSE A.amt END amt,
    a.sccycd,b.ccycd rccycd,A.exchangerate,CASE WHEN (a.sccycd = b.ccycd AND a.sccycd='VND') OR (a.sccycd='VND' and b.ccycd <> 'VND') THEN  A.amt ELSE A.exchangeamt END exchangeamt,A.memo,A.custodycd
    FROM (SELECT 'D' typefx,'6702' tltxcd,txnum,txdate_cvalue txdate,sddacctno_cvalue sddacctno,rddacctno_cvalue rddacctno,amt_nvalue amt,sccycd_cvalue sccycd,
            rccycd_cvalue rccycd,exchangerate_nvalue exchangerate,exchangeamt_nvalue exchangeamt,description_cvalue memo,custodycd_cvalue custodycd
            FROM (SELECT tf.txnum,
                       tf.txdate,
                       tf.nvalue,
                       tf.cvalue,
                       tf.fldcd
                  FROM TLLOG tl,
                       TLLOGFLD tf,
                       (SELECT *
                          FROM fldmaster
                         WHERE objname = '6702') fl
                 WHERE     tl.txnum = tf.txnum
                       AND tl.txdate = tf.txdate
                       AND TL.TXNUM = P_TXNUM
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
            )A,( select cf.cifid, dd.refcasaacct,dd.ccycd from cfmast cf, ddmast dd where cf.custodycd=dd.custodycd AND CF.STATUS <> 'C' and dd.status <> 'C') b
    WHERE a.CUSTODYCD=b.refcasaacct
    --end 6702
    UNION ALL
    --6703
    SELECT A.typefx,A.tltxcd,A.txnum,A.txdate,A.sddacctno,A.rddacctno,A.amt,
         A.sccycd,B.CCYCD rccycd,A.exchangerate,a.exchangeamt,A.memo,A.custodycd
    FROM (SELECT 'C' typefx,'6703' tltxcd,
               txnum,
               txdate_cvalue txdate,
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
                  FROM TLLOG tl,
                       TLLOGFLD tf,
                       (SELECT *
                          FROM fldmaster
                         WHERE objname = '6703') fl
                 WHERE     tl.txnum = tf.txnum
                       AND tl.txdate = tf.txdate
                       AND TL.TXNUM = P_TXNUM
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
          )A,( select cf.cifid, dd.refcasaacct,dd.ccycd from cfmast cf, ddmast dd where cf.custodycd=dd.custodycd AND CF.STATUS <> 'C' and dd.status <> 'C') b
    WHERE a.CUSTODYCD=b.refcasaacct
    --end 6703
    UNION ALL
    --6704
    SELECT typefx,tltxcd,txnum,txdate,sddacctno,rddacctno,amt,sccycd,rccycd,exchangerate,exchangeamt,memo,B.cifid custodycd
    FROM (SELECT 'D' typefx,'6704' tltxcd,txnum,txdate_cvalue txdate,sddacctno_cvalue sddacctno,rddacctno_cvalue rddacctno,
            samt_nvalue amt,sccycd_cvalue sccycd,rccycd_cvalue rccycd,exchangerate_nvalue exchangerate,
            ramt_nvalue exchangeamt,description_cvalue memo,custodycd_cvalue custodycd
            FROM (SELECT tf.txnum,tf.txdate,tf.nvalue,tf.cvalue,tf.fldcd
                    FROM TLLOG tl,TLLOGFLD tf,(SELECT * FROM fldmaster WHERE objname = '6704') fl
                    WHERE tl.txnum = tf.txnum AND tl.txdate = tf.txdate AND TL.TXNUM = P_TXNUM
                    AND tl.tltxcd = '6704' AND tf.fldcd = fl.fldname)
                    PIVOT (MAX (nvalue) nvalue, MAX (cvalue) cvalue
                    FOR fldcd IN  ('10' sddacctno,'11' rddacctno,'05' samt,'07' ramt,'01' txdate,
                    '06' sccycd,'08' rccycd,'09' exchangerate,'' exchangeamt,'30' description,'04' custodycd))
        )A,(select cf.cifid, dd.refcasaacct from cfmast cf, ddmast dd where cf.custodycd=dd.custodycd AND CF.STATUS <> 'C' and dd.status <> 'C') b
    WHERE a.sddacctno=b.refcasaacct
    UNION ALL
    SELECT typefx,tltxcd,txnum, txdate,sddacctno,rddacctno,amt,sccycd,rccycd,exchangerate,exchangeamt,memo,B.cifid custodycd
    FROM (SELECT 'C' typefx,'6704' tltxcd,txnum,txdate_cvalue txdate,sddacctno_cvalue sddacctno,rddacctno_cvalue rddacctno,
            samt_nvalue amt,sccycd_cvalue sccycd,rccycd_cvalue rccycd,exchangerate_nvalue exchangerate,
            ramt_nvalue exchangeamt,description_cvalue memo,custodycd_cvalue custodycd
            FROM (SELECT tf.txnum,tf.txdate,tf.nvalue,tf.cvalue,tf.fldcd
                    FROM TLLOG tl,TLLOGFLD tf,(SELECT * FROM fldmaster WHERE objname = '6704') fl
                    WHERE tl.txnum = tf.txnum AND tl.txdate = tf.txdate AND TL.TXNUM = P_TXNUM
                    AND tl.tltxcd = '6704' AND tf.fldcd = fl.fldname)
                    PIVOT (MAX (nvalue) nvalue, MAX (cvalue) cvalue
                    FOR fldcd IN  ('10' sddacctno,'11' rddacctno,'05' samt,'07' ramt,'01' txdate,
                    '06' sccycd,'08' rccycd,'09' exchangerate,'' exchangeamt,'30' description,'04' custodycd))
        )A,(select cf.cifid, dd.refcasaacct from cfmast cf, ddmast dd where cf.custodycd=dd.custodycd AND CF.STATUS <> 'C' and dd.status <> 'C') b
    WHERE a.rddacctno=b.refcasaacct
    -- End 6704
    --End all
    ) tl,ddmast dd,
       --afmast af,
       cfmast cf
    WHERE (case when tl.tltxcd in ('6704') and  tl.custodycd=cf.cifid then 1
    when tl.tltxcd in ('6701') and  tl.custodycd=cf.cifid and round(tl.exchangerate) > 0 then 1
    when tl.tltxcd in ('6702','6703') and tl.custodycd = dd.refcasaacct then 1
    else 0 end ) =1
    AND dd.custodycd = cf.custodycd
    --AND cf.custid = af.custid
    AND tl.tltxcd=P_TLTXCD
    ORDER BY tl.tltxcd,TL.typefx DESC)
    loop
        l_emailSubject := replace('Confirm FX and oversea remitance [p_valuedate]', '[p_valuedate]', rec.txdate);
              l_data_source:='select '''||(rec.fullname)||''' p_fullname, '''
            ||(rec.cifid)||''' p_cifid, '''
            ||rec.custodycd||''' p_custodycd,(case when '||rec.exchangeamt||' <> -1 then  '''||UTILS.SO_THANH_CHU2(to_char(rec.exchangeamt))
            ||''' else '''||' '' end )'||' p_vnd, '
            ||'(case when '||rec.amt||' <> -1 then  '''||UTILS.SO_THANH_CHU2(to_char(rec.amt))
            ||''' else '''||' '' end )'||' p_usd, '
            ||'(case when '||round(rec.exchangerate)||' <> -1 then  '''||UTILS.SO_THANH_CHU2(to_char(round(rec.exchangerate)))
            ||''' else '''||' '' end )'||' p_rate, '''
            ||rec.rmk ||''' p_rmk, '''||rec.descrip ||''' p_descrip, '''
            ||rec.txdate||''' p_valuedate, '''||l_emailSubject ||''' emailsubject, '''
            ||rec.memo ||''' p_memo from dual';

        select count(*) into l_count from FXMAILTMP where cifid=rec.cifid and txnum=rec.txnum and tltxcd=rec.tltxcd and txdate=rec.txdate;
        INSERT INTO FXMAILTMP(fullname,cifid,custid,custodycd,tltxcd,typefx,txnum,txdate,amt,exchangerate,
        exchangeamt,memo,rmk,descrip,refcasaacct,sddacctno,rddacctno,sccycd,rccycd)
          VALUES(rec.fullname,rec.cifid,rec.custid,rec.custodycd,rec.tltxcd,rec.typefx,rec.txnum,rec.txdate,rec.amt,rec.exchangerate,rec.
        exchangeamt,rec.memo,rec.rmk,rec.descrip,rec.refcasaacct,rec.sddacctno,rec.rddacctno,rec.sccycd,rec.rccycd);
        if l_count <1 then

            if l_data_source is not null  then
                nmpks_ems.pr_sendInternalEmail(l_data_source,'EMFX', rec.custid);
            end if;
            end if;
        end loop;
    plog.setEndSection(pkgctx, 'sendmailfx');
exception
when others then
  plog.setEndSection(pkgctx, 'sendmailfx');
end;
/
