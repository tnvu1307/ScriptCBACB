SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_RECFLNK_ACTIVE
(USERID, CUSTID, FULLNAME, IDCODE, IDDATE, 
 IDPLACE, AUTOID, ISAUTOTRF, AFACCTNO, EFFDATE, 
 EXPDATE, MINDREVAMT, MINIREVAMT, MININCOME, TAXRATE, 
 BALANCE, MINRATESAL, SALTYPE, TAXTYPE, MINCOMPLETED, 
 TYPERATED, BRID, BRNAME)
AS 
select mst.tlid userid, cf.custid, cf.fullname, cf.idcode, cf.iddate, cf.idplace, 
    mst.autoid, mst.isautotrf, mst.afacctno, mst.effdate, mst.expdate, mst.mindrevamt, mst.minirevamt, 
    mst.minincome, mst.taxrate, mst.balance, mst.minratesal, mst.saltype, mst.taxtype, mst.mincompleted, 
    mst.typerated, mst.brid, br.brname
from recflnk mst, cfmast cf, brgrp br
where mst.custid = cf.custid 
    and mst.brid = br.brid
    and mst.status = 'A'
/
