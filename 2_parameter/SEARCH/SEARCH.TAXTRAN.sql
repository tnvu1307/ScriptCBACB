SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('TAXTRAN','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('TAXTRAN', 'Theo dõi các loại thuế của KH', 'Manage customer taxes', 'select DT.FEECD,FORP,FEEBILL,POSTDATE,CF.CUSTID,CF.custodycd,CF.FULLNAME,CURRENCY,FEEAMOUNT,CIF.PAIDTXDATE PAIDDATE,''THU PHÍ '' || TO_CHAR(TO_DATE(CIF.TODATE,''DD/MM/RRRR''),''MM/RRRR'') DESCRIPTION,TRASCATIONCD,AMC
from
(
    select fee.FEECD,'' '' FORP,SUBSTR(tl.txdate,4,2) FEEBILL,tl.txdate POSTDATE, '''' CURRENCY, fee.feeamt FEEAMOUNT,tl.tltxcd TRASCATIONCD, '''' AMC
    FROM tllog4dr tl,tllogfld4dr tlfld,feetran fee
    WHERE tl.txnum = tlfld.txnum AND tl.txdate = tlfld.txdate
      and tl.deltd <> ''Y'' --and tl.txstatus =''4''
      and fee.txnum = tl.txnum
    and not  EXISTS (select 1 from tllog t where t.txnum = tl.txnum and t.deltd<>''Y'' and txstatus =''1'')
)DT, AFMAST AF, CFMAST CF,CIFEESCHD CIF

where CIF.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID', 'taxtran', 'frmTAX', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;