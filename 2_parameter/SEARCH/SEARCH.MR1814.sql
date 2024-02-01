SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR1814','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MR1814', 'Danh sách tiểu khoản chờ thu hồi hạn mức margin', 'General view of allocated to account', 'select cf.custid , cf.fullname, cf.custodycd, nvl(AF.groupleader,'''') ACCTNOGROUP,
       nvl(ual.mrcrlimitmax,0) mrcrlimitmax, ual.acctno, AFT.TYPENAME,aft.mnemonic, ual.tliduser
       , tl.tlname,
      GREATEST( LEAST(nvl(ual.mrcrlimitmax,0), round(round(nvl(ual1.mrcrlimitmax,0))
                - round(ci.dfodamt)
                - ROUND(nvl(ln.mrodamt,0))
                - round(nvl (b.advamt, 0)) +
       least(ci.balance - round(ci.trfbuyamt) - round(nvl(b.secureamt,0)) + round(nvl(adv.avladvance,0))
-- khong tinh phi luu ky
-- - round(ci.depofeeamt)
      ,0))),0) avlmrlimit
  ,CF1.FULLNAME REFULLNAME,cf1.custid recustid,
CF2.CUSTID REGRCUSTID, cf2.fullname REGRFULLNAME
from cfmast cf, afmast af, cimast ci, tlprofiles tl, aftype aft,
    (select acctno,  sum(acclimit) mrcrlimitmax
        from useraflimit where typereceive = ''MR''  group by acctno) ual1,
    (select acctno,tliduser,  sum(acclimit) mrcrlimitmax
        from useraflimit where typereceive = ''MR''  group by tliduser,acctno) ual,
    (select afacctno,sum(depoamt) avladvance
        from v_getAccountAvlAdvance  group by afacctno) adv,
    (
        Select ln.trfacctno, Sum(prinnml+prinovd+intnmlacr+intdue+intovdacr+intnmlovd+feeintnmlacr+feeintdue+feeintovdacr+feeintnmlovd) mrodamt
        from lnmast ln, lntype lnt where lnt.loantype =''CL''  and lnt.actype = ln.actype
        group by ln.trfacctno
    )ln, v_getbuyorderinfo b
  , (select distinct custid,refrecflnkid from  regrplnk where status = ''A'' group by custid,refrecflnkid)regl, regrp reg, cfmast cf1, cfmast cf2
where cf.custid = af.custid
      and af.acctno = ual.acctno
      and af.acctno = ual1.acctno
      and af.acctno = ci.afacctno
      and ual.tliduser = tl.tlid
      and af.acctno = ln.trfacctno (+)
      and af.acctno = adv.afacctno(+)
      and af.acctno = b.afacctno(+)
      and nvl(ual.mrcrlimitmax,0) > 0
      AND af.actype = aft.actype
    and substr(fn_get_broker(af.acctno,''AFACCTNO''),1,10) = regl.custid(+)
    and regl.refrecflnkid = reg.autoid(+)
    and substr(fn_get_broker(af.acctno,''AFACCTNO''),1,10) = cf1.custid(+)
    and reg.custid = cf2.custid(+)', 'MRTYPE', 'frmSATLID', 'TLIDUSER', '1814', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;