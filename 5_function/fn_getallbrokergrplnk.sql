SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getallbrokergrplnk(p_custid_mg IN varchar2,p_txdate in date)
  RETURN VARCHAR2 IS
    v_custid  VARCHAR2(15);
    v_str VARCHAR2(200);
    v_count NUMERIC;
    v_custid_ql VARCHAR2(15);
    /*
    Input: Ma MG, Ngay
    Output: Ma MG va Ma cac MG cap tren cua MG do
    VD: MG 0001000001 qly MG 0001000002, MG 0001000002 qly MG 0001000003
        Nhap vao ma MG 0001000003 va ngay
        --> xuat ra 0001000003|0001000002|0001000001
    */
BEGIN

    v_custid:=p_custid_mg;
    v_str:='_';
    v_count:=1;
    while v_count>0
    loop

        select count(*), max(grp.custid) into v_count,v_custid_ql
        from regrplnk lnk, regrp grp
        where lnk.refrecflnkid = grp.autoid
            and lnk.custid = v_custid
            --and lnk.status='A' and grp.status='A'
            and p_txdate >= lnk.frdate and p_txdate <  nvl(lnk.clstxdate,lnk.todate) and lnk.deltd<>'Y'
            and p_txdate >= grp.effdate and p_txdate < grp.expdate
            ;

        if(v_count > 0)
        then
            if (v_str='_') then
                v_str:=v_custid_ql;
            else
                v_str:=v_str||'|'||v_custid_ql;
            end if;
            v_custid:=v_custid_ql;
        end if;

    end loop;

    return  v_str;

EXCEPTION
   WHEN OTHERS THEN
    RETURN null;
END;
 
 
/
