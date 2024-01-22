SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('BA0003','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('BA0003', 'Điều chỉnh số tiền được nhận', 'Adjust the amount received', 'select bo.autoid, bo.camastid, bo.custodycd, bo.fullname, bo.quantity, bo.depositary, a1.en_cdcontent depositarycnt
     , ROUND(bo.amount, 0) AMOUNT
     , ROUND(case when cf.vat = ''Y'' then bo.tax else 0 end, 0) tax
     , ROUND(case when cf.vat = ''Y'' then bo.netamount else bo.amount end, 0) netamount
     , ca.pitratemethod, a2.en_cdcontent pitratemethodcnt
from bondcaschd bo, allcode a1, allcode a2,cfmast cf, camast ca
where bo.status = ''P''
and a1.cdtype = ''SY'' and a1.cdname = ''YESNO'' and a1.cdval = bo.depositary
and bo.custodycd = cf.custodycd
and bo.camastid = ca.camastid
and a2.cdtype = ''CA'' and a2.cdname = ''PITRATEMETHOD'' and a2.cdval = ca.pitratemethod', 'BONDCASCHDEDIT', '', '', '1906', 0, 5000, 'Y', 1, '', 'Y', 'T', '', 'N', '');COMMIT;