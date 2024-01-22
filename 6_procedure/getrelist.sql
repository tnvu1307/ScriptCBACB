SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE getrelist(
               pv_afacctno IN VARCHAR2, frdate date, todate date
        )
  IS
    v_count number;
    v_feeamt number;
BEGIN

     for vc in (select autoid from  regrp where custid = pv_afacctno and status ='A')
     loop
        begin
           for vc1 in (select custid from  regrplnk where refrecflnkid = vc.autoid and status = 'A')
           loop
            begin
                v_feeamt:=0;
                select sum(af.freeamt)
                into v_feeamt
                from reaf_log af, cfmast cf
                 where  cf.custid = af.afacctno
                 and af.txdate >= frdate   and af.txdate <= todate
                 and cf.opndate >=frdate and cf.opndate <=todate and af.reacctno= VC1.CUSTID;
                 insert into RELIST(custid,amt) values( vc1.custid,nvl(v_feeamt,0)) ;

                getRElist(vc1.custid,frdate,todate);

            end;
            end loop;
        end;
    end loop;

EXCEPTION when OTHERS then
   return;

END;

 
 
/
