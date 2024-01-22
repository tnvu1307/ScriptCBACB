SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getcarebygroup(p_custid IN varchar2,p_txdate in date)
  RETURN VARCHAR2 IS
    v_Result VARCHAR2(20);
BEGIN
/*
Truyen vao custid cua moi gioi
Ham nay tra ve phong cua nv moi gioi do.
*/
   select refrecflnkid into v_Result
   from(
   select refrecflnkid
    from regrplnk
    where custid like p_custid
    and p_txdate >= frdate and p_txdate < todate
        )
    where rownum<=1 ;

    RETURN v_Result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN null;
END;
 
 
 
/
