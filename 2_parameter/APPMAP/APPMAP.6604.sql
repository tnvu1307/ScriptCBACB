SET DEFINE OFF;DELETE FROM APPMAP WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('6604','NULL');Insert into APPMAP   (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM) Values   ('6604', 'DD', '0003', '03', '10', NULL, NULL, NULL, 'ACCTNO', '@1', NULL, 0);Insert into APPMAP   (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM) Values   ('6604', 'DD', '0004', '03', '10', NULL, NULL, NULL, 'ACCTNO', '@1', NULL, 0);COMMIT;