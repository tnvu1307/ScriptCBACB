SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_REINFO
(AUTOID, CUSTID, FULLNAME, TLID, BRID, 
 BRNAME)
AS 
select re.autoid, re.custid, cf.fullname, re.tlid, re.brid ,br.brname
    from recflnk re, cfmast cf, brgrp br, tlprofiles tl
    where re.custid=cf.custid and br.brid=re.brid
        and re.tlid=tl.tlid(+)
    and re.status='A'
/
