SET DEFINE OFF;
CREATE OR REPLACE function FN_GETSEMAST_BY_ACCTNO(PV_FIELD VARCHAR2 ,PV_ACCTNO IN VARCHAR2, PV_TXDATE DATE )
return number is
   v_return number;
begin
   v_return := 0;

   SELECT  NVL(SUM(CASE WHEN se.TXTYPE = 'C' THEN se.NAMT ELSE - se.NAMT END),0)
   INTO v_return
   FROM vw_setran_gen se
   WHERE se.deltd <>'Y'
   AND se.busdate  > PV_TXDATE
   AND se.ACCTNO = PV_ACCTNO
   AND se.FIELD LIKE PV_FIELD;

   return nvl(v_return,0);
exception
when others then
return 0;
end;

/
