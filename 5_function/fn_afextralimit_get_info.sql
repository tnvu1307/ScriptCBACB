SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_AFEXTRALIMIT_get_Info( pv_Field IN VARCHAR2,pv_Acctno IN VARCHAR2, pv_User in VARCHAR2)
    RETURN VARCHAR2 IS
    v_Result  VARCHAR2(50);
  pkgctx plog.log_ctx;
BEGIN

   case  pv_Field
   when 'AFTYPE' THEN
       select ACTYPE into v_Result from afmast af where af.acctno = pv_Acctno;
   when 'AFFULLNAME' THEN
     select TYPENAME into v_Result  from afmast af, aftype ft where af.ACTYPE = ft.ACTYPE and af.acctno  = pv_Acctno;
   when 'CUSTODYCD' THEN
     select CUSTODYCD into v_Result  from afmast af, cfmast cf where af.custid = cf.custid and af.acctno  = pv_Acctno;
   when 'FULLNAME' THEN
     select FULLNAME into v_Result  from afmast af, cfmast cf where af.custid = cf.custid and af.acctno  = pv_Acctno;
   when 'TLNAME' THEN
      select BROKERNAME into v_Result
      from afmast af, (select cf.custid,nvl(re.brname,' ') BRNAME, nvl(re.custid,' ') BROKERID, nvl(re.fullname,' ') BROKERNAME  from
            cfmast cf
            left join  vw_reinfo re
            on nvl(fn_getcarebydirectbroker(cf.custid,getcurrdate),-1) = re.autoid) re
      where af.custid = re.custid and af.acctno  = pv_Acctno;

   when 'AFLIMIT' THEN
     select to_char( sum(decode(typereceive,'MR',acclimit, 0)) ) into v_Result
         from useraflimit
         where acctno  = pv_Acctno
         group by ACCTNO;
    when 'CUSTLIMIT' then
     select mrloanlimit into v_Result  from afmast af, cfmast cf where af.custid = cf.custid and af.acctno  = pv_Acctno;
   else
    v_Result:='0000';
   end case;


    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
