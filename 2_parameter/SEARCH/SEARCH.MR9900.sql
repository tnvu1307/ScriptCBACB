SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR9900','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MR9900', 'Thặng dư tài sản nhóm tài khoản FIT', 'FIT asset surplus', 'select cf.custodycd, cf.fullname,af.acctno , aft.mnemonic, getavlpp(af.acctno) pp,
           --1.Tien tren tieu khoan
           mst.BALANCE - mst.holdbalance balance, --Tien tren tieu khoan
           --2.Tong gia tri chung khoan
           mst.TOTALSEAMT,
           --3.Tong phai tra
           mst.TOTALODAMT, --Tong phai tra
           --4. Tai san thuc co = 1+2-3
           mst.balance - mst.holdbalance + mst.totalseamt - mst.totalodamt NETASSVAL
 from cfmast cf, afmast af , aftype aft,
(
    select      cim.acctno,
                round(ci.balance + ci.bamt  + ci.rcvamt + ci.tdbalance + ci.crintacr + ci.tdintamt ) BALANCE, --Tien tren tieu khoan
                nvl(sec.mrqttyamt_curr,0) + nvl(sec.nonmrqttyamt_curr,0) + nvl(sec.dfqttyamt_curr,0) TOTALSEAMT,
                ci.dfodamt + ci.t0odamt + ci.mrodamt
                        + ci.ovdcidepofee + ci.execbuyamt + ci.trfbuyamt + ci.rcvadvamt + TDODAMT TOTALODAMT, --Tong phai tra
                    cim.holdbalance

            from buf_ci_account ci, afmast af, cimast cim,
                (select afacctno,
                    sum(case when mrratioloan>0 then  QTTY*BASICPRICE else 0 end) MRQTTYAMT,
                    sum(case when mrratioloan>0 then  QTTY*currprice else 0 end) MRQTTYAMT_CURR,
                    sum(case when mrratioloan>0 then  QTTY*BASICPRICE*mrratioloan/100  else 0 end) MR_QTTYAMT,
                    sum(case when mrratioloan>0 then  0 else QTTY*BASICPRICE end) NONMRQTTYAMT,
                    sum(case when mrratioloan>0 then  0 else QTTY*currprice end) NONMRQTTYAMT_CURR,
                    sum(DFQTTY * BASICPRICE) DFQTTYAMT,
                    sum(DFQTTY * currprice) DFQTTYAMT_CURR,
                    sum(case when mrratioloan>0 then  buyingqtty*BASICPRICE else 0 end) MRQTTYAMT_BUY,
                    sum(case when mrratioloan>0 then  buyingqtty*BASICPRICE*mrratioloan/100  else 0 end) MR_QTTYAMT_BUY,
                    sum(case when mrratioloan>0 then  0 else buyingqtty*BASICPRICE end) NONMRQTTYAMT_BUY
                 from (
                        select afacctno,mrratioloan,basicprice,nvl(st.closeprice,basicprice) currprice,
                                 AVLMRQTTY qtty,AVLDFQTTY dfqtty,
                                 buyingqtty
                                 from buf_se_account se, sbsecurities sb ,stockinfor st
                                 where se.codeid= sb.codeid and sb.symbol = st.symbol(+)
                    ) SE group by afacctno

                ) sec
            where ci.afacctno = af.acctno and af.acctno = cim.acctno
            and  ci.afacctno = sec.afacctno(+)

) mst
where cf.custid = af.custid and af.actype = aft.actype
and cf.status <>''C'' and cf.careby =''1032''
and af.acctno = mst.acctno', 'CFMAST', NULL, NULL, NULL, NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;