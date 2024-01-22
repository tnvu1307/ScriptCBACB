SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_insert_odauth_log(p_orderid in varchar2,p_acctno in varchar2,p_codeid in varchar2,p_otauthtype in varchar2,p_ipaddress in varchar2,p_orderdata in varchar2,p_err_code out varchar2,p_err_message out varchar2)
IS
    l_afacctno varchar2(20);
    l_via varchar2(5);
    l_exectype varchar2(5);
begin
    begin
        select afacctno, via, exectype into l_afacctno, l_via, l_exectype
        from
        (select orderid, afacctno, via, exectype from odmast
            union all
            select acctno, afacctno, via, exectype from fomast)
        where orderid=p_orderid;
    exception when others then
        l_afacctno:='';
        l_via:='';
        l_exectype:='';
    end;

    if l_afacctno is not null then
        insert into odauth_log(autoid, orderid, acctno, codeid, otauthtype, ipaddress, orderdata, lastchange, via, exectype)
        values(seq_odauth_log.nextval, p_orderid, l_afacctno, p_codeid, p_otauthtype, p_ipaddress, p_orderdata, sysdate, l_via, l_exectype);
    end if;

    p_err_code    := '0';
    p_err_message := 'Cap nhat log ODAUTH thanh cong';
exception
  when NO_DATA_FOUND then
    p_err_code    := '-1';
    p_err_message := 'Cap nhat log ODAUTH khong thanh cong';
    rollback;
  when others then
    p_err_code    := '-2';
    p_err_message := 'Cap nhat log ODAUTH khong thanh cong';
    rollback;
end;
 
 
/
