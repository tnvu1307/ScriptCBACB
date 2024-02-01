SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('BA0002','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('BA0002', 'Danh sách trái chủ được hưởng lãi', 'List of bondholders', 'select distinct bo.autoid, bo.camastid, bo.custodycd, cth.bankacname fullname, bo.quantity, bo.depositary, a1.en_cdcontent depositarycnt
     , case when bo.depositary <> ''Y'' then cth.bankacc else nos.bankacctno end bankacc
     , case when bo.depositary <> ''Y'' then cth.crbcitad else null end ciaccount
     , case when bo.depositary <> ''Y'' then cth.bankname else ''Shinhan Bank Viet Nam''  end bankname
     , case when bo.depositary <> ''Y'' then
            (select cfo.bankacc from cfotheracc cfo where cf.custid =cfo.cfcustid and cfo.defaultacct=''Y''and rownum=1)
       else
            (select dd.refcasaacct from ddmast dd where cf.custodycd = dd.custodycd  and dd.isdefault=''Y'' and rownum=1)
       end Bondholder_account
     , ROUND(bo.amount,0) AMOUNT
     , ROUND(case when (ca.pitratemethod=''IS'' and cf.country <> ''234'') or ca.pitratemethod=''SC'' then bo.tax else 0 end, 0) tax
     , ROUND(bo.amount, 0) - ROUND(case when (ca.pitratemethod=''IS'' and cf.country <> ''234'') or ca.pitratemethod=''SC'' then bo.tax else 0 end, 0) netamount
     , sb.symbol
     , case
                 when ca.catype =''015'' then ''Thanh toan Lai trai phieu ''
                 when ca.catype =''016'' then ''Thanh toan Goc va Lai trai phieu ''
                 else ''Mua lai trai phieu ''
       end ||ca.optsymbol||'' dinh ky ''||MONTHS_BETWEEN(TO_DATE(TO_CHAR(BOP.PAYMENTDATE,''MM/RRRR''),''MM/RRRR''),TO_DATE(TO_CHAR(BOP.BEGINDATE,''MM/RRRR''),''MM/RRRR'')) ||'' thang tu ''||TO_CHAR(BOP.BEGINDATE,''DD/MM/RRRR'')||'' den ''||TO_CHAR(BOP.PAYMENTDATE,''DD/MM/RRRR'') txdesc
from bondcaschd bo,cfmast cf,camast ca, sbsecurities sb, bondtypepay bop,
    (
        select * from banknostro bno where bno.banktype = ''001'' and bno.banktrans = ''INTRFBA'' and rownum = 1
    ) nos,
    (
        select ct.*, cr.citad crbcitad
        from cfotheracc ct, crbbanklist cr
        where ct.bankcode = cr.citad(+)
        and ct.deltd not in (''Y'')
        and ct.defaultacct = ''Y''
    ) cth,
    (select * from allcode where cdtype = ''SY'' and cdname = ''YESNO'') a1,
    (select * from allcode where cdtype = ''CB'' and cdname = ''PERIODINTEREST'') a2
where bo.custodycd = cf.custodycd
and bo.camastid = ca.camastid
and ca.optsymbol = sb.symbol
and bo.periodinterest = bop.autoid
and sb.periodinterest = a2.cdval(+)
and bo.depositary = a1.cdval(+)
and cf.custid = cth.cfcustid(+)
and bo.status = ''P'' and bo.deltd =''N''', 'BONDCASCHD', NULL, NULL, '1905', 0, 5000, 'Y', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;