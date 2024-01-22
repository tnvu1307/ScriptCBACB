SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('BA1002','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('BA1002', 'Danh sách phân bổ lãi cho trái chủ lưu ký tại SHV', 'List payment of interest for bondholders custody at SHV', 'select distinct bo.autoid, bo.camastid, bo.custodycd,cf.cifid, bo.fullname, bo.quantity
     , dd.acctno bankacc
     , bo.amount
     , case when ca.pitratemethod=''IS'' then bo.tax else 0 end tax
     , bo.amount - (case when ca.pitratemethod=''SC'' then 0 else bo.tax end) netamount
	 ,case
                 when ca.catype =''015'' then ''Thanh toán Lãi trái phiếu ''
                 when ca.catype =''016'' then ''Thanh toán Gốc và Lãi trái phiếu ''
                 else ''Mua lại trái phiếu ''
       end ||ca.optsymbol||'' định kỳ ''||MONTHS_BETWEEN(TO_DATE(TO_CHAR(BOP.PAYMENTDATE,''MM/RRRR''),''MM/RRRR''),TO_DATE(TO_CHAR(BOP.BEGINDATE,''MM/RRRR''),''MM/RRRR'')) 
	   ||'' tháng từ ''||TO_CHAR(BOP.BEGINDATE,''DD/MM/RRRR'')||'' đến ''
	   ||TO_CHAR(BOP.PAYMENTDATE,''DD/MM/RRRR'') txdesc 
from bondcaschd bo, allcode a1,cfmast cf,ddmast dd,
     camast ca, sbsecurities sb, allcode a2,bondtypepay bop 
where bo.status = ''A'' and bo.depositary=''Y'' 
and a1.cdtype = ''SY'' and a1.cdname = ''YESNO'' and a1.cdval = bo.depositary 
and bo.custodycd = cf.custodycd 
and bo.camastid = ca.camastid 
and ca.optsymbol = sb.symbol 
and bo.periodinterest = bop.autoid 
and dd.custodycd = cf.custodycd and  dd.STATUS <> ''C'' and dd.isdefault =''Y'' ', 'BONDCASCHD', '', '', '1915', 0, 5000, 'Y', 1, '', 'Y', 'T', '', 'N', '');COMMIT;