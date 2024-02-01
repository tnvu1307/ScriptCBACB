SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('AFEXTRALIMIT_ALL','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('AFEXTRALIMIT_ALL', 'Khai báo hạn mức bổ sung', 'List of additional standard', 'select  af.acctno ,ft.actype AFTYPE,ft.typename AFFULLNAME, cf.custodycd CUSTID,  cf.fullname , '''' GROUPID, af.tlid, re.BROKERNAME TLNAME,'''' TLGROUPID, cf.mrloanlimit CUSTLIMIT,
aflt.mracclimit AFLIMIT, least((cf.mrloanlimit-aflt.mracclimit),(us.ALLOCATELIMMIT - uflt.mracclimit)) EXTRALIMITOLD
from cfmast cf, afmast af, aftype ft,
     (select cf.custid,nvl(re.brname,'' '') BRNAME, nvl(re.custid,'' '') BROKERID, nvl(re.fullname,'' '') BROKERNAME  from
            cfmast cf
            left join  vw_reinfo re
            on nvl(fn_getcarebydirectbroker(cf.custid,getcurrdate),-1) = re.autoid) re,
     (select tliduser,sum(decode(typereceive,''MR'',acclimit, 0)) mracclimit,sum(decode(typereceive,''DP'',acclimit, 0)) tcacclimit
       from useraflimit
       group by tliduser) uflt  ,
        (select ACCTNO,sum(decode(typereceive,''MR'',acclimit, 0)) mracclimit,sum(decode(typereceive,''DP'',acclimit, 0)) tcacclimit
         from useraflimit
         group by ACCTNO) aflt,
       (select ALLOCATELIMMIT,tliduser  from userlimit ) us


where cf.custid =af.custid
and af.actype = ft.actype
and af.custid= re.custid
and cf.tlid = uflt.tliduser
and cf.tlid = us.tliduser
and af.acctno=aflt.ACCTNO(+)
and af.acctno not in (select acctno from AFEXTRALIMIT where extralimit>=0)', 'AFEXTRALIMIT', 'frmAFEXTRALIMIT', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;