SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR0011','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MR0011', 'Theo dõi Hold thêm tiền các khoản T3 (6690)', 'Holdbalance for T3 account (6690)', 'select af.brid, cf.custodycd,af.acctno AFACCTNO,cf.fullname, aft.mnemonic,
    ci.balance,CI.odamt, ci.dueamt,ci.depofeeamt,trfbuyamt, nvl(b.execbuyamt,0) execbuyamt,
    ci.bankavlbal,
    ci.odamt + ci.depofeeamt + trfbuyamt + nvl(b.execbuyamt,0) -ci.balance ADDBALANCE,
    least (ci.odamt + ci.depofeeamt + trfbuyamt + nvl(b.execbuyamt,0) -ci.balance, ci.bankavlbal) bankholdamt,
    ci.dueamt + ci.depofeeamt totaldueamt
       from afmast af,cimast ci,cfmast cf,aftype aft,
       (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance group by afacctno) adv,
       (SELECT
                sum(case when od.feeacr >0 then od.execamt+od.feeacr else round(od.execamt*(1 + typ.deffeerate / 100),0) end) execbuyamt,
                od.afacctno
        FROM odmast od, odtype typ, sysvar sy_HOSTATUS, sysvar sy_CURRDATE
        WHERE od.actype = typ.actype
         AND od.txdate = to_date(sy_CURRDATE.VARVALUE,''DD/MM/RRRR'')
         AND deltd <> ''Y''
         AND od.exectype IN (''NB'', ''BC'')
         and od.stsstatus <> ''C''
         and sy_HOSTATUS.grname=''SYSTEM'' and sy_HOSTATUS.varname=''HOSTATUS''
         and sy_CURRDATE.grname=''SYSTEM'' and sy_CURRDATE.varname=''CURRDATE''
         group by od.afacctno ) b
       where af.corebank =''N'' and af.alternateacct=''Y''
       and af.custid = cf.custid and af.actype = aft.actype
       and af.acctno = ci.acctno
       and af.status <> ''C''
       and af.acctno = adv.afacctno(+)
       and af.acctno = b.afacctno(+)
       and CI.odamt + trfbuyamt + nvl(b.execbuyamt,0) - ci.balance>1', 'MRTYPE', NULL, NULL, '6690', 0, 5000, 'N', 1, 'NYNNYYYYYN', 'Y', 'T', NULL, 'Y', 'AFACCTNO');COMMIT;