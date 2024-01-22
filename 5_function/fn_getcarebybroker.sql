SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getcarebybroker(p_custid IN varchar2,p_txdate in date)
  RETURN VARCHAR2 IS
    v_Result VARCHAR2(20);
    l_nvql varchar2(20);
BEGIN
/*
Truyen vao custid cua khach hang
Ham nay tra ve nhan vien moi gioi quan ly KH do.
*/
    -- Xac dinh nhan vien gioi thieu khach hang, co the la nhan vien kinh doanh hoac moi gioi
    select max(mst.custid)
        into l_nvql
    from
    (
        select re.custid
        from remast re, reaflnk reaf
        where re.acctno = reaf.reacctno
        and reaf.afacctno = p_custid
        and p_txdate >= reaf.frdate and p_txdate < nvl(reaf.clstxdate,reaf.todate)
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
    ) where rownum <= 1;

    RETURN v_Result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN null;
END;
 
 
/
