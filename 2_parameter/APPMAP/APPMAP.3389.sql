SET DEFINE OFF;DELETE FROM APPMAP WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('3389','NULL');Insert into APPMAP   (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM) Values   ('3389', 'CA', '0031', '03', '10', NULL, NULL, NULL, 'CAMASTID', '@1', NULL, 0);Insert into APPMAP   (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM) Values   ('3389', 'CA', '0038', '03', '12', NULL, NULL, NULL, 'CAMASTID', '75', NULL, 0);Insert into APPMAP   (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM) Values   ('3389', 'CA', '0036', '03', '08', NULL, NULL, NULL, 'CAMASTID', '14', NULL, 0);Insert into APPMAP   (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM) Values   ('3389', 'CA', '0035', '03', '07', NULL, NULL, NULL, 'CAMASTID', '14', NULL, 0);Insert into APPMAP   (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM) Values   ('3389', 'CA', '0034', '03', '06', NULL, NULL, NULL, 'CAMASTID', '75', NULL, 0);COMMIT;