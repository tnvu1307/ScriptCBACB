SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RE0000','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RE0000', 'Tra cứu tổ chức môi giới/đại lý', 'View orginazation chart of broker/remiser', 'select recf.brid , br.brname, SP_FORMAT_REGRP_MAPCODE(reg.autoid) PRGRPID, reg.fullname grfullname,REGL.custid,cf.fullname,
reg.grptype,
(select cdcontent from allcode where  cdtype =''RE'' and cdname =''ROLETYPE'' and cdval   = reg.grptype ) ROLETYPE
,CASE WHEN icc.ICTYPE=''F'' AND icc.RULETYPE=''F'' THEN to_char(icc.ICFLAT)
            WHEN icc.ICTYPE=''P'' AND icc.RULETYPE=''F'' THEN to_char(icc.ICRATE)||''%''
            WHEN icc.RULETYPE=''T'' THEN ''Bac Thang''
            WHEN icc.RULETYPE=''C'' THEN ''Luy Tien''
       END
ratecomm, nvl(tl.tlname,'''') tlname
from REGRP reg,regrplnk regl, cfmast cf,RECFLNK recf, brgrp br, remast re, tlprofiles tl,
(SELECT * FROM ICCFTYPEDEF WHERE MODCODE=''RE'') icc
where reg.autoid = regl.refrecflnkid
and regl.custid = cf.custid
and recf.custid = regl.custid
and recf.brid = br.brid
and regl.status <> ''C''
and regl.custid = re.custid
and re.actype=icc.actype
and recf.tlid = tl.tlid(+)
union
select  recf.brid , br.brname, SP_FORMAT_REGRP_MAPCODE(reg.AUTOID) prgrpid, reg.fullname grfullname,reg.custid,cf.fullname,
reg.grptype,
(select cdcontent from allcode where  cdtype =''RE'' and cdname =''ROLETYPE'' and cdval = case when reg.grptype = ''R''  THEN ''M''
     when reg.grptype = ''M''  THEN ''T''
     when reg.grptype = ''T''  THEN ''P''

END) ROLETYPE ,
CASE WHEN icc.ICTYPE=''F'' AND icc.RULETYPE=''F'' THEN to_char(icc.ICFLAT)
            WHEN icc.ICTYPE=''P'' AND icc.RULETYPE=''F'' THEN to_char(icc.ICRATE)||''%''
            WHEN icc.RULETYPE=''T'' THEN ''Bac Thang''
            WHEN icc.RULETYPE=''C'' THEN ''Luy Tien''
       END
ratecomm, nvl(tl.tlname,'''') tlname
from REGRP reg,  cfmast cf, brgrp br, recflnk recf, remast re, tlprofiles tl,
(SELECT * FROM ICCFTYPEDEF WHERE MODCODE=''RE'') icc
where reg.custid = cf.custid
and recf.brid = br.brid
and reg.custid = recf.custid
and reg.custid = re.custid
and recf.tlid = tl.tlid(+)
and re.actype=icc.actype', 'REGRP', 'frmREGRP', NULL, NULL, 0, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;