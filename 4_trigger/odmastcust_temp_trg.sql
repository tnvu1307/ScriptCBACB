SET DEFINE OFF;
CREATE OR REPLACE TRIGGER ODMASTCUST_TEMP_TRG 
BEFORE INSERT ON ODMASTCUST_TEMP
FOR EACH ROW
BEGIN
  SELECT ODMASTCUST_TEMP_autoid_seq.nextval
  INTO :new.autoid
  FROM dual;
END;
/
