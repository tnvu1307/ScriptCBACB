SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3340','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA3340', 'Xác nhận thực hiện quyền với trung tâm lưu ký', 'Confirm CA action', 'select * from
(
    select a.camastid,max(a.autoid) autoid, max(a.description) description , max(b.symbol) symbol,
           max(a.actiondate) actiondate,max(a.REPORTDATE) REPORTDATE, max(cd.<@CDCONTENT>) catype, max(chd.codeid) codeid,
           sum((case when a.catype in (''010'',''015'',''016'',''027'',''024'',''033'',''023'') and cas.qtty =0 then nvl(chd.amt,0)
                    else nvl(chd.qtty,0) end)) QTTYDIS,
           sum((case when a.catype in (''027'') then nvl(chd.aqtty,0) else nvl(chd.qtty,0) end)) QTTY,
           sum(nvl(chd.amt,0)) AMT, nvl(max(a.tocodeid),max(a.codeid)) tocodeid, max(tosym.symbol) TOSYMBOL, a.isincode,nvl(a.formofpayment,''002'')
    from camast a, sbsecurities b, allcode cd, caschd chd, sbsecurities tosym, (select sum(qtty) qtty,camastid from caschd where deltd <> ''Y'' group by camastid) cas
    where a.codeid = b.codeid
    and (
        (chd.status IN(''V'',''F'',''M'') and a.catype in (''014'',''023'',''040''))
        or
        (chd.status IN(''A'') and a.catype not in (''023'',''014'',''003'',''029'',''030'',''031'',''032''))
    )
    and a.deltd=''N''
    and a.camastid= chd.camastid and chd.deltd <> ''Y''
    and a.camastid = cas.camastid(+)
    and cd.cdname =''CATYPE'' and cd.cdtype =''CA'' and cd.cdval = a.catype
    and a.catype not in (''019'')
    and nvl(a.tocodeid,a.codeid)=tosym.codeid
    group by a.camastid, a.isincode ,a.formofpayment
) where 0=0', 'CAMAST', NULL, 'AUTOID DESC', '3340', 0, 5000, 'N', 1, 'NYNNYYYNNY', 'Y', 'T', NULL, 'N', NULL);COMMIT;