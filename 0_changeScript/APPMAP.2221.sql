SET DEFINE OFF;

DELETE FROM APPMAP WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('2221','NULL');

Insert into APPMAP
   (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM)
 Values
   ('2221', 'SE', '0045', '03', '10', NULL, '03', NULL, 'ACCTNO', '@1', NULL, 0);
Insert into APPMAP
   (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM)
 Values
   ('2221', 'SE', '0044', '03', '10', NULL, '03', NULL, 'ACCTNO', '@1', NULL, 0);
COMMIT;
