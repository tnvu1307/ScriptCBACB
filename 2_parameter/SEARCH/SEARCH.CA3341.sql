SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3341','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA3341', 'Thực hiện quyền phân bổ chứng khoán vào tài khoản', 'Allocate stock CA', 'select * from (select max(a.autoid) autoid,a.camastid, a.description, b.symbol, a.actiondate ,a.actiondate POSTINGDATE,
  case when (a.catype = ''027'' ) then sum(chd.aqtty) else sum(chd.qtty) end qtty,
  max(cd.<@CDCONTENT>) catype,
  case when (a.cancelstatus =''Y'') then max(a.codeid) else max(nvl(a.tocodeid,a.codeid)) end codeid,
  max(b2.symbol) symbol_org, a.isincode, sum(chd.amt) cashamt,sum(aqtty) CONVERTED
from camast a, sbsecurities b, caschd chd ,allcode cd, sbsecurities b2
where nvl(a.tocodeid,a.codeid) = b.codeid and a.status  in (''I'',''G'',''H'')
     and a.deltd<>''Y'' and a.camastid = chd.camastid and chd.deltd <> ''Y''
     and  chd.status <> ''C'' and chd.isSE = ''N''
     and (chd.qtty > 0 or chd.aqtty > 0)
     and chd.deltd = ''N''
     and not exists (select * from tllog where msgacct = a.camastid and txstatus =''4'' and tltxcd =''3341'')
     and cd.cdname =''CATYPE'' and cd.cdtype =''CA'' and cd.cdval = a.catype
     and b2.codeid=a.codeid and a.catype not in (''017'',''023'',''020'')
     group by a.isincode, a.camastid, a.description, b.symbol, a.actiondate,a.catype,a.cancelstatus
     having case when a.catype = ''027'' then sum(chd.aqtty) else sum(chd.qtty) end <>0
    ) where 0=0', 'CAMAST', '', 'AUTOID DESC', '3341', 0, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;