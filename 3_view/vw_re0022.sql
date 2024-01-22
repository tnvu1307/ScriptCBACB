SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_RE0022
(TXDATE, TXNUM, CUSTODYCD, RECUSTID, REOLDCUSTID, 
 OLDFUTRECUSTID, NEWFUTRECUSTID, FRDATE, TODATE, DESCC, 
 TLFULLNAME, OFFFULLNAME, FULLNAME, NEWREFULLNAME, NEWTLNAME, 
 OLDREFULLNAME, OLDTLNAME, NBRID, NBRNAME, OBRID, 
 OBRNAME, FUTRECUSTID, FUTREFULLNAME, FUTTLNAME, TYPENAME)
AS 
select a.TXDATE,a.TXNUM,a.CUSTODYCD,a.RECUSTID,a.REOLDCUSTID,a.OLDFUTRECUSTID,a.NEWFUTRECUSTID,a.TXDATE FRDATE,a.TODATE,a.DESCC,a.TLFULLNAME,a.OFFFULLNAME,
    cf.fullname, b.fullname newrefullname, b.tlname newtlname,  c.fullname oldrefullname, c.tlname oldtlname,
    b.brid nbrid, b.brname nbrname, c.brid obrid, c.brname obrname,
    substr(nvl(NEWFUTRECUSTID, OLDFUTRECUSTID),1,10) FUTRECUSTID, futrecf.fullname FUTREFULLNAME, nvl(d.tlname,'') futtlname,
    ret.typename
from(
    select txdate,txnum, CUSTODYCD, RECUSTID, REOLDCUSTID,
        OLDFUTRECUSTID, NEWFUTRECUSTID, FRDATE, TODATE, DESCC,
        tlp.tlfullname tlfullname, tlp2.tlfullname offfullname
    from (
        select txdate,txnum,tlid,nvl(offid,tlid) offid,
            max(case when fldcd = '88' then cvalue else '' end) CUSTODYCD,
            max(case when fldcd = '08' then cvalue else '' end) RECUSTID,
            max(case when fldcd = '21' then cvalue else '' end) REOLDCUSTID,
            max(case when fldcd = '22' then cvalue else null end) OLDFUTRECUSTID,
            max(case when fldcd = '23' then cvalue else null end) NEWFUTRECUSTID,
            max(case when fldcd = '05' then cvalue else '' end) FRDATE,
            max(case when fldcd = '06' then cvalue else '' end) TODATE,
            max(case when fldcd = '30' then cvalue else '' end) DESCC
        from
        (
            select tl.txdate, tl.txnum,tl.tlid, tl.offid, fld.fldcd--,fm.caption,fm.defname
            ,fld.nvalue, fld.cvalue
            from vw_tllog_all_re tl, vw_tllogfld_re fld --,fldmaster fm
            where tltxcd = '0381'
                and tl.txdate = fld.txdate
                and tl.txnum = fld.txnum
               -- and fm.objname = '0381'
              --  and fm.fldname  = fld.fldcd
                and fld.fldcd in ('88','05','08','21','22','23', '30','06')
                and tl.deltd <> 'Y'
        )
        group by txdate,txnum,tlid,offid
        union all
    select txdate,txnum,tlid,offid,
        max(case when fldcd = '88' then cvalue else '' end) CUSTODYCD,
        '' RECUSTID,
        max(case when fldcd = '21' then cvalue else '' end) REOLDCUSTID,
        '' OLDFUTRECUSTID,
        '' NEWFUTRECUSTID,
        '' FRDATE,
        '' TODATE,
        max(case when fldcd = '30' then cvalue else '' end) DESCC
    from (select tl.txdate, tl.txnum,tl.tlid, tl.offid, fld.fldcd--,fm.caption,fm.defname
    ,fld.nvalue, fld.cvalue
        from vw_tllog_all_re tl, vw_tllogfld_re fld-- ,fldmaster fm
        where tltxcd = '0384'
            and tl.txdate = fld.txdate
            and tl.txnum = fld.txnum
          --  and fm.objname = '0384'
           -- and fm.fldname  = fld.fldcd
            and fld.fldcd in ('88','20','30')
            and tl.deltd <> 'Y'
        )
        group by txdate,txnum,tlid,offid
        union all
    select txdate,txnum,tlid,offid,
        max(case when fldcd = '88' then cvalue else '' end) CUSTODYCD,
        max(case when fldcd = '08' then cvalue else '' end) RECUSTID,
        '' REOLDCUSTID,
        '' OLDFUTRECUSTID,
        max(substr(case when fldcd = '11' then cvalue else null end,1,10)) NEWFUTRECUSTID,
        max(case when fldcd = '05' then cvalue else '' end) FRDATE,
        max(case when fldcd = '06' then cvalue else '' end) TODATE,
        max(case when fldcd = '30' then cvalue else '' end) DESCC
    from (
        select tl.txdate, tl.txnum,tl.tlid, tl.offid, fld.fldcd--,fm.caption,fm.defname
        ,fld.nvalue, fld.cvalue
        from vw_tllog_all_re tl, vw_tllogfld_re fld--,fldmaster fm
        where tltxcd = '0380'
            and tl.txdate = fld.txdate
            and tl.txnum = fld.txnum
          --  and fm.objname = '0380'
            --and fm.fldname  = fld.fldcd
            and fld.fldcd in ('88','02','11','05','06','30')
            and tl.deltd <> 'Y'
        )
        group by txdate,txnum,tlid,offid
    )log , tlprofiles tlp, tlprofiles tlp2
    where log.tlid = tlp.tlid(+)
        and log.offid = tlp2.tlid(+)
    --group by txdate,txnum
    ) a, (--Tai khoan MG moi
        select rcf.custid, rcf.effdate, rcf.expdate, cf.fullname, tl.tlid, tl.tlname, br.brid, br.brname
        from (SELECT   f.*
               FROM   recflnk f,
                     (  SELECT   DISTINCT custid, MAX (autoid) autoid
                        FROM   recflnk
                        GROUP BY   custid) l
               WHERE   f.autoid = l.autoid) rcf,
               cfmast cf, tlprofiles tl, brgrp br
        where rcf.custid=cf.custid
            and rcf.tlid=tl.tlid
            and rcf.brid=br.brid
             and rcf.status <> 'P'
    ) b ,(--Tai khoan MG cu
        select rcf.custid, rcf.effdate, rcf.expdate, cf.fullname, tl.tlid, tl.tlname, br.brid, br.brname
        from (SELECT   e.*
              FROM   recflnk e, (  SELECT   DISTINCT custid, MAX (autoid) autoid FROM   recflnk  GROUP BY   custid) k
              WHERE   e.autoid = k.autoid) rcf,
              cfmast cf, tlprofiles tl, brgrp br
        where rcf.custid=cf.custid
            and rcf.tlid=tl.tlid
            and rcf.brid=br.brid

            and rcf.status <> 'P'
    ) c, cfmast futrecf,retype ret,
    (--Tai khoan tuong lai
        select  re.autoid, re.custid,re.effdate,re.expdate,re.tlid, nvl(tl.tlname,'') tlname
        from (SELECT   g.*
              FROM   recflnk g, (  SELECT   DISTINCT custid, MAX (autoid) autoid FROM   recflnk GROUP BY   custid) o
              WHERE   g.autoid = o.autoid) re,
        tlprofiles tl
        where  re.tlid=tl.tlid
        and re.status <> 'P'
    ) d, cfmast cf
where a.custodycd = cf.custodycd
    and substr(RECUSTID,1,10) = b.custid(+)
    and substr(REOLDCUSTID,1,10) = c.custid(+)
    --and SUBSTR(RECUSTID,11,4)=ret.actype(+)
    and SUBSTR(nvl(RECUSTID,REOLDCUSTID),11,4) = ret.actype(+)
    and substr(nvl(NEWFUTRECUSTID, OLDFUTRECUSTID),1,10) = futrecf.custid(+)
    and substr(nvl(NEWFUTRECUSTID, OLDFUTRECUSTID),1,10) = d.custid(+)
    and a.txdate >= nvl(b.effdate,to_date('01/01/2000','dd/MM/rrrr')) and a.txdate < nvl(b.expdate,to_date('31/12/2099','dd/MM/rrrr'))
    and a.txdate >= nvl(c.effdate,to_date('01/01/2000','dd/MM/rrrr')) and a.txdate < nvl(c.expdate,to_date('31/12/2099','dd/MM/rrrr'))
    and a.txdate >= nvl(d.effdate,to_date('01/01/2000','dd/MM/rrrr')) and a.txdate <nvl(d.expdate,to_date('31/12/2099','dd/MM/rrrr'))
    and a.txdate <= to_date('02/10/2015','dd/MM/rrrr')

    union all
 ----sau ngày 02/10 --> phan khuc du lieu do truoc do chua co log lai autoid c?a recflnk nen ko lay dc mg vào thoi diem do

select a.TXDATE,a.TXNUM,a.CUSTODYCD,a.RECUSTID,a.REOLDCUSTID,a.OLDFUTRECUSTID,a.NEWFUTRECUSTID,a.TXDATE FRDATE,a.TODATE,a.DESCC,a.TLFULLNAME,a.OFFFULLNAME,
    cf.fullname, b.fullname newrefullname, b.tlname newtlname,  c.fullname oldrefullname, c.tlname oldtlname,
    b.brid nbrid, b.brname nbrname, c.brid obrid, c.brname obrname,
    substr(nvl(NEWFUTRECUSTID, OLDFUTRECUSTID),1,10) FUTRECUSTID, futrecf.fullname FUTREFULLNAME, nvl(d.tlname,'') futtlname,
    ret.typename
from(
    select txdate,txnum, CUSTODYCD, RECUSTID, REOLDCUSTID,
        OLDFUTRECUSTID, NEWFUTRECUSTID, FRDATE, TODATE, DESCC,
        tlp.tlfullname tlfullname, tlp2.tlfullname offfullname,oldrefrecflnkid,refrecflnkid
    from (
        select txdate,txnum,tlid,nvl(offid,tlid) offid,
            max(case when fldcd = '88' then cvalue else '' end) CUSTODYCD,
            max(case when fldcd = '08' then cvalue else '' end) RECUSTID,
            max(case when fldcd = '21' then cvalue else '' end) REOLDCUSTID,
            max(case when fldcd = '22' then cvalue else null end) OLDFUTRECUSTID,
            max(case when fldcd = '23' then cvalue else null end) NEWFUTRECUSTID,
            max(case when fldcd = '05' then cvalue else '' end) FRDATE,
            max(case when fldcd = '06' then cvalue else '' end) TODATE,
            max(case when fldcd = '77' then cvalue else '' end) oldrefrecflnkid,
            max(case when fldcd = '78' then cvalue else '' end) refrecflnkid,
            max(case when fldcd = '30' then cvalue else '' end) DESCC
        from
        (
            select tl.txdate, tl.txnum,tl.tlid, tl.offid, fld.fldcd--,fm.caption,fm.defname
            ,fld.nvalue, fld.cvalue
            from vw_tllog_all_re tl, vw_tllogfld_re fld-- ,fldmaster fm
            where tltxcd = '0381'
                and tl.txdate = fld.txdate
                and tl.txnum = fld.txnum
              --  and fm.objname = '0381'
              --  and fm.fldname  = fld.fldcd
                and fld.fldcd in ('88','05','08','21','22','23', '30','06','77','78')
                and tl.deltd <> 'Y'
        )
        group by txdate,txnum,tlid,offid
        union all
    select txdate,txnum,tlid,offid,
        max(case when fldcd = '88' then cvalue else '' end) CUSTODYCD,
        '' RECUSTID,
        max(case when fldcd = '21' then cvalue else '' end) REOLDCUSTID,
        '' OLDFUTRECUSTID,
        '' NEWFUTRECUSTID,
        '' FRDATE,
        '' TODATE,
        max(case when fldcd = '77' then cvalue else '' end) oldrefrecflnkid,
        max(case when fldcd = '78' then cvalue else '' end) refrecflnkid,
        max(case when fldcd = '30' then cvalue else '' end) DESCC
    from (select tl.txdate, tl.txnum,tl.tlid, tl.offid, fld.fldcd--,fm.caption,fm.defname
    ,fld.nvalue, fld.cvalue
        from vw_tllog_all_re tl, vw_tllogfld_re fld-- ,fldmaster fm
        where tltxcd = '0384'
            and tl.txdate = fld.txdate
            and tl.txnum = fld.txnum
           -- and fm.objname = '0384'
           -- and fm.fldname  = fld.fldcd
           -- and fld.fldcd in ('88','20','30','77','78')
            and tl.deltd <> 'Y'
        )
        group by txdate,txnum,tlid,offid
        union all
    select txdate,txnum,tlid,offid,
        max(case when fldcd = '88' then cvalue else '' end) CUSTODYCD,
        max(case when fldcd = '08' then cvalue else '' end) RECUSTID,
        '' REOLDCUSTID,
        '' OLDFUTRECUSTID,
        max(substr(case when fldcd = '11' then cvalue else null end,1,10)) NEWFUTRECUSTID,
        max(case when fldcd = '05' then cvalue else '' end) FRDATE,
        max(case when fldcd = '06' then cvalue else '' end) TODATE,
        max(case when fldcd = '77' then cvalue else '' end) oldrefrecflnkid,
        max(case when fldcd = '78' then cvalue else '' end) refrecflnkid,
        max(case when fldcd = '30' then cvalue else '' end) DESCC
    from (
        select tl.txdate, tl.txnum,tl.tlid, tl.offid, fld.fldcd--,fm.caption,fm.defname
        ,fld.nvalue, fld.cvalue
        from vw_tllog_all_re tl, vw_tllogfld_re fld --,fldmaster fm
        where tltxcd = '0380'
            and tl.txdate = fld.txdate
            and tl.txnum = fld.txnum
           -- and fm.objname = '0380'
           -- and fm.fldname  = fld.fldcd
          --  and fld.fldcd in ('88','02','11','05','06','30','77','78')
            and tl.deltd <> 'Y'
        )
        group by txdate,txnum,tlid,offid
    )log , tlprofiles tlp, tlprofiles tlp2
    where log.tlid = tlp.tlid(+)
        and log.offid = tlp2.tlid(+)
    --group by txdate,txnum
    ) a, (--Tai khoan MG moi
        select rcf.autoid,rcf.custid, rcf.effdate, rcf.expdate, cf.fullname, tl.tlid, tl.tlname, br.brid, br.brname
        from recflnk rcf,cfmast cf, tlprofiles tl, brgrp br
        where rcf.custid=cf.custid
            and rcf.tlid=tl.tlid
            and rcf.brid=br.brid
             and rcf.status <> 'P'
    ) b ,(--Tai khoan MG cu
        select rcf.autoid,rcf.custid, rcf.effdate, rcf.expdate, cf.fullname, tl.tlid, tl.tlname, br.brid, br.brname
        from recflnk rcf,
              cfmast cf, tlprofiles tl, brgrp br
        where rcf.custid=cf.custid
            and rcf.tlid=tl.tlid
            and rcf.brid=br.brid

            and rcf.status <> 'P'
    ) c, cfmast futrecf,retype ret,
    (--Tai khoan MG tuong lai
        select  re.autoid, re.custid,re.effdate,re.expdate,re.tlid, nvl(tl.tlname,'') tlname
        from recflnk  re,
        tlprofiles tl
        where  re.tlid=tl.tlid
        and re.status <> 'P'
    ) d, cfmast cf
where a.custodycd = cf.custodycd
    and a.refrecflnkid = b.autoid(+)
    and a.oldrefrecflnkid = c.autoid(+)
    --and SUBSTR(RECUSTID,11,4)=ret.actype(+)
    and SUBSTR(nvl(RECUSTID,REOLDCUSTID),11,4) = ret.actype(+)
    and substr(nvl(NEWFUTRECUSTID, OLDFUTRECUSTID),1,10) = futrecf.custid(+)
    and substr(nvl(NEWFUTRECUSTID, OLDFUTRECUSTID),1,10) = d.custid(+)
    and a.txdate >= nvl(b.effdate,to_date('01/01/2000','dd/MM/rrrr')) and a.txdate < nvl(b.expdate,to_date('31/12/2099','dd/MM/rrrr'))
    and a.txdate >= nvl(c.effdate,to_date('01/01/2000','dd/MM/rrrr')) and a.txdate <= nvl(c.expdate,to_date('31/12/2099','dd/MM/rrrr'))
    and a.txdate >= nvl(d.effdate,to_date('01/01/2000','dd/MM/rrrr')) and a.txdate < nvl(d.expdate,to_date('31/12/2099','dd/MM/rrrr'))
    and a.txdate > to_date('02/10/2015','dd/MM/rrrr')
--order by txdate asc
/
