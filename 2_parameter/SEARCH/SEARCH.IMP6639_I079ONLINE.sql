SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('IMP6639_I079ONLINE','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('IMP6639_I079ONLINE', 'Tra c?u thông tin import 6639_I079', 'Tra c?u thông tin import 6639_I079', '    select t.FTYPE,t.SYMBOL,t.VALUEDATE,t.AMOUNT,t.DESCRIPTION,t.BANKTRANSFERS,
           t.beneficiaryaccount,t.BENEFICIARYBANK,t.BENERFICARYNAME,t.TLIDIMP MAKER,''TABLE'' TYPE from(
        select * from PAYMENTINSTRUCTION_TARD_ETFEX
        union all
        select * from PAYMENTINSTRUCTION_TARD_ETFEX_HIST) t
    where 1=1', 'IMP6639_I079ONLINE', NULL, NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;