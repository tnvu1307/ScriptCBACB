SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR1808','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MR1808', 'Quản lý hạn mức User cấp cho tiểu khoản', 'General view of allocated to account', 'select cf.custid, tl.tlname , cf.fullname, cf.custodycd, nvl(AF.groupleader,'''') ACCTNOGROUP,
       nvl(ual.dpcrlimitmax,0) dpcrlimitmax, ual.acctno,UAL.tliduser, AFT.TYPENAME,aft.mnemonic,
       
       
        
  GREATEST( 
             LEAST( round(    round(nvl(ual1.dpcrlimitmax,0))  - ROUND(nvl(ln.dpodamt,0))  - round(nvl (b.advamt, 0)) 
                             + least(ci.balance - round(ci.trfbuyamt) - round(nvl(b.secureamt,0)) + round(nvl(adv.avladvance,0)),0)
                          )
                           
                    ,nvl(ual.dpcrlimitmax,0)
                   )
          ,0) avldplimit
        
from cfmast cf, afmast af, cimast ci, aftype aft, tlprofiles tl, 
   (    Select ln.trfacctno, Sum(ln.prinnml+ln.prinovd+ln.intnmlacr+ln.intdue+ln.intovdacr+ln.intnmlovd+ln.feeintnmlacr
                                  +ln.feeintdue+ln.feeintovdacr+ln.feeintnmlovd) dpodamt
        from lnmast ln, lntype lnt where lnt.loantype =''DP''  and lnt.actype = ln.actype
        group by ln.trfacctno
    )ln,
    (select tliduser,acctno , sum(acclimit) dpcrlimitmax 
        from useraflimit where typereceive = ''DP'' group by tliduser,acctno ) ual,
 (select acctno , sum(acclimit) dpcrlimitmax 
        from useraflimit where typereceive = ''DP'' group by acctno ) ual1,
    (select afacctno,sum(depoamt) avladvance 
        from v_getAccountAvlAdvance  group by afacctno) adv, v_getbuyorderinfo b
where cf.custid = af.custid 
      and af.acctno = ual.acctno 
      and af.acctno = ual1.acctno 
      and ual.tliduser = tl.tlid
      and af.acctno = ci.afacctno 
      and af.acctno = ln.trfacctno (+)
      and af.acctno = adv.afacctno(+) 
      and af.acctno = b.afacctno(+) 
      and nvl(ual.dpcrlimitmax,0) > 0
      AND af.actype = aft.actype', 'MRTYPE', 'frmSATLID', NULL, '1808', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;