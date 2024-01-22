SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CF0019','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CF0019', 'Theo dõi trạng thái nộp chứng từ gốc của yêu cầu thay đổi thông tin', 'Manage submitting document status of changing information request', 'select cfv.txnum || to_char(cfv.txdate,''DD/MM/RRRR'') txkey, cf.custodycd,cfv.custid,cfv.ofullname,cfv.nfullname,cfv.oaddress,cfv.naddress,cfv.oidcode,cfv.nidcode,cfv.oiddate,cfv.niddate,cfv.oidexpired
,cfv.nidexpired,cfv.oidplace,cfv.nidplace,cfv.otradingcode,cfv.ntradingcode,cfv.otradingcodedt,cfv.ntradingcodedt,cfv.txdate,cfv.txnum,cfv.confirmtxdate,cfv.confirmtxnum,cfv.ocusttype,cfv.ncusttype
,cfv.typeofdocument,ST.<@CDCONTENT> STATUS,ST.CDVAL STATUSTX,
 --cfv.*,
cfv.ofullname vofullname,
case when cfv.ofullname <> cfv.nfullname then cfv.nfullname else null end vnfullname,
cfv.oaddress voaddress,
case when cfv.oaddress <> cfv.naddress then cfv.naddress else null end vnaddress,
cfv.oidcode voidcode,
case when cfv.oidcode <> cfv.nidcode then cfv.nidcode else null end vnidcode,
cfv.oiddate voiddate,
case when cfv.oiddate <> cfv.niddate then cfv.niddate else null end vniddate,
cfv.oidexpired voidexpired,
case when cfv.oidexpired <> cfv.nidexpired then cfv.nidexpired else null end vnidexpired,
cfv.oidplace voidplace,
case when cfv.oidplace <> cfv.nidplace then cfv.nidplace else null end vnidplace,
cfv.otradingcode votradingcode,
case when cfv.otradingcode <> cfv.ntradingcode then cfv.ntradingcode else null end vntradingcode,
cfv.otradingcodedt votradingcodedt,
case when cfv.otradingcodedt <> cfv.ntradingcodedt then cfv.ntradingcodedt else null end vntradingcodedt
from cfvsdlog cfv, cfmast cf,
(
    select CDVAL , CDVAL VALUE, cdcontent ,
    EN_CDCONTENT  FROM ALLCODE WHERE CDTYPE=''CF'' AND CDNAME=''STATUS'' AND CDVAL IN (''R'',''NR'')
)ST
 where  cfv.custid = cf.custid --and confirmtxdate is null and confirmtxnum is null
    and ST.CDVAL = CFV.status
    and not exists ( select f.cvalue from
                                    tllog tl, tllogfld f where tl.txnum = f.txnum and
                                    tl.txdate = f.txdate and tl.tltxcd = ''0019'' and f.fldcd = ''87''
                                    and tl.txstatus in(''1'', ''4'') and f.cvalue = cfv.txnum)', 'CF0019', 'frm', '', '0019', NULL, 5000, 'N', 1, 'NYNNYYYNNY', 'Y', 'T', 'CUSTODYCD', 'N', '');COMMIT;