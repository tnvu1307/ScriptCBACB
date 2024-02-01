SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RM6630','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RM6630', 'Danh sách duyệt lệnh chi hộ điện tử (6630)', 'View approval electronic payment order (6630)', '
select rm.txdate, rm.txnum, cf.custodycd, af.acctno, cf.fullname, rm.amt, rm.feeamt, rm.benefacct,
    rm.benefcustname, rm.bankid, rm.benefbank, rm.citybank, rm.cityef, rm.rmstatus,
    log.tlid, log.tlname, log.busdate, log.autoid
from CIREMITTANCE rm, afmast af, cfmast cf,(
        SELECT l.autoid,l.txdate,l.txnum,l.tlid,l.tltxcd, l.busdate, tl.tlname
        FROM tllog l, tlprofiles tl
        WHERE l.TLTXCD in (''1101'',''1111'',''1179'')
        AND l.TXSTATUS=''1'' and tl.tlid=l.tlid
    ) log
where rm.acctno=af.acctno and af.custid=cf.custid and rm.rmstatus=''A''
    and rm.txdate=log.txdate and rm.txnum=log.txnum and rm.DELTD <> ''Y''
    and not EXISTS (Select * from tllog tl where tl.tltxcd =''6630'' and txstatus =4 and tl.msgacct = af.acctno and tl.msgamt = rm.amt)
', 'CRBTRFLOG', NULL, NULL, '6630', 0, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;