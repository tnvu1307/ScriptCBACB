SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ST9943','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('ST9943', 'Tra cứu điện thông báo từ VSD (544, 546, 508)', 'Manage notification messages from VSD (544, 546, 508)', 'select v.vsdreqid REFID, v.vsdeffdate VSDMSGDATE,v.custodycd CUSTODYCD,v.sectype,A3.CDCONTENT IDTYPE,
case when INSTR(v.symbol,''ISIN'')>0 then ''''
    else case when v.sectype = ''PEND'' then v.symbol||''_WFT'' else v.symbol end
    end SYMBOL,
v.qtty QTTY,v.vsdsectype,v.DESCRIPTION description,l.msgtype MTTYPE , trf.CDCONTENT MTNAME ,
substr(v.refcustodycd,1,3) REFMEMBER,v.refcustodycd REFCUSTODYCD,A1.CDCONTENT FROMQTTY,A2.CDCONTENT TOQTTY ,v.vsdpromsg,
case when INSTR(v.symbol,''ISIN'')>0 then REPLACE(v.symbol,''ISIN '')
    else '''' end ISIN
from vsd_mt508_inf v,
 (select * from vsdtrflog
union all
select * from vsdtrfloghist)L,
 (select trfcode,en_description EN_CDCONTENT, description CDCONTENT from vsdtrfcode)trf,
(select * from allcode where cdtype = ''ST'' and cdname = ''FROMSE'')A1,(select * from allcode where cdtype = ''ST'' and cdname = ''FROMSE'')A2
,( SELECT * FROM allcode where cdname = ''VSDDEALTYPE'') A3,
(
    select max(to_date(decode(varname,''CURRDATE'',varvalue,''01/01/1900''),''DD/MM/RRRR'')) CURRDATE, max(decode(varname,''STPBKDAY'',to_number(varvalue),0)) STPBKDAY
    from sysvar where varname in (''CURRDATE'',''STPBKDAY'') and grname=''SYSTEM''
) sy
where l.autoid = v.vsdmsgid
and trf.trfcode = v.vsdpromsg
and v.FROMSE=A1.cdval(+)
and v.TOSE=A2.cdval(+)
and v.vsdsectype=A3.cdval(+)
and sy.currdate - v.vsdmsgdate <= sy.stpbkday', 'CFMAST', 'frmMT598', 'REFID DESC', '', 0, 5000, 'Y', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;