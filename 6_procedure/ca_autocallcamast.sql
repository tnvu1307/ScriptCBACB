SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca_autocallcamast
   IS
BEGIN
FOR  item in (select * from TLOG_CAMAST where status = 'P')
loop
    Begin
        ca_autocall3312(item.camastid);
    END;

    Begin
        ca_autocall3375(item.camastid);
    end;

     update TLOG_CAMAST set status ='A' where camastid = item.camastid;
end loop;
EXCEPTION
  WHEN OTHERS
   THEN
      ROLLBACK;
      RETURN;
END;
/
