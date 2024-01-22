SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getallcusbybroker(p_custid IN varchar2,p_txdate in date)
  RETURN VARCHAR2 IS
    v_Result VARCHAR2(20);
    l_tp number;
BEGIN
/*
Truyen vao ma cua moi gioi, ngay
Ham nay tra ve nguoi quan mg nay
*/
    -- xac dinh mg co la truong phong hay khong?
    select count(*) into l_tp
    from regrp where custid= p_custid and p_txdate BETWEEN effdate and expdate;

    begin
    if l_tp > 0 then
        v_Result := p_custid;
    else
        select reg.custid into v_Result
        from (select refrecflnkid from regrplnk where p_txdate BETWEEN frdate and todate and SUBSTR(reacctno,1,10)=p_custid) grl,
                (select autoid,custid from regrp where p_txdate BETWEEN effdate and expdate) reg
        where grl.refrecflnkid=reg.autoid;
    end if;
    EXCEPTION
    when OTHERS then
       v_Result := p_custid;
    end;
   /* select max(mst.custid)
        into l_nvql
    from
    (
        select re.custid
        from remast re, reaflnk reaf
        where re.acctno = reaf.reacctno
        and reaf.afacctno = p_custid
        and p_txdate >= reaf.frdate and p_txdate < reaf.todate
        group by re.custid, reaf.frdate
        order by reaf.frdate desc
    ) mst
    where rownum <= 1;

    -- Xac dinh moi gioi dung ra cham soc
    select max(recustid)
        into v_Result
    from
    (
    select substr(nvl(reacctno,afacctno),1,10) recustid
    from reaflnk re
    where substr(re.reacctno,1,10) = l_nvql
    group by substr(nvl(reacctno,afacctno),1,10), status
    order by case when status = 'A' then 0 else 1 end
    ) where rownum <= 1;*/

    RETURN v_Result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN null;
END;
 
 
/
