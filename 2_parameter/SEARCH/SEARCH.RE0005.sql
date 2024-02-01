SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RE0005','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RE0005', 'Tra cứu lịch sử gán môi giới vào nhóm', 'View history of assigning remiser to group', '
select * from (
select mst.*, tlp2.tlfullname tlname, regrp1.fullname oldgrpname, regrp2.fullname newgrpname, recf.tlid reuserid, tlp.tlname reusername
from
(
    select tl.txnum, tl.txdate, tl.tlid, tl.offid, tl.txtime,
        max(decode(fld.fldcd,''08'',fld.cvalue,null)) reacctno,
        max(decode(fld.fldcd,''03'',fld.cvalue,null)) recustid,
        max(decode(fld.fldcd,''04'',fld.cvalue,null)) refullname,
        max(decode(fld.fldcd,''05'',fld.cvalue,null)) frdate,
        max(decode(fld.fldcd,''06'',fld.cvalue,null)) todate,
        null OLDGROUPID,
        substr(max(decode(fld.fldcd,''91'',fld.cvalue,null)),-6) NEWGROUPID
    from vw_tllog_all_re tl, vw_tllogfld_re fld
    where tl.txnum = fld.txnum
        and tl.txdate =fld.txdate
        and tl.tltxcd = ''0382''
        and tl.deltd <> ''Y''
        and txstatus = ''1''
    group by tl.txnum, tl.txdate, tl.tlid, tl.offid, tl.txtime
          union all
    select tl.txnum, tl.txdate, tl.tlid, tl.offid, tl.txtime,
        max(decode(fld.fldcd,''03'',fld.cvalue,null)) reacctno,
        max(decode(fld.fldcd,''03'',fld.cvalue,null)) recustid,
        max(decode(fld.fldcd,''11'',fld.cvalue,null)) refullname,
        max(decode(fld.fldcd,''05'',fld.cvalue,null)) frdate,
        max(decode(fld.fldcd,''06'',fld.cvalue,null)) todate,
        max(decode(fld.fldcd,''20'',fld.cvalue,null)) OLDGROUPID,
        max(decode(fld.fldcd,''91'',fld.cvalue,null)) NEWGROUPID
    from vw_tllog_all_re tl, vw_tllogfld_re fld
    where tl.txnum = fld.txnum
        and tl.txdate =fld.txdate
        and tl.tltxcd = ''0383''
        and tl.deltd <> ''Y''
        and txstatus = ''1''
    group by tl.txnum, tl.txdate, tl.tlid, tl.offid, tl.txtime
          union all
    select tl.txnum, tl.txdate, tl.tlid, tl.offid, tl.txtime, tl.reacctno, tl.recustid, cf.fullname refullname, tl.frdate,
        tl.todate, substr(sp_format_regrp_mapcode(to_number(tl.OLDGROUPID)),-6) OLDGROUPID, tl.NEWGROUPID
    from cfmast cf,(
         select tl.txnum, tl.txdate, tl.tlid, tl.offid,  tl.txtime,
            max(decode(fld.fldcd,''03'',fld.cvalue,null)) reacctno,
            max(decode(fld.fldcd,''03'',fld.cvalue,null)) recustid,
            null frdate,
            null todate,
            max(decode(fld.fldcd,''20'',fld.cvalue,null)) OLDGROUPID,
            null NEWGROUPID
        from vw_tllog_all_re tl, vw_tllogfld_re fld
        where tl.txnum = fld.txnum
            and tl.txdate =fld.txdate
            and tl.tltxcd = ''0385''
            and tl.deltd <> ''Y''
            and txstatus = ''1''
        group by tl.txnum, tl.txdate, tl.tlid, tl.offid, tl.txtime
    ) tl where cf.custid=tl.recustid
) mst, recflnk recf, regrp regrp1, regrp regrp2, tlprofiles tlp, tlprofiles tlp2
where mst.recustid = recf.custid(+)
    and recf.tlid = tlp.tlid (+)
    and mst.tlid = tlp2.tlid(+)
    and mst.oldgroupid = regrp1.autoid(+)
    and mst.newgroupid = regrp2.autoid(+)
order by txdate asc, txtime asc, recustid asc)
where 0=0
    ', 'RE.REMAST', 'frmREMAST', NULL, NULL, 0, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;