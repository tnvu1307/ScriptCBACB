SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('PRAFMAP','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('PRAFMAP', 'DS tiểu khoản', 'Sub-account list', '
select praf.AUTOID, praf.STATUS, praf.prcode,praf.afacctno, cf.custodycd, cf.fullname, FN_PRAFMAP_GET_PRCODE(praf.afacctno, praf.prcode) prcodelst ,
       nvl(brname,'' '') brname, nvl(brkid,'' '') REID, nvl(brkname,'' '') RE_NAME, nvl(grpname,'' '') REGRPNAME, af.careby CAREBY
from PRAFMAP praf, afmast af, cfmast cf , (
        select reaf.afacctno, reaf.reacctno, cf.custid brkid, cf.fullname brkname,  recf.brid, br.brname , nvl(regl.grpname,'' '') grpname, nvl(regl.grleader,'' '') grleader
        from reaflnk reaf, cfmast cf, recflnk recf, retype retyp, brgrp br, (
            select REGL.reacctno,REG.fullname grpname, a0.fullname grleader
            from regrp reg, regrplnk regl, cfmast a0
            where regl.status=''A'' and reg.status=''A'' and regl.refrecflnkid=reg.autoid and reg.custid=a0.custid ) regl
        where cf.custid=substr(reaf.reacctno,1,10)  and reaf.reacctno =  REGL.reacctno(+) and recf.custid=cf.custid
        and reaf.status=''A''  and recf.status=''A'' and reaf.frdate<=getcurrdate and reaf.todate>getcurrdate
        and   substr(reaf.reacctno,11) = retyp.ACTYPE AND  retyp.rerole IN ( ''RM'',''BM'') and br.brid= recf.brid
        ) re
where praf.afacctno=af.acctno and cf.custid=af.custid and  cf.custid=re.afacctno(+)  and praf.prcode = ''<$KEYVAL>''
order by cf.custodycd, praf.afacctno
', 'PR.PRAFMAP', 'BRID', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;