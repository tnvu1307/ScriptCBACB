SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RM0009','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RM0009', 'Cảnh báo import lần 2', 'View warnning import 2', 'select cf.fullname,CF.CUSTODYCD, af.acctno,recf.brid,cf2.fullname refullname,CF.mobilesms,
        nvl(cb.balance,0) IMPBALANCE,
        (ci.balance -ci.holdbalance) balance,
        (ci.balance  + ci.holdbalance - ci.Odamt) amt,
        ci.holdbalance, getavlpp(af.acctno) PP0,
        ci.Odamt,
        ''Tinh trang lenh'' status
from cfmast cf,afmast af, crb_offline_bodsync cb, cimast ci,recflnk recf,cfmast cf2,
     (SELECT AFACCTNO, secureamt FROM v_getbuyorderinfo WHERE secureamt > 0) OD
where af.acctno = cb.afacctno
and fn_getcarebydirectbroker(cf.custid,getcurrdate)=recf.autoid
and recf.custid=cf2.custid
and cf.custid = af.custid
and ci.afacctno = af.acctno
and ci.afacctno = OD.afacctno (+)
AND CI.BALANCE - NVL(OD.secureamt,0) < 0', 'RM0009', NULL, NULL, NULL, 0, 1000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;