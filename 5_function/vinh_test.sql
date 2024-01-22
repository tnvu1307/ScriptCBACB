SET DEFINE OFF;
CREATE OR REPLACE FUNCTION vinh_test
  RETURN CLOB IS
   bb            CLOB;
BEGIN
  SELECT EncodeBASE64(fileblob) into bb FROM fileupload  where autoid = '472';

  return bb;
END;
/
