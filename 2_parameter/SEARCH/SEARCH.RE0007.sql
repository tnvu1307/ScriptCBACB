SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RE0007','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RE0007', 'Tra cứu lịch sử cài phí ưu đãi', 'View history of setting preferential fees', '
select oaf.autoid,oaf.afacctno,cf.custodycd, cf.fullname, case when o.feetype=''T''  then nvl(valamt,0) else o.feerate end feerate, oaf.createddate,
    o.valdate, least(nvl(oaf.delddate,o.expdate+1),o.expdate) expdate, o.PROBRKMSTTYPE, a0.cdcontent pPROBRKMSTTYPE,
    nvl(re.recustid,'''') recustid, nvl(re.refullname,'''') refullname, nvl(br.brname,'''') brname, nvl(re.tlname,'''') retlname,
    nvl(tl.tlfullname,'''') tlfullname,log.maker_id,log.maker_dt,log.del_id,log.del_dt,tl1.tlname maker_name, tl2.tlname del_name,a1.cdcontent status_text
from (select * from ODPROBRKAF union all select * from  ODPROBRKAF_DELTD) oaf,
     (select * from ODPROBRKMST union all select * from ODPROBRKMST_DELTD) o,
  afmast af, cfmast cf, allcode a0, tlprofiles tl, brgrp br,tlprofiles tl1, tlprofiles tl2,
    (select re.autoid, re.custid recustid, nvl(cf.fullname,'''') refullname, re.brid, nvl(br.brname,'''') brname, re.tlid, nvl(tl.tlname,'''') tlname, raf.afacctno
        from reaflnk raf, recflnk re, tlprofiles tl, sysvar sys, brgrp br, cfmast cf
        where re.tlid=tl.tlid(+) and re.custid = substr(raf.reacctno,1,10)
            and  raf.frdate<=to_date(sys.VARVALUE,''DD/MM/YYYY'') and nvl(raf.clstxdate,raf.todate) > to_date(sys.VARVALUE,''DD/MM/YYYY'')
            and sys.GRNAME = ''SYSTEM'' AND sys.VARNAME =''CURRDATE''
            and re.effdate <= to_date(sys.VARVALUE,''DD/MM/YYYY'') and re.expdate > to_date(sys.VARVALUE,''DD/MM/YYYY'')
            and re.brid=br.brid(+)
            and re.custid=cf.custid(+)
            --and raf.status <> ''C''
    ) re, (select refautoid, max(valamt) valamt from ODPROBRKSCHM group by refautoid) chm,
    (select  TBLKEY, max(maker_id) maker_id,max(maker_dt) maker_dt,max(del_id) del_id,max(del_dt) del_dt
    from(
      SELECT distinct(case when table_name = ''ODPROBRKMST'' and CHILD_TABLE_NAME = ''ODPROBRKAF'' then  child_record_key else record_key end) TBLKEY,
        case when action_flag = ''ADD'' then maker_id else '''' end maker_id,
        case when action_flag = ''ADD'' then maker_dt else null end maker_dt,
        case when action_flag = ''DELETE'' then maker_id else '''' end del_id,
        case when action_flag = ''DELETE'' then maker_dt else null end del_dt
        FROM maintain_log
        WHERE  TABLE_NAME = ''ODPROBRKAF'' or CHILD_TABLE_NAME = ''ODPROBRKAF'')
      group by TBLKEY) log,
      (select * from allcode
       where cdname = ''STATUS'' and cdtype = ''RE'') a1
 where oaf.refautoid=o.autoid
    and instr(log.TBLKEY,oaf.autoid) >0
    --and o.status=''A''
    and oaf.afacctno=af.acctno
    and af.custid=cf.custid
    and a0.cdval=o.PROBRKMSTTYPE and a0.CDTYPE = ''SA'' AND a0.CDNAME = ''PROBRKMSTTYPE''
    and cf.custid=re.afacctno(+)
    and oaf.tlid=tl.tlid(+)
    and o.autoid=chm.refautoid(+)
    and nvl(re.brid,cf.brid)=br.brid
    and log.maker_id = tl1.tlid(+)
    and log.del_id = tl2.tlid(+)
    and o.status = a1.cdval', 'RE.REMAST', 'frmREMAST', NULL, NULL, 0, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;