SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CF0012','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CF0012', 'Danh sách cần xác nhận trạng thái VSD', 'VSD status confirm', 'select CUSTID, FULLNAME, CUSTODYCD, IDCODE, ADDRESS, OPNDATE, c1.<@CDCONTENT> ACTIVESTS, c2.<@CDCONTENT> status,
       a3.<@CDCONTENT> ALTERNATE, a3.cdval ALTERNATECD, cf.IDDATE, cf.IDPLACE
from cfmast cf, allcode c1, allcode c2, allcode a3
where activests in (''N'',''P'') and isbanking = ''N'' and status = ''A'' and cf.custodycd is not null and cf.custodycd not like ''OTC%''
and c1.cdtype = ''CF'' and c1.cdname = ''ACTIVESTS'' and c1.cdval = cf.activests
and c2.cdtype = ''CF'' and c2.cdname = ''STATUS'' and c2.cdval = cf.status
AND (''VISD/'' || case when cf.idtype = ''001'' then ''IDNO''
                     when cf.idtype = ''002'' then ''CCPT''
                     when cf.idtype = ''005'' then ''CORP''
                     when cf.idtype = ''009'' and cf.custtype = ''B'' then ''FIIN''
                     when cf.idtype = ''009'' and cf.custtype = ''I'' then ''ARNU''
                     else ''OTHR''
                end) = a3.cdval AND a3.CDNAME =  ''VSDALTE_DISP'' AND a3.cdtype = ''CF''', 'CFMAST', 'frm', 'CUSTID', '0012', 0, 5000, 'N', 1, 'NNNNYNYNNY', 'Y', 'T', 'CUSTODYCD', 'N', NULL);COMMIT;