SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getcarebydirectbroker (
        p_afacctno IN VARCHAR2,
        p_date in date)
RETURN NUMBER
--Ham lay ra ma moi gioi cham soc
--Input: custid cua KH, ngay
--Output: AutoId cua NVMG co loai hinh la moi gioi
  IS
    l_result VARCHAR2(20);

BEGIN
    SELECT autoid into l_result
    from (
            select recf.autoid,recf.custid , reaf.status
            from recflnk recf, reaflnk reaf,
            (
                    select ret.actype, case when rerole='RM' then 1 else 2 end ord
                    from retype ret
                    --where ret.rerole IN ( 'RM','BM','DG','RD','CM')
            ) ret
            where recf.autoid = reaf.refrecflnkid
                 and reaf.frdate <= p_date and nvl(reaf.clstxdate,reaf.todate) > p_date
                 and recf.effdate <= p_date and recf.expdate > p_date
                 and reaf.afacctno = p_afacctno
                 and substr(reaf.reacctno,11,4) = ret.ACTYPE
            order by ret.ord asc, recf.autoid desc
            )
    where rownum<=1
            ;

    RETURN l_result;
   EXCEPTION
    WHEN others THEN
        return null;
END;
 
 
/
