SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3347','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA3347', 'Giảm trái phiếu gốc tương ứng với SKQ trả gốc, lãi trái phiếu', 'Debit bond due to Bond maturity event', '
select * from (select max(a.autoid) autoid,a.camastid, a.description, b.symbol, a.actiondate ,a.actiondate POSTINGDATE, sum(chd.balance) qtty, max(cd.cdcontent) catype,
max(nvl(a.tocodeid,a.codeid)) codeid, max(b2.symbol) symbol_org, a.isincode
from camast a, sbsecurities b, caschd chd ,allcode cd, sbsecurities b2
where nvl(a.tocodeid,a.codeid) = b.codeid and a.status  in (''I'',''G'',''H'',''K'')
     and a.deltd<>''Y'' and a.camastid = chd.camastid and chd.deltd <> ''Y''
     and (select count(1) from caschd where camastid = a.camastid and status <> ''C'' and isSE =''N'' and amt>=0 and deltd=''N'') >0
     and cd.cdname =''CATYPE'' and cd.cdtype =''CA'' and cd.cdval = a.catype
     and b2.codeid=a.codeid and a.catype in (''033'')
     group by a.isincode, a.camastid, a.description, b.symbol, a.actiondate
     having sum(chd.amt) >= 0) where 0=0', 'CAMAST', '', 'AUTOID DESC', '3341', NULL, 5000, 'N', 30, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;