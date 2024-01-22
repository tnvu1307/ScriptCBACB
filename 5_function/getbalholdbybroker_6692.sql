SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getbalholdbybroker_6692 (p_afacctno IN VARCHAR2,p_memberid IN VARCHAR2)
RETURN NUMBER
  IS
    l_baldefavl NUMBER(20,2);
    l_hold NUMBER(20,2);
    l_unhold NUMBER(20,2);
BEGIN
l_baldefavl := 0;

select sum(to_number(nvl(tl.msgamt,0))) into l_hold
from tllog  tl, (select cvalue memberid, txnum from  tllogfld f where fldcd = '05') f, (select cvalue acctno, txnum from  tllogfld f where fldcd = '04') f2
where tl.txnum = f.txnum and tl.txnum = f2.txnum
and tl.tltxcd = '6692' and txstatus =1
and  f.memberid = p_memberid
and f2.acctno = p_afacctno;

select sum(to_number(nvl(tl.msgamt,0))) into l_unhold
from tllog  tl, (select cvalue memberid, txnum from  tllogfld f where fldcd = '05') f, (select cvalue acctno, txnum from  tllogfld f where fldcd = '04') f2
where tl.txnum = f.txnum and tl.txnum = f2.txnum
and tl.tltxcd = '6693' and txstatus =1
and  f.memberid = p_memberid
and f2.acctno = p_afacctno;

l_baldefavl:=nvl(l_hold,0)-nvl(l_unhold,0);

RETURN nvl(l_baldefavl,0);

EXCEPTION WHEN others THEN
    return 0;
END;
/
