SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getseholdbybroker (p_afacctno IN VARCHAR2,p_codeid IN VARCHAR2, p_memberid IN varchar2)
RETURN NUMBER
  IS
    l_hold NUMBER(20,2);
    l_unhold NUMBER(20,2);
    l_baldefavl NUMBER(20,2);
BEGIN
l_baldefavl := 0;
/*
select nvl(sum(to_number(tl.msgamt)),0) into l_hold
from tllog  tl, (select cvalue memberid, txnum from  tllogfld f where fldcd = '05') f, (select cvalue acctno, txnum from  tllogfld f where fldcd = '03') f2
where tl.txnum = f.txnum and tl.txnum = f2.txnum
and tl.tltxcd = '2212' and txstatus =1
and  f.memberid = p_memberid
and f2.acctno = p_afacctno||p_codeid;


select nvl(sum(to_number(tl.msgamt)),0) into l_unhold
from tllog  tl, (select cvalue memberid, txnum from  tllogfld f where fldcd = '05') f, (select cvalue acctno, txnum from  tllogfld f where fldcd = '03') f2
where tl.txnum = f.txnum and tl.txnum = f2.txnum
and tl.tltxcd = '2213' and txstatus =1
and  f.memberid = p_memberid
and f2.acctno = p_afacctno||p_codeid;
*/
select totalhold - (totalunhold +unhold_no_broker) into l_baldefavl  from buf_se_member b, sbsecurities sb,cfmast cf
    where   b.symbol  =sb.symbol
        and sb.codeid = p_codeid
        and b.members = p_memberid
        and b.custodycd = cf.custodycd
        and cf.custid = p_afacctno

;
--l_baldefavl:= nvl(l_hold,0) - nvl(l_unhold,0);

RETURN l_baldefavl;

EXCEPTION WHEN others THEN
    return 0;
END;
/
