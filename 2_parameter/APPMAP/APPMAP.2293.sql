SET DEFINE OFF;DELETE FROM APPMAP WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('2293','NULL');Insert into APPMAP   (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM) Values   ('2293', 'SE', '0043', '03', '14', NULL, NULL, NULL, 'ACCTNO', '@1', NULL, 0);Insert into APPMAP   (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM) Values   ('2293', 'SE', '0045', '03', '10', NULL, NULL, NULL, 'ACCTNO', '@1', NULL, 0);Insert into APPMAP   (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM) Values   ('2293', 'SE', '0042', '03', '10', NULL, NULL, NULL, 'ACCTNO', '@1', NULL, 0);Insert into APPMAP   (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM) Values   ('2293', 'SE', '0088', '03', '14', NULL, NULL, NULL, 'ACCTNO', '@1', NULL, 0);Insert into APPMAP   (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM) Values   ('2293', 'CF', NULL, NULL, NULL, NULL, NULL, NULL, 'ACCTNO', '@1', NULL, 0);COMMIT;