SET DEFINE OFF;DELETE FROM APPTX WHERE 1 = 1 AND NVL(APPTYPE,'NULL') = NVL('BA','NULL');Insert into APPTX   (APPTYPE, TXCD, TXUPDATE, TXTYPE, FIELD, FLDTYPE, OFILE, OFILEACT, IFILE, INTF, TBLNAME, TRANF, FLDRND) Values   ('BA', '1902', 'C', 'C', 'QUANTITY', 'N', NULL, NULL, NULL, NULL, 'BONDSEMAST', 'BONDSETRAN', '0');Insert into APPTX   (APPTYPE, TXCD, TXUPDATE, TXTYPE, FIELD, FLDTYPE, OFILE, OFILEACT, IFILE, INTF, TBLNAME, TRANF, FLDRND) Values   ('BA', '1903', 'D', 'D', 'QUANTITY', 'N', NULL, NULL, NULL, NULL, 'BONDSEMAST', 'BONDSETRAN', '0');COMMIT;