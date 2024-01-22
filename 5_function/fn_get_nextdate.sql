SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_nextdate(p_date date, p_prevnum number)
return date
is
l_prevdate date;
BEGIN
    -- HAM THUC HIEN LAY NGAY GD TRUOC NGAY HIEN TAI p_prevnum NGAY
    -- DUNG CHO CAC HAM CUA THENN, :D
    /*select max(sbdate)
        into l_prevdate
    from (
             select sb.sbdate from sbcldr sb
             where sb.cldrtype = '000' and sb.holiday = 'N' and sb.sbdate > p_date
             order by sb.sbdate)
     where rownum <= p_prevnum;
     return l_prevdate;*/
     -- SUA THEO CACH CUA GIANHVG -- 12-MAR-2012
     select TO_DATE(sbdate,systemnums.c_date_format) into l_prevdate from sbcurrdate where numday=(
        select numday from sbcurrdate
        where sbdate= p_date and sbtype='B'
        ) + p_prevnum
    and sbtype='B';
    return l_prevdate;
exception when others then
    return p_date + p_prevnum; --28/02/2017 DieuNDA: TH p_prevnum la so qua lon thi ngay lam vieck tiep theo = p_date + p_prevnum do bang lich chua sinh du lieu
end;
/
