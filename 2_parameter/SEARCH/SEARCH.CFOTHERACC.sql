SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CFOTHERACC','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CFOTHERACC', 'Thông tin đăng ký chuyển tiền trực tuyến tiểu khoản đã dang ký', 'Online cash transfer', 'SELECT *
FROM
(
    select cfo.AUTOID, cfo.bankcode, c1.cdcontent TRFTYPE, cf.custodycd, cf.fullname, cfo.cfcustid ,case when cfo.type = 0 then cfo.ciaccount else ''---'' end ciaccount,
        case when cfo.type = 0 then cfo.ciname else ''---'' end ciname,
        case when cfo.type = 1 then cfo.custid else ''---'' end custid,
        case when cfo.type = 1 then cfo.bankacc else ''---'' end bankacc,
        case when cfo.type = 1 then cfo.bankacname else ''---'' end bankacname,
        case when cfo.type = 1 then cfo.bankname else ''---'' end  bankname,
        nvl(cfo.acnidcode, ''---'') acnidcode,
        case when cfo.type = 1 then cfo.acniddate else null end acniddate,
        case when cfo.type = 1 then cfo.acnidplace else ''---'' end acnidplace,
        case when cfo.type = 1 then cfo.feecd else ''---'' end feecd,
        case when cfo.type = 1 then cfo.citybank else ''---'' end citybank,
        case when cfo.type = 1 then cfo.cityef else ''---'' end cityef,
        fee.feename, nvl(cfo.tlid,''---'') tlid, nvl(tl1.tlname,''---'') tlname,
        cfo.createddt, nvl(cfo.offid,''---'') offid, nvl(tl2.tlname,''---'') offname,
        nvl(tl3.tlname,nvl(tl2.tlname,''---'')) last_offname, cfo.apprvdt, nvl(cfo.last_apprvdt, cfo.apprvdt) last_apprvdt,
        (case when cfo.status in (''B'',''C'',''N'') then ''N'' else ''Y'' END) EDITALLOW,
        (case when cfo.status in (''P'') and ''<$BRID>'' = ''<$HO_BRID>'' then ''Y'' else ''N'' end) APRALLOW, ''Y'' DELALLOW
    from cfotheracc cfo, cfmast cf, allcode c1, feemaster fee, tlprofiles tl1, tlprofiles tl2, tlprofiles tl3
    where cfo.cfcustid = cf.custid(+)
        and cfo.deltd=''N''
        and c1.cdname = ''TYPE''
        and c1.cdtype = ''AF''
        and cfo.type = c1.cdval
        and cfo.feecd = fee.feecd(+)
        and cfo.tlid = tl1.tlid(+)
        and cfo.offid = tl2.tlid(+)
        and cfo.last_offid = tl3.tlid(+)
        --29/05/2015 TruongLD Modified, TT tai khoan bank --> khong can chan careby
        --and nvl(cf.careby,''0001'') IN (SELECT TLGRP.GRPID FROM TLGRPUSERS TLGRP WHERE TLID = ''<$TELLERID>'')
        --End TruongLD
    order by autoid
)
WHERE 0 = 0', 'CFOTHERACC', 'frmAFOTHERACC', '', '', NULL, 5000, 'N', 1, 'YYYYYYNNNNY', 'Y', 'T', '', 'N', '');COMMIT;