SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CRBUNHOLD','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CRBUNHOLD', 'Qu?n lý  Unhold', 'Unhold management', 'Select BATCHNAME,reqid AutoID,''Y'' ISAUTO,
cr.bankcode,crb.bankname,substr(refcode, 11,10)
txnum,cr.txdate,cr.objname,cr.afacctno,cr.bankacct
,trfcode,(txamt - nvl(h.amt,0)) So_tien, (txamt - nvl(h.amt,0)) unholdamount ,notes,
( Case when cr.status =''P'' then ''Chờ gửi''
       when cr.status =''C'' then ''Thành công''
       when cr.status =''E'' then ''Có lỗi'' else
cr.status end ) status
   ,errorcode ,af.autotrf,
de.errdesc ErrDesc,cf.custodycd,cf.fullname
from
vw_CRBTXREQ_all cr, deferror de , crbdefbank crb, cfmast cf, afmast af, vw_tllog_all tl,
   (select sum(amt) amt, txnum
            from HOLDBASEON6600
            where deltd <> ''Y''
            group by txnum) h
Where cr.errorcode=de.errnum(+)
and  trfcode=''UNHOLD''
and cr.bankcode = crb.bankcode
and cr.afacctno=af.acctno
and af.custid=cf.custid
and substr(refcode, 11,10) = h.txnum(+)
and cr.txdate = getcurrdate
AND txamt > nvl(h.amt,0)
and tl.txdate =getcurrdate
and tl.tltxcd  =''6600''
and tl.txnum = substr(refcode, 11,10)
   -- chi lay 6600 tu batch giua ngay
and batchname =''BAMTTRF''', 'CRBUNHOLD', '', '', '6692', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;