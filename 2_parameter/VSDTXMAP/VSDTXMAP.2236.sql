SET DEFINE OFF;DELETE FROM VSDTXMAP WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('2236','NULL');Insert into VSDTXMAP   (OBJTYPE, OBJNAME, TRFCODE, FLDREFCODE, FLDNOTES, AMTEXP, AFFECTDATE, FLDACCTNO) Values   ('T', '2236', '524.NEWM.FROM//AVAL.TOBA//PLED', '$04', '$30', '$10', '<$TXDATE>', '$02');COMMIT;