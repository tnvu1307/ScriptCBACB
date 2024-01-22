SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_REAFLNK_BEFORE 
 before
  INSERT 
 ON reaflnk
REFERENCING NEW AS NEWVAL 
 FOR EACH ROW
DISABLE
DECLARE
BEGIN
       --tu dong gen recfcustid
        IF :NEWVAL.recfcustid is null then
            :NEWVAL.recfcustid :=substr(:NEWVAL.reacctno,1,10);
        END IF;
       
    
END;
/
