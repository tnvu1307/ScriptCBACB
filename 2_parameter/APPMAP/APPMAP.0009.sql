SET DEFINE OFF;DELETE FROM APPMAP WHERE 1 = 1 AND NVL(TLTXCD,'NULL') = NVL('0009','NULL');Insert into APPMAP   (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM) Values   ('0009', 'CF', '0030', '03', '<$BUSDATE>', NULL, '03', 'CF', 'ACCTNO', '@1', NULL, 0);Insert into APPMAP   (TLTXCD, APPTYPE, APPTXCD, ACFLD, AMTEXP, COND, ACFLDREF, APPTYPEREF, FLDKEY, ISRUN, TRDESC, ODRNUM) Values   ('0009', 'CF', '0101', '03', '10', NULL, '03', 'CF', 'ACCTNO', '@1', NULL, 0);COMMIT;