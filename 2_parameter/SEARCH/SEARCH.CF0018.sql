SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CF0018','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CF0018', 'Danh sách cần xác nhận từ VSD hoàn tất thay đổi thông tin khách hàng', 'Accounts need VSD confirmation of changing customer information', 'select cfv.txnum || to_char(cfv.txdate,''DD/MM/RRRR'') txkey, cf.custodycd, cfv.*,
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
from cfvsdlog cfv, cfmast cf 
where cfv.custid = cf.custid and confirmtxdate is null and confirmtxnum is null
    and not exists ( select f.cvalue from
                                    tllog tl, tllogfld f where tl.txnum = f.txnum and
                                    tl.txdate = f.txdate and tl.tltxcd = ''0018'' and f.fldcd = ''18''
                                    and tl.txstatus in(''1'', ''4'') and f.cvalue = cfv.txnum)', 'CFMAST', 'frm', NULL, '0018', NULL, 5000, 'N', 1, 'NYNNYYYNNY', 'Y', 'T', 'CUSTODYCD', 'N', NULL);COMMIT;