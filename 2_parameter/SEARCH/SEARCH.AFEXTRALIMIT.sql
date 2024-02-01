SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('AFEXTRALIMIT','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('AFEXTRALIMIT', 'Khai báo hạn mức bổ sung', 'List of additional standard', 'select distinct ex.autoid,ex.ACCTNO,ex.status,
(CASE WHEN ex.STATUS=''P'' THEN ''Y'' ELSE ''N'' END) APRALLOW,
ex.extralimit,ft.actype AFTYPE,ft.typename AFFULLNAME, cf.custodycd CUSTID,  cf.fullname , '''' GROUPID, af.tlid, re.BROKERNAME TLNAME,'''' TLGROUPID, cf.mrloanlimit CUSTLIMIT,
aflt.mracclimit AFLIMIT, least((cf.mrloanlimit-aflt.mracclimit),(us.ALLOCATELIMMIT - uflt.mracclimit)) EXTRALIMITOLD,
(
  select sum(nvl(ln.odamt,0)) from LNPROBRKLOG ln
   where ln.afacctno=AF.ACCTNO  and ln.symbol in
  (select symbol from AFEXTRALIMITSYMBOL S,AFEXTRALIMIT E where S.REFID= E.AUTOID and E.ACCTNO = AF.ACCTNO  and E.extralimit >0)
) DEPT,
 (select sum(nvl(ln1.odamt,0)) from LNPROBRKLOG ln1
   where ln1.afacctno=AF.ACCTNO ) DEPT_FULL,
  (aflt.mracclimit-ex.extralimit) freeLimit,
  --HM chua d? n?
  --max( H?n m?c c??u ki?n ? T?ng n? theo m?K;0)
   --N?u T?ng n? > H?n m?c kh?c??u ki?n
 CASE WHEN ((select sum(nvl(ln3.odamt,0)) from LNPROBRKLOG ln3 where ln3.afacctno=AF.ACCTNO ) >(aflt.mracclimit-ex.extralimit) ) --tong du no hien tai > han muc khong dk
   and (  select sum(nvl(ln2.odamt,0))
          from LNPROBRKLOG ln2  --du no ma khong dk  > han muc khong dk
          where ln2.afacctno=AF.ACCTNO  and ln2.symbol not in
                 (select symbol
                  from AFEXTRALIMITSYMBOL S,AFEXTRALIMIT E
                  where S.REFID= E.AUTOID and E.ACCTNO = AF.ACCTNO  and E.extralimit >0))
           >
           (aflt.mracclimit-ex.extralimit)

    THEN   GREATEST( (select sum(nvl(ln3.odamt,0)) -  (aflt.mracclimit-ex.extralimit) from LNPROBRKLOG ln3
                       where ln3.afacctno=AF.ACCTNO  and ln3.symbol not in
           (select symbol from AFEXTRALIMITSYMBOL S1,AFEXTRALIMIT E1 where S1.REFID= E1.AUTOID and E1.ACCTNO = AF.ACCTNO  and E1.extralimit >0)),0  )
    ELSE 0 end EXDEPT
from cfmast cf, afmast af, aftype ft,AFEXTRALIMIT EX,LNPROBRKLOG ln1  ,
     (select cf.custid,nvl(re.brname,'' '') BRNAME, nvl(re.custid,'' '') BROKERID, nvl(re.fullname,'' '') BROKERNAME  from
            cfmast cf
            left join  vw_reinfo re
            on nvl(fn_getcarebydirectbroker(cf.custid,getcurrdate),-1) = re.autoid) re,
     (select tliduser,sum(decode(typereceive,''MR'',acclimit, 0)) mracclimit,sum(decode(typereceive,''DP'',acclimit, 0)) tcacclimit
       from useraflimit
  --     where  TLIDUSER = ''<$TELLERID>''
       group by tliduser) uflt  ,
        (select ACCTNO,sum(decode(typereceive,''MR'',acclimit, 0)) mracclimit,sum(decode(typereceive,''DP'',acclimit, 0)) tcacclimit
         from useraflimit
         group by ACCTNO) aflt,
       (select TLIDUSER,ALLOCATELIMMIT  from userlimit ) us


where cf.custid =af.custid
and af.actype = ft.actype
and af.custid= re.custid
and cf.tlid = uflt.tliduser
and af.acctno = ex.acctno
and cf.tlid = us.tliduser
and af.acctno=aflt.ACCTNO(+)', 'AFEXTRALIMIT', 'frmAFEXTRALIMIT', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;