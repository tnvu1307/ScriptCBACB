SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_RECFINGRP
(TXDATE, REACCTNO, RECUSTID, GRPID, GRPCODE, 
 LEADERCUSTID, QLMG)
AS 
select  to_date(varvalue,'DD/MM/YYYY') txdate, re.reacctno, re.custid recustid,grp.grpid, grp.grpcode, grp.custid leadercustid, 
    case when grp.qlmg='_' then grp.custid else grp.custid||'|'||grp.qlmg end qlmg
from regrplnk re, sysvar sys, 
    (
    select grp.autoid grpid, SP_FORMAT_REGRP_MAPCODE(grp.autoid) grpcode, grp.custid, fn_getallbrokergrplnk(grp.custid,to_date(varvalue,'DD/MM/YYYY')) qlmg
    from regrp grp, sysvar sys 
    where sys.grname = 'SYSTEM' AND sys.varname ='CURRDATE'
        and grp.effdate <= to_date(varvalue,'DD/MM/YYYY') and grp.expdate > to_date(varvalue,'DD/MM/YYYY')
    ) grp
where re.refrecflnkid=grp.grpid 
    and re.frdate <= to_date(varvalue,'DD/MM/YYYY') and re.todate > to_date(varvalue,'DD/MM/YYYY')
    and sys.grname = 'SYSTEM' AND sys.varname ='CURRDATE'
/
