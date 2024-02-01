SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CASH_ACCOUNT_AITHER','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CASH_ACCOUNT_AITHER', 'Đồng bộ trạng thái tài khoản tiền từ Aither', 'Sync cash account status from Aither', 'select *from (
select a.autoid,A2.CDVAL TYPEVAL, A2.<@CDCONTENT> TYPE, a.cifid, cf.fullname custname, dd.ddacctno, a.bankaccount,
       cf.custodycd, nvl(dd.accounttype,a.accounttype) accounttype, a.status, a1.<@CDCONTENT> STATUSTEXT, p.tlname tlid, to_char(a.lastchange,''DD/MM/RRRR hh24:mi:ss'') lastchange,
       a.bankref, decode(a.accountstatus,''10'',''Open'',''Close'') accountstatus , dd.CACCOUNTSTATUS
from CASH_ACCOUNT_AITHER a,CFMAST CF,
     (select a2.<@CDCONTENT> CACCOUNTSTATUS, d.refcasaacct ,d.acctno ddacctno, d.accounttype
       from ddmast d,(select * from allcode where cdname = ''STATUS'' and cdtype = ''CI'')a2
       where d.status(+) = a2.cdval )dd,
     (select * from allcode where cdname = ''STATUS'' and cdtype = ''AD'')a1,tlprofiles p,
     (select *From allcode  where cdtype = ''RM'' and cdname = ''ACTIONTYPE'')a2
where a.status =a1.cdval AND A.TYPE = A2.CDVAL and a.status =''P'' and a.cifid=nvl(cf.mcifid,cf.cifid) and a.bankaccount = dd.refcasaacct(+) and  a.tlid=p.tlid (+) and a.type = ''01''
union all
select a.autoid,A2.CDVAL TYPEVAL, A2.<@CDCONTENT> TYPE, a.cifid, cf.fullname custname, dd.ddacctno, a.bankaccount,
       cf.custodycd, nvl(dd.accounttype,a.accounttype) accounttype, a.status, a1.<@CDCONTENT> STATUSTEXT, p.tlname tlid, to_char(a.lastchange,''DD/MM/RRRR hh24:mi:ss'') lastchange,
       a.bankref, decode(a.accountstatus,''10'',''Open'',''Close'') accountstatus , dd.CACCOUNTSTATUS
from CASH_ACCOUNT_AITHER a,CFMAST CF,
     (select a2.<@CDCONTENT> CACCOUNTSTATUS, d.refcasaacct ,d.acctno ddacctno, d.accounttype,d.custodycd
       from ddmast d,(select * from allcode where cdname = ''STATUS'' and cdtype = ''CI'')a2
       where d.status(+) = a2.cdval )dd,
     (select * from allcode where cdname = ''STATUS'' and cdtype = ''AD'')a1,tlprofiles p,
     (select *From allcode  where cdtype = ''RM'' and cdname = ''ACTIONTYPE'')a2
where a.status =a1.cdval AND A.TYPE = A2.CDVAL and a.status =''P'' and a.cifid=nvl(cf.mcifid,cf.cifid) and cf.custodycd = dd.custodycd and a.bankaccount = dd.refcasaacct(+) and  a.tlid=p.tlid (+) and a.type in (''02'',''11'')
)a where 0=0', 'CASH_ACCOUNT_AITHER', NULL, 'AUTOID desc', '6609', NULL, 50, 'N', 30, 'NNNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;